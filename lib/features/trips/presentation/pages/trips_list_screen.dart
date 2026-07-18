import 'dart:math' show cos, sin, asin, sqrt, pi;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/domain/models/booking_model.dart';
import '../../domain/entities/trip.dart';
import '../../../../core/theme/app_colors.dart';

class TripsListScreen extends ConsumerStatefulWidget {
  /// Optional role passed from home screen: 'rider' (finding rides) or 'driver' (offering rides)
  final String? role;

  const TripsListScreen({super.key, this.role});

  @override
  ConsumerState<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends ConsumerState<TripsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all'; // 'all', 'person', 'package'
  String _filterRole = 'all'; // 'all', 'offer', 'request'
  int _selectedNavIndex = 1; // Trips is index 1

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableTrips = ref.watch(availableTripsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Trips'),
            Tab(text: 'Matches'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.pushNamed('advanced-search'),
            tooltip: 'Advanced Search',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFiltersSheet,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Available Trips Tab
          currentUser.when(
            data: (user) {
              if (user == null) {
                return availableTrips.when(
                  data: (trips) {
                    final filtered = filterTrips(trips);
                    return _buildTripsList(filtered, isMyTrips: false);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, st) => Center(child: Text('Error: $error')),
                );
              }
              
              // Get user's bookings to filter out trips they've booked
              final userBookings = ref.watch(userBookingsProvider(user.id));
              
              return availableTrips.when(
                data: (trips) {
                  return userBookings.when(
                    data: (bookings) {
                      // Get trip IDs that user has confirmed or paid bookings for
                      final bookedTripIds = bookings
                          .where((b) => b.status == 'confirmed' || b.status == 'paid')
                          .map((b) => b.tripId)
                          .toSet();
                      
                      // Filter out booked trips first, then apply other filters
                      final availableFiltered = trips
                          .where((trip) => !bookedTripIds.contains(trip.id))
                          .toList();
                      
                      final filtered = filterTrips(availableFiltered);
                      
                      print('🚗 Total: ${trips.length}, After booking filter: ${availableFiltered.length}, After search: ${filtered.length}');
                      return _buildTripsList(filtered, isMyTrips: false);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, st) {
                      // If bookings fail to load, show all available trips
                      final filtered = filterTrips(trips);
                      return _buildTripsList(filtered, isMyTrips: false);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, st) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      const Text('Failed to load trips'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(availableTripsProvider);
                        },
                        child: const Text('Retry'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text('Failed to load trips'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(availableTripsProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

          // My Trips Tab
          currentUser.when(
            data: (user) {
              if (user == null) {
                return const Center(
                  child: Text('Please sign in to view your trips'),
                );
              }
              final userTrips = ref.watch(userTripsProvider(user.id));
              return userTrips.when(
                data: (trips) => _buildTripsList(trips, isMyTrips: true),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, st) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text('Error: $error'),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, st) => Center(
              child: Text('Error loading user: $error'),
            ),
          ),

          // Matches Tab
          currentUser.when(
            data: (user) {
              if (user == null) {
                return const Center(
                  child: Text('Please sign in to view your matches'),
                );
              }
              return _buildMatchesTab(user.id);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, st) => Center(
              child: Text('Error loading user: $error'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final roleParam = widget.role != null ? '?role=${widget.role}' : '';
          context.push('/trips/create$roleParam');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
          switch (index) {
            case 0:
              context.pushReplacementNamed('home');
              break;
            case 1:
              // Already on trips, do nothing
              break;
            case 2:
              // TODO: Navigate to chat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat feature coming soon')),
              );
              break;
            case 3:
              context.pushReplacementNamed('profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTripsList(List trips, {required bool isMyTrips}) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No trips found'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(context, trip);
      },
    );
  }

  Widget _buildTripCard(BuildContext context, dynamic trip) {
    return GestureDetector(
      onTap: () => context.push('/trips/${trip.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Header with trip type
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: trip.isOffer ? Colors.blue[50] : Colors.orange[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        trip.isOffer ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 20,
                        color: trip.isOffer ? Colors.blue : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        trip.directionDisplay,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: trip.isOffer ? Colors.blue : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(trip.typeDisplay),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.originAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '↓',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trip.destinationAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Trip details grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailBox(
                        context,
                        Icons.schedule,
                        trip.timeDisplay,
                      ),
                      _buildDetailBox(
                        context,
                        Icons.directions,
                        trip.distanceDisplay,
                      ),
                      _buildDetailBox(
                        context,
                        Icons.people,
                        '${trip.availableSeats}/${trip.totalSeats}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price and Availability
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trip.priceDisplay,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (trip.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Available',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Full',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(BuildContext context, IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Trip Type Filter
              Text('Trip Type', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['all', 'person', 'package']
                    .map((type) => FilterChip(
                          label: Text(
                            type == 'all'
                                ? 'All Types'
                                : type == 'person'
                                    ? 'Person Transport'
                                    : 'Package Delivery',
                          ),
                          selected: _filterType == type,
                          onSelected: (selected) {
                            setState(() => _filterType = type);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Role Filter
              Text('Role', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['all', 'offer', 'request']
                    .map((role) => FilterChip(
                          label: Text(
                            role == 'all'
                                ? 'All'
                                : role == 'offer'
                                    ? 'Offering'
                                    : 'Requesting',
                          ),
                          selected: _filterRole == role,
                          onSelected: (selected) {
                            setState(() => _filterRole = role);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),

              // Apply button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchesTab(String userId) {
    print('🎯 Building Matches tab for userId: $userId');
    // Get user bookings (agreed deals)
    final userBookingsAsync = ref.watch(userBookingsProvider(userId));
    
    // Get all available trips
    final availableTripsAsync = ref.watch(availableTripsProvider);

    return userBookingsAsync.when(
      data: (bookings) {
        return availableTripsAsync.when(
          data: (allTrips) {
            // Get trips created by current user
            final myTrips = allTrips.where((trip) => trip.driverId == userId).toList();
            
            // Find matching trips based on user's trips
            final matchingTrips = <Trip>[];
            
            for (final myTrip in myTrips) {
              // If I'm offering a ride, find requests that match
              if (myTrip.role == 'offer') {
                final matchingRequests = allTrips.where((trip) {
                  return trip.role == 'request' &&
                         trip.driverId != userId && // Not my trip
                         _isRouteMatch(myTrip, trip); // Routes match
                }).toList();
                matchingTrips.addAll(matchingRequests);
              }
              // If I'm requesting a ride, find offers that match
              else if (myTrip.role == 'request') {
                final matchingOffers = allTrips.where((trip) {
                  return trip.role == 'offer' &&
                         trip.driverId != userId && // Not my trip
                         _isRouteMatch(myTrip, trip); // Routes match
                }).toList();
                matchingTrips.addAll(matchingOffers);
              }
            }

            // Remove duplicates
            final uniqueMatchingTrips = matchingTrips.toSet().toList();

            // Filter bookings to show only confirmed or paid deals
            final agreedDeals = bookings
                .where((b) => b.status == 'confirmed' || b.status == 'paid')
                .toList();
            
            print('📊 Matches tab: ${bookings.length} total bookings, ${agreedDeals.length} agreed deals');
            if (bookings.isEmpty) {
              print('⚠️ No bookings found for user $userId');
              print('   Make sure:');
              print('   1. User has created bookings');
              print('   2. Bookings have passengerId = $userId');
              print('   3. Firestore index is deployed');
            } else {
              for (final booking in bookings) {
                print('   📋 Booking: ${booking.id} | status: ${booking.status} | payment: ${booking.paymentStatus}');
              }
            }
            
            // Build the matches UI with two sections
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Agreed Deals Section
                if (agreedDeals.isNotEmpty) ...[
                  Text(
                    'Agreed Deals',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trips where you and another user have agreed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...agreedDeals.map((booking) => _buildBookingCard(booking, allTrips)),
                  const SizedBox(height: 32),
                ],
                
                // Matching Trips Section
                Text(
                  'Potential Matches',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Trips that match your route and preferences',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                if (uniqueMatchingTrips.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No matching trips found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a trip to find matches',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ...uniqueMatchingTrips.map((trip) => _buildTripCard(context, trip)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, st) => Center(
            child: Text('Error loading trips: $error'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, st) {
        // Check if error is due to missing Firestore index
        final errorMsg = error.toString();
        final isMissingIndex = errorMsg.contains('failed-precondition') || 
                               errorMsg.contains('requires an index');
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isMissingIndex ? Icons.build_circle : Icons.error_outline,
                  size: 64,
                  color: isMissingIndex ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  isMissingIndex 
                    ? 'Database Setup Required'
                    : 'Error Loading Matches',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isMissingIndex
                    ? 'The matches feature requires additional database configuration. Please contact your administrator to set up Firestore indexes.'
                    : 'Unable to load your matches at this time.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (!isMissingIndex) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Trigger a refresh
                      ref.invalidate(userBookingsProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
                const SizedBox(height: 16),
                // Show error details in debug mode
                if (!isMissingIndex)
                  ExpansionTile(
                    title: const Text('Error Details'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMsg,
                          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isRouteMatch(Trip trip1, Trip trip2) {
    // Simple distance-based matching (within 5km for origin and destination)
    const double matchThresholdKm = 5.0;
    
    final originDistance = _calculateDistance(
      trip1.originLat, trip1.originLng,
      trip2.originLat, trip2.originLng,
    );
    
    final destDistance = _calculateDistance(
      trip1.destinationLat, trip1.destinationLng,
      trip2.destinationLat, trip2.destinationLng,
    );
    
    return originDistance <= matchThresholdKm && destDistance <= matchThresholdKm;
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Haversine formula for distance calculation
    const double earthRadiusKm = 6371.0;
    
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
              cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
              sin(dLng / 2) * sin(dLng / 2);
    
    final c = 2 * asin(sqrt(a));
    
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  Widget _buildBookingCard(BookingModel booking, List<Trip> allTrips) {
    // Find the trip associated with this booking
    final trip = allTrips.firstWhere(
      (t) => t.id == booking.tripId,
      orElse: () => allTrips.first, // Fallback, should not happen
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: booking.status == 'confirmed' 
            ? Colors.green 
            : Colors.orange,
          child: Icon(
            booking.status == 'confirmed' 
              ? Icons.check 
              : Icons.pending,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${trip.originAddress} → ${trip.destinationAddress}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Status: ${booking.status}'),
            Text('Seats: ${booking.seatsBooked} • \$${booking.totalPrice.toStringAsFixed(2)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => context.push('/trips/${trip.id}'),
        ),
        onTap: () => context.push('/trips/${trip.id}'),
      ),
    );
  }

  List filterTrips(List trips) {
    return trips.where((trip) {
      if (_filterType != 'all' && trip.type != _filterType) return false;
      if (_filterRole != 'all' && trip.role != _filterRole) {
        return false;
      }
      return true;
    }).toList();
  }
}
