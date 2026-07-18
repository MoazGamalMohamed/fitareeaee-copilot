import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/user_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const EditProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  final _formKey = GlobalKey<FormState>();
  
  bool _isPhoneVerified = false;
  String? _originalPhone;
  bool _isVerifying = false;
  String _countryCode = '+20'; // Default to Egypt
  String? _verificationId;
  
  Set<String> _selectedRoles = {};
  final List<String> _availableRoles = ['rider', 'sender', 'driver', 'courier'];
  
  final Map<String, String> _countryCodes = {
    '+1': '🇺🇸 US',
    '+20': '🇪🇬 EG',
    '+44': '🇬🇧 UK',
    '+966': '🇸🇦 SA',
    '+971': '🇦🇪 AE',
    '+965': '🇰🇼 KW',
    '+962': '🇯🇴 JO',
    '+91': '🇮🇳 IN',
    '+86': '🇨🇳 CN',
    '+81': '🇯🇵 JP',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    // If phone number changed, mark as not verified
    if (_phoneController.text != _originalPhone) {
      setState(() {
        _isPhoneVerified = false;
      });
    } else {
      // Phone reverted to original, restore verification status
      setState(() {
        _isPhoneVerified = _originalPhone != null;
      });
    }
  }

  void _toggleRole(String role) {
    setState(() {
      if (_selectedRoles.contains(role)) {
        _selectedRoles.remove(role);
      } else {
        _selectedRoles.add(role);
        
        // Show verification requirement for driver/courier
        if (role == 'driver' || role == 'courier') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Adding $role role requires additional verification. '
                'Please complete the verification process after saving.',
              ),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    });
  }

  Future<void> _verifyPhoneNumber() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    // Auto-add country code if not present
    if (!phone.startsWith('+')) {
      phone = _countryCode + phone;
      _phoneController.text = phone;
    }

    setState(() => _isVerifying = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          setState(() {
            _isPhoneVerified = true;
            _originalPhone = phone;
            _isVerifying = false;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$phone verified automatically!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isVerifying = false);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Verification failed: ${e.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isVerifying = false;
          });
          
          // Show dialog to enter SMS code
          _showCodeInputDialog(phone);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() => _isVerifying = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCodeInputDialog(String phone) {
    final codeController = TextEditingController();
    bool isVerifying = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Enter Verification Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A verification code has been sent to $phone'),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  hintText: '123456',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                autofocus: true,
                enabled: !isVerifying,
              ),
              if (isVerifying)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isVerifying ? null : () {
                Navigator.of(dialogContext).pop();
                codeController.dispose();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isVerifying ? null : () async {
                final code = codeController.text.trim();
                if (code.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please enter the code')),
                  );
                  return;
                }

                if (code.length != 6) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Code must be 6 digits'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                if (_verificationId == null) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Verification ID not found. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setDialogState(() => isVerifying = true);

                try {
                  // Create credential with verification ID and SMS code
                  final credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId!,
                    smsCode: code,
                  );

                  // Verify the credential (don't link to account, just verify)
                  await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);

                  // Close dialog first
                  Navigator.of(dialogContext).pop();

                  // Wait a moment for dialog to close completely
                  await Future.delayed(const Duration(milliseconds: 100));
                  
                  // Dispose controller after dialog is closed
                  codeController.dispose();

                  // Then update state
                  if (mounted) {
                    setState(() {
                      _isPhoneVerified = true;
                      _originalPhone = phone;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$phone verified successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  setDialogState(() => isVerifying = false);
                  
                  String errorMessage = 'Invalid verification code';
                  if (e is FirebaseAuthException) {
                    switch (e.code) {
                      case 'invalid-verification-code':
                        errorMessage = 'Invalid code. Please check and try again.';
                        break;
                      case 'session-expired':
                        errorMessage = 'Code expired. Please request a new one.';
                        break;
                      default:
                        errorMessage = e.message ?? 'Verification failed';
                    }
                  }
                  
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile(UserProfile currentProfile) {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      
      // Check if phone changed and not verified
      if (phone.isNotEmpty && phone != _originalPhone && !_isPhoneVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your phone number before saving'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final updatedProfile = currentProfile.copyWith(
        name: _nameController.text,
        phone: phone.isEmpty ? null : phone,
        address: _addressController.text,
        city: _cityController.text,
        country: _countryController.text,
        roles: _selectedRoles.toList(),
        isPhoneVerified: _isPhoneVerified,
        updatedAt: DateTime.now(),
      );

      ref.read(updateProfileProvider.notifier).updateProfile(updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider(widget.userId));
    final updateState = ref.watch(updateProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          // Initialize form fields with current profile data
          if (_nameController.text.isEmpty) {
            _nameController.text = profile.name;
            _phoneController.text = profile.phone ?? '';
            _addressController.text = profile.address ?? '';
            _cityController.text = profile.city ?? '';
            _countryController.text = profile.country ?? '';
            
            // Initialize phone verification status
            _isPhoneVerified = profile.isPhoneVerified;
            _originalPhone = profile.phone;
            
            // Initialize roles
            _selectedRoles = profile.roles.toSet();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile header
                  const SizedBox(height: 16),
                  Text(
                    'Edit Your Profile Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),

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

                  // Email field (read-only)
                  TextFormField(
                    initialValue: profile.email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon: profile.isEmailVerified
                          ? const Icon(Icons.verified, color: Colors.green, size: 20)
                          : null,
                      helperText: profile.isEmailVerified 
                          ? 'Verified' 
                          : 'Not verified',
                      helperStyle: TextStyle(
                        color: profile.isEmailVerified 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // Phone number field with country code
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country code dropdown
                      Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _countryCode,
                            isExpanded: true,
                            items: _countryCodes.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _countryCode = value);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Phone number field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '1234567890',
                            prefixIcon: const Icon(Icons.phone),
                            suffixIcon: _isPhoneVerified
                                ? const Icon(Icons.verified, color: Colors.green, size: 20)
                                : null,
                            helperText: _isPhoneVerified
                                ? 'Verified'
                                : _phoneController.text.isNotEmpty && _phoneController.text != _originalPhone
                                    ? 'Not verified - Click verify button below'
                                    : null,
                            helperStyle: TextStyle(
                              color: _isPhoneVerified ? Colors.green : Colors.orange,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => _onPhoneChanged(),
                        ),
                      ),
                    ],
                  ),
                  if (_phoneController.text.isNotEmpty && !_isPhoneVerified) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _isVerifying ? null : _verifyPhoneNumber,
                      icon: _isVerifying 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.verified_user),
                      label: Text(_isVerifying ? 'Sending Code...' : 'Verify Phone Number'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Roles section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Roles',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select the roles you want to have in the app. Driver and Courier roles require additional verification.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _availableRoles.map((role) {
                              final isSelected = _selectedRoles.contains(role);
                              final requiresVerification = role == 'driver' || role == 'courier';
                              
                              return FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      role[0].toUpperCase() + role.substring(1),
                                    ),
                                    if (requiresVerification) ...[
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.verified_user,
                                        size: 16,
                                        color: isSelected ? Colors.white : Colors.orange,
                                      ),
                                    ],
                                  ],
                                ),
                                selected: isSelected,
                                onSelected: (selected) => _toggleRole(role),
                                selectedColor: requiresVerification ? Colors.orange : Colors.blue,
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address field
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // City field
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Enter your city',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Country field
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      hintText: 'Enter your country',
                      prefixIcon: Icon(Icons.public),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  ElevatedButton(
                    onPressed: updateState.isLoading
                        ? null
                        : () => _saveProfile(profile),
                    child: updateState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Changes'),
                  ),

                  // Display success/error messages
                  if (updateState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Text(
                          'Error: ${updateState.error}',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ),

                  if (updateState.hasValue && !updateState.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Text(
                          'Profile updated successfully',
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, st) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
