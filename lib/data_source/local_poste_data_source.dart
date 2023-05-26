import 'package:flutter/material.dart';
import 'package:tp_flutter/data_source/poste_data_source.dart';
import 'package:tp_flutter/models/poste.dart';

class LocalPosteDataSource extends PosteDataSource {
  @override
  Future<List<Poste>> getPoste() {
    debugPrint('Getting fruits from local data source');
    return Future.value([]);
  }
}
