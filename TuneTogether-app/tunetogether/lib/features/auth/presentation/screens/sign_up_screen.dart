import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunetogether/common/widgets/text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/alternate_auth.dart';
import '../widgets/loading_btn.dart';
import '../widgets/submit_btn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _changeScreen(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool isReplacement = false,
  }) {
    if (isReplacement) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onSignUpPressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthBloc>().add(SignUpEvent(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  _buildBody(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showMessage(state.error);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildForm(context),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildSignInBtn(context),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildAlternateAuths(context),
            ),
            const SizedBox(height: 32),
            _buildToSignInText(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'New Here?',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your TuneTogether account to connect with friends and start tuning together.',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          MyFormTextField(
            hintText: 'username',
            controller: _usernameController,
            keyboardType: TextInputType.name,
            label: 'Username',
            keyboardAction: TextInputAction.next,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Username is required';
              }
              // if (!email.isValidEmail) {
              //   return 'Enter a valid email address';
              // }
              return null;
            },
          ),
          const SizedBox(height: 18),
          MyFormTextField(
            hintText: 'example@gmail.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
            keyboardAction: TextInputAction.next,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Email is required';
              }
              // if (!email.isValidEmail) {
              //   return 'Enter a valid email address';
              // }
              return null;
            },
          ),
          const SizedBox(height: 18),
          MyFormTextField(
            hintText: 'password',
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            label: 'Password',
            keyboardAction: TextInputAction.done,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Password is required';
              } else if (email == 'password') {
                return 'Enter a secured password';
              }
              // } else if (!email.isValidPassword) {
              //   return 'Password must be at least 8 characters long';
              // }
              return null;
            },
            obscureText: true,
          ),
        ],
      ),
    );
  }

  _buildSignInBtn(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const LoadingBtn();
        }
        return SubmitBtn(
          onPressed: () {
            _onSignUpPressed();
          },
          text: 'Sign Up',
        );
      },
    );
  }

  _buildAlternateAuths(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AlternateAuth(
          asset: 'assets/svg/google.svg',
          onTap: () {
            context.read<AuthBloc>().add(const GoogleAuthEvent());
          },
        ),
        const SizedBox(width: 12),
        AlternateAuth(
          asset: 'assets/svg/telephone.svg',
          onTap: () {},
        ),
        const SizedBox(width: 12),
        AlternateAuth(
          asset: 'assets/svg/github.svg',
          onTap: () {},
        ),
      ],
    );
  }

  _buildToSignInText(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _changeScreen('/sign-in', isReplacement: true),
          child: RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                fontSize: theme.textTheme.titleMedium!.fontSize,
                color: theme.colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: 'Sign in',
                  style: TextStyle(
                    fontSize: theme.textTheme.titleMedium!.fontSize,
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
