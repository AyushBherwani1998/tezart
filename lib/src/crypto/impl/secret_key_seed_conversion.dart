import 'dart:typed_data';

import 'package:tezart/tezart.dart';


// 1. Convert secret key to bytes
// 2. Cut first 4 bytes representing the prefix
// 3. Take first 32 bytes representing the secret key
// 4. encode the result using edsk2 prefix
// returns the seed of the secret key
String secretKeyToSeed(String secretKey) {
  const seedPrefix = Prefixes.edsk2;
  final bytes = Uint8List.fromList(decodeWithoutPrefix(secretKey).take(32).toList());

  return encodeWithPrefix(
    prefix: seedPrefix,
    bytes: bytes,
  );
}

String seedToSecretKey(String seed) {
  const secretKeyPrefix = Prefixes.edsk;

  final seedBytes = decodeWithoutPrefix(seed);
  if (seedBytes.length != 32) {
    throw CryptoError(type: CryptoErrorTypes.seedBytesLengthError);
  }

  final secretKey = secretKeyBytesFromSeedBytes(seedBytes);

  return encodeWithPrefix(
    prefix: secretKeyPrefix,
    bytes: Uint8List.fromList(secretKey.toList()),
  );
}
