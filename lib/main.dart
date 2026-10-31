import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..initData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '9mart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: appRouter,
    );
  }
}
