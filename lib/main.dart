import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sys_ivy_frontend/config/routes_config.dart';
import 'package:sys_ivy_frontend/utils/color_pallete.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYS - ANC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColorPallete.primaryColor,
      ),
      initialRoute: Routes.CLIENTS_ADD_EDIT_ROUTE,
      onGenerateRoute: Routes.createRoute,
    );
  }
}
