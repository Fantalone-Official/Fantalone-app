import 'package:flutter/material.dart';
import 'schermata_asta.dart';
import 'area_scambi.dart';

class AreaMercato extends StatelessWidget {
  const AreaMercato({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AREA MERCATO"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildMercatoButton(context, "Asta live", const SchermataAsta()),
            const SizedBox(height: 20),
            _buildMercatoButton(context, "Listone completo", null), // Da creare
            const SizedBox(height: 20),
            _buildMercatoButton(context, "Area scambi", const AreaScambi()),
          ],
        ),
      ),
    );
  }

  Widget _buildMercatoButton(BuildContext context, String titolo, Widget? targetPage) {
    return InkWell(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sezione $titolo in arrivo!")),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            titolo,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}