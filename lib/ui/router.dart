import 'package:cay_khe/ui/views/cu_post/cu_post_view.dart';
import 'package:cay_khe/ui/views/details_page/postDetails.dart';
import 'package:cay_khe/ui/views/user_use/changePassword_page.dart';
import 'package:cay_khe/ui/views/user_use/forgotPassword_page.dart';
import 'package:cay_khe/ui/views/user_use/login_page.dart';
import 'package:cay_khe/ui/views/user_use/register_page.dart';
import 'package:cay_khe/ui/views/user_use/resetPassword_page.dart';
import 'package:cay_khe/ui/widgets/ScreenWithHeaderAndFooter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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

final appRouter = GoRouter(navigatorKey: navigatorKey, routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('home'),
      child: ScreenWithHeaderAndFooter(
        body: Text("post"),
      ),
    ),
  ),
  GoRoute(
    path: '/question',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('question'),
      child: ScreenWithHeaderAndFooter(
        body: Text("question"),
      ),
    ),
  ),
  GoRoute(
    path: '/search',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('search'),
      child: ScreenWithHeaderAndFooter(
        body: Text("search"),
      ),
    ),
    routes: [
      GoRoute(
        path: ':pid',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: ScreenWithHeaderAndFooter(
              body: Text(state.pathParameters['pid']!),
            )),
      ),
    ],
  ),
  GoRoute(
    path: '/publish/post',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('post-create'),
      child: ScreenWithHeaderAndFooter(
        body: CuPost(),
      ),
    ),
  ),
  GoRoute(
    path: '/publish/series',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('series-create'),
      child: ScreenWithHeaderAndFooter(
        body: Text("create series"),
      ),
    ),
  ),
  GoRoute(
    path: '/publish/ask',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('ask-create'),
      child: ScreenWithHeaderAndFooter(
        body: CuPost(isQuestion: true),
      ),
    ),
  ),
  GoRoute(
      path: '/posts',
      pageBuilder: (context, state) => const MaterialPage<void>(
            key: ValueKey('posts'),
            child: ScreenWithHeaderAndFooter(
              body: Text("posts"),
            ),
          ),
      routes: [
        GoRoute(
            path: ':pid',
            pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ScreenWithHeaderAndFooter(
                  body: Text('Details ${state.pathParameters['pid']!}'),
                )),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) => MaterialPage<void>(
                    key: state.pageKey,
                    child: ScreenWithHeaderAndFooter(
                      body: CuPost(
                          id: state.pathParameters['pid']!, isUpdated: true),
                    )),
              ),
            ]),
      ]),
       GoRoute(
    path: '/postdetails',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('postdetails'),
      child: ScreenWithHeaderAndFooter(
        body: PostDetailsPage()
      ),
    ),
  ),
  GoRoute(
    name: 'login',
    path: '/login',
    pageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('login'),
      child: LoginPage(),
    ),
  ),
  GoRoute(
    path: '/register',
    pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('register'), child: SignupPage()),
  ),
  GoRoute(
    path: '/forgotpass',
    pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('forgotpass'), child: ForgotPasswordPage()),
  ),
  GoRoute(
    path: '/changepass',
    pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('changepass'), child: ChangePasswordPage()),
  ),
  GoRoute(
    path: '/resetpass',
    pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('resetpass'), child: ResetPasswordPage()),
  ),
  

]);
