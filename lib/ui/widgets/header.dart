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
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
      color: Colors.white.withOpacity(0.5),
      ),

      child: const Expanded(
        // fix error: The overflowing RenderFlex has an orientation of Axis.horizontal.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [LeftHeader(), RightHeader()],
        ),
      ),
    );
    //);
  }
}
