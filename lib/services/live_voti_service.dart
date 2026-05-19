import 'dart:convert';
import 'package:http/http.dart' as http;

class LiveVotiService {
  static const String apiKey = "e617733a81cda00742b86936cb5e8147";

  // Recupera i voti live di una specifica partita di Serie A
  static Future<Map<String, double>> recuperaVotiMatch(int fixtureId) async {
    final response = await http.get(
      Uri.parse(
        "https://v3.football.api-sports.io/fixtures/players?fixture=$fixtureId",
      ),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host': 'v3.football.api-sports.io',
      },
    );

    Map<String, double> votiEstratti = {};

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var team in data['response']) {
        for (var playerEntry in team['players']) {
          String nome = playerEntry['player']['name'];
          // Il rating dell'API è una stringa (es: "7.5"), lo convertiamo in numero
          double voto =
              double.tryParse(
                playerEntry['statistics'][0]['games']['rating'] ?? "6.0",
              ) ??
              6.0;
          votiEstratti[nome] = voto;
        }
      }
    }
    return votiEstratti;
  }
}
