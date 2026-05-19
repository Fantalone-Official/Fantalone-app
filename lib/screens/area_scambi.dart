import 'package:flutter/material.dart';
import '../models/giocatore.dart';
import 'proponi_scambio.dart'; // File che creeremo dopo

class AreaScambi extends StatefulWidget {
  const AreaScambi({super.key});

  @override
  State<AreaScambi> createState() => _AreaScambiState();
}

class _AreaScambiState extends State<AreaScambi> {
  String? squadraSelezionata;
  Giocatore? giocatoreInUscita; // Dalla tua rosa
  Giocatore? giocatoreInEntrata; // Dal listone (filtrato per squadra)
  final TextEditingController _creditiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AREA SCAMBI"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildScambioButton(context, "Proponi nuovo\nScambio", Colors.teal.shade100, Colors.teal, true),
            const SizedBox(height: 20),
            _buildScambioButton(context, "Scambi in corso", Colors.yellow.shade100, Colors.yellow.shade700, false),
            const SizedBox(height: 20),
            _buildScambioButton(context, "Scambi accettati", Colors.green.shade100, Colors.green.shade700, false),
            const SizedBox(height: 20),
            _buildScambioButton(context, "Scambi rifiutati", Colors.red.shade100, Colors.red.shade700, false),
          ],
        ),
      ),
    );
  }

  Widget _buildScambioButton(BuildContext context, String testo, Color bgColor, Color borderColor, bool isProponi) {
    return InkWell(
      onTap: () {
        if (isProponi) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProponiScambioScreen()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _creditiController.dispose();
    super.dispose();
  }
}