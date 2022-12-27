part of mapbox_maps_flutter;

class ModelSource extends Source {
  final Uri uri;

  ModelSource({required String id, required this.uri}) : super(id: id);

  @override
  String getType() => "model";

  @override
  String _encode(bool volatile) {
    var properties = <String, dynamic>{};
    properties["id"] = id;
    properties['uri'] = uri.path;
    properties["type"] = getType();
    return json.encode(properties);
  }

  Map<String, String> encode() {
    var properties = <String, String>{};
    properties["id"] = id;
    properties['uri'] = uri.toString();
    properties["type"] = getType();
    return properties;
  }
}
