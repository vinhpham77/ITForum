import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;

class LeftHeader extends StatefulWidget {
  const LeftHeader({super.key});

  @override
  _LeftHeaderState createState() => _LeftHeaderState();
}

class _LeftHeaderState extends State<LeftHeader> {
  bool _isPostHovering = false;
  bool _isQuestionHovering = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: screenSize.width / 10),
        const Text(
          'STARFRUIT',
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
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
            go.GoRouter.of(context).go("/");
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
            go.GoRouter.of(context).go("/question");
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
        SizedBox(width: screenSize.width / 30)
      ],
    );
  }
}
