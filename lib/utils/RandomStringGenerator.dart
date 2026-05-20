import 'dart:math';

class RandomStringGenerator {

  static const String alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';

  static final Random _random =
  Random.secure();

  static String generateContentPlaybackNonce() {
    return _generate(alphabet, 16);
  }

  static String generateTParameter() {
    return _generate(alphabet, 12);
  }

  static String _generate(
      String alphabet,
      int length,
      ) {

    return List.generate(
      length,
          (_) => alphabet[
      _random.nextInt(alphabet.length)],
    ).join();
  }
}