part of mapbox_maps_flutter;

class NativeMap {
    Pointer<Void> peer = Pointer.fromAddress(0);
    NativeMap._fromPeer(Pointer<Void> peer) {
        this.peer = peer;
    }

    void render() {
        _renderNative(this.peer);
    }

}

class MapMarshaller {
    static NativeHolder<Pointer<Void>> toC(NativeMap x) { return NativeHolder(_copyHandle(x.peer), _release); }

    static NativeMap toDart(Pointer<Void> x) {
        return _getDartPeerOrCreateIfNotExist(x, Pointer.fromFunction<Uint8 Function(Handle)>(isNull, 0), Pointer.fromFunction<Handle Function(Pointer<Void>)>(_createInstanceFromPeer)) as NativeMap;
    }

    static Object _createInstanceFromPeer(Pointer<Void> peer) { return NativeMap._fromPeer(peer); }
}

final _copyHandle = Context.lib.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
>('mapbox_maps_Map_copyHandle');
final _renderNative = Context.lib.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
>('mapbox_maps_Map_render');
final _getDartPeerOrCreateIfNotExist = Context.lib.lookupFunction<
    Handle Function(Pointer<Void>, Pointer, Pointer),
    Object? Function(Pointer<Void>, Pointer, Pointer)
>('mapbox_maps_Map_getDartPeerOrCreateIfNotExist');

final _setDartRef = Context.lib.lookupFunction<
    Void Function(Pointer<Void>, Handle),
    void Function(Pointer<Void>, Object?)
>('mapbox_maps_Map_setDartRef');
final _release = Context.lib.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
>('mapbox_maps_Map_release');
