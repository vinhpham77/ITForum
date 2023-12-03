import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemMenu {
  ItemMenu({required this.name, required this.icon, required this.route});

  final String name;
  final IconData icon;
  final String route;
}

class RightHeader extends StatefulWidget {
  const RightHeader({super.key});

  @override
  State<RightHeader> createState() => _RightHeaderState();
}

class _RightHeaderState extends State<RightHeader> {
  List<ItemMenu> createMenu = [
    ItemMenu(name: "Bài viết", icon: Icons.create, route: "/publish/post"),
    ItemMenu(name: "Series", icon: Icons.list, route: "/publish/series"),
    ItemMenu(name: "Đặt câu hỏi", icon: Icons.help, route: "/publish/ask")
  ];

  List<ItemMenu> profilerMenu = [
    ItemMenu(
        name: "Trang cá nhân",
        icon: Icons.person,
        route: "/profile/${JwtPayload.sub}"),
    ItemMenu(
        name: "Đổi mật khẩu", icon: Icons.change_circle, route: "/changepass"),
    ItemMenu(name: "Quên mật khẩu", icon: Icons.vpn_key, route: "/forgotpass"),
    ItemMenu(name: "Đăng xuất", icon: Icons.logout, route: "/publish/post")
  ];

  final searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          height: 34,
          constraints: const BoxConstraints(maxWidth: 220, minWidth: 40),
          child: TextField(
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            controller: searchController,
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                hintText: 'Nhập từ khóa tìm kiếm...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)))),
          ),
        ),
        SizedBox(
          height: 34,
          child: FloatingActionButton(
            hoverColor: Colors.black38,
            backgroundColor: Colors.black,
            onPressed: () {
              if (searchController.text == '') {
                appRouter.go('/search');
              } else {
                appRouter
                    .go('/viewsearch/searchContent=${searchController.text}');
              }
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        (JwtPayload.displayName == null)
            ? Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                constraints: const BoxConstraints(minWidth: 120),
                child: FilledButton(
                  onPressed: () => appRouter.go('/login'),
                  child: const Text("Đăng Nhập",
                      style: TextStyle(color: Colors.white),
                      softWrap: false,
                      maxLines: 1),
                ),
              )
            : widgetSignIn()
      ],
    );
  }

  Widget widgetSignIn() => Row(
        children: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.edit_note),
                iconSize: 24,
                splashRadius: 16,
                tooltip: 'Viết',
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              createMenu.length,
              (int index) => MenuItemButton(
                  onPressed: () =>
                      {GoRouter.of(context).go(createMenu[index].route)},
                  child: Row(
                    children: [
                      Icon(createMenu[index].icon),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(createMenu[index].name)
                    ],
                  )),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.notifications_none),
            iconSize: 24,
            splashRadius: 16,
          ),
          const SizedBox(width: 10),
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.account_circle),
                iconSize: 32,
                splashRadius: 16,
                tooltip: 'Profiler',
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              createMenu.length,
              (int index) => MenuItemButton(
                  onPressed: () =>
                      {GoRouter.of(context).go(profilerMenu[index].route)},
                  child: Row(
                    children: [
                      Icon(profilerMenu[index].icon),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(profilerMenu[index].name)
                    ],
                  )),
            ),
          ),
        ],
      );
}
