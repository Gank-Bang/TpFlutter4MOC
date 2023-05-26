import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter/data_source/poste_data_source.dart';
import 'package:tp_flutter/models/poste.dart';

class ApiPosteDataSource extends PosteDataSource {
  @override
  Future<List<Poste>> getPoste() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('poste');

    QuerySnapshot querySnapshot = await collectionReference.get();
    List<DocumentSnapshot> documents = querySnapshot.docs;

    List<Poste> postes = [];

    for (var document in documents) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      String titre = data['titre'];
      String description = data['description'];

      // La partie en commentaires suivantes est pour tester le cas ou une erreur se produit monsieur Ecalle
      //if (titre == 'Titre recherché' &&
      //description == 'Description recherchée') {
      Poste poste = Poste(titre: titre, description: description);
      postes.add(poste);
      //}
    }

    return postes;
  }
}
