import 'package:tp_flutter/models/poste.dart';

abstract class PosteDataSource {
  Future<List<Poste>> getPoste();
}
