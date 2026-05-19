import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/giocatore.dart';
import '../services/stato_lega.dart';
import '../services/database_service.dart';
import '../services/budget_service.dart';
import '../services/log_service.dart';

class ProponiScambioScreen extends StatefulWidget {
  const ProponiScambioScreen({super.key});

  @override
  State<ProponiScambioScreen> createState() => _ProponiScambioScreenState();
}

class _ProponiScambioScreenState extends State<ProponiScambioScreen> {
  Giocatore? mioGiocatoreSelezionato;
  Giocatore? giocatoreTargetSelezionato;
  String? squadraSelezionata;

  final TextEditingController _tuoiCreditiController = TextEditingController(
    text: "0",
  );
  final TextEditingController _suoiCreditiController = TextEditingController(
    text: "0",
  );

  @override
  void dispose() {
    _tuoiCreditiController.dispose();
    _suoiCreditiController.dispose();
    super.dispose();
  }

  // Verifica se lo scambio è eseguibile
  bool _isDataValid() {
    return mioGiocatoreSelezionato != null &&
        giocatoreTargetSelezionato != null &&
        squadraSelezionata != null;
  }

  void _confermaEseguiScambio() {
    int offri = int.tryParse(_tuoiCreditiController.text) ?? 0;
    int ricevi = int.tryParse(_suoiCreditiController.text) ?? 0;
    int bilancioNetto = ricevi - offri;

    // Controllo disponibilità budget se il bilancio è negativo (stai spendendo)
    if (bilancioNetto < 0 &&
        BudgetService.budgetRimanente < bilancioNetto.abs()) {
      _mostraMessaggio("Errore: Budget insufficiente!", Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Conferma Scambio"),
        content: Text(
          "Stai scambiando ${mioGiocatoreSelezionato!.nome} per ${giocatoreTargetSelezionato!.nome}.\n"
          "Bilancio crediti: ${bilancioNetto >= 0 ? "+" : ""}$bilancioNetto FM",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULLA"),
          ),
          TextButton(
            onPressed: () {
              _eseguiLogicaScambio(bilancioNetto);
              Navigator.pop(context); // Chiude Dialog
              Navigator.pop(context); // Torna alla Home
            },
            child: const Text(
              "CONFERMA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _eseguiLogicaScambio(int bilancioNetto) {
    setState(() {
      // 1. Spostamento Giocatori
      // Rimuovo il mio e lo rimetto nel listone (o nella squadra target se gestissi le altre rose)
      StatoLega.rosaUtente.remove(mioGiocatoreSelezionato);
      DatabaseService.listaCompleta.add(mioGiocatoreSelezionato!);

      // Prendo il suo e lo rimuovo dal listone
      StatoLega.rosaUtente.add(giocatoreTargetSelezionato!);
      DatabaseService.listaCompleta.remove(giocatoreTargetSelezionato);

      // 2. Gestione Budget
      if (bilancioNetto > 0) {
        BudgetService.aggiungi(bilancioNetto);
      } else if (bilancioNetto < 0) {
        BudgetService.sottrai(bilancioNetto.abs());
      }

      // 3. Log dell'evento
      LogService.aggiungiEvento(
        "SCAMBIO: OUT ${mioGiocatoreSelezionato!.nome} / IN ${giocatoreTargetSelezionato!.nome}",
        "Scambio con $squadraSelezionata",
        bilancioNetto.abs(),
        bilancioNetto >= 0,
      );
    });

    _mostraMessaggio("Scambio effettuato con successo!", Colors.green);
  }

  void _mostraMessaggio(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROPONI SCAMBIO"),
        backgroundColor: Colors.teal,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                "Disp: ${BudgetService.budgetRimanente} FM",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildMioGiocatoreSection(),
            const Divider(height: 40),
            _buildSquadraTargetSection(),
            const SizedBox(height: 20),
            _buildCreditiSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMioGiocatoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "IL TUO GIOCATORE DA CEDERE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<Giocatore>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          initialValue: mioGiocatoreSelezionato,
          items: StatoLega.rosaUtente.map((g) {
            return DropdownMenuItem(
              value: g,
              child: Text("${g.ruolo} - ${g.nome}"),
            );
          }).toList(),
          onChanged: (val) => setState(() => mioGiocatoreSelezionato = val),
        ),
      ],
    );
  }

  Widget _buildSquadraTargetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SQUADRA E GIOCATORE RICHIESTO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Seleziona Squadra Lega",
            border: OutlineInputBorder(),
          ),
          initialValue: squadraSelezionata,
          items: StatoLega.nomiSquadreLega.map((nome) {
            return DropdownMenuItem(value: nome, child: Text(nome));
          }).toList(),
          onChanged: (val) {
            setState(() {
              squadraSelezionata = val;
              giocatoreTargetSelezionato = null; // Reset se cambia squadra
            });
          },
        ),
        const SizedBox(height: 15),
        if (squadraSelezionata != null)
          DropdownButtonFormField<Giocatore>(
            decoration: const InputDecoration(
              labelText: "Giocatore da ricevere",
              border: OutlineInputBorder(),
            ),
            initialValue: giocatoreTargetSelezionato,
            items: DatabaseService.listaCompleta
                .where((g) => g.squadra == squadraSelezionata)
                .map(
                  (g) => DropdownMenuItem(
                    value: g,
                    child: Text("${g.ruolo} - ${g.nome}"),
                  ),
                )
                .toList(),
            onChanged: (val) =>
                setState(() => giocatoreTargetSelezionato = val),
          ),
      ],
    );
  }

  Widget _buildCreditiSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _tuoiCreditiController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: "Tu offri (FM)",
              prefixIcon: Icon(Icons.remove_circle_outline, color: Colors.red),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: _suoiCreditiController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: "Lui offre (FM)",
              prefixIcon: Icon(Icons.add_circle_outline, color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        onPressed: _isDataValid() ? _confermaEseguiScambio : null,
        child: const Text(
          "ESEGUI SCAMBIO",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
