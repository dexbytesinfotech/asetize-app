import '../../../../imports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WorkplaceNetworkBloc
    extends Bloc<WorkplaceNetworkEvent, WorkplaceNetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  WorkplaceNetworkBloc() : super(NetworkInitial()) {
    // Listen to List<ConnectivityResult> stream
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

    on<NetworkUpdateEvent>((event, emit) async {
      emit(NetworkConnected());
    });

    on<NetworkLostEvent>((event, emit) async {
      emit(NetworkDisconnected());
    });
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isConnected = results.any((result) => result != ConnectivityResult.none);

    if (isConnected) {
      add(NetworkUpdateEvent());
    } else {
      add(NetworkLostEvent());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
