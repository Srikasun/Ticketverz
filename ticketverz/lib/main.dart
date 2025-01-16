import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketverz/screens/onboarding_screen.dart';
import 'package:ticketverz/screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Scanner',
      theme: appTheme, // Custom theme defined in `theme.dart`
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Starting screen of the app
      onGenerateRoute: (settings) => _generateRoute(settings),
      builder: (context, child) {
        // Adding smooth animations globally
        return PageTransitionSwitcher(
          duration: Duration(milliseconds: 300),
          reverse: false,
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }

  // Route generation for navigation
  Route _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      // Add more routes as needed
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
