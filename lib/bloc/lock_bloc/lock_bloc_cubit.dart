import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:only_diary/models/app_settings.dart';
import 'package:path_provider/path_provider.dart';

part 'lock_bloc_state.dart';

class LockBlocCubit extends Cubit<LockBlocState> {
  late final String? _appDir;

  LockBlocCubit() : super(LockBlocInitial()) {
    getApplicationDocumentsDirectory().then((d) => _appDir = d.path);
  }
}
