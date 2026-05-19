import 'package:flutter/material.dart';
import 'dashboard_lega.dart'; // Colleghiamo la dashboard

class HomepageLega extends StatelessWidget {
  const HomepageLega({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bentornato", style: TextStyle(fontSize: 18, color: Colors.grey)),
              const Text("\"Nome utente\"", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              
              const Text("Le tue leghe:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              
              // IL RIQUADRO DELLA TUA LEGA (Cliccabile)
              ElevatedButton(
                onPressed: () {
                  // Questo comando fa cambiare pagina!
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardLega()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Lega 1", style: TextStyle(fontSize: 18)),
                          Text("Posizione: 1°", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Text("Scarsenal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              const Text("Altre leghe:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              
              // I DUE TASTI SOTTO
              Row(
                children: [
                  Expanded(
                    child: _buildSmallButton("Crea nuova\nLega."),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildSmallButton("Ricerca\nLega esistente"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(String testo) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(testo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}