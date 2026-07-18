import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import '../../domain/models/verification_model.dart';
import '../providers/verification_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'driver_profile_screen.dart';

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

    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
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
      final downloadUrl = await ref.read(uploadVerificationDocumentProvider(params).future);

      // Submit verification request
      await submitVerification(
        userId: userId,
        type: type,
        documentUrl: downloadUrl,
      );

      if (type != VerificationType.identity && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title uploaded successfully. Pending review.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
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
      appBar: AppBar(
        title: const Text('Verification Center'),
      ),
      body: verificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (verification) => userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) => _buildContent(verification, user),
        ),
      ),
    );
  }

  Widget _buildContent(UserVerification? verification, user) {
    final level = verification?.verificationLevel ?? 0;
    final isDriver = user?.hasRole('driver') ?? false;
    final isCourier = user?.hasRole('courier') ?? false;
    // Both driver license and vehicle registration required for anyone using vehicles
    final needsVehicleVerification = isDriver || isCourier;
    
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
                  'Verification Level $level/3',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: level / 3,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(_getLevelColor(level)),
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
          isPending: (verification?.identityDocumentUrl != null && !(verification?.identityVerified ?? false)),
          onTap: () => _uploadDocument(VerificationType.identity, 'Identity Document'),
        ),
        _buildVerificationItem(
          title: 'Selfie with ID',
          subtitle: 'Upload a selfie holding your ID',
          icon: Icons.face,
          isVerified: verification?.selfieWithIdVerified ?? false,
          isUploading: _uploadingType == VerificationType.selfieWithId.name,
          isPending: (verification?.selfieWithIdUrl != null && !(verification?.selfieWithIdVerified ?? false)),
          onTap: () => _uploadDocument(VerificationType.selfieWithId, 'Selfie with ID'),
        ),
        if (needsVehicleVerification)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (verification?.driverLicenseVerified ?? false) && (verification?.vehicleVerified ?? false)
                    ? Colors.green
                    : (verification?.driverLicenseUrl != null || verification?.vehicleRegistrationUrl != null)
                        ? Colors.orange
                        : Colors.blue,
                child: Icon(
                  (verification?.driverLicenseVerified ?? false) && (verification?.vehicleVerified ?? false)
                      ? Icons.check_circle
                      : Icons.drive_eta,
                  color: Colors.white,
                ),
              ),
              title: const Text('Driver/Vehicle Verification'),
              subtitle: Text(
                (verification?.driverLicenseVerified ?? false) && (verification?.vehicleVerified ?? false)
                    ? 'Driver profile verified'
                    : (verification?.driverLicenseUrl != null || verification?.vehicleRegistrationUrl != null)
                        ? 'Complete your driver profile'
                        : 'Set up your driver profile and upload documents',
                style: TextStyle(
                  color: (verification?.driverLicenseVerified ?? false) && (verification?.vehicleVerified ?? false)
                      ? Colors.green
                      : null,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverProfileScreen(),
                  ),
                );
              },
            ),
          ),
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
          backgroundColor: isVerified ? Colors.green : (isPending ? Colors.orange : Colors.grey[300]),
          child: isUploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(icon, color: isVerified || isPending ? Colors.white : Colors.grey[600]),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isVerified
            ? const Icon(Icons.check_circle, color: Colors.green)
            : (isPending 
                ? const Chip(
                    label: Text('Pending Approval', style: TextStyle(fontSize: 12)),
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
      case 0: return Icons.shield_outlined;
      case 1: return Icons.verified_user_outlined;
      case 2: return Icons.verified_user;
      case 3: return Icons.verified;
      default: return Icons.shield_outlined;
    }
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 0: return Colors.grey;
      case 1: return Colors.blue;
      case 2: return Colors.orange;
      case 3: return Colors.green;
      default: return Colors.grey;
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
        // Update Firestore if email is verified
        final docRef = FirebaseFirestore.instance.collection('verifications').doc(user.uid);
        final docSnapshot = await docRef.get();
        final now = DateTime.now().toIso8601String();
        
        if (!docSnapshot.exists) {
          // Create new document with all required fields
          await docRef.set({
            'userId': user.uid,
            'emailVerified': true,
            'phoneVerified': false,
            'identityVerified': false,
            'driverLicenseVerified': false,
            'vehicleVerified': false,
            'selfieWithIdVerified': false,
            'createdAt': now,
            'updatedAt': now,
          });
        } else {
          // Update existing document
          await docRef.update({
            'emailVerified': true,
            'updatedAt': now,
          });
        }
        
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
                label: Text('+${selectedCountry.phoneCode} ${selectedCountry.name}'),
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
                final fullNumber = '+${selectedCountry.phoneCode}${phoneController.text.trim()}';
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
          SnackBar(
            content: Text('Error: $e'),
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

    await FirebaseFirestore.instance
        .collection('verifications')
        .doc(user.uid)
        .set({
      'userId': user.uid,
      'phoneVerified': true,
      'updatedAt': DateTime.now().toIso8601String(),
      if (await FirebaseFirestore.instance.collection('verifications').doc(user.uid).get().then((doc) => !doc.exists))
        'createdAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}
