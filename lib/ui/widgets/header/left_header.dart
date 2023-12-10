import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;

class LeftHeader extends StatefulWidget {
  const LeftHeader({super.key});

  @override
  State<LeftHeader> createState() => _LeftHeaderState();
}

class _LeftHeaderState extends State<LeftHeader> {
  bool _isPostHovering = false;
  bool _isQuestionHovering = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              appRouter.go("/");
            },
            child: const Text(
              'STARFRUIT',
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          SizedBox(width: screenSize.width / 20),
          InkWell(
            onHover: (value) {
              setState(() {
                value ? _isPostHovering = true : _isPostHovering = false;
              });
            },
            onTap: () {
              appRouter.go("/");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bài viết',
                  style: TextStyle(
                      color: _isPostHovering ? Colors.black : Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(width: screenSize.width / 30),
          InkWell(
            onHover: (value) {
              setState(() {
                value ? _isQuestionHovering = true : _isQuestionHovering = false;
              });
            },
            onTap: () {
              go.GoRouter.of(context).go("/viewquestion");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hỏi đáp',
                  style: TextStyle(
                      color: _isQuestionHovering ? Colors.black : Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
