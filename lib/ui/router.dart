import 'package:cay_khe/ui/widgets/ScreenWithHeaderAndFooter.dart';
import 'package:cay_khe/ui/widgets/footer.dart';
import 'package:cay_khe/ui/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("post"),
        footer: Footer(),
      ),
    ),
  ),
  GoRoute(
    path: '/question',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("question"),
        footer: Footer(),
      ),
    ),
  ),
  GoRoute(
    path: '/search',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("search"),
        footer: Footer(),
      ),
    ),
    routes: [
      GoRoute(
        path: ':pid',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: ScreenWithHeaderAndFooter(
              header: Header(),
              body: Text(state.pathParameters['pid']!),
              footer: Footer(),
            )),
      ),
    ],
  ),
  GoRoute(
    path: '/publish/post',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("create post"),
        footer: Footer(),
      ),
    ),
  ),
  GoRoute(
    path: '/publish/series',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("create series"),
        footer: Footer(),
      ),
    ),
  ),
  GoRoute(
    path: '/publish/ask',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: Text("create ask"),
        footer: Footer(),
      ),
    ),
  ),
]);
