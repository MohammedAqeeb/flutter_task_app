import 'package:flutter/material.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_up_page.dart';
import 'package:frontend/features/blog/pages/home_page.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final authRepo = AuthRepository();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void validateLogin() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.withOpacity(0.3),
                content: Text(state.message),
              ),
            );
          } else if (state is AuthStateSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthStateLoding) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email
                  emailTextField(),
                  const SizedBox(height: 20),
                  // Password
                  passwordField(),
                  const SizedBox(height: 25),
                  signInButton(),
                  const SizedBox(height: 20),
                  createButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      controller: emailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email field can\'t be empty';
        }
        return null;
      },
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      controller: passwordController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password field can\'t be empty';
        }
        return null;
      },
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: validateLogin,
      child: const Text(
        'SIGN IN',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget createButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SignUpPage.route());
      },
      child: RichText(
        text: TextSpan(
          text: 'Does\'t have an Account? ',
          style: Theme.of(context).textTheme.titleMedium,
          children: const [
            TextSpan(
              text: 'Create Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
