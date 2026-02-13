import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

/// Represents a logged HTTP request or response for display
class HttpLogEntry {
  final DateTime timestamp;
  final bool isRequest;
  final String url;
  final String method;
  final int? statusCode;
  final Map<String, String> headers;
  final int? bodySize;
  final String? requestId;

  HttpLogEntry({
    required this.timestamp,
    required this.isRequest,
    required this.url,
    required this.method,
    this.statusCode,
    required this.headers,
    this.bodySize,
    this.requestId,
  });

  String get displayText {
    if (isRequest) {
      return '$method ${_truncateUrl(url)}';
    } else {
      return '$statusCode ${_truncateUrl(url)}';
    }
  }

  String _truncateUrl(String url) {
    if (url.length > 60) {
      return '${url.substring(0, 57)}...';
    }
    return url;
  }
}

/// Groups a request with its corresponding response
class HttpLogGroup {
  final String? requestId;
  final HttpLogEntry? request;
  final HttpLogEntry? response;

  HttpLogGroup({this.requestId, this.request, this.response});

  /// Returns the timestamp to use for sorting (request time, or response time if no request)
  DateTime get sortTimestamp =>
      request?.timestamp ?? response?.timestamp ?? DateTime.now();

  /// Calculates duration between request and response in milliseconds
  int? get durationMs {
    if (request != null && response != null) {
      return response!.timestamp.difference(request!.timestamp).inMilliseconds;
    }
    return null;
  }

  /// Returns the URL from either request or response
  String get url => request?.url ?? response?.url ?? '';

  /// Returns the method from request
  String get method => request?.method ?? '';

  /// Returns true if we have both request and response
  bool get isComplete => request != null && response != null;

  /// Returns true if this is a pending request (no response yet)
  bool get isPending => request != null && response == null;
}

class CustomHeaderExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.network_check);
  @override
  final String title = 'Custom Header Example';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => CustomHeaderExampleState();
}

class CustomHeaderExampleState extends State<CustomHeaderExample> {
  CustomHeaderExampleState();

  MapboxMap? mapboxMap;
  var mapProject = StyleProjectionName.globe;
  var locale = 'en';
  bool useInterceptor =
      true; // Start with interceptor enabled to capture ALL requests
  List<HttpLogEntry> requestLog = [];
  static const int maxLogEntries = 50;

  // Dart-level request ID generation for correlating requests with responses.
  // This demonstrates how users can implement their own correlation strategy
  // by adding a custom header that gets roundtripped in the response.
  int _requestIdCounter = 0;

