import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp_flutter/models/poste.dart';
import 'package:tp_flutter/poste_bloc/bloc/poste_bloc.dart';
import 'package:tp_flutter/widget/list_tile.dart';

class AjoutPage extends StatefulWidget {
  static const String routeName = '/AjoutScreen';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const AjoutPage();

  @override
  _AjoutPageState createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  late TextEditingController titreController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titreController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
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
                  'Ajouter un Poste',
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
              _addEntry(titre, description);
            },
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _addEntry(String titre, String description) async {
    try {
      print("$titre $description");
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('poste');

      QuerySnapshot querySnapshot = await collectionReference
          .where('titre', isEqualTo: titre)
          .where('description', isEqualTo: description)
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isEmpty) {
        if (titre.isEmpty || description.isEmpty) {
          _showSnackBar(context, 'Un champ ne peut pas être vide');
        } else {
          await collectionReference
              .add({'titre': titre, 'description': description});

          _onRefreshList(context);

          Navigator.pop(context);
        }
      } else {
        print('Une entrée avec les mêmes valeurs existe déjà.');
      }
    } catch (error) {
      print('Erreur lors de l\'ajout dans Firestore: $error');
    }
  }

  void _onRefreshList(BuildContext context) {
    final posteBloc = BlocProvider.of<PosteBloc>(context);
    posteBloc.add(GetAllPoste(10));
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
