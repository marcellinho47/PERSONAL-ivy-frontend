import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/screens/home.dart';
import 'package:sys_ivy_frontend/screens/login.dart';

class Routes {

  // ADD NEW ROUTES HERE
  static const String INITAL_ROUTE = "/";
  static const String LOGIN_ROUTE = "/login";
  static const String HOME_ROUTE = "/home";

  // NAVIGATION
  static Route<dynamic> createRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case INITAL_ROUTE:
        return MaterialPageRoute(builder: (_) => const Login());
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => const Login());
      case HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => const Home());
    }

    return _errorNotFoundRoute();
  }

  static Route<dynamic> _errorNotFoundRoute() {
    return MaterialPageRoute(builder: (_) => const Login());
  }
}