import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'connection_shell_event.dart';
part 'connection_shell_state.dart';

class ConnectionShellBloc
    extends Bloc<ConnectionShellEvent, ConnectionShellState> {
  ConnectionShellBloc() : super(ConnectionShellState.initial) {
    on<ConnectionStatusSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    ConnectionStatusSubscriptionRequested event,
    Emitter<ConnectionShellState> emit,
  ) async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    emit(
      state.copyWith(
        status: hasInternet ? ConnectionStatus.on : ConnectionStatus.off,
      ),
    );

    await emit.onEach<InternetStatus>(
      InternetConnection().onStatusChange,
      onData: (status) async {
        if (status == InternetStatus.disconnected) {
          await Future.delayed(Duration(seconds: 5));
        }
        emit(
          state.copyWith(
            status: status == InternetStatus.connected
                ? ConnectionStatus.on
                : ConnectionStatus.off,
          ),
        );
      },
    );
  }
}
