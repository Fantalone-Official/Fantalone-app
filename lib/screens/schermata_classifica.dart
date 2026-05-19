import 'package:flutter/material.dart';

class SchermataClassifica extends StatelessWidget {
  const SchermataClassifica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classifica Lega"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Intestazione tabella
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 30, child: Text("Pos", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Squadra", style: TextStyle(fontWeight: FontWeight.bold))),
                  Text("Punti", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Lista dei partecipanti (Dati Mock per ora)
            _buildRankRow("1", "Scarsenal (Tu)", "0", isUser: true),
            _buildRankRow("2", "Aggressivo", "0"),
            _buildRankRow("3", "Moderato", "0"),
            _buildRankRow("4", "Sparagnino", "0"),
          ],
        ),
      ),
    );
  }

  Widget _buildRankRow(String pos, String nome, String punti, {bool isUser = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        color: isUser ? Colors.yellow.shade50 : Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(pos, style: TextStyle(fontWeight: isUser ? FontWeight.bold : FontWeight.normal))),
          Expanded(child: Text(nome, style: TextStyle(fontWeight: isUser ? FontWeight.bold : FontWeight.normal))),
          Text(punti, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}