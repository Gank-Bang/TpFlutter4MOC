part of 'poste_bloc.dart';

enum PosteStatus {
  initial,
  loading,
  success,
  error,
}

class PosteState {
  final PosteStatus status;
  final List<Poste> postes;
  final String error;

  PosteState({
    this.status = PosteStatus.initial,
    this.postes = const [],
    this.error = '',
  });

  PosteState copyWith({
    PosteStatus? status,
    List<Poste>? postes,
    String? error,
  }) {
    return PosteState(
      status: status ?? this.status,
      postes: postes ?? this.postes,
      error: error ?? this.error,
    );
  }
}
