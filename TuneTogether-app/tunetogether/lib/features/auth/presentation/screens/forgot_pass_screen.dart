import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunetogether/common/helpers/extensions.dart';
import 'package:tunetogether/common/widgets/text_field.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/loading_btn.dart';
import '../widgets/submit_btn.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _formkey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int step = 0;

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

  _onContinue() {
    if (_formkey.currentState!.validate()) {
      if (step == 0) {
        // send otp
        context
            .read<AuthBloc>()
            .add(SendPassResetOtpEvent(email: _emailController.text.trim()));
      } else if (step == 1) {
        // verify otp
        context.read<AuthBloc>().add(VerifyOtpEvent(
              code: _otpController.text.trim(),
              email: _emailController.text.trim(),
            ));
      } else {
        // reset pass
        context.read<AuthBloc>().add(ResetPassEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ));
      }
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
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          _changeScreen('/sign-in', isReplacement: true);
        } else if (state is SentPassResetCode) {
          _showMessage('Code sent');
          setState(() {
            step = 1;
          });
        } else if (state is VerifiedPassResetCode) {
          _showMessage('Code is valid');
          setState(() {
            step = 2;
          });
        } else if (state is PassResetCodeError) {
          setState(() {
            step = 0;
          });
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: _buildHeader(context),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: _buildForm(context),
          ),
          const SizedBox(height: 340),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildContinueBtn(context),
          ),
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your email address, and we'll send you a code to reset your password.",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  _buildForm(BuildContext context) {
    return Column(
      children: [
        if (step == 0)
          Form(
            key: _formkey,
            child: MyFormTextField(
              hintText: 'example@gmail.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              keyboardAction: TextInputAction.next,
              validator: (val) {
                if (!val!.isValidEmail) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
          ),
        if (step == 1)
          Form(
            key: _formkey,
            child: PinCodeField(
              otpController: _otpController,
            ),
          ),
        if (step == 2)
          Form(
            key: _formkey,
            child: Column(
              children: [
                MyFormTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Password',
                  keyboardAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (!val!.isValidPassword) {
                      return 'Enter a valid password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                MyFormTextField(
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Confirm Password',
                  keyboardAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (!val!.isValidPassword) {
                      return 'Enter a valid password.';
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  _buildContinueBtn(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const LoadingBtn();
        }
        return SubmitBtn(
          onPressed: () {
            _onContinue();
          },
          text: 'Continue',
        );
      },
    );
  }
}
