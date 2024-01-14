import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/router.dart';

void main() {
  usePathUrlStrategy();
  runApp(const ITForumApp());
}

class ITForumApp extends StatefulWidget {
  const ITForumApp({super.key});

  @override
  State<ITForumApp> createState() => _ITForumAppState();
}

class _ITForumAppState extends State<ITForumApp> {
  Future<void>? _loadJwtFuture;

  @override
  void initState() {
    super.initState();
    _loadJwtFuture = loadJwt();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadJwtFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        var isLoading = snapshot.connectionState != ConnectionState.done;
        return buildMaterialApp(isLoading: isLoading);
      },
    );
  }

  Future<void> loadJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    await JwtInterceptor()
        .parseJwt(accessToken, needToRefresh: true);
  }

  Widget buildMaterialApp({bool isLoading = false}) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Starfruit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.indigoAccent,
        ),
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : child!;
      },
    );
  }
}
