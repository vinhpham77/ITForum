import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      String? accessToken = prefs.getString('accessToken');
      JwtInterceptor().parseJwt(accessToken, needToRefresh: true);
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primaryColor: Colors.black,
      ),
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      routerDelegate: appRouter.routerDelegate,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
