import 'package:flutter/material.dart';

abstract class ExamplePage extends StatelessWidget {
  const ExamplePage(this.leading, this.title);

  final Widget leading;
  final String title;
}
