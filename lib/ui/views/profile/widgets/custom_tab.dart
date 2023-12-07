import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final Widget child;

  const CustomTab(
      {super.key,
      required this.isActive,
      required this.child,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    // a button with bottom border as activated
    return InkWell(
      onTap: onTap,
      hoverColor: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
