import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text("No route is configured"))),
    );
  }
}
