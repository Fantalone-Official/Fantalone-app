class LegaMatch {
  final int giornata; // Da 1 a 38
  final String idCasa;
  final String idTrasferta;
  int? golCasa;
  int? golTrasferta;

  LegaMatch({
    required this.giornata,
    required this.idCasa,
    required this.idTrasferta,
    this.golCasa,
    this.golTrasferta,
  });
}
