import 'package:flutter/material.dart';
import '../widgets/slot_giocatore.dart';
import '../models/giocatore.dart';

// Supponendo che tu abbia questi modelli e servizi definiti altrove
class FormazioneInviata {
  final String idUtente;
  final int giornata;
  final List<String> idTitolari;
  final List<String> idPanchinari;
  final String modulo;
  final DateTime dataInvio;

  FormazioneInviata({
    required this.idUtente,
    required this.giornata,
    required this.idTitolari,
    required this.idPanchinari,
    required this.modulo,
    required this.dataInvio,
  });
}

class InviaFormazioneScreen extends StatefulWidget {
  const InviaFormazioneScreen({super.key});

  @override
  _InviaFormazioneScreenState createState() => _InviaFormazioneScreenState();
}

class _InviaFormazioneScreenState extends State<InviaFormazioneScreen> {
  String moduloScelto = "4-3-3";
  List<String> moduliDisponibili = ["4-3-3", "3-4-3", "4-4-2", "3-5-2"];

  // STATO DELLA FORMAZIONE
  Map<String, Giocatore?> titolariSelezionati = {};
  List<Giocatore?> panchinaSelezionata = List.filled(7, null);

  // Dati simulati per la rosa (da sostituire con i tuoi dati reali)
  List<Giocatore> giocatoreRosa = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Invia Formazione"),
        actions: [
          TextButton(
            onPressed: _salvaFormazione,
            child: const Text(
              "SALVA",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelettoreModulo(),
                const SizedBox(height: 10),

                // CAMPO DA GIOCO
                Container(
                  height: 420,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade800, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildLineeCampo(),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Panchina (max 7):",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildPanchina(),
                const SizedBox(
                  height: 120,
                ), // Spazio per il pannello scorrevole
              ],
            ),
          ),
          _buildListaRosaScorrevole(),
        ],
      ),
    );
  }

  // --- LOGICA DI SELEZIONE ---

  void _selezionaGiocatore(Giocatore g) {
    setState(() {
      // 1. Evitiamo duplicati
      if (titolariSelezionati.values.contains(g) ||
          panchinaSelezionata.contains(g)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Giocatore già inserito!"),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      String ruoloCodice = g.ruolo.substring(0, 3).toUpperCase();
      bool inseritoNeiTitolari = false;
      int slotMassimiPerRuolo = _getSlotMassimiPerModulo(ruoloCodice);

      // 2. Cerchiamo slot libero nei titolari
      for (int i = 0; i < slotMassimiPerRuolo; i++) {
        String key = "${ruoloCodice}_$i";
        if (titolariSelezionati[key] == null) {
          titolariSelezionati[key] = g;
          inseritoNeiTitolari = true;
          break;
        }
      }

      // 3. Se pieno, prova in panchina
      if (!inseritoNeiTitolari) {
        int primoLibero = panchinaSelezionata.indexOf(null);
        if (primoLibero != -1) {
          panchinaSelezionata[primoLibero] = g;
        } else {
          _mostraAvviso("Formazione e panchina piene!");
        }
      }
    });
  }

  void _rimuoviGiocatore(String key, {bool isPanchina = false, int? index}) {
    setState(() {
      if (isPanchina) {
        panchinaSelezionata[index!] = null;
      } else {
        titolariSelezionati[key] = null;
      }
    });
  }

  int _getSlotMassimiPerModulo(String ruolo) {
    List<int> parti = moduloScelto.split('-').map(int.parse).toList();
    switch (ruolo) {
      case "POR":
        return 1;
      case "DIF":
        return parti[0];
      case "CEN":
        return parti[1];
      case "ATT":
        return parti[2];
      default:
        return 0;
    }
  }

  // --- UI WIDGETS ---

  List<Widget> _buildLineeCampo() {
    List<int> struttura = moduloScelto.split('-').map(int.parse).toList();
    struttura.insert(0, 1); // Portiere

    List<String> ruoliKey = ["POR", "DIF", "CEN", "ATT"];
    List<Widget> linee = [];

    for (int i = 0; i < struttura.length; i++) {
      linee.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(struttura[i], (index) {
            String key = "${ruoliKey[i]}_$index";
            return SlotGiocatore(
              giocatore: titolariSelezionati[key],
              ruoloDesc: ruoliKey[i],
              onTap: () => _rimuoviGiocatore(key),
            );
          }),
        ),
      );
    }
    return linee.reversed.toList();
  }

  Widget _buildPanchina() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(panchinaSelezionata.length, (index) {
        return SlotGiocatore(
          giocatore: panchinaSelezionata[index],
          ruoloDesc: "PAN",
          onTap: () => _rimuoviGiocatore("", isPanchina: true, index: index),
        );
      }),
    );
  }

  Widget _buildListaRosaScorrevole() {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.15,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.grey.shade300,
              ),
              const Text(
                "La Tua Rosa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: giocatoreRosa.length,
                  separatorBuilder: (c, i) => const Divider(),
                  itemBuilder: (context, index) {
                    final g = giocatoreRosa[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(g.ruolo[0])),
                      title: Text(g.nome),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.teal),
                        onPressed: () => _selezionaGiocatore(g),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelettoreModulo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Modulo:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: moduloScelto,
          onChanged: (val) => setState(() {
            moduloScelto = val!;
            titolariSelezionati.clear();
          }),
          items: moduliDisponibili
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
        ),
      ],
    );
  }

  void _mostraAvviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _salvaFormazione() async {
    // Logica di salvataggio finale
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Formazione salvata con successo! ⚽")),
    );
  }
}
