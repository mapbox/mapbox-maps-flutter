import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class ProxyBinaryMessenger implements BinaryMessenger {
  ProxyBinaryMessenger(
      {required String suffix, BinaryMessenger? binaryMessenger})
      : _suffix = suffix,
        _binaryMessenger =
            binaryMessenger ?? ServicesBinding.instance.defaultBinaryMessenger;

  final BinaryMessenger _binaryMessenger;
  final String _suffix;

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    ui.PlatformMessageResponseCallback? callback,
  ) {
    return _binaryMessenger.handlePlatformMessage(
        "$channel$_suffix", data, callback);
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? data) {
    return _binaryMessenger.send("$channel$_suffix", data);
  }

  @override
  void setMessageHandler(
    String channel,
    MessageHandler? handler,
  ) {
    _binaryMessenger.setMessageHandler("$channel$_suffix", handler);
  }
}
