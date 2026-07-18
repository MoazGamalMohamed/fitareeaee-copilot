import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../trips/domain/entities/trip.dart';
import '../../../trips/presentation/providers/trip_provider.dart';
import '../../domain/copilot_draft.dart';
import '../../domain/copilot_match.dart';

String copilotTripDetailsRoute(String tripId, CopilotDraft draft) {
  final seats = (draft.passengerOrSeatCount ?? 1).clamp(1, 8);
  return '/trips/$tripId?seats=$seats';
}

class CopilotResultsScreen extends ConsumerStatefulWidget {
  final CopilotDraft draft;

  const CopilotResultsScreen({super.key, required this.draft});

  @override
  ConsumerState<CopilotResultsScreen> createState() =>
      _CopilotResultsScreenState();
}

class _CopilotResultsScreenState extends ConsumerState<CopilotResultsScreen> {
  late Future<List<Trip>> _trips;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _trips = ref.read(tripRepositoryProvider).getAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transparent matches')),
      body: FutureBuilder<List<Trip>>(
        future: _trips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return _error(snapshot.error.toString());
          final matches = rankCopilotMatches(
            snapshot.data ?? const [],
            widget.draft,
          );
          if (matches.isEmpty) return _empty();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _explanation(),
              const SizedBox(height: 12),
              Text(
                '${matches.length} live ${matches.length == 1 ? 'match' : 'matches'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...matches.map(_matchCard),
            ],
          );
        },
      ),
    );
  }

  Widget _explanation() {
    return Card(
      color: Colors.blue.shade50,
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.rule_outlined),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'GPT-5.6 interpreted the request. These results are ranked deterministically from live trips using route, time, availability, price, and preferences.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchCard(CopilotMatch match) {
    final trip = match.trip;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.push(copilotTripDetailsRoute(trip.id, widget.draft)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Text('${match.score.round()}')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${trip.originAddress} → ${trip.destinationAddress}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(trip.priceDisplay),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                trip.isPackage
                    ? '${trip.departureTime.toLocal()} • package capacity available'
                    : '${trip.departureTime.toLocal()} • ${trip.availableSeats} seats available',
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: match.reasons
                    .map(
                      (reason) => Chip(
                        avatar: const Icon(Icons.check, size: 16),
                        label: Text(reason),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72),
            const SizedBox(height: 16),
            Text(
              'No live trips match this draft',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Fitareeaee never invents trips. Adjust the draft or browse current trips manually.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Adjust AI draft'),
            ),
            TextButton(
              onPressed: () => context.push(_manualTripsRoute),
              child: const Text('Browse live trips manually'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _error(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 72),
            const SizedBox(height: 16),
            const Text('Live trips could not be loaded'),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => setState(_load),
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => context.push(_manualTripsRoute),
              child: const Text('Use manual search'),
            ),
          ],
        ),
      ),
    );
  }

  String get _manualTripsRoute => widget.draft.intent == 'offer'
      ? '/trips?role=driver'
      : '/trips?role=rider';
}
