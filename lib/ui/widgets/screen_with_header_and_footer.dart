import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/widgets/header.dart';
import 'package:flutter/material.dart';

import 'footer.dart';

class ScreenWithHeaderAndFooter extends StatelessWidget {
  final Widget body;

  const ScreenWithHeaderAndFooter({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 60), child: const Header()),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: headerHeight + 292,
                  minWidth: screenSize.width,
                ),
                child: body,
              ),
              const Footer(),
            ],
          ),
        ));
  }
}
