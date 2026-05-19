class Giocatore {
  final String id;
  final String nome;
  final String squadra;
  final String ruolo;
  final int quotazione;
  double? voto; // Popolato dall'API dopo la partita
  int? prezzoAcquisto;

  // DATI LIVE
  double? votoBase;      // Il voto del giornalista (es. 6.5)
  double? fantaVoto;     // Voto + Bonus/Malus (es. 9.5 se ha segnato)
  String? eventoLive;    // "Gol", "Ammonizione", "Rigore Parato"
  int? titolarita;       // Percentuale di probabilità di giocare (es. 80%)
  String? infoSalute;    // "Infortunato", "Squalificato", "Disponibile"

  Giocatore({
    required this.id,
    required this.nome,
    required this.squadra,
    required this.ruolo,
    required this.quotazione,
    this.prezzoAcquisto,
    this.votoBase,
    this.fantaVoto,
    this.eventoLive,
    this.titolarita = 100,
    this.infoSalute = "Disponibile",
  });

  factory Giocatore.fromCsv(List<dynamic> row) {
    return Giocatore(
      id: row[0].toString(),
      nome: row[1].toString(),
      squadra: row[2].toString(),
      ruolo: row[3].toString(),
      quotazione: int.parse(row[4].toString()),
    );
  }

  Giocatore copyWith({
    String? id,
    String? nome,
    String? squadra,
    String? ruolo,
    int? quotazione,
    double? voto,
    int? prezzo,
    double? votoBaseNew,
    double? fantaVotoNew,
    String? eventoLiveNew,
    int? titolaritaNew,
    String? infoSaluteNew,
  }) {
    return Giocatore(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      squadra: squadra ?? this.squadra,
      ruolo: ruolo ?? this.ruolo,
      quotazione: quotazione ?? this.quotazione,
      prezzoAcquisto: prezzo ?? prezzoAcquisto,
      votoBase: votoBaseNew ?? votoBase,
      fantaVoto: fantaVotoNew ?? fantaVoto,
      eventoLive: eventoLiveNew ?? eventoLive,
      titolarita: titolaritaNew ?? titolarita,
      infoSalute: infoSaluteNew ?? infoSalute,
    );
  }
}