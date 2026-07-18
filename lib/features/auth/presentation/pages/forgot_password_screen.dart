import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/error_dialog.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(passwordResetProvider);

    ref.listen<AsyncValue<void>>(passwordResetProvider, (previous, next) {
      next.when(
        data: (_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reset Email Sent'),
              content: const Text(
                'Check your email for password reset instructions.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          showErrorDialog(
            context: context,
            title: 'Reset Failed',
            message: error.toString(),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email to receive reset instructions',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Email is required';
                    }
                    if (!value!.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Reset button
                ElevatedButton(
                  onPressed: resetState.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(passwordResetProvider.notifier)
                                .resetPassword(email: _emailController.text);
                          }
                        },
                  child: resetState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send Reset Email'),
                ),
                const SizedBox(height: 16),

                // Back to login
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
