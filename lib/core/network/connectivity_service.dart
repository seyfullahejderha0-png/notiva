import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// İnternet bağlantı durumunu izleyen servis.
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  bool _isConnected = true;

  bool get isConnected => _isConnected;
  Stream<bool> get connectivityStream => _connectionController.stream;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Bağlantı dinleyicisini başlatır.
  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected = results.any(
      (r) => r != ConnectivityResult.none,
    );
    if (_isConnected != connected) {
      _isConnected = connected;
      _connectionController.add(_isConnected);
    }
  }

  /// Dinleyiciyi temizler.
  void dispose() {
    _subscription?.cancel();
    _connectionController.close();
  }
}
