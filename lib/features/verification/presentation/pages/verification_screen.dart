import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/user_path.dart';
import '../../domain/models/verification_model.dart';
import '../../domain/verification_requirements.dart';
import '../providers/verification_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key, this.role});

  final String? role;

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _picker = ImagePicker();
  String? _uploadingType;
  String? _verificationId; // For phone verification
  bool? _driverMode;

  @override
  void initState() {
    super.initState();
    _driverMode = switch (widget.role) {
      'driver' => true,
      'rider' => false,
      _ => null,
    };
  }

  @override
  void didUpdateWidget(covariant VerificationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role != widget.role) {
      _driverMode = switch (widget.role) {
        'driver' => true,
        'rider' => false,
        _ => null,
      };
    }
  }

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
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Center')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _buildLoadError(),
        data: (user) {
          if (user == null) return _buildLoadError();
          final verificationAsync = ref.watch(
            userVerificationProvider(user.id),
          );
          return verificationAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => _buildLoadError(userId: user.id),
            data: (verification) => _buildContent(
              verification,
              isDriver:
                  _driverMode ?? marketplacePathForRoles(user.roles).isDriver,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadError({String? userId}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 52),
            const SizedBox(height: 12),
            const Text(
              'Verification could not be loaded safely.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your connection and try again. Your uploaded documents are not removed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (userId != null) {
                  ref.invalidate(userVerificationProvider(userId));
                } else {
                  ref.invalidate(authStateProvider);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry verification'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    UserVerification? verification, {
    required bool isDriver,
  }) {
    final totalSteps = tripVerificationTotalSteps(driver: isDriver);
    final approvedSteps = approvedTripVerificationStepCount(
      verification,
      driver: isDriver,
    );
    final pendingSteps = pendingTripVerificationStepCount(
      verification,
      driver: isDriver,
    );
    final submittedSteps = submittedTripVerificationStepCount(
      verification,
      driver: isDriver,
    );
    final allApproved = approvedSteps == totalSteps;
    final statusColor = allApproved
        ? Colors.green
        : (pendingSteps > 0 ? Colors.orange : Colors.grey);
    final progressValue = (submittedSteps / totalSteps).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.person_search_outlined),
              label: Text('Request'),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(Icons.drive_eta_outlined),
              label: Text('Offer'),
            ),
          ],
          selected: {isDriver},
          onSelectionChanged: (selection) {
            setState(() => _driverMode = selection.first);
          },
        ),
        const SizedBox(height: 16),
        // Verification Level Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  allApproved
                      ? Icons.verified_user
                      : (pendingSteps > 0
                            ? Icons.hourglass_top
                            : Icons.shield_outlined),
                  size: 64,
                  color: statusColor,
                ),
                const SizedBox(height: 8),
                Text(
                  allApproved
                      ? '${isDriver ? 'Driver' : 'Rider'} verified'
                      : (pendingSteps > 0
                            ? 'Verification pending'
                            : (approvedSteps > 0
                                  ? 'Verification in progress'
                                  : 'Unverified')),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$submittedSteps of $totalSteps requirements submitted',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(statusColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '$approvedSteps approved • $pendingSteps awaiting manual review',
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
        if (isDriver) ...[
          _buildVerificationItem(
            title: 'Driver License',
            subtitle: 'Required before offering rides',
            icon: Icons.badge_outlined,
            isVerified: verification?.driverLicenseVerified ?? false,
            isUploading: _uploadingType == VerificationType.driverLicense.name,
            isPending:
                (verification?.driverLicenseUrl != null &&
                !(verification?.driverLicenseVerified ?? false)),
            onTap: () => _uploadDocument(
              VerificationType.driverLicense,
              'Driver License',
            ),
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
            onTap: () => _uploadDocument(
              VerificationType.vehicle,
              'Vehicle Registration',
            ),
          ),
        ],
      ],
    );
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
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email verification could not be started. Try again shortly.',
            ),
            backgroundColor: Colors.red,
          ),
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

    Country selectedCountry;
    try {
      selectedCountry = CountryParser.parseCountryCode(countryCode);
    } catch (_) {
      selectedCountry = CountryParser.parseCountryCode('US');
    }
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
                final localDigits = phoneController.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                final fullNumber = '+${selectedCountry.phoneCode}$localDigits';
                if (localDigits.length < 6 || fullNumber.length > 16) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid phone number.'),
                    ),
                  );
                  return;
                }
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
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Phone verification could not be started. Check the number and connection.',
            ),
            backgroundColor: Colors.red,
          ),
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
      final verificationId = _verificationId;
      if (verificationId == null || verificationId.isEmpty) {
        throw const FormatException('Verification session expired.');
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
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
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The code is invalid or expired. Request a new code and try again.',
            ),
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
