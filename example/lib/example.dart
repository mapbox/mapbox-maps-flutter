import 'package:flutter/material.dart';

abstract interface class Example extends Widget {
  const Example(this.leading, this.title);

  final Widget leading;
  final String title;
}
