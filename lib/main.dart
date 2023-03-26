import 'package:flutter/material.dart';

import 'logistics_login.dart';

void main() {
  runApp(LogisticsApp());
}

class LogisticsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        // canvasColor: Colors.yellow,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
              background: Colors.grey,
              secondary: Colors.black,
            ),
      ),
      home: LogisticsLogin(),
    );
  }
}
