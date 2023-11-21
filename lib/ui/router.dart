import 'package:cay_khe/ui/views/login/changePassword_page.dart';
import 'package:cay_khe/ui/views/login/forgotPassword_page.dart';
import 'package:cay_khe/ui/views/login/login_page.dart';
import 'package:cay_khe/ui/views/login/register_page.dart';
import 'package:cay_khe/ui/views/login/resetPassword_page.dart';
import 'package:cay_khe/ui/widgets/ScreenWithHeaderAndFooter.dart';
import 'package:cay_khe/ui/widgets/footer.dart';
import 'package:cay_khe/ui/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cay_khe/ui/views/cu_post/cu_post_view.dart';





const _pageKey = ValueKey('_pageKey');

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
    pageBuilder: (context, state) =>
    const MaterialPage<void>(
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
    pageBuilder: (context, state) =>
    const MaterialPage<void>(
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
    pageBuilder: (context, state) =>
    const MaterialPage<void>(
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
        pageBuilder: (context, state) =>
            MaterialPage<void>(
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
    pageBuilder: (context, state) =>
    const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: CuPost(),
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
    pageBuilder: (context, state) =>
    const MaterialPage<void>(
      key: _pageKey,
      child: ScreenWithHeaderAndFooter(
        header: Header(),
        body: CuPost(isQuestion: true),
        footer: Footer(),
      ),
    ),
  ),
  GoRoute(
      path: '/posts',
      pageBuilder: (context, state) =>
      const MaterialPage<void>(
        key: _pageKey,
        child: ScreenWithHeaderAndFooter(
          header: Header(),
          body: Text("posts"),
          footer: Footer(),
        ),
      ),
      routes: [
        GoRoute(
            path: ':pid',
            pageBuilder: (context, state) =>
                MaterialPage<void>(
                    key: state.pageKey,
                    child: ScreenWithHeaderAndFooter(
                      header: Header(),
                      body: Text('Details ${state.pathParameters['pid']!}'),
                      footer: Footer(),
                    )),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) =>
                    MaterialPage<void>(
                        key: state.pageKey,
                        child: ScreenWithHeaderAndFooter(
                          header: Header(),
                          body: CuPost(id: state.pathParameters['pid']!, isUpdated: true),
                          footer: Footer(),
                        )),
              ),
            ]),
      ]
  ),
   GoRoute(
    path: '/login',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: LoginPage(),
    ),
  ),
    GoRoute(
    path: '/register',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: SignupPage()
    ),
  ),
    GoRoute(
    path: '/forgotpass',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ForgotPasswordPage()
    ),
  ),
  GoRoute(
    path: '/changepass',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ChangePasswordPage()
    ),
  ),
   GoRoute(
    path: '/resetpass',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: _pageKey,
      child: ResetPasswordPage()
    ),
  ),
]);