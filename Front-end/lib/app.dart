import 'package:api_aeroporto/core/theme/app_theme.dart';
import 'package:api_aeroporto/features/auth/presentation/views/login_screen.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/passageiros_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/portoes_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/voos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PortoesViewModel()),
        ChangeNotifierProvider(create: (_) => VoosViewModel()),
        ChangeNotifierProvider(create: (_) => PassageirosViewModel()),
      ],
      child: MaterialApp(
        title: 'API em Node testada no App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
