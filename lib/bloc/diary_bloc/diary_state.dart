part of 'diary_bloc.dart';

/// форма выбора файла и ввода пароля;
/// форма создания нового дневника, поля: пароль, выбор места сохранения
/// (по умолчанию в папке пользователя);
/// список записей;
/// форма редактирования записи с автосохранением,
/// причем должно быть два режима: чтение и редактирование,
/// поле ввода в идеале wysiwyg (markdown внутри)
/// при попытке перехода в режим редактирования, если не сегодняшняя запись
/// спросить "Вы действительно хотите ворошить прошлое?"
/// смена пароля;

abstract class DiaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLocked extends DiaryState {
  final String lastPath;

  DiaryLocked({
    this.lastPath = '',
  });
}

class DiaryUnlocked extends DiaryState {
}
