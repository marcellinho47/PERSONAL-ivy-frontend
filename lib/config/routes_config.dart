// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/screens_config.dart';
import 'package:sys_ivy_frontend/screens/category_add_edit_screen.dart';
import 'package:sys_ivy_frontend/screens/category_screen.dart';
import 'package:sys_ivy_frontend/screens/dashboard_screen.dart';
import 'package:sys_ivy_frontend/screens/home_screen.dart';
import 'package:sys_ivy_frontend/screens/login_screen.dart';
import 'package:sys_ivy_frontend/screens/operator_add_edit_screen.dart';
import 'package:sys_ivy_frontend/screens/operator_screen.dart';

class Routes {
  // ADD NEW ROUTES HERE
  static const String INITAL_ROUTE = "/";
  static const String LOGIN_ROUTE = "/login";
  static const String HOME_ROUTE = "/home";
  static const String DASHBOARD_ROUTE = "/dashboard";
  static const String PURCHASES_ROUTE = "/purchases";
  static const String SALES_ROUTE = "/sales";
  static const String CATEGORIES_ROUTE = "/categories";
  static const String CATEGORIES_ADD_EDIT_ROUTE = "/categories/add_edit";
  static const String PRODUCTS_ROUTE = "/products";
  static const String STOCK_ROUTE = "/stock";
  static const String OPERATOR_ROUTE = "/operator";
  static const String OPERATOR_ADD_EDIT_ROUTE = "/operator/add_edit";
  static const String LOGOUT_ROUTE = "/logout";

  // NAVIGATION
  static Route<dynamic> createRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case INITAL_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case LOGIN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case HOME_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            null,
            ScreenName.HOME_SCREEN,
          ),
        );
      case DASHBOARD_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            DashBoardScreen(),
            ScreenName.DASHBOARD_SCREEN,
          ),
        );
      case PURCHASES_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            null,
            ScreenName.PURCHASES_SCREEN,
          ),
        );
      case SALES_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            null,
            ScreenName.SALES_SCREEN,
          ),
        );
      case CATEGORIES_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            CategoryScreen(),
            ScreenName.CATEGORIES_SCREEN,
          ),
        );
      case CATEGORIES_ADD_EDIT_ROUTE:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            CategoryAddEditScreen(args),
            ScreenName.CATEGORIES_ADD_EDIT_SCREEN,
          ),
        );
      case PRODUCTS_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            null,
            ScreenName.PRODUCTS_SCREEN,
          ),
        );
      case STOCK_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            null,
            ScreenName.STOCK_SCREEN,
          ),
        );
      case OPERATOR_ROUTE:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            Operator(),
            ScreenName.OPERATOR_SCREEN,
          ),
        );
      case OPERATOR_ADD_EDIT_ROUTE:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            OperatorAddEditScreen(args),
            ScreenName.OPERATOR_ADD_EDIT_SCREEN,
          ),
        );
    }

    return _errorNotFoundRoute();
  }

  static Route<dynamic> _errorNotFoundRoute() {
    // TODO create not found error page

    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    );
  }
}
