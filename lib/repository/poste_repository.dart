import 'package:tp_flutter/data_source/poste_data_source.dart';
import 'package:tp_flutter/models/poste.dart';

class PosteRepository {
  final PosteDataSource remoteDataSource;

  PosteRepository({
    required this.remoteDataSource,
  });

  Future<List<Poste>> getProducts() async {
    try {
      final products = await remoteDataSource.getPoste();
      return products;
    } catch (e) {
      rethrow;
    }
  }
}
