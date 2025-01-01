import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunetogether/common/widgets/text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/alternate_auth.dart';
import '../widgets/loading_btn.dart';
import '../widgets/submit_btn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

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

  void _onSignInPressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthBloc>().add(SignInEvent(
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
        if (state is Authenticated) {
          _changeScreen('/home', isReplacement: true);
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildForm(context),
            ),
            const SizedBox(height: 200),
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
            _buildToSignUpText(context),
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
        Text(
          'Welcome back!',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Log in to your TuneTogether account to access your friends, chats, and rooms.',
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
            keyboardAction: TextInputAction.next,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _changeScreen('/forgot-password');
                },
                child: Text(
                  'Forgot password?',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
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
            _onSignInPressed();
          },
          text: 'Sign In',
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

  _buildToSignUpText(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _changeScreen('/sign-up', isReplacement: true),
          child: RichText(
            text: TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                fontSize: theme.textTheme.titleMedium!.fontSize,
                color: theme.colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: 'Sign up',
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
