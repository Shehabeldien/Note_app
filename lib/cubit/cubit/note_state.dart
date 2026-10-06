part of 'note_cubit.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class Noteloadingstate extends NoteState {}

final class NoteSuccessState extends NoteState {}

final class NoteEmptyState extends NoteState {}

final class NoteAddedState extends NoteState {}

final class NoteClearAllState extends NoteState {}

final class NoteDeleteState extends NoteState {}

final class NoteUpdateState extends NoteState {}
