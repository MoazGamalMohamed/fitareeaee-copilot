class Failure {
  final String message;
  const Failure({required this.message});
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({required String message}) : super(message: message);
}
