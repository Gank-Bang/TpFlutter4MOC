import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp_flutter/models/poste.dart';
import 'package:tp_flutter/pages/add_page.dart';
import 'package:tp_flutter/pages/details_page.dart';
import 'package:tp_flutter/poste_bloc/bloc/poste_bloc.dart';
import 'package:tp_flutter/repository/poste_repository.dart';
import 'package:tp_flutter/widget/list_tile.dart';
import 'package:provider/provider.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

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
                  'Accueil',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<PosteBloc, PosteState>(
              builder: (context, state) {
                switch (state.status) {
                  case PosteStatus.initial:
                    return const SizedBox();
                  case PosteStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PosteStatus.error:
                    return Center(
                      child: Text(state.error),
                    );
                  case PosteStatus.success:
                    final postes = state.postes;

                    if (postes.isEmpty) {
                      return const Center(
                        child: Text('Aucun poste'),
                      );
                    }

                    return ListView.builder(
                      itemCount: postes.length,
                      itemBuilder: (context, index) {
                        final poste = postes[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ListTileBeauty(
                            poste: poste,
                            onTap: () => _onTileTap(context, poste),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _onDeleteAllTap(context);
                },
                child: Icon(Icons.delete),
                backgroundColor: Colors.red, // Couleur de fond du bouton
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () {
                  _onActualizeTap(context);
                },
                child: Icon(Icons.refresh),
                backgroundColor: Colors.blue, // Couleur de fond du bouton
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () {
                  _onCrashTap();
                },
                child: Icon(Icons.car_crash),
                backgroundColor: Colors.deepOrange, // Couleur de fond du bouton
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () {
                  _onPlusTap(context);
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.grey, // Couleur de fond du bouton
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Position du bouton
    );
  }

  void _onTileTap(BuildContext context, Poste poste) {
    DetailsPage.navigateTo(context, poste);
  }

  void _onCrashTap() async {
    try {
      throw Exception("Par ici les 5 points de Crashlytics :) !!");
    } catch (error, stacktrace) {
      await FirebaseCrashlytics.instance
          .recordError(error, stacktrace, reason: 'a non-fatal error');
    }
  }

  void _onPlusTap(BuildContext context) {
    AjoutPage.navigateTo(context);
  }

  void _onActualizeTap(BuildContext context) {
    BlocProvider.of<PosteBloc>(context).add(GetAllPoste(1));
  }

  void _onDeleteAllTap(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Test de gestion d'état vide"),
          content: Text(
              "Supprimer tout les postes de Firestore Monsieur Ecalle ? \n\n\nPar ici les points de la gestion d'etats :)"),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                await deleteAllPostes();
                _onActualizeTap(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> deleteAllPostes() async {
    CollectionReference postesCollection =
        FirebaseFirestore.instance.collection('poste');

    QuerySnapshot querySnapshot = await postesCollection.get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
    return true;
  }
}
