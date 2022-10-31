// ignore_for_file: use_build_context_synchronously

import 'package:devhub/services/auth_service.dart';
import 'package:devhub/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../screens/mainscreen.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? email, password;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  AuthService authService = AuthService();

  login(BuildContext context) async {
    FormState formState = formKey.currentState!;
    formState.save();
    if (!formState.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      loading = true;
      notifyListeners();
      try {
        bool success = await authService.loginUser(
          email: email,
          password: password,
        );
        print(success);
        if (success) {
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (_) => const TabScreen()));
        }
      } catch (e) {
        loading = false;
        notifyListeners();
        print(e);
        showInSnackBar(
            authService.handleFirebaseAuthError(e.toString()), context);
      }
      loading = false;
      notifyListeners();
    }
  }

  forgotPassword(BuildContext context) async {
    loading = true;
    notifyListeners();
    FormState formState = formKey.currentState!;
    formState.save();
    print(Validations.validateEmail(email));
    if (Validations.validateEmail(email) != null) {
      showInSnackBar(
          "Please input a valid email to reset your password.", context);
    } else {
      try {
        await authService.forgotPassword(email!);
        showInSnackBar(
            'Please check your email for instructions to rest your password',
            context);
      } catch (e) {
        showInSnackBar(e.toString(), context);
      }
    }
    loading = false;
    notifyListeners();
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
