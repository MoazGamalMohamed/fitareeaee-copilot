import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

/// Admin screen to review and approve/reject user verifications
class AdminVerificationsScreen extends ConsumerStatefulWidget {
  const AdminVerificationsScreen({super.key});

  @override
  ConsumerState<AdminVerificationsScreen> createState() =>
      _AdminVerificationsScreenState();
}

class _AdminVerificationsScreenState
    extends ConsumerState<AdminVerificationsScreen> {
  String _selectedFilter = 'pending'; // pending, all, approved, rejected

  @override
  Widget build(BuildContext context) {
    final isAdminAsync = ref.watch(isAdminProvider);

    return isAdminAsync.when(
      data: (isAdmin) {
        if (!isAdmin) {
          return Scaffold(
            appBar: AppBar(title: const Text('Access Denied')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Admin Access Required',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You do not have permission to access this page.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return _buildAdminContent(context);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error checking admin status: $error')),
      ),
    );
  }

  Widget _buildAdminContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'pending',
                        label: Text('Pending'),
                        icon: Icon(Icons.pending_actions),
                      ),
                      ButtonSegment(
                        value: 'approved',
                        label: Text('Approved'),
                        icon: Icon(Icons.check_circle),
                      ),
                      ButtonSegment(
                        value: 'rejected',
                        label: Text('Rejected'),
                        icon: Icon(Icons.cancel),
                      ),
                      ButtonSegment(value: 'all', label: Text('All')),
                    ],
                    selected: {_selectedFilter},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedFilter = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('verifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOperationsOverview(context),
                const SizedBox(height: 16),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No verification requests yet',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            );
          }

          final allDocs = snapshot.data!.docs;
          final filteredDocs = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            if (_selectedFilter == 'all') return true;

            // Pending: has URL but not verified and not rejected
            final hasPendingIdentity =
                data['identityDocumentUrl'] != null &&
                !(data['identityVerified'] ?? false) &&
                data['identityRejectionReason'] == null;
            final hasPendingSelfie =
                data['selfieWithIdUrl'] != null &&
                !(data['selfieWithIdVerified'] ?? false) &&
                data['selfieRejectionReason'] == null;
            final hasPendingLicense =
                data['driverLicenseUrl'] != null &&
                !(data['driverLicenseVerified'] ?? false) &&
                data['licenseRejectionReason'] == null;
            final hasPendingVehicle =
                data['vehicleRegistrationUrl'] != null &&
                !(data['vehicleVerified'] ?? false) &&
                data['vehicleRejectionReason'] == null;

            if (_selectedFilter == 'pending') {
              return hasPendingIdentity ||
                  hasPendingSelfie ||
                  hasPendingLicense ||
                  hasPendingVehicle;
            }

            if (_selectedFilter == 'approved') {
              return (data['identityVerified'] ?? false) ||
                  (data['selfieWithIdVerified'] ?? false) ||
                  (data['driverLicenseVerified'] ?? false) ||
                  (data['vehicleVerified'] ?? false);
            }

            if (_selectedFilter == 'rejected') {
              // Only show rejected documents that are NOT verified
              final hasRejectedIdentity =
                  data['identityRejectionReason'] != null &&
                  !(data['identityVerified'] ?? false);
              final hasRejectedSelfie =
                  data['selfieRejectionReason'] != null &&
                  !(data['selfieWithIdVerified'] ?? false);
              final hasRejectedLicense =
                  data['licenseRejectionReason'] != null &&
                  !(data['driverLicenseVerified'] ?? false);
              final hasRejectedVehicle =
                  data['vehicleRejectionReason'] != null &&
                  !(data['vehicleVerified'] ?? false);

              return hasRejectedIdentity ||
                  hasRejectedSelfie ||
                  hasRejectedLicense ||
                  hasRejectedVehicle;
            }

            return false;
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No $_selectedFilter verifications',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOperationsOverview(context),
              const SizedBox(height: 16),
              ...filteredDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildUserCard(doc.id, data);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOperationsOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operations overview',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _AdminOpsChip(
                  icon: Icons.verified_user_outlined,
                  label: 'Verification review',
                ),
                _AdminOpsChip(
                  icon: Icons.support_agent_outlined,
                  label: 'Support tickets',
                ),
                _AdminOpsChip(
                  icon: Icons.event_available_outlined,
                  label: 'Bookings',
                ),
                _AdminOpsChip(
                  icon: Icons.chat_bubble_outline,
                  label: 'Confirmed chat only',
                ),
                _AdminOpsChip(
                  icon: Icons.payments_outlined,
                  label: 'Payments disabled',
                ),
                _AdminOpsChip(
                  icon: Icons.report_problem_outlined,
                  label: 'Safety escalation',
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Private participant messages remain participant-only. Admins handle verification and explicit support/safety tickets; real refunds and payouts require a payment processor integration before launch.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(String userId, Map<String, dynamic> data) {
    final pendingCount = _getPendingCount(data);
    final approvedCount = _getApprovedCount(data);
    final rejectedCount = _getRejectedCount(data);
    final pendingDocs = _getPendingDocumentTypes(data);
    final rejectedDocs = _getRejectedDocumentTypes(data);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get(),
        builder: (context, userSnapshot) {
          String userName = 'User: ${userId.substring(0, 8)}...';
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            final fullName = userData?['fullName'] as String?;
            final email = userData?['email'] as String?;
            if (fullName != null && fullName.isNotEmpty) {
              userName = fullName;
            } else if (email != null) {
              userName = email;
            }
          }

          return ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _selectedFilter == 'rejected'
                  ? Colors.red
                  : (pendingCount > 0 ? Colors.orange : Colors.green),
              child: Text(
                _selectedFilter == 'rejected'
                    ? rejectedCount.toString()
                    : (pendingCount > 0 ? pendingCount.toString() : '✓'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(userName),
            subtitle: _selectedFilter == 'rejected'
                ? Text(
                    'Rejected: $rejectedDocs',
                    style: const TextStyle(color: Colors.red),
                  )
                : (pendingCount > 0
                      ? Text(
                          'Pending: $pendingDocs',
                          style: const TextStyle(color: Colors.orange),
                        )
                      : Text(
                          'All verified • $approvedCount documents',
                          style: const TextStyle(color: Colors.green),
                        )),
            children: [
              const Divider(),
              // Show only rejected documents in rejected filter
              if (_selectedFilter == 'rejected') ...[
                if (data['identityRejectionReason'] != null &&
                    !(data['identityVerified'] ?? false))
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Identity Document',
                    imageUrl: data['identityDocumentUrl'] ?? '',
                    isVerified: false,
                    isRejected: true,
                    rejectionReason: data['identityRejectionReason']
                        ?.toString(),
                    verifiedAt: null,
                    fieldName: 'identityVerified',
                    urlField: 'identityDocumentUrl',
                  ),
                if (data['selfieRejectionReason'] != null &&
                    !(data['selfieWithIdVerified'] ?? false))
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Selfie with ID',
                    imageUrl: data['selfieWithIdUrl'] ?? '',
                    isVerified: false,
                    isRejected: true,
                    rejectionReason: data['selfieRejectionReason']?.toString(),
                    verifiedAt: null,
                    fieldName: 'selfieWithIdVerified',
                    urlField: 'selfieWithIdUrl',
                  ),
                if (data['licenseRejectionReason'] != null &&
                    !(data['driverLicenseVerified'] ?? false))
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Driver License',
                    imageUrl: data['driverLicenseUrl'] ?? '',
                    isVerified: false,
                    isRejected: true,
                    rejectionReason: data['licenseRejectionReason']?.toString(),
                    verifiedAt: null,
                    fieldName: 'driverLicenseVerified',
                    urlField: 'driverLicenseUrl',
                  ),
                if (data['vehicleRejectionReason'] != null &&
                    !(data['vehicleVerified'] ?? false))
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Vehicle Registration',
                    imageUrl: data['vehicleRegistrationUrl'] ?? '',
                    isVerified: false,
                    isRejected: true,
                    rejectionReason: data['vehicleRejectionReason']?.toString(),
                    verifiedAt: null,
                    fieldName: 'vehicleVerified',
                    urlField: 'vehicleRegistrationUrl',
                  ),
              ] else ...[
                // Show all documents in other filters
                if (data['identityDocumentUrl'] != null)
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Identity Document',
                    imageUrl: data['identityDocumentUrl'].toString(),
                    isVerified: data['identityVerified'] ?? false,
                    verifiedAt: data['identityVerifiedAt'],
                    fieldName: 'identityVerified',
                    urlField: 'identityDocumentUrl',
                  ),
                if (data['selfieWithIdUrl'] != null)
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Selfie with ID',
                    imageUrl: data['selfieWithIdUrl'].toString(),
                    isVerified: data['selfieWithIdVerified'] ?? false,
                    verifiedAt: data['selfieWithIdVerifiedAt'],
                    fieldName: 'selfieWithIdVerified',
                    urlField: 'selfieWithIdUrl',
                  ),
                if (data['driverLicenseUrl'] != null)
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Driver License',
                    imageUrl: data['driverLicenseUrl'].toString(),
                    isVerified: data['driverLicenseVerified'] ?? false,
                    verifiedAt: data['driverLicenseVerifiedAt'],
                    fieldName: 'driverLicenseVerified',
                    urlField: 'driverLicenseUrl',
                  ),
                if (data['vehicleRegistrationUrl'] != null)
                  _buildVerificationItem(
                    userId: userId,
                    title: 'Vehicle Registration',
                    imageUrl: data['vehicleRegistrationUrl'].toString(),
                    isVerified: data['vehicleVerified'] ?? false,
                    verifiedAt: data['vehicleVerifiedAt'],
                    fieldName: 'vehicleVerified',
                    urlField: 'vehicleRegistrationUrl',
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerificationItem({
    required String userId,
    required String title,
    required String imageUrl,
    required bool isVerified,
    required String fieldName,
    required String urlField,
    dynamic verifiedAt,
    bool isRejected = false,
    String? rejectionReason,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isVerified) ...[
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Approved',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (isRejected) ...[
                const Icon(Icons.cancel, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Rejected',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Pending Review',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (verifiedAt != null) ...[
            const SizedBox(height: 4),
            Text(
              'Verified: ${DateFormat('MMM dd, yyyy HH:mm').format(_convertToDateTime(verifiedAt))}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
          if (isRejected && rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rejection Reason:',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rejectionReason.toString(),
                    style: TextStyle(color: Colors.red[900], fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          FutureBuilder<String>(
            future: _resolveDocumentUrl(imageUrl),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: snapshot.hasError
                        ? const Icon(Icons.error)
                        : const CircularProgressIndicator(),
                  ),
                );
              }
              final resolvedUrl = snapshot.data!;
              return GestureDetector(
                onTap: () => _showFullImage(resolvedUrl, title),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: resolvedUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              );
            },
          ),
          if (!isVerified) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _rejectVerification(userId, fieldName, urlField),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _approveVerification(userId, fieldName, title),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 32),
        ],
      ),
    );
  }

  Future<String> _resolveDocumentUrl(String reference) {
    if (reference.startsWith('https://')) return Future.value(reference);
    return FirebaseStorage.instance.ref(reference).getDownloadURL();
  }

  void _showFullImage(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Flexible(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _verificationType(String fieldName) {
    switch (fieldName) {
      case 'identityVerified':
        return 'identity';
      case 'selfieWithIdVerified':
        return 'selfieWithId';
      case 'driverLicenseVerified':
        return 'driverLicense';
      case 'vehicleVerified':
        return 'vehicle';
      default:
        throw ArgumentError.value(fieldName, 'fieldName');
    }
  }

  Future<void> _approveVerification(
    String userId,
    String fieldName,
    String title,
  ) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('reviewVerification')
          .call({
            'schemaVersion': 1,
            'userId': userId,
            'type': _verificationType(fieldName),
            'approved': true,
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title approved successfully'),
            backgroundColor: Colors.green,
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

  Future<void> _rejectVerification(
    String userId,
    String fieldName,
    String urlField,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        String rejectionReason = '';
        return AlertDialog(
          title: const Text('Reject Verification'),
          content: TextField(
            onChanged: (value) => rejectionReason = value,
            decoration: const InputDecoration(
              labelText: 'Rejection Reason',
              hintText: 'Enter reason for rejection',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, rejectionReason),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    if (reason == null || reason.isEmpty) return;

    try {
      await FirebaseFunctions.instance
          .httpsCallable('reviewVerification')
          .call({
            'schemaVersion': 1,
            'userId': userId,
            'type': _verificationType(fieldName),
            'approved': false,
            'reason': reason,
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification rejected'),
            backgroundColor: Colors.orange,
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

  int _getPendingCount(Map<String, dynamic> data) {
    int count = 0;
    if (data['identityDocumentUrl'] != null &&
        !(data['identityVerified'] ?? false))
      count++;
    if (data['selfieWithIdUrl'] != null &&
        !(data['selfieWithIdVerified'] ?? false))
      count++;
    if (data['driverLicenseUrl'] != null &&
        !(data['driverLicenseVerified'] ?? false))
      count++;
    if (data['vehicleRegistrationUrl'] != null &&
        !(data['vehicleVerified'] ?? false))
      count++;
    return count;
  }

  int _getApprovedCount(Map<String, dynamic> data) {
    int count = 0;
    if (data['identityVerified'] ?? false) count++;
    if (data['selfieWithIdVerified'] ?? false) count++;
    if (data['driverLicenseVerified'] ?? false) count++;
    if (data['vehicleVerified'] ?? false) count++;
    return count;
  }

  String _getPendingDocumentTypes(Map<String, dynamic> data) {
    List<String> pending = [];
    if (data['identityDocumentUrl'] != null &&
        !(data['identityVerified'] ?? false) &&
        data['identityRejectionReason'] == null) {
      pending.add('Identity');
    }
    if (data['selfieWithIdUrl'] != null &&
        !(data['selfieWithIdVerified'] ?? false) &&
        data['selfieRejectionReason'] == null) {
      pending.add('Selfie');
    }
    if (data['driverLicenseUrl'] != null &&
        !(data['driverLicenseVerified'] ?? false) &&
        data['licenseRejectionReason'] == null) {
      pending.add('License');
    }
    if (data['vehicleRegistrationUrl'] != null &&
        !(data['vehicleVerified'] ?? false) &&
        data['vehicleRejectionReason'] == null) {
      pending.add('Vehicle');
    }
    return pending.isEmpty ? 'None' : pending.join(', ');
  }

  int _getRejectedCount(Map<String, dynamic> data) {
    int count = 0;
    if (data['identityRejectionReason'] != null &&
        !(data['identityVerified'] ?? false))
      count++;
    if (data['selfieRejectionReason'] != null &&
        !(data['selfieWithIdVerified'] ?? false))
      count++;
    if (data['licenseRejectionReason'] != null &&
        !(data['driverLicenseVerified'] ?? false))
      count++;
    if (data['vehicleRejectionReason'] != null &&
        !(data['vehicleVerified'] ?? false))
      count++;
    return count;
  }

  String _getRejectedDocumentTypes(Map<String, dynamic> data) {
    List<String> rejected = [];
    if (data['identityRejectionReason'] != null &&
        !(data['identityVerified'] ?? false)) {
      rejected.add('Identity');
    }
    if (data['selfieRejectionReason'] != null &&
        !(data['selfieWithIdVerified'] ?? false)) {
      rejected.add('Selfie');
    }
    if (data['licenseRejectionReason'] != null &&
        !(data['driverLicenseVerified'] ?? false)) {
      rejected.add('License');
    }
    if (data['vehicleRejectionReason'] != null &&
        !(data['vehicleVerified'] ?? false)) {
      rejected.add('Vehicle');
    }
    return rejected.isEmpty ? 'None' : rejected.join(', ');
  }

  DateTime _convertToDateTime(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    // If it's a map (from JSON), try to parse it
    if (timestamp is Map) {
      final seconds = timestamp['_seconds'] ?? timestamp['seconds'];
      final nanoseconds =
          timestamp['_nanoseconds'] ?? timestamp['nanoseconds'] ?? 0;
      if (seconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + nanoseconds ~/ 1000000,
        );
      }
    }
    return DateTime.now();
  }
}

class _AdminOpsChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AdminOpsChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}
