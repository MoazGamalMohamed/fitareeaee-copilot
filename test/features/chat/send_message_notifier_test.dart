import 'package:dartz/dartz.dart';
import 'package:fitareeaee/core/error/failures.dart';
import 'package:fitareeaee/features/chat/domain/entities/message.dart';
import 'package:fitareeaee/features/chat/domain/repositories/chat_repository.dart';
import 'package:fitareeaee/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository(this.result);

  Either<Failure, Message> result;

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async =>
      result.map((_) => message);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('send failure remains visible and completes with an error', () async {
    final repository = _FakeChatRepository(
      const Left(FirebaseFailure(message: 'permission denied')),
    );
    final notifier = SendMessageNotifier(
      chatRepository: repository,
      userId: 'rider',
    );

    await expectLater(
      notifier.sendMessage(recipientId: 'driver', content: 'Hello'),
      throwsA(isA<Exception>()),
    );
    expect(notifier.state, isA<AsyncError<void>>());
  });

  test('authorized send completes successfully', () async {
    final placeholder = Message(
      id: 'placeholder',
      senderId: 'rider',
      recipientId: 'driver',
      content: 'Hello',
      attachments: const <String>[],
      createdAt: DateTime.utc(2026, 7, 18),
      isRead: false,
      readAt: null,
      isDeleted: false,
    );
    final repository = _FakeChatRepository(Right(placeholder));
    final notifier = SendMessageNotifier(
      chatRepository: repository,
      userId: 'rider',
    );

    await notifier.sendMessage(recipientId: 'driver', content: 'Hello');

    expect(notifier.state, isA<AsyncData<void>>());
  });
}
