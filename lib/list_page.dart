import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF512DA8);

    final List<Map<String, dynamic>> instruments = [
      {"name": "Piano", "icon": "🎹", "baseColor": Colors.orange},
      {"name": "Gitar", "icon": "🎸", "baseColor": Colors.red},
      {"name": "Biola", "icon": "🎻", "baseColor": Colors.purple},
      {"name": "Drum", "icon": "🥁", "baseColor": Colors.blue},
      {"name": "Terompet", "icon": "🎺", "baseColor": Colors.yellow},
      {"name": "Suling", "icon": "🪈", "baseColor": Colors.green},
      {"name": "Harpa", "icon": "🪄", "baseColor": Colors.pink},
      {"name": "Marakas", "icon": "🪇", "baseColor": Colors.teal},
      {"name": "Simbal", "icon": "🔔", "baseColor": Colors.cyan},
      {"name": "Tamborin", "icon": "🪘", "baseColor": Colors.deepOrange},
      {"name": "Silo", "icon": "🎼", "baseColor": Colors.indigo},
      {"name": "Harmonika", "icon": "👄", "baseColor": Colors.lightGreen},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_awan.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 15), 

                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: 40,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: primaryPurple, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "Melodia",
                    style: TextStyle(
                        color: primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 22, 
                        letterSpacing: 1.2),
                  ),
                  centerTitle: true,
                ),

                const SizedBox(height: 10),

                Container(
  margin: const EdgeInsets.symmetric(horizontal: 20),
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.8), 
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white, 
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        offset: const Offset(0, 8),
      )
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kenali Alat Musik",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryPurple, 
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Ketuk untuk mempelajari alat musik!",
              style: TextStyle(
                fontSize: 13,
                color: primaryPurple.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB300).withValues(alpha: 0.2), 
          shape: BoxShape.circle,
        ),
        child: const Text("🤖", style: TextStyle(fontSize: 28)),
      ),
    ],
  ),
),

                const SizedBox(height: 15),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: instruments.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = instruments[index];
                      final Color baseColor = item['baseColor'];

                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(

                                color: baseColor.withValues(alpha: 0.3), 
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: baseColor.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(item['icon'],
                                    style: const TextStyle(fontSize: 35)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryPurple,
                                fontSize: 13),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.pinkAccent,
            unselectedItemColor: Colors.grey[400],
            currentIndex: 1, 
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
              BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: "Alat"),
              BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: "Kuis"),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
            ],
            onTap: (index) {
              if (index == 0) Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}