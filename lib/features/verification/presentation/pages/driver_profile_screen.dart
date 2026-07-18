import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/verification_model.dart';
import '../providers/verification_provider.dart';

/// Screen for drivers to enter their vehicle and license information
/// Required before they can offer rides
class DriverProfileScreen extends ConsumerStatefulWidget {
  /// If true, user is redirected here before creating a trip offer
  final bool isRequired;

  const DriverProfileScreen({super.key, this.isRequired = false});

  @override
  ConsumerState<DriverProfileScreen> createState() =>
      _DriverProfileScreenState();
}

class _DriverProfileScreenState extends ConsumerState<DriverProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _plateNumberController;
  late TextEditingController _licenseNumberController;

  String _vehicleType = 'car'; // car, van, motorcycle, truck, bike
  bool _isLoading = false;
  bool _hasExistingData = false;
  String? _uploadingType; // Track which document is being uploaded

  @override
  void initState() {
    super.initState();
    _vehicleModelController = TextEditingController();
    _vehicleColorController = TextEditingController();
    _plateNumberController = TextEditingController();
    _licenseNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _plateNumberController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final verificationAsync = userId != null
        ? ref.watch(userVerificationProvider(userId))
        : const AsyncValue<UserVerification?>.data(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
        centerTitle: true,
        leading: widget.isRequired
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: verificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (verification) {
          // Pre-fill form if data exists
          if (verification != null && !_hasExistingData) {
            _vehicleModelController.text = verification.vehicleModel ?? '';
            _vehicleColorController.text = verification.vehicleColor ?? '';
            _plateNumberController.text = verification.vehiclePlateNumber ?? '';
            // Load vehicle type from metadata if available
            _hasExistingData = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info banner
                  if (widget.isRequired)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please complete your driver profile before offering rides.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Verification status
                  _buildVerificationStatus(verification),
                  const SizedBox(height: 24),

                  // Vehicle Information Section
                  _buildSectionTitle('Vehicle Information'),
                  const SizedBox(height: 16),

                  // Vehicle Type Selection
                  _buildSectionTitle('Vehicle Type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildVehicleTypeChip('car', 'Car', Icons.directions_car),
                      _buildVehicleTypeChip(
                        'van',
                        'Van',
                        Icons.airport_shuttle,
                      ),
                      _buildVehicleTypeChip(
                        'motorcycle',
                        'Motorcycle',
                        Icons.two_wheeler,
                      ),
                      _buildVehicleTypeChip(
                        'truck',
                        'Truck',
                        Icons.local_shipping,
                      ),
                      _buildVehicleTypeChip(
                        'bike',
                        'Bicycle',
                        Icons.pedal_bike,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _vehicleModelController,
                    label: _vehicleType == 'bike'
                        ? 'Bicycle Brand/Model'
                        : 'Vehicle Model',
                    hint: _vehicleType == 'bike'
                        ? 'e.g., Trek Mountain Bike'
                        : 'e.g., Toyota Camry 2020',
                    icon: _vehicleType == 'bike'
                        ? Icons.pedal_bike
                        : Icons.directions_car,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _vehicleColorController,
                    label: _vehicleType == 'bike'
                        ? 'Bicycle Color'
                        : 'Vehicle Color',
                    hint: 'e.g., Silver',
                    icon: Icons.color_lens,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  // Only show plate number for motorized vehicles
                  if (_vehicleType != 'bike') ...[
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _plateNumberController,
                      label: 'License Plate Number',
                      hint: 'e.g., ABC 1234',
                      icon: Icons.confirmation_number,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ],
                  const SizedBox(height: 24),

                  // License Section - Only for motorized vehicles
                  if (_vehicleType != 'bike') ...[
                    _buildSectionTitle('Driver\'s License'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _licenseNumberController,
                      label: 'License Number',
                      hint: 'Enter your license number',
                      icon: Icons.badge,
                    ),
                    const SizedBox(height: 16),

                    // Driver's License Document Upload
                    _buildDocumentUploadCard(
                      title: "Driver's License Photo",
                      subtitle:
                          'Upload a clear photo of your driver\'s license',
                      icon: Icons.drive_eta,
                      isVerified: verification?.driverLicenseVerified ?? false,
                      isUploading: _uploadingType == 'driverLicense',
                      isPending:
                          (verification?.driverLicenseUrl != null &&
                          !(verification?.driverLicenseVerified ?? false)),
                      documentUrl: verification?.driverLicenseUrl,
                      onUpload: () => _uploadDocument(
                        VerificationType.driverLicense,
                        "Driver's License",
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Vehicle Registration Section - Only for motorized vehicles
                  if (_vehicleType != 'bike') ...[
                    _buildSectionTitle('Vehicle Registration'),
                    const SizedBox(height: 16),
                    _buildDocumentUploadCard(
                      title: 'Vehicle Registration Photo',
                      subtitle:
                          'Upload a clear photo of your vehicle registration',
                      icon: Icons.description,
                      isVerified: verification?.vehicleVerified ?? false,
                      isUploading: _uploadingType == 'vehicle',
                      isPending:
                          (verification?.vehicleRegistrationUrl != null &&
                          !(verification?.vehicleVerified ?? false)),
                      documentUrl: verification?.vehicleRegistrationUrl,
                      onUpload: () => _uploadDocument(
                        VerificationType.vehicle,
                        'Vehicle Registration',
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _saveProfile(verification),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Driver Profile'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  Widget _buildVehicleTypeChip(String type, String label, IconData icon) {
    final isSelected = _vehicleType == type;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _vehicleType = type);
        }
      },
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isVerified,
    required bool isUploading,
    required bool isPending,
    String? documentUrl,
    required VoidCallback onUpload,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVerified
              ? Colors.green
              : isPending
              ? Colors.orange
              : Colors.grey[300],
          child: Icon(
            isVerified
                ? Icons.check
                : isPending
                ? Icons.pending
                : icon,
            color: isVerified || isPending ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            if (isPending)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Chip(
                  label: Text(
                    'Pending Approval',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            if (isVerified)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Chip(
                  label: Text(
                    'Verified',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        trailing: isUploading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: Icon(
                  documentUrl != null ? Icons.refresh : Icons.camera_alt,
                  color: isVerified ? Colors.green : Colors.blue,
                ),
                onPressed: isVerified ? null : onUpload,
              ),
      ),
    );
  }

  Future<void> _uploadDocument(
    VerificationType type,
    String documentName,
  ) async {
    try {
      setState(() => _uploadingType = type.name);

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) {
        setState(() => _uploadingType = null);
        return;
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      // Upload to Firebase Storage
      final file = File(image.path);
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$documentName uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingType = null);
      }
    }
  }

  Widget _buildVerificationStatus(UserVerification? verification) {
    final hasVehicleInfo =
        verification?.vehicleModel != null &&
        verification?.vehiclePlateNumber != null;
    final isVerified = verification?.vehicleVerified ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withValues(alpha: 0.1)
            : hasVehicleInfo
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVerified
              ? Colors.green
              : hasVehicleInfo
              ? Colors.orange
              : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isVerified
                ? Icons.verified
                : hasVehicleInfo
                ? Icons.pending
                : Icons.info_outline,
            color: isVerified
                ? Colors.green
                : hasVehicleInfo
                ? Colors.orange
                : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified
                      ? 'Verified Driver'
                      : hasVehicleInfo
                      ? 'Pending Verification'
                      : 'Not Verified',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isVerified
                        ? Colors.green
                        : hasVehicleInfo
                        ? Colors.orange
                        : Colors.grey,
                  ),
                ),
                Text(
                  isVerified
                      ? 'Your driver profile is verified'
                      : hasVehicleInfo
                      ? 'Your information is being reviewed'
                      : 'Complete your profile to start offering rides',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile(UserVerification? existing) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      final now = DateTime.now();
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('verifications').doc(userId).set({
        'userId': userId,
        'vehicleModel': _vehicleModelController.text.trim(),
        'vehicleColor': _vehicleColorController.text.trim(),
        'vehiclePlateNumber': _plateNumberController.text.trim(),
        'vehicleType': _vehicleType, // Save vehicle type
        'driverLicenseNumber': _licenseNumberController.text.trim(),
        'updatedAt': now.toIso8601String(),
        if (existing == null) 'createdAt': now.toIso8601String(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver profile saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // If this was required before creating a trip, go to create trip
        if (widget.isRequired) {
          context.pushReplacement('/trips/create?role=driver');
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
