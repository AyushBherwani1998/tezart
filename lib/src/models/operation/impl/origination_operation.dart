import 'package:meta/meta.dart';

import 'operation.dart';

class OriginationOperation extends Operation {
  OriginationOperation({
    @required int balance,
    @required List<Map<String, dynamic>> code,
    @required Map<String, dynamic> storage,
    int storageLimit,
  }) : super(
          kind: Kinds.origination,
          balance: balance,
          script: {
            'code': code,
            'storage': storage,
          },
          storageLimit: storageLimit,
        );
  String get contractAddress {
    // TODO: use ?. when null safety migration is done
    // TODO: handle the case of multiple originated contracts ?!
    return operationsList
        .operations.first.simulationResult['metadata']['operation_result']['originated_contracts'].first;
  }
}