import 'package:devhub/view_models/auth/register_view_model.dart';
import 'package:devhub/widgets/indeicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
key: viewModel.scaffoldKey,
body: ListView(
  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
  children: [
    SizedBox()
  ],
),
      ),
    );
  }
}