  /// Generates a unique request ID for correlating requests with responses.
  /// In production, you might want to use a UUID package instead.
  String _generateRequestId() {
    _requestIdCounter++;
    return 'req-$_requestIdCounter-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Groups log entries by requestId for display
  List<HttpLogGroup> get groupedLog {
    final Map<String, HttpLogGroup> groups = {};
    final List<HttpLogEntry> ungrouped = [];

    for (final entry in requestLog) {
      if (entry.requestId != null) {
        final id = entry.requestId!;
        final existing = groups[id];
        if (existing == null) {
          groups[id] = HttpLogGroup(
            requestId: id,
            request: entry.isRequest ? entry : null,
            response: entry.isRequest ? null : entry,
          );
        } else {
          groups[id] = HttpLogGroup(
            requestId: id,
            request: entry.isRequest ? entry : existing.request,
            response: entry.isRequest ? existing.response : entry,
          );
        }
      } else {
        ungrouped.add(entry);
      }
    }

    // Convert to list and sort by most recent first
    final result = groups.values.toList();
    // Add ungrouped entries as single-item groups
    for (final entry in ungrouped) {
      result.add(HttpLogGroup(
        requestId: null,
        request: entry.isRequest ? entry : null,
        response: entry.isRequest ? null : entry,
      ));
    }

    result.sort((a, b) => b.sortTimestamp.compareTo(a.sortTimestamp));
    return result;
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  void _setupHttpInterceptor() {
    // Using static methods on MapboxMapsOptions - these work BEFORE any map is created,
    // ensuring all HTTP requests (including initial style/tile requests) are intercepted.
    if (useInterceptor) {
      // Set up request interceptor for dynamic header injection
      MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        // Generate a unique ID for this request at the Dart level.
        // This ID is added as a header and will be roundtripped in the response,
        // allowing us to correlate requests with their responses without
        // maintaining any state (like a URL -> ID map).
        final requestId = _generateRequestId();

        // Always add the request ID header, and conditionally add other custom headers
        final modifiedRequest = request.copyWith(
          headers: {
            ...request.headers,
            'X-Request-Id': requestId,
            if (request.url.contains('api.mapbox.com'))
              'X-Custom-Header': 'custom-value',
          },
        );

        // Log the request AFTER modification so we see the final headers
        final entry = HttpLogEntry(
          timestamp: DateTime.now(),
          isRequest: true,
          url: modifiedRequest.url,
          method: modifiedRequest.method,
          headers: Map<String, String>.from(modifiedRequest.headers),
          bodySize: modifiedRequest.body?.length,
          requestId: requestId,
        );

        setState(() {
          requestLog.insert(0, entry);
          if (requestLog.length > maxLogEntries) {
            requestLog.removeLast();
          }
        });

        return modifiedRequest;
      });

      // Optionally set up response interceptor for logging/monitoring
      MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        // The request ID is available via the roundtripped request headers.
        // This eliminates the need for maintaining a URL -> ID map.
        final requestId = response.requestHeaders['X-Request-Id'];

        final entry = HttpLogEntry(
          timestamp: DateTime.now(),
          isRequest: false,
          url: response.url,
          method: '', // Response doesn't have method
          statusCode: response.statusCode,
          headers: Map<String, String>.from(response.headers),
          bodySize: response.data?.length,
          requestId: requestId,
        );

        setState(() {
          requestLog.insert(0, entry);
          if (requestLog.length > maxLogEntries) {
            requestLog.removeLast();
          }
        });
      });
    } else {
      // Disable interceptors
      MapboxMapsOptions.setHttpRequestInterceptor(null);
      MapboxMapsOptions.setHttpResponseInterceptor(null);
    }
  }

  void _showRequestDetails(BuildContext context, HttpLogEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    entry.isRequest ? Icons.arrow_upward : Icons.arrow_downward,
                    color: entry.isRequest
                        ? Colors.blue
                        : _getStatusColor(entry.statusCode),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.isRequest ? 'REQUEST' : 'RESPONSE',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Timestamp
              _buildDetailRow('Timestamp', _formatTimestamp(entry.timestamp)),

              // Method (for requests)
              if (entry.isRequest) _buildDetailRow('Method', entry.method),

              // Status Code (for responses)
              if (!entry.isRequest)
                _buildDetailRow(
                  'Status Code',
                  '${entry.statusCode}',
                  valueColor: _getStatusColor(entry.statusCode),
                ),

              // URL
              _buildDetailRow('URL', entry.url, isSelectable: true),

              // Body Size
              if (entry.bodySize != null)
                _buildDetailRow('Body Size', '${entry.bodySize} bytes'),

              const SizedBox(height: 16),

              // Headers Section
              const Text(
                'Headers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (entry.headers.isEmpty)
                const Text(
                  'No headers',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
              else
                ...entry.headers.entries.map(
                  (e) => _buildHeaderRow(e.key, e.value),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? valueColor, bool isSelectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: isSelectable
                ? SelectableText(
                    value,
                    style: TextStyle(color: valueColor),
                  )
                : Text(
                    value,
                    style: TextStyle(color: valueColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
          SelectableText(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int? statusCode) {
    if (statusCode == null) return Colors.grey;
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.orange;
    if (statusCode >= 400) return Colors.red;
    return Colors.grey;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // Set up interceptors BEFORE the map is created.
    // This ensures ALL requests are intercepted, including
    // the initial style and tile requests during map initialization.
    MapboxMapsOptions.setCustomHeaders({'X-Static-Header': 'static-value'});
    _setupHttpInterceptor();
  }

  @override
  void dispose() {
    // Clean up using static methods
    MapboxMapsOptions.setCustomHeaders({});
    MapboxMapsOptions.setHttpRequestInterceptor(null);
    MapboxMapsOptions.setHttpResponseInterceptor(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      onResourceRequestListener: (request) {},
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Enable HTTP Interceptor:'),
              Switch(
                value: useInterceptor,
                onChanged: (value) {
                  setState(() {
                    useInterceptor = value;
                    _setupHttpInterceptor();
                  });
                },
              ),
              const Spacer(),
              if (requestLog.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      requestLog.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear'),
                ),
            ],
          ),
        ),
        if (!useInterceptor)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Enable the HTTP interceptor to see requests and responses.\n'
              'Tap on any entry to view full details including headers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        if (useInterceptor && requestLog.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Waiting for HTTP requests...\n'
              'Pan or zoom the map to trigger tile requests.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        if (requestLog.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: groupedLog.length,
              itemBuilder: (context, index) {
                final group = groupedLog[index];
                return _buildGroupedLogTile(context, group);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGroupedLogTile(BuildContext context, HttpLogGroup group) {
    final durationMs = group.durationMs;
    final statusCode = group.response?.statusCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: group.isPending
              ? Colors.orange.shade200
              : (statusCode != null && statusCode >= 200 && statusCode < 300)
                  ? Colors.green.shade200
                  : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Request row
          if (group.request != null)
            InkWell(
              onTap: () => _showRequestDetails(context, group.request!),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: _buildEntryRow(group.request!, isFirst: true),
            ),
          // Divider with duration
          if (group.request != null && group.response != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Icon(Icons.swap_vert, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 8),
                  Text(
                    durationMs != null ? '${durationMs}ms' : '...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (group.requestId != null)
                    Text(
                      'ID: ${group.requestId}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
          // Pending indicator (when we only have request, no response yet)
          if (group.isPending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Waiting for response...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          // Response row
          if (group.response != null)
            InkWell(
              onTap: () => _showRequestDetails(context, group.response!),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              child: _buildEntryRow(group.response!,
                  isFirst: group.request == null),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryRow(HttpLogEntry entry, {required bool isFirst}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Request/Response indicator
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: entry.isRequest
                  ? Colors.blue.shade50
                  : _getStatusColor(entry.statusCode).withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              entry.isRequest ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: entry.isRequest
                  ? Colors.blue
                  : _getStatusColor(entry.statusCode),
            ),
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (entry.isRequest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          entry.method,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(entry.statusCode).withAlpha(51),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${entry.statusCode}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(entry.statusCode),
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTimestamp(entry.timestamp),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.headers.length} headers',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry.url,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
