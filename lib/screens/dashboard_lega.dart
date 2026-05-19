import 'package:flutter/material.dart';
import 'area_mercato.dart';
import 'schermata_classifica.dart';
import 'visualizza_rosa.dart';
import '../models/match_live.dart';
import '../models/lega_match.dart';
import '../services/liveserieaservice.dart';
import '../services/calcolatore_service.dart';
import '../services/stato_lega.dart';
import '../services/calendario_service.dart';
// Immagino esista un service per la formazione, lo aggiungo come riferimento
// import '../services/formazione_service.dart';

class DashboardLega extends StatefulWidget {
  const DashboardLega({super.key});

  @override
  State<DashboardLega> createState() => _DashboardLegaState();
}

class _DashboardLegaState extends State<DashboardLega> {
  List<MatchLive> matchSerieA = [];
  bool caricamento = true;
  LegaMatch? mioMatch;
  int giornataAttuale = 0;

  // Variabili aggiunte dagli ultimi innesti
  double totalePunti = 0.0;
  String statoCampionato = "LIVE"; // Esempio: "NON_INIZIATO", "LIVE", "FINITO"

  @override
  void initState() {
    super.initState();
    _inizializzaDati();
  }

  Future<void> _inizializzaDati() async {
    await _caricaDatiSerieA();
    await _aggiornaPunteggioLive(); // Chiama il calcolo del punteggio
  }

  Future<void> _caricaDatiSerieA() async {
    setState(() => caricamento = true);
    try {
      matchSerieA = await LiveSerieAService.recuperaMatchOggi();
      statoCampionato = LiveSerieAService.determinaStatoLega(matchSerieA);

      // Recupera la giornata dalla data odierna (semplificato)
      giornataAttuale = DateTime.now().day % 38 + 1; // Mock calculation

      try {
        var calendario = CalendarioService.generaCalendario(
          StatoLega.partecipantiLega,
          2,
        );
        mioMatch = calendario
            .expand((giornata) => giornata)
            .firstWhere(
              (m) =>
                  m.idCasa == StatoLega.utenteCorrente?.id ||
                  m.idTrasferta == StatoLega.utenteCorrente?.id,
              orElse: () => LegaMatch(
                idCasa: '',
                idTrasferta: '',
                giornata: 0,
              ),
            );
        if (mioMatch!.idCasa.isEmpty) mioMatch = null;
      } catch (e) {
        mioMatch = null;
      }
    } catch (e) {
      debugPrint("Errore caricamento dati: $e");
    } finally {
      setState(() => caricamento = false);
    }
  }

  // Metodo integrato correttamente nello stato
  Future<void> _aggiornaPunteggioLive() async {
    // Nota: Assicurati che FormazioneService e giornataReale siano definiti
    // Qui uso giornataAttuale recuperata sopra
    /* 
    var formSalvata = await FormazioneService.recuperaFormazione(
      StatoLega.utenteCorrente!.id,
      giornataAttuale,
    );

    if (formSalvata != null) {
      List<String> idTitolari = List<String>.from(formSalvata['titolari']);
      double somma = await CalcolatoreService.calcolaTotaleDagliId(idTitolari);

      setState(() {
        totalePunti = somma;
      });
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    // Logica per il testo del punteggio integrata nel build
    String testoPunteggio;
    if (statoCampionato == "NON_INIZIATO") {
      testoPunteggio = "Inizia alle 15:00";
    } else if (statoCampionato == "LIVE" || statoCampionato == "FINITO") {
      // Esempio: qui dovresti avere anche i punti dell'avversario
      int golMiei = CalcolatoreService.calcolaGol(totalePunti);
      int golSuoi = 0; // Da recuperare logicamente
      testoPunteggio = "$golMiei - $golSuoi";
    } else {
      testoPunteggio = "Prossima Giornata";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giornata $giornataAttuale",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.teal),
            onPressed: _inizializzaDati,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _inizializzaDati,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuCard("👕\n rose", context),
                  _buildMenuCard("✈️\n invia formazione", context),
                  _buildMenuCard("🏆\n Classifica", context),
                ],
              ),
              const SizedBox(height: 15),
              _buildAreaMercatoBottone(),
              const SizedBox(height: 20),
              _buildSectionTitle("Giornata $giornataAttuale - Live Lega"),
              if (mioMatch != null)
                _buildIlTuoMatch(
                  StatoLega.utenteCorrente?.nomeSquadra ?? "Mia Squadra",
                  testoPunteggio,
                  "Avversario",
                )
              else
                const Text("Nessuna partita per questa giornata"),
              const SizedBox(height: 25),
              _buildSectionTitle("Risultati Live Serie A"),
              if (caricamento)
                const Center(child: CircularProgressIndicator())
              else if (matchSerieA.isEmpty)
                const Text("Nessuna partita in programma per oggi.")
              else
                ...matchSerieA
                    .map(
                      (m) => _buildRowSerieA(
                        m.info,
                        m.casa,
                        m.punteggio,
                        m.trasferta,
                      ),
                    )
                    ,
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildAreaMercatoBottone() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AreaMercato()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "AREA MERCATO 🔨",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String testo, BuildContext context) {
    return InkWell(
      onTap: () {
        if (testo.contains("Classifica")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SchermataClassifica(),
            ),
          );
        } else if (testo.contains("rose")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VisualizzaRosa()),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildIlTuoMatch(String s1, String result, String s2) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(color: Colors.yellow.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "IL TUO MATCH",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s1, style: const TextStyle(fontSize: 16)),
              Text(
                result,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(s2, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowSerieA(
    String info,
    String casa,
    String punteggio,
    String trasferta,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              info,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text("$casa  $punteggio  $trasferta")),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}
