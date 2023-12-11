import 'package:cay_khe/ui/views/cu_post/cu_post_view.dart';
import 'package:cay_khe/ui/views/cu_series/cu_series_view.dart';
import 'package:cay_khe/ui/views/details_page/postDetails.dart';
import 'package:cay_khe/ui/views/forbidden/forbidden_view.dart';
import 'package:cay_khe/ui/views/not_found/not_found_view.dart';
import 'package:cay_khe/ui/views/posts/posts_view.dart';
import 'package:cay_khe/ui/views/posts/question_view.dart';
import 'package:cay_khe/ui/views/profile/profile_view.dart';
import 'package:cay_khe/ui/views/search/search_view.dart';
import 'package:cay_khe/ui/views/series_detail/seriesDetail.dart';
import 'package:cay_khe/ui/views/user_use/changePassword_page.dart';
import 'package:cay_khe/ui/views/user_use/forgotPassword_page.dart';
import 'package:cay_khe/ui/views/user_use/login_page.dart';
import 'package:cay_khe/ui/views/user_use/register_page.dart';
import 'package:cay_khe/ui/views/user_use/resetPassword_page.dart';
import 'package:cay_khe/ui/widgets/comment/comment_view.dart';
import 'package:cay_khe/ui/widgets/screen_with_header_and_footer.dart';
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

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('home'),
        child: ScreenWithHeaderAndFooter(
          body: PostsView(params: {}),
        ),
      ),
    ),
    GoRoute(
      path: '/not-found',
      pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey('not-found'),
          child: ScreenWithHeaderAndFooter(body: NotFound())),
    ),
    GoRoute(
      path: '/forbidden',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('forbidden'),
        child: ScreenWithHeaderAndFooter(
          body: Forbidden(),
        ),
      ),
    ),
    GoRoute(
        path: '/viewquestion',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestion"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(params: convertQuery(query: "")),
              ));
        }),
    GoRoute(
        path: '/viewquestion/:query',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestion"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(
                    params: convertQuery(
                        query: state.pathParameters["query"] ?? "")),
              ));
        }),
    GoRoute(
        path: '/viewquestionfollow',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestionfollow"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(
                    indexSelected: 1, params: convertQuery(query: "")),
              ));
        }),
    GoRoute(
        path: '/viewquestionfollow/:query',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestionfollow"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(
                    indexSelected: 1,
                    params: convertQuery(
                        query: state.pathParameters["query"] ?? "")),
              ));
        }),
    GoRoute(
        path: '/viewquestionbookmark',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestionbookmark"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(
                    indexSelected: 2, params: convertQuery(query: "")),
              ));
        }),
    GoRoute(
        path: '/viewquestionbookmark/:query',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: const ValueKey("viewquestionbookmark"),
              child: ScreenWithHeaderAndFooter(
                body: QuestionView(
                    indexSelected: 2,
                    params: convertQuery(
                        query: state.pathParameters["query"] ?? "")),
              ));
        }),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('search'),
        child: ScreenWithHeaderAndFooter(
          body: SearchView(params: {}),
        ),
      ),
    ),
    GoRoute(
        path: '/viewsearch/:query',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
              key: state.pageKey,
              child: ScreenWithHeaderAndFooter(
                body: SearchView(
                    params: convertQuery(
                        query: state.pathParameters["query"] ?? "")),
              ));
        }),
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
        child: ScreenWithHeaderAndFooter(body: CuSeries()),
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
          body: PostsView(params: {}),
        ),
      ),
    ),
    GoRoute(
      path: '/posts/:pid',
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: state.pageKey,
            child: ScreenWithHeaderAndFooter(
              body: PostDetailsPage(id: state.pathParameters['pid']!),
            ));
      },
    ),
    GoRoute(
      path: '/posts/:pid/edit',
      pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ScreenWithHeaderAndFooter(
            body: CuPost(id: state.pathParameters['pid']!),
          )),
    ),
    GoRoute(
      path: '/series',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('series'),
        child: ScreenWithHeaderAndFooter(
          body: Text("series"),
        ),
      ),
    ),
    GoRoute(
      path: '/series/:pid',
      pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ScreenWithHeaderAndFooter(
            body: SeriesDetail(id: state.pathParameters['pid']!),
          )),
    ),
    GoRoute(
      path: '/series/:pid/edit',
      pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ScreenWithHeaderAndFooter(
            body: CuSeries(id: state.pathParameters['pid']!),
          )),
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
      name: 'onepost',
      path: '/onepost',
      pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey('onepost'), child: Text("test")),
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
    GoRoute(
      path: "/viewposts",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewposts"),
            child: ScreenWithHeaderAndFooter(
              body: PostsView(params: convertQuery(query: "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewposts/:query",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: UniqueKey(),
            child: ScreenWithHeaderAndFooter(
              body: PostsView(
                  params:
                      convertQuery(query: state.pathParameters["query"] ?? "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewseries",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewseries"),
            child: ScreenWithHeaderAndFooter(
              body:
                  PostsView(indexSelected: 1, params: convertQuery(query: "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewseries/:query",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewseries"),
            child: ScreenWithHeaderAndFooter(
              body: PostsView(
                  indexSelected: 1,
                  params:
                      convertQuery(query: state.pathParameters["query"] ?? "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewpostsfollow",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewpostsfollow"),
            child: ScreenWithHeaderAndFooter(
              body:
                  PostsView(indexSelected: 2, params: convertQuery(query: "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewpostsfollow/:query",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewpostsfollow"),
            child: ScreenWithHeaderAndFooter(
              body: PostsView(
                  indexSelected: 2,
                  params:
                      convertQuery(query: state.pathParameters["query"] ?? "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewbookmark",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewbookmark"),
            child: ScreenWithHeaderAndFooter(
              body:
                  PostsView(indexSelected: 3, params: convertQuery(query: "")),
            ));
      },
    ),
    GoRoute(
      path: "/viewbookmark/:query",
      pageBuilder: (context, state) {
        return MaterialPage<void>(
            key: const ValueKey("viewbookmark"),
            child: ScreenWithHeaderAndFooter(
              body: PostsView(
                  indexSelected: 3,
                  params:
                      convertQuery(query: state.pathParameters["query"] ?? "")),
            ));
      },
    ),
    GoRoute(
      path: '/profile/:username',
      redirect: (BuildContext context, GoRouterState state) async {
        return '/profile/${state.pathParameters['username']}/posts';
      },
    ),
    GoRoute(
      path: '/profile/:username/posts',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: UniqueKey(),
        child: ScreenWithHeaderAndFooter(
          body: Profile(
            username: state.pathParameters['username']!,
            selectedIndex: 0,
            params: state.extra as Map<String, dynamic>? ?? {},
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/profile/:username/questions',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: UniqueKey(),
        child: ScreenWithHeaderAndFooter(
          body: Profile(
            username: state.pathParameters['username']!,
            selectedIndex: 1,
            params: state.extra as Map<String, dynamic>? ?? {},
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/profile/:username/series',
      pageBuilder: (context, state) => MaterialPage<void>(
        key: UniqueKey(),
        child: ScreenWithHeaderAndFooter(
            body: Profile(
                username: state.pathParameters['username']!,
                selectedIndex: 2,
                params: state.extra as Map<String, dynamic>? ?? {})),
      ),
    ),
    GoRoute(
        path: '/profile/:username/bookmarks',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: UniqueKey(),
            child: ScreenWithHeaderAndFooter(
              body: Profile(
                  username: state.pathParameters['username']!,
                  selectedIndex: 3,
                  params: state.extra as Map<String, dynamic>? ?? {}),
            ))),
    GoRoute(
        path: '/profile/:username/followings',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: UniqueKey(),
            child: ScreenWithHeaderAndFooter(
              body: Profile(
                  username: state.pathParameters['username']!,
                  selectedIndex: 4,
                  params: state.extra as Map<String, dynamic>? ?? {}),
            ))),
    GoRoute(
        path: '/profile/:username/followers',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: UniqueKey(),
            child: ScreenWithHeaderAndFooter(
              body: Profile(
                  username: state.pathParameters['username']!,
                  selectedIndex: 5,
                  params: state.extra as Map<String, dynamic>? ?? {}),
            ))),
    GoRoute(
        path: '/profile/:username/personal',
        pageBuilder: (context, state) => MaterialPage<void>(
            key: UniqueKey(),
            child: ScreenWithHeaderAndFooter(
              body: Profile(
                  username: state.pathParameters['username']!,
                  selectedIndex: 6,
                  params: state.extra as Map<String, dynamic>? ?? {}),
            ))),
    GoRoute(
      path: '/comment',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: ValueKey('comment'),
        child: ScreenWithHeaderAndFooter(
          body: CommentView(postId: "654d3e139d8e142b7fadc7ca"),
        ),
      ),
    )
  ],
  errorPageBuilder: (context, state) => const MaterialPage<void>(
      key: ValueKey('not-found'),
      child: ScreenWithHeaderAndFooter(body: NotFound())),
);

Map<String, String> convertQuery({required String query}) {
  Map<String, String> params = {};
  query.split("&").forEach((param) {
    List<String> keyValue = param.split("=");
    if (keyValue.length == 2) {
      params[keyValue[0]] = keyValue[1];
    }
  });
  return params;
}
