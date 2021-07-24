import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Bindings/ListBinding.dart';
import 'Screens/EmployeeDetailScreen.dart';
import 'Screens/EmployeeListScreen.dart';
import 'Screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(DirectoryApp());
  });
}

class DirectoryApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: '/',
      getPages: [
        GetPage(name: "/", page: () => SplashScreen()),
        GetPage(
            name: "/employee-list",
            page: () => EmployeeListScreen(),
            binding: ListBinding(),
            transition: Transition.fade),
        GetPage(
            name: "/detail-page",
            page: () => EmployeeDetailScreen(),
            transition: Transition.zoom),
      ],
    );
  }
}
