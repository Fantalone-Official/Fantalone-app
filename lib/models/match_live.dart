class MatchLive {
  final String casa;
  final String trasferta;
  final String punteggio;
  final String info;
  final bool isSerieA;

  MatchLive({
    required this.casa,
    required this.trasferta,
    required this.punteggio,
    required this.info,
    this.isSerieA = true,
  });
}
