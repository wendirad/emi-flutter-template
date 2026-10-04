part of 'remembered_email_bloc.dart';

sealed class RememberedEmailEvent extends Equatable {
  const RememberedEmailEvent();

  @override
  List<Object?> get props => [];
}

class RememberedEmailRequested extends RememberedEmailEvent {
  const RememberedEmailRequested();
}
