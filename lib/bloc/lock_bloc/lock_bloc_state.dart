part of 'lock_bloc_cubit.dart';

abstract class LockBlocState extends Equatable {
  const LockBlocState();
}

class LockBlocInitial extends LockBlocState {
  final String? lastPath = AppSettings.current.lastPath;

  @override
  List<Object?> get props => [lastPath];
}
