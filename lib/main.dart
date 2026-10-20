import 'package:balance/core/app.dart';
import 'package:balance/core/database/db_helper.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initialize();
  runApp(const App());
}
