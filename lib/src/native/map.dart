part of mapbox_maps_flutter;

class WrapperMap {
    Pointer<Void> peer = Pointer.fromAddress(0);
    WrapperMap._fromPeer(Pointer<Void> peer) {
        this.peer = peer;
    }

    WrapperMap(int peer) {
        final peerNativeHolder_ = IntegerMarshaller.toC(peer);
        this.peer = _initializeNative_u64(peerNativeHolder_.content);
        _setDartRef(this.peer, this);
        peerNativeHolder_.dealloc();
    }

    void render() {
        _renderNative(this.peer);
    }

}

class WrapperMapMarshaller {
    static NativeHolder<Pointer<Void>> toC(WrapperMap x) { return NativeHolder(_copyHandle(x.peer), _release); }

    static WrapperMap toDart(Pointer<Void> x) {
        return _getDartPeerOrCreateIfNotExist(x, Pointer.fromFunction<Uint8 Function(Handle)>(isNull, 0), Pointer.fromFunction<Handle Function(Pointer<Void>)>(_createInstanceFromPeer)) as WrapperMap;
    }

    static Object _createInstanceFromPeer(Pointer<Void> peer) { return WrapperMap._fromPeer(peer); }
}

final _initializeNative_u64 = Context.lib.lookupFunction<
    Pointer<Void> Function(Uint64),
    Pointer<Void> Function(int)
>('mapbox_maps_WrapperMap_initialize');
final _copyHandle = Context.lib.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
>('mapbox_maps_WrapperMap_copyHandle');
final _renderNative = Context.lib.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
>('mapbox_maps_WrapperMap_render');
final _getDartPeerOrCreateIfNotExist = Context.lib.lookupFunction<
    Handle Function(Pointer<Void>, Pointer, Pointer),
    Object? Function(Pointer<Void>, Pointer, Pointer)
>('mapbox_maps_WrapperMap_getDartPeerOrCreateIfNotExist');

final _setDartRef = Context.lib.lookupFunction<
    Void Function(Pointer<Void>, Handle),
    void Function(Pointer<Void>, Object?)
>('mapbox_maps_WrapperMap_setDartRef');
final _release = Context.lib.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
>('mapbox_maps_WrapperMap_release');
