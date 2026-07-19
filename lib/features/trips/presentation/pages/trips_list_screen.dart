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
  final String? initialTab;

  const TripsListScreen({super.key, this.role, this.initialTab});

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
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _tabIndex(widget.initialTab),
    );
  }

  @override
  void didUpdateWidget(covariant TripsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(_tabIndex(widget.initialTab));
    }
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
            Tab(text: 'Past'),
          ],
        ),
        actions: [
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const Center(
                    child: Text('Trips are unavailable. Please retry.'),
                  ),
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
                          .where(
                            (b) =>
                                b.status == 'confirmed' || b.status == 'paid',
                          )
                          .map((b) => b.tripId)
                          .toSet();

                      // Filter out booked trips first, then apply other filters
                      final availableFiltered = trips
                          .where((trip) => !bookedTripIds.contains(trip.id))
                          .toList();

                      final filtered = filterTrips(availableFiltered);

                      return _buildTripsList(filtered, isMyTrips: false);
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
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
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
                      ),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, st) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      const Text('Your trips are unavailable. Please retry.'),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('Account unavailable.')),
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
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('Account unavailable.')),
          ),

          // Past Trips Tab
          currentUser.when(
            data: (user) {
              if (user == null) {
                return const Center(
                  child: Text('Please sign in to view past trips'),
                );
              }
              return _buildPastTripsTab(user.id);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('Account unavailable.')),
          ),
        ],
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
              context.pushReplacement('/chat');
              break;
            case 3:
              context.pushReplacementNamed('profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Trips',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static int _tabIndex(String? value) {
    switch (value) {
      case 'my':
        return 1;
      case 'matches':
        return 2;
      case 'past':
        return 3;
      case 'available':
      default:
        return 0;
    }
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
                        trip.isOffer
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
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
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.primary,
                      ),
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
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[400]),
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
                        trip.isRequest
                            ? '${trip.totalSeats} needed'
                            : '${trip.availableSeats}/${trip.totalSeats}',
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
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
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
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
    var pendingType = _filterType;
    var pendingRole = _filterRole;
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),

              // Trip Type Filter
              Text('Trip Type', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['all', 'person', 'package']
                    .map(
                      (type) => FilterChip(
                        label: Text(
                          type == 'all'
                              ? 'All Types'
                              : type == 'person'
                              ? 'Person Transport'
                              : 'Package Delivery',
                        ),
                        selected: pendingType == type,
                        onSelected: (selected) {
                          setSheetState(() => pendingType = type);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Role Filter
              Text('Role', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['all', 'offer', 'request']
                    .map(
                      (role) => FilterChip(
                        label: Text(
                          role == 'all'
                              ? 'All'
                              : role == 'offer'
                              ? 'Offering'
                              : 'Requesting',
                        ),
                        selected: pendingRole == role,
                        onSelected: (selected) {
                          setSheetState(() => pendingRole = role);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 32),

              // Apply button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filterType = pendingType;
                    _filterRole = pendingRole;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchesTab(String userId) {
    final participantBookingsAsync = ref.watch(
      participantBookingsProvider(userId),
    );
    final availableTripsAsync = ref.watch(availableTripsProvider);
    final userTripsAsync = ref.watch(userTripsProvider(userId));

    return participantBookingsAsync.when(
      data: (bookings) => userTripsAsync.when(
        data: (myTrips) => availableTripsAsync.when(
          data: (allTrips) {
            final matchingById = <String, Trip>{};
            for (final myTrip in myTrips) {
              for (final candidate in allTrips) {
                if (candidate.driverId == userId ||
                    candidate.role == myTrip.role ||
                    !_isRouteMatch(myTrip, candidate)) {
                  continue;
                }
                matchingById[candidate.id] = candidate;
              }
            }
            final agreedDeals = bookings
                .where((b) => b.status == 'confirmed' || b.status == 'paid')
                .toList();
            final matchingTrips = matchingById.values.toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (agreedDeals.isNotEmpty) ...[
                  Text(
                    'Confirmed trips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paid/confirmed matches where trip chat is active',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ...agreedDeals.map(_buildBookingCard),
                  const SizedBox(height: 32),
                ],
                Text(
                  'Potential matches',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Opposite requests and offers with compatible routes',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                if (matchingTrips.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text('No compatible matches yet'),
                          const SizedBox(height: 8),
                          Text(
                            'Create a request or offer, or use Plan with AI.',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...matchingTrips.map((trip) => _buildTripCard(context, trip)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _matchesError(userId),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _matchesError(userId),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _matchesError(userId),
    );
  }

  Widget _matchesError(String userId) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Matches are unavailable right now.'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(participantBookingsProvider(userId));
              ref.invalidate(userTripsProvider(userId));
              ref.invalidate(availableTripsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  bool _isRouteMatch(Trip trip1, Trip trip2) {
    final missingCoordinates =
        (trip1.originLat == 0 && trip1.originLng == 0) ||
        (trip2.originLat == 0 && trip2.originLng == 0) ||
        (trip1.destinationLat == 0 && trip1.destinationLng == 0) ||
        (trip2.destinationLat == 0 && trip2.destinationLng == 0);
    if (missingCoordinates) {
      return _addressMatch(trip1.originAddress, trip2.originAddress) &&
          _addressMatch(trip1.destinationAddress, trip2.destinationAddress);
    }

    // Simple distance-based matching (within 5km for origin and destination)
    const double matchThresholdKm = 5.0;

    final originDistance = _calculateDistance(
      trip1.originLat,
      trip1.originLng,
      trip2.originLat,
      trip2.originLng,
    );

    final destDistance = _calculateDistance(
      trip1.destinationLat,
      trip1.destinationLng,
      trip2.destinationLat,
      trip2.destinationLng,
    );

    return originDistance <= matchThresholdKm &&
        destDistance <= matchThresholdKm;
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    // Haversine formula for distance calculation
    const double earthRadiusKm = 6371.0;

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * asin(sqrt(a));

    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  bool _addressMatch(String first, String second) {
    const ignored = {'the', 'downtown', 'central', 'city', 'texas', 'tx'};
    Set<String> tokens(String value) => value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((token) => token.length > 2 && !ignored.contains(token))
        .toSet();
    final left = tokens(first);
    final right = tokens(second);
    return left.isNotEmpty &&
        right.isNotEmpty &&
        left.intersection(right).isNotEmpty;
  }

  Widget _buildBookingCard(BookingModel booking) {
    final encodedBookingId = Uri.encodeQueryComponent(booking.id);
    final detailsRoute = '/trips/${booking.tripId}?bookingId=$encodedBookingId';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: booking.status == 'confirmed'
              ? Colors.green
              : Colors.orange,
          child: Icon(
            booking.status == 'confirmed' ? Icons.check : Icons.pending,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${booking.pickupLocation ?? 'Pickup'} → ${booking.dropoffLocation ?? 'Destination'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Status: ${booking.status}'),
            Text(
              'Seats: ${booking.seatsBooked} • \$${booking.totalPrice.toStringAsFixed(2)}',
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => context.push(detailsRoute),
        ),
        onTap: () => context.push(detailsRoute),
      ),
    );
  }

  List<Trip> filterTrips(List<Trip> trips) {
    final now = DateTime.now();
    final filtered = trips.where((trip) {
      if (trip.status != 'pending' ||
          trip.departureTime.isBefore(now) ||
          trip.availableSeats <= 0) {
        return false;
      }
      if (widget.role == 'rider' && !trip.isOffer) return false;
      if (widget.role == 'driver' && !trip.isRequest) return false;
      if (_filterType != 'all' && trip.type != _filterType) return false;
      if (_filterRole != 'all' && trip.role != _filterRole) {
        return false;
      }
      return true;
    }).toList();
    filtered.sort((a, b) {
      final byDeparture = a.departureTime.compareTo(b.departureTime);
      if (byDeparture != 0) return byDeparture;
      return a.distance.compareTo(b.distance);
    });
    return filtered;
  }

  Widget _buildPastTripsTab(String userId) {
    final participantBookingsAsync = ref.watch(
      participantBookingsProvider(userId),
    );
    final userTripsAsync = ref.watch(userTripsProvider(userId));

    return participantBookingsAsync.when(
      data: (bookings) => userTripsAsync.when(
        data: (myTrips) {
          final completedBookings = bookings
              .where((booking) => booking.status == 'completed')
              .toList();
          final completedTripIds = completedBookings
              .map((booking) => booking.tripId)
              .toSet();
          final completedOwnedTrips = myTrips
              .where(
                (trip) =>
                    trip.status == 'completed' &&
                    !completedTripIds.contains(trip.id),
              )
              .toList();

          if (completedBookings.isEmpty && completedOwnedTrips.isEmpty) {
            return const Center(child: Text('No completed past trips yet'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (completedBookings.isNotEmpty) ...[
                Text(
                  'Completed bookings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...completedBookings.map(_buildBookingCard),
                const SizedBox(height: 24),
              ],
              if (completedOwnedTrips.isNotEmpty) ...[
                Text(
                  'Completed offers and requests',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...completedOwnedTrips.map(
                  (trip) => _buildTripCard(context, trip),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _matchesError(userId),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _matchesError(userId),
    );
  }
}
