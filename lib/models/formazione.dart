import 'giocatore.dart';

class FormazioneSchierata {
  final List<Giocatore> titolari;
  final List<Giocatore> panchina;
  final String modulo;

  FormazioneSchierata({
    required this.titolari,
    required this.panchina,
    required this.modulo,
  });
}
