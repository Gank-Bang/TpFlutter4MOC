import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tp_flutter/models/poste.dart';
import 'package:tp_flutter/repository/poste_repository.dart';

part 'poste_event.dart';
part 'poste_state.dart';

class PosteBloc extends Bloc<PosteEvent, PosteState> {
  final PosteRepository repository;

  PosteBloc({required this.repository}) : super(PosteState()) {
    on<GetAllPoste>((event, emit) async {
      emit(state.copyWith(status: PosteStatus.loading));

      final count = event.count;

      try {
        final postes = await repository.getProducts();
        emit(state.copyWith(status: PosteStatus.success, postes: postes));
      } catch (error) {
        emit(
            state.copyWith(status: PosteStatus.error, error: error.toString()));
      }
    });
  }
}
