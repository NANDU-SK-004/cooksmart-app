import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CookSmartApp());
}

class CookSmartApp extends StatefulWidget {
  const CookSmartApp({super.key});

  @override
  State<CookSmartApp> createState() => _CookSmartAppState();
}

class _CookSmartAppState extends State<CookSmartApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainShell(state: _appState),
    );
  }
}
