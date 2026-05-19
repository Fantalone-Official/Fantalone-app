import 'package:flutter/material.dart';

class CreazioneLegaScreen extends StatefulWidget {
  const CreazioneLegaScreen({super.key});

  @override
  State<CreazioneLegaScreen> createState() => _CreazioneLegaScreenState();
}

class _CreazioneLegaScreenState extends State<CreazioneLegaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  int budgetIniziale = 500;
  int numeroBot = 3;

  void _cambiaBot(int delta) {
    setState(() {
      int nuovoValore = numeroBot + delta;
      if (nuovoValore >= 1 && nuovoValore <= 10) {
        numeroBot = nuovoValore;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crea Nuova Lega"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: "Nome della Lega",
              hintText: "Es: Lega degli Amici",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.emoji_events),
            ),
          ),
          const SizedBox(height: 30),

          // SEZIONE BUDGET
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Budget Iniziale",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "$budgetIniziale FM",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: budgetIniziale.toDouble(),
            min: 100,
            max: 1000,
            divisions: 18,
            activeColor: Colors.teal,
            onChanged: (v) => setState(() => budgetIniziale = v.toInt()),
          ),
          const SizedBox(height: 30),

          // SEZIONE BOT
          const Text(
            "Numero di Bot (Avversari)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _cambiaBot(-1),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 32,
                  color: Colors.red,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$numeroBot",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _cambiaBot(1),
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 32,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // BOTTONE AZIONE
          SizedBox(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_nomeController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Inserisci un nome per la lega!"),
                    ),
                  );
                  return;
                }

                // Chiamata al manager della logica
                // LegaManager.inizializzaLega(
                //   _nomeController.text,
                //   budgetIniziale,
                //   numeroBot,
                // );

                Navigator.pushReplacementNamed(context, '/asta');
              },
              child: const Text(
                "GENERA LEGA E AVVIA ASTA",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
