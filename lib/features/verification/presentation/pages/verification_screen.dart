import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:country_picker/country_picker.dart';
import '../../domain/models/verification_model.dart';
import '../providers/verification_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _picker = ImagePicker();
  String? _uploadingType;
  String? _verificationId; // For phone verification

  Future<void> _uploadDocument(VerificationType type, String title) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile == null) return;

    setState(() {
      _uploadingType = type.name;
    });

    try {
      final file = File(pickedFile.path);
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      // Upload to Firebase Storage
      final params = UploadDocumentParams(file: file, type: type);
      final downloadUrl = await ref.read(
        uploadVerificationDocumentProvider(params).future,
      );

      // Submit verification request
      await submitVerification(
        userId: userId,
        type: type,
        documentUrl: downloadUrl,
      );

      if (type != VerificationType.identity && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title uploaded successfully. Pending review.'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Upload failed. Check the image and connection, then try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingType = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationAsync = ref.watch(currentUserVerificationProvider);
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Center')),
      body: verificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (verification) => userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (_) => _buildContent(verification),
        ),
      ),
    );
  }

  Widget _buildContent(UserVerification? verification) {
    final level = verification?.verificationLevel ?? 0;
    const totalSteps = 6;
    final approvedSteps = _approvedStepCount(verification);
    final pendingSteps = _pendingStepCount(verification);
    final progressValue = ((approvedSteps + pendingSteps * 0.5) / totalSteps)
        .clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Verification Level Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  _getLevelIcon(level),
                  size: 64,
                  color: _getLevelColor(level),
                ),
                const SizedBox(height: 8),
                Text(
                  verification?.badgeText ?? 'Unverified',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _getLevelColor(level),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Verification Level $level/4',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(_getLevelColor(level)),
                ),
                const SizedBox(height: 8),
                Text(
                  '$approvedSteps approved, $pendingSteps pending of $totalSteps checks',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Verification Items
        _buildVerificationItem(
          title: 'Email Verification',
          subtitle: 'Verify your email address',
          icon: Icons.email,
          isVerified: verification?.emailVerified ?? false,
          onTap: () => _sendEmailVerification(),
        ),
        _buildVerificationItem(
          title: 'Phone Verification',
          subtitle: 'Verify your phone number',
          icon: Icons.phone,
          isVerified: verification?.phoneVerified ?? false,
          onTap: () => _verifyPhone(),
        ),
        _buildVerificationItem(
          title: 'Identity Document',
          subtitle: 'Upload your ID card or passport',
          icon: Icons.badge,
          isVerified: verification?.identityVerified ?? false,
          isUploading: _uploadingType == VerificationType.identity.name,
          isPending:
              (verification?.identityDocumentUrl != null &&
              !(verification?.identityVerified ?? false)),
          onTap: () =>
              _uploadDocument(VerificationType.identity, 'Identity Document'),
        ),
        _buildVerificationItem(
          title: 'Selfie with ID',
          subtitle: 'Upload a selfie holding your ID',
          icon: Icons.face,
          isVerified: verification?.selfieWithIdVerified ?? false,
          isUploading: _uploadingType == VerificationType.selfieWithId.name,
          isPending:
              (verification?.selfieWithIdUrl != null &&
              !(verification?.selfieWithIdVerified ?? false)),
          onTap: () =>
              _uploadDocument(VerificationType.selfieWithId, 'Selfie with ID'),
        ),
        _buildVerificationItem(
          title: 'Driver License',
          subtitle: 'Required before offering rides',
          icon: Icons.badge_outlined,
          isVerified: verification?.driverLicenseVerified ?? false,
          isUploading: _uploadingType == VerificationType.driverLicense.name,
          isPending:
              (verification?.driverLicenseUrl != null &&
              !(verification?.driverLicenseVerified ?? false)),
          onTap: () =>
              _uploadDocument(VerificationType.driverLicense, 'Driver License'),
        ),
        _buildVerificationItem(
          title: 'Vehicle Registration',
          subtitle: 'Required before offering rides or deliveries',
          icon: Icons.directions_car_filled_outlined,
          isVerified: verification?.vehicleVerified ?? false,
          isUploading: _uploadingType == VerificationType.vehicle.name,
          isPending:
              (verification?.vehicleRegistrationUrl != null &&
              !(verification?.vehicleVerified ?? false)),
          onTap: () =>
              _uploadDocument(VerificationType.vehicle, 'Vehicle Registration'),
        ),
      ],
    );
  }

  int _approvedStepCount(UserVerification? verification) {
    if (verification == null) return 0;
    return [
      verification.emailVerified,
      verification.phoneVerified,
      verification.identityVerified,
      verification.selfieWithIdVerified,
      verification.driverLicenseVerified,
      verification.vehicleVerified,
    ].where((isVerified) => isVerified).length;
  }

  int _pendingStepCount(UserVerification? verification) {
    if (verification == null) return 0;
    return [
      verification.identityDocumentUrl != null &&
          !verification.identityVerified,
      verification.selfieWithIdUrl != null &&
          !verification.selfieWithIdVerified,
      verification.driverLicenseUrl != null &&
          !verification.driverLicenseVerified,
      verification.vehicleRegistrationUrl != null &&
          !verification.vehicleVerified,
    ].where((isPending) => isPending).length;
  }

  Widget _buildVerificationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isVerified,
    bool isUploading = false,
    bool isPending = false,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVerified
              ? Colors.green
              : (isPending ? Colors.orange : Colors.grey[300]),
          child: isUploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  icon,
                  color: isVerified || isPending
                      ? Colors.white
                      : Colors.grey[600],
                ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isVerified
            ? const Icon(Icons.check_circle, color: Colors.green)
            : (isPending
                  ? const Chip(
                      label: Text(
                        'Pending Approval',
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.orange,
                      labelStyle: TextStyle(color: Colors.white),
                    )
                  : TextButton(
                      onPressed: isUploading ? null : onTap,
                      child: Text(isUploading ? 'Uploading...' : 'Verify'),
                    )),
        onTap: isVerified || isUploading ? null : onTap,
      ),
    );
  }

  IconData _getLevelIcon(int level) {
    switch (level) {
      case 0:
        return Icons.shield_outlined;
      case 1:
        return Icons.verified_user_outlined;
      case 2:
        return Icons.verified_user;
      case 3:
        return Icons.verified;
      case 4:
        return Icons.workspace_premium;
      default:
        return Icons.shield_outlined;
    }
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Reload user to get latest verification status
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified ?? false) {
        await FirebaseFunctions.instance
            .httpsCallable('syncContactVerification')
            .call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email already verified'),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      }

      await user.sendEmailVerification();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verification Email Sent'),
            content: const Text(
              'Please check your inbox and click the verification link. Then return here and tap the Email Verification item again to refresh your status.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _verifyPhone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if user already has a phone number linked
    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      await _updatePhoneVerificationStatus(user.phoneNumber!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone already verified'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return;
    }

    // Detect user's country from locale
    String countryCode = 'US'; // Default
    try {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      countryCode = locale.countryCode ?? 'US';
    } catch (e) {
      // Use default
    }

    Country selectedCountry = CountryParser.parseCountryCode(countryCode);
    final phoneController = TextEditingController();

    final phoneNumber = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Enter Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Country Picker Button
              OutlinedButton.icon(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                  );
                },
                icon: Text(
                  selectedCountry.flagEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                label: Text(
                  '+${selectedCountry.phoneCode} ${selectedCountry.name}',
                ),
              ),
              const SizedBox(height: 16),
              // Phone Number Input
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  helperText: 'Without country code',
                  prefixText: '+${selectedCountry.phoneCode} ',
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final fullNumber =
                    '+${selectedCountry.phoneCode}${phoneController.text.trim()}';
                Navigator.pop(context, fullNumber);
              },
              child: const Text('Send Code'),
            ),
          ],
        ),
      ),
    );

    if (phoneNumber == null || phoneNumber.isEmpty) return;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          try {
            await FirebaseAuth.instance.currentUser?.updatePhoneNumber(
              credential,
            );
            await _updatePhoneVerificationStatus(phoneNumber);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Phone verified successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Verification failed: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
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
          });
          _showCodeInputDialog(phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showCodeInputDialog(String phoneNumber) async {
    final codeController = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Verification Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the 6-digit code sent to $phoneNumber'),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                hintText: '123456',
                prefixIcon: Icon(Icons.sms),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, codeController.text.trim()),
            child: const Text('Verify'),
          ),
        ],
      ),
    );

    if (code == null || code.isEmpty) return;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );

      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      await _updatePhoneVerificationStatus(phoneNumber);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updatePhoneVerificationStatus(String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFunctions.instance
        .httpsCallable('syncContactVerification')
        .call();
  }
}
