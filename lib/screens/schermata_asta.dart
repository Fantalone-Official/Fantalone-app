import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:math';
import '../models/giocatore.dart';
import '../services/stato_lega.dart';
import '../services/budget_service.dart';

// --- MODELLO LOGICA BOT ---
class BotAsta {
  final String nome;
  final double aggressivita;
  int budget;
  Map<String, int> rosa;

  BotAsta({
    required this.nome,
    required this.aggressivita,
    this.budget = 500,
    required this.rosa,
  });

  bool vuoleRilanciare(
    String ruolo,
    int quotazioneBase,
    int prezzoAttuale,
    Map<String, int> limiti,
  ) {
    if ((rosa[ruolo] ?? 0) >= (limiti[ruolo] ?? 0)) return false;
    if (budget <= prezzoAttuale) return false;

    // Il bot smette di rilanciare se il prezzo supera la quotazione * la sua aggressività
    double limiteMassimo = quotazioneBase * aggressivita;
    return prezzoAttuale < limiteMassimo;
  }
}

class SchermataAsta extends StatefulWidget {
  const SchermataAsta({super.key});

  @override
  State<SchermataAsta> createState() => _AstaScreenState();
}

class _AstaScreenState extends State<SchermataAsta> {
  // Configurazione Asta
  final Map<String, int> limitiRuolo = {'P': 3, 'D': 8, 'C': 8, 'A': 6};
  List<Map<String, dynamic>> calciatori = [];

  // Lista dei Bot con la loro logica
  List<BotAsta> bots = [
    BotAsta(
      nome: 'Aggressivo',
      aggressivita: 2.6,
      rosa: {'P': 0, 'D': 0, 'C': 0, 'A': 0},
    ),
    BotAsta(
      nome: 'Moderato',
      aggressivita: 1.8,
      rosa: {'P': 0, 'D': 0, 'C': 0, 'A': 0},
    ),
    BotAsta(
      nome: 'Sparagnino',
      aggressivita: 1.3,
      rosa: {'P': 0, 'D': 0, 'C': 0, 'A': 0},
    ),
  ];

  // Stato dell'asta corrente
  Map<String, dynamic>? _calciatoreInAsta;
  int _prezzoAttuale = 0;
  String _ultimoOfferente = "Nessuno";

  Timer? _timer;
  int _secondi = 30;
  bool _faseChiamata = true;

  @override
  void initState() {
    super.initState();
    leggiFile();
    _avviaTimerLogica();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- CARICAMENTO DATI ---
  Future<void> leggiFile() async {
    try {
      final stringaGrezza = await rootBundle.loadString(
        'assets/calciatori.csv',
      );
      List<String> righe = stringaGrezza.split('\n');
      setState(() {
        calciatori = righe
            .where((r) => r.trim().isNotEmpty)
            .map((r) {
              var col = r.split(',');
              return col.length >= 4
                  ? {
                      'nome': col[0].trim(),
                      'ruolo': col[1].trim().toUpperCase(),
                      'squadra': col[2].trim(),
                      'quotazione': int.tryParse(col[3].trim()) ?? 1,
                      'comprato': false,
                    }
                  : null;
            })
            .whereType<Map<String, dynamic>>()
            .toList();
      });
    } catch (e) {
      debugPrint("Errore caricamento CSV: $e");
    }
  }

  // --- LOGICA ASTA ---
  void _avviaTimerLogica() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondi > 0) {
        setState(() => _secondi--);
      } else {
        _faseChiamata ? _chiamaCasuale() : _concludiAsta();
      }
    });
  }

  void _chiamaCasuale() {
    var disponibili = calciatori.where((c) => !c['comprato']).toList();
    if (disponibili.isNotEmpty) {
      _iniziaAstaCalciatore(disponibili[Random().nextInt(disponibili.length)]);
    }
  }

  void _iniziaAstaCalciatore(Map<String, dynamic> c) {
    setState(() {
      _faseChiamata = false;
      _calciatoreInAsta = c;
      _prezzoAttuale = c['quotazione'];
      _ultimoOfferente = "Base";
      _secondi = 10;
    });
    _faiPensareIBot();
  }

  void _faiPensareIBot() {
    if (_faseChiamata || _calciatoreInAsta == null) return;

    Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)), () {
      if (!mounted || _faseChiamata) return;

      for (var bot in bots) {
        if (_ultimoOfferente != bot.nome &&
            bot.vuoleRilanciare(
              _calciatoreInAsta!['ruolo'],
              _calciatoreInAsta!['quotazione'],
              _prezzoAttuale,
              limitiRuolo,
            )) {
          _eseguiRilancio(bot.nome);
          return;
        }
      }
    });
  }

  void _eseguiRilancio(String chi) {
    setState(() {
      _prezzoAttuale++;
      _ultimoOfferente = chi;
      _secondi = 10;
    });
    _faiPensareIBot();
  }

  void _concludiAsta() {
    if (_calciatoreInAsta == null) return;

    final vincitore = _ultimoOfferente;
    final prezzo = _prezzoAttuale;
    final nomeAtleta = _calciatoreInAsta!['nome'];

    if (vincitore == "Tu") {
      // Trasforma la mappa in oggetto Giocatore e salva
      Giocatore g = Giocatore(
        id: nomeAtleta,
        nome: nomeAtleta,
        squadra: _calciatoreInAsta!['squadra'],
        ruolo: _calciatoreInAsta!['ruolo'],
        quotazione: _calciatoreInAsta!['quotazione'],
      );
      StatoLega.aggiungiGiocatore(g, prezzo);
      BudgetService.sottrai(prezzo);
    } else if (vincitore != "Base" && vincitore != "Nessuno") {
      // Aggiorna budget e rosa del bot vincitore
      var botVincitore = bots.firstWhere((b) => b.nome == vincitore);
      botVincitore.budget -= prezzo;
      botVincitore.rosa[_calciatoreInAsta!['ruolo']] =
          (botVincitore.rosa[_calciatoreInAsta!['ruolo']] ?? 0) + 1;
    }

    setState(() {
      _calciatoreInAsta!['comprato'] = true;
      _calciatoreInAsta = null;
      _faseChiamata = true;
      _secondi = 30;
      _ultimoOfferente = "Nessuno";
    });
    _avviaTimerLogica();
  }

  // --- INTERFACCIA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("ASTA LIVE"),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text("Budget: ${BudgetService.budgetRimanente} FM"),
            ),
          ),
        ],
      ),
      body: _faseChiamata ? _buildAttesaChiamata() : _buildAstaAttiva(),
    );
  }

  Widget _buildAttesaChiamata() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          Text(
            "Prossima chiamata tra: $_secondi s",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _chiamaCasuale,
            child: const Text("CHIAMA ORA"),
          ),
        ],
      ),
    );
  }

  Widget _buildAstaAttiva() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    _calciatoreInAsta!['nome'],
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${_calciatoreInAsta!['ruolo']} - ${_calciatoreInAsta!['squadra']}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Divider(height: 40),
                  Text(
                    "$_prezzoAttuale",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    "OFFERTA DI: $_ultimoOfferente",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            "$_secondi",
            style: TextStyle(
              fontSize: 50,
              color: _secondi < 4 ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _ultimoOfferente == "Tu"
                  ? null
                  : () => _eseguiRilancio("Tu"),
              child: const Text(
                "RILANCIA +1 FM",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
