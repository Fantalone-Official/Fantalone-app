import 'package:flutter/material.dart';

class ImpostazioniLegaScreen extends StatefulWidget {
  const ImpostazioniLegaScreen({super.key});

  @override
  _ImpostazioniLegaScreenState createState() => _ImpostazioniLegaScreenState();
}

class _ImpostazioniLegaScreenState extends State<ImpostazioniLegaScreen> {
  // Variabili di stato
  String budget = "500";
  String panchina = "12";
  String cambi = "5";
  Map<String, bool> moduli = {"3-4-3": true, "4-3-3": true, "4-4-2": true, "3-5-2": true}; // ...tutti i 14

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Impostazioni Lega")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildDropdown("Budget Iniziale", budget, ["250", "500", "1000"], (v) => setState(() => budget = v!)),
          _buildDropdown("Panchina", panchina, List.generate(12, (i) => (i+5).toString()), (v) => setState(() => panchina = v!)),
          _buildDropdown("Cambi", cambi, List.generate(17, (i) => i.toString()), (v) => setState(() => cambi = v!)),
          
          Divider(),
          Text("Moduli Ammessi", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            children: moduli.keys.map((m) => FilterChip(
              label: Text(m),
              selected: moduli[m]!,
              onSelected: (bool s) => setState(() => moduli[m] = s),
            )).toList(),
          ),
          // ... tasto salva
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
    );
  }
}