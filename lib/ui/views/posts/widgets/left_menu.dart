import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';

import '../posts_view.dart';

class LeftMenu extends StatelessWidget {
  final List<NavigationPost> listSelectBtn;

  const LeftMenu({super.key, required this.listSelectBtn});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listSelectBtn.map((selectBtn) {
          return selectBtn.isSelected ? buttonSelected(selectBtn.index) : buttonSelect(selectBtn.index);
        }).toList(),
      ),
    );
  }

  Widget buttonSelect(int index) {
    return SizedBox(
      width: 180,
      child: TextButton(
        onPressed: () => appRouter.go(listSelectBtn[index].path, extra: {}),
        onHover: (value) {listSelectBtn[index].isSelected = value;},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(listSelectBtn[index].isSelected ? const Color.fromRGBO(242, 238, 242, 1) : Colors.white),
        ),
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: const TextStyle(color: Colors.black),),
        ),
      ),
    );
  }

  Widget buttonSelected(int index) {
    return SizedBox(
      width: 180,
      child: TextButton(
        onPressed: () => appRouter.go(listSelectBtn[index].path, extra: {}),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(242, 242, 242, 1)),
        ),
        child:  Align(
          alignment: Alignment.centerLeft,
          child: Text(listSelectBtn[index].text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}