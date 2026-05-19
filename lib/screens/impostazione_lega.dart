import 'package:flutter/material.dart';

// Definizione della classe Regole (messa fuori dallo State per pulizia)
class RegoleLega {
  double bonusGol = 3.0;
  double bonusAssist = 1.0;
  double bonusRigoreParato = 3.0;
  double bonusPortaInviolata = 1.0;
  double malusGolSubito = -1.0;
  double malusRigoreSbagliato = -3.0;
  double malusAmmonizione = -0.5;
  double malusEspulsione = -1.0;
  double malusAutogol = -2.0;
}

class ImpostazioniLegaScreen extends StatefulWidget {
  const ImpostazioniLegaScreen({super.key});

  @override
  _ImpostazioniLegaScreenState createState() => _ImpostazioniLegaScreenState();
}

class _ImpostazioniLegaScreenState extends State<ImpostazioniLegaScreen> {
  // 1. Inizializzazione oggetti e variabili
  final RegoleLega regole = RegoleLega();

  String sogliaPrimoGol = "66";
  String intervalloGol = "6";
  int budgetIniziale = 500;
  int giocatoriPanchina = 7;
  int numeroCambi = 5;
  String modalitaPanchina = "Cambi fissi";

  Map<String, bool> moduliAmmessi = {
    "3-4-3": true,
    "3-5-2": true,
    "3-6-1": false,
    "4-3-3": true,
    "4-4-2": true,
    "4-5-1": false,
    "5-3-2": false,
    "5-4-1": false,
  };

  // 2. Funzioni di supporto per i valori dei menu
  List<String> generaValoriBonus() =>
      List.generate(9, (index) => (index * 0.5).toString());
  List<String> generaValoriMalus() =>
      List.generate(9, (index) => (index * -0.5).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni Lega"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSezioneTitolo("Regole Calcolo (Punti)"),
          _buildDropdownSetting(
            label: "Soglia primo gol",
            value: sogliaPrimoGol,
            items: ["60", "66", "70", "72"],
            onChanged: (val) => setState(() => sogliaPrimoGol = val!),
          ),
          _buildDropdownSetting(
            label: "Intervallo gol successivi",
            value: intervalloGol,
            items: ["4", "6", "8", "10"],
            onChanged: (val) => setState(() => intervalloGol = val!),
          ),

          const Divider(height: 40),
          _buildSezioneTitolo("Bonus"),
          _buildDropdownSetting(
            label: "Gol Segnato",
            value: regole.bonusGol.toString(),
            items: generaValoriBonus(),
            onChanged: (val) =>
                setState(() => regole.bonusGol = double.parse(val!)),
          ),
          _buildDropdownSetting(
            label: "Porta Inviolata (Clean Sheet)",
            value: regole.bonusPortaInviolata.toString(),
            items: generaValoriBonus(),
            onChanged: (val) =>
                setState(() => regole.bonusPortaInviolata = double.parse(val!)),
          ),
          _buildDropdownSetting(
            label: "Assist",
            value: regole.bonusAssist.toString(),
            items: generaValoriBonus(),
            onChanged: (val) =>
                setState(() => regole.bonusAssist = double.parse(val!)),
          ),

          const Divider(height: 40),
          _buildSezioneTitolo("Malus"),
          _buildDropdownSetting(
            label: "Rigore Sbagliato",
            value: regole.malusRigoreSbagliato.toString(),
            items: generaValoriMalus(),
            onChanged: (val) => setState(
              () => regole.malusRigoreSbagliato = double.parse(val!),
            ),
          ),
          _buildDropdownSetting(
            label: "Ammonizione",
            value: regole.malusAmmonizione.toString(),
            items: generaValoriMalus(),
            onChanged: (val) =>
                setState(() => regole.malusAmmonizione = double.parse(val!)),
          ),

          const Divider(height: 40),
          _buildSezioneTitolo("Gestione Squadra & Budget"),
          _buildDropdownSetting(
            label: "Budget Iniziale",
            value: budgetIniziale.toString(),
            items: ["250", "500", "1000"],
            onChanged: (val) =>
                setState(() => budgetIniziale = int.parse(val!)),
          ),
          _buildDropdownSetting(
            label: "Giocatori in panchina",
            value: giocatoriPanchina.toString(),
            items: List.generate(12, (index) => (index + 5).toString()),
            onChanged: (val) =>
                setState(() => giocatoriPanchina = int.parse(val!)),
          ),

          const Divider(height: 40),
          _buildSezioneTitolo("Moduli Ammessi"),
          _buildTabellaModuli(),

          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: _salvaNuoveRegole,
            child: const Text(
              "SALVA MODIFICHE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Helper ---

  Widget _buildDropdownSetting({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value)
            ? value
            : items.first, // Evita errori se il valore non è in lista
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSezioneTitolo(String titolo) {
    return Text(
      titolo,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildTabellaModuli() {
    return Column(
      children: moduliAmmessi.keys.map((modulo) {
        return CheckboxListTile(
          title: Text(modulo),
          value: moduliAmmessi[modulo],
          onChanged: (bool? value) {
            setState(() => moduliAmmessi[modulo] = value!);
          },
        );
      }).toList(),
    );
  }

  void _salvaNuoveRegole() {
    // Logica di salvataggio (Database/API)
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Impostazioni salvate con successo!")),
    );
  }
}
