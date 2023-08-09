import 'package:tezart/src/models/operation/impl/operation_visitor.dart';

import 'operation.dart';

class OperationFeesSetterVisitor implements OperationVisitor {
  static const _baseOperationMinimalFee = 200;
  static const _gasBuffer = 500;
  static const _minimalFeePerByte = 1;
  static const _minimalFeePerGas = 0.5;

  @override
  Future<void> visit(Operation operation) async {
    operation.fee = operation.customFee ?? await _totalCost(operation);
  }

  Future<int> _burnFee(Operation operation) async {
    if (operation.storageLimit == null) throw ArgumentError.notNull('operation.storageLimit');

    return (operation.storageLimit! * await _costPerBytes(operation)).ceil();
  }

  Future<int> _costPerBytes(Operation operation) async {
    if (operation.operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    return int.parse((await operation.operationsList!.rpcInterface.constants())['cost_per_byte']);
  }

  int _minimalFee(Operation operation) {
    return (_baseOperationMinimalFee + _operationFee(operation)).ceil();
  }

  int _operationFee(Operation operation) {
    if (operation.gasLimit == null) throw ArgumentError.notNull('operation.gasLimit');

    return ((operation.gasLimit! + _gasBuffer) * _minimalFeePerGas + _operationSize(operation) * _minimalFeePerByte)
        .ceil();
  }

  // TODO: Why divide by two ?
  int _operationSize(Operation operation) {
    final operationsList = operation.operationsList;
    if (operationsList == null) throw ArgumentError.notNull('operation.operationsList');

    final operationsListResult = operationsList.result;
    if (operationsListResult.forgedOperation == null) {
      throw ArgumentError.notNull('operation.operationsList.result.forgedOperation');
    }

    return (operationsList.result.forgedOperation!.length / 2 / operationsList.operations.length).ceil();
  }

  Future<int> _totalCost(Operation operation) async {
    return (await _burnFee(operation)) + _minimalFee(operation);
  }
}
