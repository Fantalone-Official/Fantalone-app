import 'package:flutter/material.dart';
import '../models/giocatore.dart';
import '../services/stato_lega.dart';
import '../services/budget_service.dart';
import '../services/log_service.dart';
import '../services/database_service.dart';

class VisualizzaRosa extends StatefulWidget {
  const VisualizzaRosa({super.key});

  @override
  State<VisualizzaRosa> createState() => _VisualizzaRosaState();
}

class _VisualizzaRosaState extends State<VisualizzaRosa> {
  @override
  Widget build(BuildContext context) {
    // Filtro dinamico della rosa attuale
    final portieri = StatoLega.rosaUtente.where((g) => g.ruolo == "P").toList();
    final difensori = StatoLega.rosaUtente
        .where((g) => g.ruolo == "D")
        .toList();
    final centrocampisti = StatoLega.rosaUtente
        .where((g) => g.ruolo == "C")
        .toList();
    final attaccanti = StatoLega.rosaUtente
        .where((g) => g.ruolo == "A")
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("LA MIA ROSA"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _mostraCronologia(context),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                "${BudgetService.budgetRimanente} FM",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSezioneReparto(context, "PORTIERI", portieri, Colors.orange, 3),
          _buildSezioneReparto(
            context,
            "DIFENSORI",
            difensori,
            Colors.green,
            8,
          ),
          _buildSezioneReparto(
            context,
            "CENTROCAMPISTI",
            centrocampisti,
            Colors.blue,
            8,
          ),
          _buildSezioneReparto(
            context,
            "ATTACCANTI",
            attaccanti,
            Colors.red,
            6,
          ),
        ],
      ),
    );
  }

  Widget _buildSezioneReparto(
    BuildContext context,
    String titolo,
    List<Giocatore> lista,
    Color colore,
    int limite,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          color: colore.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titolo,
                style: TextStyle(
                  color: colore,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${lista.length} / $limite",
                style: TextStyle(color: colore, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (lista.isEmpty)
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Nessun giocatore acquistato",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          )
        else
          ...lista
              .map(
                (g) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colore,
                    child: Text(
                      g.ruolo,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(
                    g.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(g.squadra),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${g.prezzoAcquisto} FM",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _confermaSvincolo(context, g),
                      ),
                    ],
                  ),
                ),
              )
              ,
        const Divider(height: 1),
      ],
    );
  }

  void _confermaSvincolo(BuildContext context, Giocatore giocatore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Conferma svincolo"),
        content: Text(
          "Vuoi svincolare ${giocatore.nome}? Recupererai ${giocatore.prezzoAcquisto} FM.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULLA"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final prezzo = giocatore.prezzoAcquisto ?? 0;
                BudgetService.aggiungi(prezzo);
                LogService.aggiungiEvento(
                  giocatore.nome,
                  "Svincolo",
                  prezzo,
                  false,
                );
                StatoLega.rosaUtente.removeWhere(
                  (item) => item.nome == giocatore.nome,
                );
                DatabaseService.listaCompleta.add(giocatore);
                DatabaseService.listaCompleta.sort(
                  (a, b) => a.nome.compareTo(b.nome),
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${giocatore.nome} svincolato correttamente."),
                ),
              );
            },
            child: const Text("SVINCOLA", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostraCronologia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "CRONOLOGIA MOVIMENTI",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: LogService.cronologia.isEmpty
                  ? const Center(child: Text("Nessuna operazione registrata"))
                  : ListView.builder(
                      itemCount: LogService.cronologia.length,
                      itemBuilder: (context, index) {
                        final ev = LogService.cronologia[index];
                        return ListTile(
                          leading: Icon(
                            ev.isIngresso
                                ? Icons.add_circle
                                : Icons.remove_circle,
                            color: ev.isIngresso ? Colors.green : Colors.red,
                          ),
                          title: Text(ev.nomeGiocatore),
                          subtitle: Text(
                            "${ev.tipo} - ${ev.data.day}/${ev.data.month}",
                          ),
                          trailing: Text(
                            "${ev.isIngresso ? '-' : '+'}${ev.crediti} FM",
                            style: TextStyle(
                              color: ev.isIngresso ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
