import 'package:flutter/material.dart';

abstract interface class Example extends Widget {
  Widget get leading;
  String get title;
  String? get subtitle;
}
