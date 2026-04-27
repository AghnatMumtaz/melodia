import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'list_page.dart';
import 'detail_page.dart'; 
import 'profile.dart'; // Memastikan file profile diimport

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Palette Warna
  final Color doremiYellow = const Color(0xFFFFD93D);
  final Color doremiBrown = const Color(0xFF4D4112);
  final Color doremiBg = const Color(0xFFFAF9F6);

  // --- LOGIKA NAVIGASI ---

  void _navigateToExplore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListPage()),
    ).then((_) {
      setState(() => _currentIndex = 0); // Reset icon ke home saat kembali
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      // Pastikan nama class di profile.dart adalah ProfilePage
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    ).then((_) {
      setState(() => _currentIndex = 0); // Reset icon ke home saat kembali
    });
  }

  void _navigateToDetail(String name, String instrumentImg) {
    String maskotPath = "assets/images/maskot2.png"; 
    if (name.contains("Guitar")) {
      maskotPath = "assets/images/maskotgitar.png";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          name: name,
          instrumentImg: instrumentImg,
          maskotImg: maskotPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: doremiBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFigmaHeader(),
                const SizedBox(height: 30),
                _buildStatsSection(),
                const SizedBox(height: 30),
                _buildMenuCard(
                  title: "Explore Instrument",
                  subtitle: "Looks... i found music here",
                  image: "assets/images/maskot2.png",
                  buttonText: "Explore More",
                  onTap: _navigateToExplore,
                ),
                const SizedBox(height: 20),
                _buildMenuCard(
                  title: "Guess Instrument",
                  subtitle: "Help me to find the\ncorrect instrument",
                  image: "assets/images/maskot3.png",
                  buttonText: "Let's Guess",
                  onTap: () {}, // Tambahkan navigasi game jika ada
                ),
                const SizedBox(height: 40),
                _sectionTitle("Continue Playing"),
                const SizedBox(height: 15),
                _buildContinueSection(),
                const SizedBox(height: 40),
                _sectionTitle("Popular Instruments"),
                const SizedBox(height: 15),
                _buildPopularSection(),
              ],
            ),
          ),
          _buildBottomNavbar(),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildContinueSection() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        children: [
          _continueCard("Acoustic Guitar", "assets/images/gitarakustik.png", 0.4, isGuitar: true),
          _continueCard("Saxophone", "assets/images/saxophone.png", 0.7),
        ],
      ),
    );
  }

  Widget _continueCard(String title, String img, double progress, {bool isGuitar = false}) {
    return GestureDetector(
      onTap: () => _navigateToDetail(title, img),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(40)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 20)),
                const Text("Beginner  •  30 mins", style: TextStyle(fontSize: 12, color: Colors.black54)),
                const Spacer(),
                _progressBar(progress),
              ],
            ),
            Positioned(
              right: -15, top: -15,
              child: Hero(
                tag: title,
                child: Transform.rotate(
                  angle: isGuitar ? math.pi / 4 : 0,
                  child: Image.asset(img, height: 130, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.music_note, size: 70)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(child: _popularCard("Acoustic Guitar", "assets/images/gitarakustik.png", "#1", 27, isGuitar: true)),
          const SizedBox(width: 15),
          Expanded(child: _popularCard("Saxophone", "assets/images/saxophone.png", "#2", 21)),
        ],
      ),
    );
  }

  Widget _popularCard(String name, String img, String rank, int plays, {bool isGuitar = false}) {
    return GestureDetector(
      onTap: () => _navigateToDetail(name, img),
      child: Container(
        height: 280,
        decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(35)),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 45,
              child: Icon(Icons.star, size: 160, color: doremiBrown.withOpacity(0.15)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(8)),
                      child: Text(rank, style: TextStyle(color: doremiYellow, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Hero(
                        tag: name,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Transform.rotate(
                            angle: isGuitar ? math.pi / 4 : 0,
                            child: Image.asset(img, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.music_video, size: 70)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(name, textAlign: TextAlign.center, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity, height: 30,
                    decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text("$plays plays this week", style: TextStyle(color: doremiYellow, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFigmaHeader() {
    return Container(
      height: 320, width: double.infinity,
      decoration: BoxDecoration(color: doremiYellow, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: HeaderPainter(doremiBrown))),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset("assets/images/logo.png", width: 130, errorBuilder: (c, e, s) => const Icon(Icons.music_note, size: 40)),
              const SizedBox(height: 30),
              Text("Welcome back,", style: TextStyle(color: doremiBrown, fontSize: 18)),
              Text("Mumtaz", style: TextStyle(color: doremiBrown, fontSize: 45, fontWeight: FontWeight.bold, height: 1.0)),
              const SizedBox(height: 10),
              Text("Ready to play some music today?", style: TextStyle(color: doremiBrown.withOpacity(0.8), fontSize: 14)),
            ]),
          ),
          Positioned(right: -10, bottom: -5, child: Image.asset("assets/images/maskot.png", width: 250, errorBuilder: (c, e, s) => const Icon(Icons.face, size: 100))),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _statCircle("Explore", "12%"),
      _statCircle("Pitch", "7%"),
      _statCircle("Accuracy", "85%"),
    ]);
  }

  Widget _statCircle(String label, String val) {
    return Container(
      width: 95, height: 95,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: doremiYellow, width: 6)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildMenuCard({required String title, required String subtitle, required String image, required String buttonText, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25), height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(35)),
            padding: const EdgeInsets.only(left: 140, right: 20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 12),
              _miniButton(buttonText, onTap),
            ]),
          ),
          Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 100, decoration: BoxDecoration(color: doremiBrown, borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), bottomLeft: Radius.circular(35))))),
          Positioned(left: -10, top: -30, bottom: -10, child: Image.asset(image, width: 140, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.headphones, size: 80))),
        ],
      ),
    );
  }

  // --- BOTTOM NAVBAR DENGAN NAVIGASI KE PROFILE ---
  Widget _buildBottomNavbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 110, width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))]
        ),
        child: Center(
          child: Container(
            width: 320, height: 70,
            decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(35)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                _navIcon(Icons.home_filled, 0), 
                _navIcon(Icons.explore, 1), 
                _navIcon(Icons.person, 2)
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int idx) {
    bool isSelected = _currentIndex == idx;
    return GestureDetector(
      onTap: () {
        if (idx == _currentIndex && idx == 0) return; // Sudah di Home

        if (idx == 1) {
          setState(() => _currentIndex = 1);
          Future.delayed(const Duration(milliseconds: 150), _navigateToExplore);
        } else if (idx == 2) {
          setState(() => _currentIndex = 2);
          Future.delayed(const Duration(milliseconds: 150), _navigateToProfile);
        } else {
          setState(() => _currentIndex = 0);
        }
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: isSelected ? doremiYellow : Colors.white.withOpacity(0.5), size: 28),
        const SizedBox(height: 4),
        AnimatedContainer(duration: const Duration(milliseconds: 200), height: 2, width: isSelected ? 18 : 0, decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(2))),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Text(t, style: TextStyle(color: doremiBrown, fontSize: 24, fontWeight: FontWeight.bold)));
  Widget _progressBar(double p) => Stack(children: [Container(height: 12, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(10))), FractionallySizedBox(widthFactor: p, child: Container(height: 12, decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(10))))]);
  Widget _miniButton(String txt, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(txt, style: TextStyle(color: doremiYellow, fontWeight: FontWeight.bold, fontSize: 12)), const SizedBox(width: 5), Icon(Icons.arrow_forward_ios, size: 10, color: doremiYellow)])));
}

class HeaderPainter extends CustomPainter {
  final Color color;
  HeaderPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();
    path.moveTo(size.width, size.height);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.5, size.width, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}