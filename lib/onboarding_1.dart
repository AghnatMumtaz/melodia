import 'package:flutter/material.dart';
import 'setup_profile.dart'; // Arahkan ke halaman setup profile yang baru

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna yang konsisten dengan tema Doremi
    const Color doremiBrown = Color(0xFF4D4112);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header Asset
              Image.asset(
                'assets/images/asset1_onboarding1.png',
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              // Visual Asset Utama
              Center(
                child: Image.asset(
                  'assets/images/asset2_onboarding1.png',
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              // Tombol START yang dipindah ke tengah
              Center(
                child: SizedBox(
                  width: 220, // Ukuran lebar tombol yang proporsional
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doremiBrown,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: doremiBrown.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Text(
                      'START',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}