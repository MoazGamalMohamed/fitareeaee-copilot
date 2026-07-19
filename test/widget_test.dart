// This is a basic Flutter widget test for the Fitareeaee app.

import 'package:flutter_test/flutter_test.dart';
import 'package:fitareeaee/features/chat/domain/entities/message.dart';
import 'package:fitareeaee/features/trips/domain/entities/trip.dart';
import 'package:fitareeaee/features/search/domain/entities/search_criteria.dart';
import 'package:fitareeaee/features/search/domain/entities/match_result.dart';

void main() {
  group('Domain Entities Tests', () {
    test('Message entity creation and utilities', () {
      final message = Message(
        id: 'msg1',
        conversationId: 'trip1__user1_user2',
        senderId: 'user1',
        recipientId: 'user2',
        content: 'Hello',
        createdAt: DateTime.now(),
      );

      expect(message.id, 'msg1');
      expect(message.content, 'Hello');
      expect(message.isSentByUser('user1'), true);
      expect(message.isSentByUser('user2'), false);
      expect(message.isDeleted, false);
      expect(message.isRead, false);
    });

    test('Message conversation ID generation', () {
      final convId1 = Message.getLegacyConversationId('alice', 'bob');
      final convId2 = Message.getLegacyConversationId('bob', 'alice');

      expect(convId1, convId2);
      expect(convId1.contains('_'), true);
    });

    test('Trip entity creation', () {
      final trip = Trip(
        id: 'trip1',
        type: 'person',
        role: 'offer',
        driverId: 'driver1',
        originAddress: 'Cairo',
        originLat: 30.0,
        originLng: 31.0,
        destinationAddress: 'Alexandria',
        destinationLat: 31.2,
        destinationLng: 30.0,
        departureTime: DateTime.now(),
        distance: 200.0,
        estimatedDuration: 120,
        pricePerSeat: 100.0,
        totalSeats: 4,
        availableSeats: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(trip.id, 'trip1');
      expect(trip.availableSeats, 3);
      expect(trip.status, 'pending');
    });

    test('SearchCriteria creation', () {
      final criteria = SearchCriteria(
        origin: 'Cairo',
        destination: 'Alexandria',
        tripType: 'person',
        maxPrice: 150.0,
      );

      expect(criteria.origin, 'Cairo');
      expect(criteria.destination, 'Alexandria');
      expect(criteria.tripType, 'person');
      expect(criteria.maxPrice, 150.0);
    });

    test('MatchResult creation and quality indicators', () {
      final trip = Trip(
        id: 'trip1',
        type: 'person',
        role: 'offer',
        driverId: 'driver1',
        originAddress: 'Cairo',
        originLat: 30.0,
        originLng: 31.0,
        destinationAddress: 'Alexandria',
        destinationLat: 31.2,
        destinationLng: 30.0,
        departureTime: DateTime.now(),
        distance: 200.0,
        estimatedDuration: 120,
        pricePerSeat: 100.0,
        totalSeats: 4,
        availableSeats: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = MatchResult(
        trip: trip,
        matchScore: 85.0,
        matchReasons: ['Within budget', 'Matching type'],
        distance: 200.0,
      );

      expect(result.matchScore, 85.0);
      expect(result.matchQuality, 'Great Match');
      expect(result.distance, 200.0);
    });
  });

  group('App Compilation Tests', () {
    test('App has required imports and structure', () {
      expect(Message, isNotNull);
      expect(Trip, isNotNull);
      expect(SearchCriteria, isNotNull);
      expect(MatchResult, isNotNull);
    });
  });
}
