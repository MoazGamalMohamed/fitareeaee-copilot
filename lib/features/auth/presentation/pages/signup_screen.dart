import 'package:fitareeaee/core/routing/app_router.dart';
import 'package:fitareeaee/core/user_path.dart';
import 'package:fitareeaee/core/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/app_user.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  MarketplacePath? _selectedPath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpProvider);

    ref.listen<AsyncValue<AppUser?>>(signUpProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            context.go(AppRoutes.home);
          }
        },
        error: (error, stackTrace) {
          showErrorDialog(
            context: context,
            title: 'Sign Up Failed',
            message: error.toString(),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Phone is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password is required';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // One account path keeps rider and driver responsibilities clear.
                Text(
                  'Choose your marketplace path',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SegmentedButton<MarketplacePath>(
                  emptySelectionAllowed: true,
                  showSelectedIcon: true,
                  segments: const [
                    ButtonSegment(
                      value: MarketplacePath.rider,
                      icon: Icon(Icons.person_search),
                      label: Text('Request'),
                      tooltip: 'Rider or sender',
                    ),
                    ButtonSegment(
                      value: MarketplacePath.driver,
                      icon: Icon(Icons.drive_eta),
                      label: Text('Offer'),
                      tooltip: 'Driver or courier',
                    ),
                  ],
                  selected: {if (_selectedPath != null) _selectedPath!},
                  onSelectionChanged: (selection) {
                    setState(
                      () => _selectedPath = selection.isEmpty
                          ? null
                          : selection.first,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedPath == MarketplacePath.driver
                      ? 'Drivers and couriers publish offers and receive payment. Driver and vehicle verification is required before offering.'
                      : _selectedPath == MarketplacePath.rider
                      ? 'Riders and senders request rides or deliveries and are the paying side after a real payment provider is enabled.'
                      : 'Choose Request for the rider/sender path or Offer for the verified driver/courier path.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 32),

                // Sign up button
                ElevatedButton(
                  onPressed: signUpState.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedPath == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please choose Request or Offer',
                                  ),
                                ),
                              );
                              return;
                            }
                            ref
                                .read(signUpProvider.notifier)
                                .signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  name: _nameController.text,
                                  phone: _phoneController.text,
                                  roles: rolesForMarketplacePath(
                                    _selectedPath!,
                                  ),
                                );
                          }
                        },
                  child: signUpState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 16),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
