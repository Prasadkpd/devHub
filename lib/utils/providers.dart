import 'package:devhub/view_models/theme/theme_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:devhub/view_models/auth/login_view_model.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_)=> LoginViewModel()),
  ChangeNotifierProvider(create: (_)=> ThemeProvider())
];
