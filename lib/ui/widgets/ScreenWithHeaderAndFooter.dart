import 'package:flutter/material.dart';

class ScreenWithHeaderAndFooter extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;

  const ScreenWithHeaderAndFooter({super.key,
    required this.header,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header,
        Expanded(child: body),
        footer,
      ],
    );
  }
}