import 'package:flutter/material.dart';
import 'list_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _tappedCardTitle;

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF512DA8);

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 40, 22, 10), 
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("✨", style: TextStyle(fontSize: 22)),
                      SizedBox(width: 10),
                      Text(
                        "Melodia",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("🎶", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  
                  const Spacer(flex: 1),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 85,
                          height: 85,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 18),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang! 👋",
                                style: TextStyle(
                                  color: primaryPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Yuk, mulai petualangan musikmu di Khayangan!",
                                style: TextStyle(
                                  color: primaryPurple,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  const Text(
                    "Pilih Aktivitasmu:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  
                  const SizedBox(height: 15),

                  Expanded(
                    flex: 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        _buildFixedMenuCard(
                          title: "Kenali Alat Musik",
                          subtitle: "Dengarkan suara ajaib!",
                          emoji: "🎹", 
                          color: const Color(0xFFFFE082),
                          textColor: primaryPurple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ListPage()),
                            );
                          },
                        ),
                        
                        _buildFixedMenuCard(
                          title: "Tebak Suaranya!",
                          subtitle: "Uji pendengaranmu",
                          emoji: "🎸", 
                          color: const Color(0xFFFF8A80),
                          textColor: primaryPurple,
                          onTap: () {
                          },
                        ),
                        
                        _buildFixedMenuCard(
                          title: "Mainkan Musik!",
                          subtitle: "Coba musik virtual",
                          emoji: "🎶", 
                          color: const Color(0xFFC5E1A5),
                          textColor: primaryPurple,
                          onTap: () {
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                ],
              ),
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
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
              BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: "Alat"),
              BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: "Kuis"),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedMenuCard({
    required String title,
    required String subtitle,
    required String emoji,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final isPressed = _tappedCardTitle == title;

    return GestureDetector(
      onTapDown: (_) => setState(() => _tappedCardTitle = title),
      onTapUp: (_) {
        setState(() => _tappedCardTitle = null);
        onTap();
      },
      onTapCancel: () => setState(() => _tappedCardTitle = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}