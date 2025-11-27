import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/get_it/get_it.dart';
import '../../domain/services/auth_service.dart';
import '../widgets/custom_text_form_field.dart';
import 'provider/login_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginNotifier>().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  Widget buttonContent(bool isLoading) {
    if (isLoading) return const CircularProgressIndicator();
    return const Text('LOGIN');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginNotifier(getIt<AuthService>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Consumer<LoginNotifier>(
                builder: (context, LoginNotifier notifier, child) {
                  final state = notifier.state;
                  return ElevatedButton(
                    onPressed: () => login(context),
                    child: buttonContent(state.isLoading),
                  );
                },
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hi there!', style: TextStyle(fontSize: 25)),
                const SizedBox(height: 50),
                CustomTextFormField.email(_emailController),
                const SizedBox(height: 10),
                CustomTextFormField.password(_passwordController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
