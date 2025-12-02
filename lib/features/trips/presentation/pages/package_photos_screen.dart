import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Photo type for package delivery
enum PackagePhotoType {
  pickup,   // Photo taken at pickup
  dropoff,  // Photo taken at delivery
}

/// Screen for capturing package photos at pickup/dropoff
class PackagePhotosScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final String tripId;
  final PackagePhotoType photoType;

  const PackagePhotosScreen({
    super.key,
    required this.bookingId,
    required this.tripId,
    required this.photoType,
  });

  @override
  ConsumerState<PackagePhotosScreen> createState() => _PackagePhotosScreenState();
}

class _PackagePhotosScreenState extends ConsumerState<PackagePhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];
  bool _isUploading = false;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    final isPickup = widget.photoType == PackagePhotoType.pickup;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isPickup ? 'Pickup Photos' : 'Delivery Photos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPickup 
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPickup ? Colors.blue : Colors.green,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPickup ? Icons.camera_alt : Icons.check_circle,
                        color: isPickup ? Colors.blue : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPickup ? 'Document Package Pickup' : 'Document Package Delivery',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isPickup ? Colors.blue : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPickup
                        ? 'Take clear photos of the package before pickup. This protects both you and the sender.'
                        : 'Take photos showing the package has been delivered safely. Include the delivery location.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Photo Grid
            Text(
              'Photos (${_photos.length}/5)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildPhotoGrid(),
            const SizedBox(height: 24),

            // Notes
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                hintText: isPickup 
                    ? 'Any notes about package condition...'
                    : 'Delivery notes (e.g., left at door)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
              onChanged: (value) => _notes = value,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _photos.isEmpty || _isUploading ? null : _submitPhotos,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: isPickup ? Colors.blue : Colors.green,
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isPickup ? 'Confirm Pickup' : 'Confirm Delivery'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _photos.length + (_photos.length < 5 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _photos.length) {
          return _buildAddPhotoButton();
        }
        return _buildPhotoTile(index);
      },
    );
  }

  Widget _buildAddPhotoButton() {
    return InkWell(
      onTap: _showPhotoOptions,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
            SizedBox(height: 4),
            Text('Add Photo', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_photos[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _photos.removeAt(index)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _photos.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture photo: $e')),
        );
      }
    }
  }

  Future<void> _submitPhotos() async {
    if (_photos.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      final storage = FirebaseStorage.instance;
      final firestore = FirebaseFirestore.instance;
      final photoUrls = <String>[];

      // Upload all photos
      for (int i = 0; i < _photos.length; i++) {
        final fileName = '${widget.photoType.name}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child('package_photos/${widget.bookingId}/$fileName');

        final uploadTask = await ref.putFile(_photos[i]);
        final url = await uploadTask.ref.getDownloadURL();
        photoUrls.add(url);
      }

      // Update booking with photos
      final fieldPrefix = widget.photoType == PackagePhotoType.pickup ? 'pickup' : 'dropoff';
      await firestore.collection('bookings').doc(widget.bookingId).update({
        '${fieldPrefix}PhotoUrls': photoUrls,
        '${fieldPrefix}Notes': _notes,
        '${fieldPrefix}Time': FieldValue.serverTimestamp(),
        '${fieldPrefix}By': userId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // If dropoff, update booking status to completed
      if (widget.photoType == PackagePhotoType.dropoff) {
        await firestore.collection('bookings').doc(widget.bookingId).update({
          'status': 'completed',
          'completedAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.photoType == PackagePhotoType.pickup
                ? 'Pickup confirmed!'
                : 'Delivery confirmed!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }
}
