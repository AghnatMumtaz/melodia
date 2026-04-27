import 'package:flutter/material.dart';
import 'detail_page.dart'; 
import 'profile.dart'; // IMPORT KE PROFILE SUDAH DITAMBAHKAN

// 1. MODEL DATA
class Instrument {
  final String name, img, origin, type, playMode;
  final double angle, topPos, rightPos, imgHeight;

  Instrument({
    required this.name,
    required this.img,
    required this.origin,
    required this.type,
    required this.playMode,
    required this.angle,
    required this.topPos,
    required this.rightPos,
    required this.imgHeight,
  });
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Color doremiYellow = const Color(0xFFFFD93D);
  final Color doremiBrown = const Color(0xFF4D4112);
  int _currentIndex = 1;

  // 2. MASTER DATA
  final List<Instrument> _allInstruments = [
    Instrument(
      name: "Acoustic Guitar",
      img: "assets/images/gitarakustik.png",
      origin: "Spain",
      type: "String Instrument",
      playMode: "Plucked / Strummed",
      angle: 0.8, topPos: -55, rightPos: -85, imgHeight: 450,
    ),
    Instrument(
      name: "Saxophone",
      img: "assets/images/saxophone.png",
      origin: "Belgium",
      type: "Woodwind",
      playMode: "Blown",
      angle: -0.3, topPos: 10, rightPos: -40, imgHeight: 400,
    ),
  ];

  // 3. FILTERED DATA
  List<Instrument> _foundInstruments = [];

  @override
  void initState() {
    super.initState();
    _foundInstruments = _allInstruments; 
  }

  // 4. LOGIC SEARCH
  void _runFilter(String enteredKeyword) {
    List<Instrument> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allInstruments;
    } else {
      results = _allInstruments
          .where((instrument) =>
              instrument.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundInstruments = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      backgroundColor: doremiYellow,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildFigmaHeader(),
                const SizedBox(height: 15),
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildFilters(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: _foundInstruments.isNotEmpty 
                      ? ListView.builder( 
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _foundInstruments.length,
                          itemBuilder: (context, index) {
                            final data = _foundInstruments[index];
                            return _buildInstrumentCard(context, data);
                          },
                        )
                      : _buildNoResult(), 
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: _buildBottomNavbar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 42,
        child: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
            hintText: "Type here to search",
            hintStyle: TextStyle(color: doremiBrown.withOpacity(0.4), fontSize: 13),
            suffixIcon: Icon(Icons.search, color: doremiBrown, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: doremiBrown, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: doremiBrown, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstrumentCard(BuildContext context, Instrument data) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(right: 20, top: 40),
      decoration: BoxDecoration(color: doremiBrown, borderRadius: BorderRadius.circular(40)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: data.topPos,
            right: data.rightPos,
            child: Transform.rotate(
              angle: data.angle,
              child: Image.asset(
                data.img, 
                height: data.imgHeight, 
                fit: BoxFit.contain, 
                errorBuilder: (c, e, s) => const Icon(Icons.music_note, size: 80, color: Colors.white10)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(data.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
                const SizedBox(height: 12),
                _infoRow(Icons.public, data.origin),
                _infoRow(Icons.music_note, data.type),
                _infoRow(Icons.keyboard, data.playMode),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            name: data.name,
                            maskotImg: "assets/images/maskotgitar.png", 
                            instrumentImg: data.img,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doremiYellow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0
                    ),
                    child: Text("Learn More", style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: doremiBrown.withOpacity(0.3)),
          const SizedBox(height: 10),
          Text("No instrument found", style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFigmaHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Expl", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: doremiBrown, letterSpacing: -1.0)),
            Image.asset("assets/images/oo.png", width: 35, height: 35, errorBuilder: (c, e, s) => Icon(Icons.remove_red_eye, size: 30, color: doremiBrown)),
            Text("re", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: doremiBrown, letterSpacing: -1.0)),
          ],
        ),
        Text("Instrument", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: doremiBrown, height: 0.8, letterSpacing: -1.0)),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 30),
        children: [
          _filterChip("All Type", isActive: true),
          _filterChip("Bowed"),
          _filterChip("Plucked"),
          Container(
            width: 34, margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: doremiBrown, width: 1.2)),
            child: Icon(Icons.tune, color: doremiBrown, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? doremiBrown : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: doremiBrown, width: 1.2),
      ),
      child: Text(label, style: TextStyle(color: isActive ? doremiYellow : doremiBrown, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildBottomNavbar() {
    return Center(
      child: Container(
        width: 320, height: 70,
        decoration: BoxDecoration(
          color: doremiBrown, borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navIcon(Icons.home_filled, 0),
            _navIcon(Icons.explore, 1),
            _navIcon(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  // LOGIKA NAVIGASI YANG DIPERBARUI
  Widget _navIcon(IconData icon, int idx) {
    bool isSelected = _currentIndex == idx;
    return GestureDetector(
      onTap: () {
        if (idx == _currentIndex) return;

        if (idx == 0) {
          // Kembali ke Home
          setState(() => _currentIndex = 0);
          Future.delayed(const Duration(milliseconds: 150), () => Navigator.pop(context));
        } 
        else if (idx == 2) {
          // Pindah ke Profile
          setState(() => _currentIndex = 2);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? doremiYellow : Colors.white.withOpacity(0.5), size: 28),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2, width: isSelected ? 18 : 0,
            decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))
      ]),
    );
  }
}