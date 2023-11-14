import 'package:cay_khe/ui/widgets/header.dart';
import 'package:flutter/material.dart';

class ScreenWithHeaderAndFooter extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;

  const ScreenWithHeaderAndFooter({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 60), child: header),
        body: SingleChildScrollView(
          child: Column(
            children: [
              body,
              footer,
            ],
          ),
        ));
  }
}
