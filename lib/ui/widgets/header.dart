import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/widgets/header/left_header.dart';
import 'package:flutter/material.dart';

import 'header/right_header.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      decoration: const BoxDecoration (
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      color: Colors.white,
      ),
      child: Center(
        child:
          Container(
            margin: const EdgeInsets.symmetric(horizontal: horizontalSpace),
            constraints: const BoxConstraints(maxWidth: maxContent),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [LeftHeader(), RightHeader()],
            ),
          ),

      ),
    );
    //);
  }
}
