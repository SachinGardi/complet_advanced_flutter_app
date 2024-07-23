import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  final DataConnectionChecker _dataConnectionChecker;
  NetworkInfoImpl(this._dataConnectionChecker);
  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => _dataConnectionChecker.hasConnection;

}