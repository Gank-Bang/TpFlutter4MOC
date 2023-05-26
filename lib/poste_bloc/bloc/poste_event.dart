part of 'poste_bloc.dart';

@immutable
abstract class PosteEvent {}

class GetAllPoste extends PosteEvent {
  final int count;

  GetAllPoste(this.count);
}
