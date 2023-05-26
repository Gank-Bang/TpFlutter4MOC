import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp_flutter/models/poste.dart';
import 'package:tp_flutter/poste_bloc/bloc/poste_bloc.dart';
import 'package:tp_flutter/widget/list_tile.dart';

class DetailsPage extends StatefulWidget {
  static const String routeName = '/DetailsScreen';
  final Poste poste;

  static void navigateTo(BuildContext context, Poste poste) {
    Navigator.of(context).pushNamed(routeName, arguments: poste);
  }

  const DetailsPage({required this.poste});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController titreController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titreController = TextEditingController(text: widget.poste.titre);
    descriptionController =
        TextEditingController(text: widget.poste.description);
  }

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Text(
                  'Détails',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Titre',
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
              controller: titreController,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
              controller: descriptionController,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String titre = titreController.text;
              String description = descriptionController.text;
              _modifyEntry(titre, description, widget.poste.titre,
                  widget.poste.description);
            },
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _modifyEntry(String titre, String description, String oldTitre,
      String oldDescription) async {
    try {
      print("$titre $description");
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('poste');

      QuerySnapshot querySnapshot = await collectionReference
          .where('titre', isEqualTo: oldTitre)
          .where('description', isEqualTo: oldDescription)
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        // Mettre à jour les valeurs dans Firestore
        DocumentSnapshot document = documents.first;
        await document.reference
            .update({'titre': titre, 'description': description});

        _onRefreshList(context);

        Navigator.pop(context);
      } else {
        print('Aucun document trouvé avec les valeurs spécifiées.');
      }
    } catch (error) {
      print('Erreur lors de la modification dans Firestore: $error');
    }
  }

  void _onRefreshList(BuildContext context) {
    final posteBloc = BlocProvider.of<PosteBloc>(context);
    posteBloc.add(GetAllPoste(10));
  }
}
