part of 'connection_shell_bloc.dart';

sealed class ConnectionShellEvent extends Equatable {
  const ConnectionShellEvent();

  @override
  List<Object?> get props => [];
}

class UpdateConnectionStatus extends ConnectionShellEvent {
  const UpdateConnectionStatus();
}

class ConnectionStatusSubscriptionRequested extends ConnectionShellEvent {
  const ConnectionStatusSubscriptionRequested();
}
