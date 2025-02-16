import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}