import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/verification_model.dart';
import '../providers/verification_provider.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _picker = ImagePicker();
  String? _uploadingType;

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

      if (mounted) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Center'),
      ),
      body: verificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (verification) => _buildContent(verification),
      ),
    );
  }

  Widget _buildContent(UserVerification? verification) {
    final level = verification?.verificationLevel ?? 0;
    
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
          onTap: () => _uploadDocument(VerificationType.identity, 'Identity Document'),
        ),
        _buildVerificationItem(
          title: "Driver's License",
          subtitle: 'Required to offer rides',
          icon: Icons.drive_eta,
          isVerified: verification?.driverLicenseVerified ?? false,
          isUploading: _uploadingType == VerificationType.driverLicense.name,
          onTap: () => _uploadDocument(VerificationType.driverLicense, "Driver's License"),
        ),
        _buildVerificationItem(
          title: 'Vehicle Registration',
          subtitle: 'Verify your vehicle details',
          icon: Icons.directions_car,
          isVerified: verification?.vehicleVerified ?? false,
          isUploading: _uploadingType == VerificationType.vehicle.name,
          onTap: () => _uploadDocument(VerificationType.vehicle, 'Vehicle Registration'),
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
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVerified ? Colors.green : Colors.grey[300],
          child: isUploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(icon, color: isVerified ? Colors.white : Colors.grey[600]),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isVerified
            ? const Icon(Icons.check_circle, color: Colors.green)
            : TextButton(
                onPressed: isUploading ? null : onTap,
                child: Text(isUploading ? 'Uploading...' : 'Verify'),
              ),
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

      if (user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already verified')),
        );
        return;
      }

      await user.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent. Check your inbox.')),
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
    // Show phone verification dialog
    final phoneController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Phone'),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+1234567890',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, phoneController.text),
            child: const Text('Send Code'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone verification code sent')),
      );
    }
  }
}

