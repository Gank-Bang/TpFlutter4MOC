import 'package:flutter/material.dart';
import 'package:tp_flutter/models/poste.dart';

class ListTileBeauty extends StatelessWidget {
  final VoidCallback? onTap;
  final Poste poste;
  const ListTileBeauty({
    Key? key,
    required this.poste,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey, // Couleur de fond du rectangle
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 10), // Espacement à gauche et à droite
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  '${poste.titre}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text("${poste.description}"),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
