import 'package:cay_khe/ui/widgets/header/left_header.dart';
import 'package:flutter/material.dart';

import 'header/right_header.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white.withOpacity(0.5),
      child: Container(
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [LeftHeader(), RightHeader()],
          ),
        ),
      ),
    );
    //);
  }
}
