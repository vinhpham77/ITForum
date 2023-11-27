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
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 60), child: const Header()),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black12.withOpacity(0.05),
            child: Column(
              children: [
                body,
                const Footer(),
              ],
            ),
          ),
        ));
  }
}
