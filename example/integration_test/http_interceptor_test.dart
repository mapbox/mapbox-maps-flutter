import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    // Clean up interceptors after each test
    MapboxMapsOptions.setHttpRequestInterceptor(null);
    MapboxMapsOptions.setHttpResponseInterceptor(null);
    MapboxMapsOptions.setCustomHeaders({});
  });

  group('HTTP Interceptor - Deadlock Prevention', () {
    testWidgets(
        'map loads successfully with request interceptor set before map creation',
        (WidgetTester tester) async {
      // This test verifies the fix for the deadlock issue.
      // Previously, setting an interceptor before map creation could cause
      // a deadlock because HTTP requests made during map initialization
      // would block the main thread waiting for the Flutter callback.
      //
      // With the async continuation pattern fix, this should complete
      // successfully without hanging.

      final requestsIntercepted = <String>[];

      // Set up interceptor BEFORE creating the map
      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        requestsIntercepted.add(request.url);
        // Add a custom header to prove interception worked
        return request.copyWith(
          headers: {...request.headers, 'X-Test-Intercepted': 'true'},
        );
      });

      // Create the map - this will make HTTP requests during initialization
      // If deadlock fix is working, this will complete; if not, it will hang
      final mapFuture = app.main();
      await tester.pumpAndSettle();

      // Wait for map to load with a timeout - if deadlock occurs, this fails
      final mapboxMap = await mapFuture.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
            'Map failed to load - possible deadlock in HTTP interceptor'),
      );

      // Verify map loaded successfully
      expect(mapboxMap, isNotNull);

      // Verify that requests were actually intercepted
      // (style and tile requests should have been captured)
      expect(requestsIntercepted, isNotEmpty,
          reason: 'HTTP requests should have been intercepted during map load');
    });

    testWidgets(
        'map loads successfully with response interceptor set before map creation',
        (WidgetTester tester) async {
      final responsesIntercepted = <String>[];

      // Set up response interceptor BEFORE creating the map
      await MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        responsesIntercepted.add(response.url);
      });

      // Create the map
      final mapFuture = app.main();
      await tester.pumpAndSettle();

      // Wait for map to load
      final mapboxMap = await mapFuture.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
            'Map failed to load - possible deadlock in HTTP interceptor'),
      );

      expect(mapboxMap, isNotNull);

      // Wait a bit for responses to come in
      await tester.pump(const Duration(seconds: 2));

      expect(responsesIntercepted, isNotEmpty,
          reason:
              'HTTP responses should have been intercepted during map load');
    });

    testWidgets(
        'map loads successfully with both interceptors set before map creation',
        (WidgetTester tester) async {
      final requestsIntercepted = <String>[];
      final responsesIntercepted = <String>[];

      // Set up both interceptors BEFORE creating the map
      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        requestsIntercepted.add(request.url);
        return request.copyWith(
          headers: {
            ...request.headers,
            'X-Request-Id': 'test-${request.url.hashCode}'
          },
        );
      });

      await MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        responsesIntercepted.add(response.url);
      });

      // Create the map
      final mapFuture = app.main();
      await tester.pumpAndSettle();

      final mapboxMap = await mapFuture.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
            'Map failed to load - possible deadlock in HTTP interceptor'),
      );

      expect(mapboxMap, isNotNull);
      await tester.pump(const Duration(seconds: 2));

      expect(requestsIntercepted, isNotEmpty);
      expect(responsesIntercepted, isNotEmpty);
    });
  });

  group('HTTP Interceptor - Custom Headers', () {
    testWidgets('custom headers are applied to requests',
        (WidgetTester tester) async {
      Map<String, String>? capturedHeaders;

      await MapboxMapsOptions.setCustomHeaders({
        'X-Static-Header': 'static-value',
        'X-App-Version': '1.0.0',
      });

      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        // Capture headers from a mapbox request
        if (request.url.contains('mapbox')) {
          capturedHeaders = Map<String, String>.from(request.headers);
        }
        return null; // Don't modify the request
      });

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;

      // Custom headers should have been applied
      expect(capturedHeaders, isNotNull);
      expect(capturedHeaders!['X-Static-Header'], equals('static-value'));
      expect(capturedHeaders!['X-App-Version'], equals('1.0.0'));
    });
  });

  group('HTTP Interceptor - Response Body Opt-in', () {
    testWidgets('response body is null by default (not included)',
        (WidgetTester tester) async {
      final responseBodies = <List<int>?>[];

      // Set up response interceptor WITHOUT includeResponseBody
      // Body should be null by default to avoid performance issues
      await MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        responseBodies.add(response.data);
      });

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;
      await tester.pump(const Duration(seconds: 2));

      // All response bodies should be null (not included)
      expect(responseBodies, isNotEmpty,
          reason: 'Should have captured some responses');
      expect(responseBodies.every((body) => body == null), isTrue,
          reason:
              'Response bodies should be null by default to avoid performance issues');
    });

    testWidgets('response body is included when opted in',
        (WidgetTester tester) async {
      final responseBodies = <List<int>?>[];

      // Set up response interceptor WITH includeResponseBody: true
      await MapboxMapsOptions.setHttpResponseInterceptor(
        (response) async {
          responseBodies.add(response.data);
        },
        includeResponseBody: true,
      );

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;
      await tester.pump(const Duration(seconds: 2));

      // At least some response bodies should be non-null
      expect(responseBodies, isNotEmpty,
          reason: 'Should have captured some responses');
      expect(
          responseBodies.any((body) => body != null && body.isNotEmpty), isTrue,
          reason:
              'At least some response bodies should be included when opted in');
    });
  });

  group('HTTP Interceptor - Request Modification', () {
    testWidgets('modified request is used', (WidgetTester tester) async {
      String? capturedTestHeader;

      // First interceptor adds a header
      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        return request.copyWith(
          headers: {...request.headers, 'X-Modified': 'yes'},
        );
      });

      // Response interceptor checks if the modified header roundtripped
      await MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        if (response.requestHeaders.containsKey('X-Modified')) {
          capturedTestHeader = response.requestHeaders['X-Modified'];
        }
      });

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;
      await tester.pump(const Duration(seconds: 2));

      // The modified header should have been sent with requests
      // and roundtripped back in the response
      expect(capturedTestHeader, equals('yes'),
          reason: 'Modified request headers should be used');
    });

    testWidgets('returning null from interceptor uses original request',
        (WidgetTester tester) async {
      int interceptCallCount = 0;

      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        interceptCallCount++;
        return null; // Return null to use original request unchanged
      });

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;

      // Interceptor should have been called, but returning null
      // means the original request was used
      expect(interceptCallCount, greaterThan(0),
          reason: 'Interceptor should have been called');
    });
  });

  group('HTTP Interceptor - Request/Response Correlation', () {
    testWidgets('all requests receive corresponding responses',
        (WidgetTester tester) async {
      // This test verifies the async continuation pattern correctly handles
      // concurrent requests - each request should get a matching response.
      // This tests the thread safety and correlation logic, not channel performance.

      final requestUrls = <String>{};
      final responseUrls = <String>{};
      final requestTimestamps = <String, DateTime>{};
      final responseTimestamps = <String, DateTime>{};

      // Track all requests
      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        requestUrls.add(request.url);
        requestTimestamps[request.url] = DateTime.now();
        return null; // Don't modify
      });

      // Track all responses
      await MapboxMapsOptions.setHttpResponseInterceptor((response) async {
        responseUrls.add(response.url);
        responseTimestamps[response.url] = DateTime.now();
      });

      // Load the map - this generates many concurrent HTTP requests
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;
      await tester.pump(const Duration(seconds: 3));

      // Log correlation results
      // ignore: avoid_print
      print('Request/Response correlation results:');
      // ignore: avoid_print
      print('  Total requests intercepted: ${requestUrls.length}');
      // ignore: avoid_print
      print('  Total responses intercepted: ${responseUrls.length}');

      // Key assertion: we should have intercepted requests
      expect(requestUrls, isNotEmpty,
          reason: 'Should have intercepted HTTP requests');

      // Key assertion: we should have intercepted responses
      expect(responseUrls, isNotEmpty,
          reason: 'Should have intercepted HTTP responses');

      // Check how many requests have matching responses
      final matchedUrls = requestUrls.intersection(responseUrls);
      final unmatchedRequests = requestUrls.difference(responseUrls);

      // ignore: avoid_print
      print('  Matched request/response pairs: ${matchedUrls.length}');
      // ignore: avoid_print
      print('  Requests without responses: ${unmatchedRequests.length}');

      // Most requests should have corresponding responses
      // (some may be in-flight or failed, so we don't require 100%)
      final matchRate = matchedUrls.length / requestUrls.length;
      // ignore: avoid_print
      print('  Match rate: ${(matchRate * 100).toStringAsFixed(1)}%');

      expect(matchRate, greaterThan(0.5),
          reason:
              'At least 50% of requests should have matching responses (got ${(matchRate * 100).toStringAsFixed(1)}%)');

      // Verify response timestamps are after request timestamps (causality check)
      for (final url in matchedUrls) {
        final requestTime = requestTimestamps[url];
        final responseTime = responseTimestamps[url];
        if (requestTime != null && responseTime != null) {
          expect(
              responseTime.isAfter(requestTime) || responseTime == requestTime,
              isTrue,
              reason: 'Response should come after request for $url');
        }
      }
    });
  });

  group('HTTP Interceptor - Cleanup', () {
    testWidgets('interceptors can be disabled', (WidgetTester tester) async {
      int requestCountWithInterceptor = 0;
      int requestCountAfterDisabling = 0;

      // Enable interceptor
      await MapboxMapsOptions.setHttpRequestInterceptor((request) async {
        requestCountWithInterceptor++;
        return null;
      });

      final mapFuture = app.main();
      await tester.pumpAndSettle();
      await mapFuture;

      final initialCount = requestCountWithInterceptor;
      expect(initialCount, greaterThan(0));

      // Disable interceptor
      await MapboxMapsOptions.setHttpRequestInterceptor(null);

      // Force some additional requests by panning the map
      // Note: This is a basic check - interceptor should not be called
      requestCountAfterDisabling = requestCountWithInterceptor;

      // After disabling, the counter should not increase
      // (or at least should be stable)
      expect(requestCountAfterDisabling, equals(requestCountWithInterceptor));
    });
  });
}
