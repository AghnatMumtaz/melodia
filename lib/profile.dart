import 'package:flutter/material.dart';
import 'list_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Warna Tema (Samakan dengan HomePage kamu)
  final Color doremiYellow = const Color(0xFFFFD93D);
  final Color doremiBrown = const Color(0xFF4D4112);
  final Color doremiBg = const Color(0xFFFAF9F6);

  final int _currentIndex = 2; // Index untuk Profile

  bool soundEffects = true;
  bool music = true;
  bool notifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: doremiBg,
      body: Stack(
        children: [
          // KONTEN UTAMA
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildSimpleHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      _sectionTitle("My Badges"),
                      const SizedBox(height: 15),
                      _buildBadgesRow(),
                      const SizedBox(height: 40),
                      _sectionTitle("Settings"),
                      const SizedBox(height: 15),
                      _buildSettingsBox(),
                      const SizedBox(height: 150), // Ruang agar tidak tertutup Navbar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // NAVBAR MELAYANG
          _buildFloatingNavbar(),
        ],
      ),
    );
  }

  // --- HEADER ---
  Widget _buildSimpleHeader() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        color: doremiYellow,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Frame Foto Profil
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: doremiBrown.withOpacity(0.1),
              backgroundImage: const AssetImage('assets/images/avatar1.png'),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Mumtaz",
            style: TextStyle(color: doremiBrown, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            "Young Musician",
            style: TextStyle(color: doremiBrown.withOpacity(0.7), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // --- BADGES ---
  Widget _buildBadgesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _badgeItem("assets/images/nobadge_First Note.png", "First Note"),
        _badgeItem("assets/images/nobadge_Explorer.png", "Explorer"),
        _badgeItem("", "Locked", isLocked: true),
      ],
    );
  }

  Widget _badgeItem(String imgPath, String label, {bool isLocked = false}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          isLocked 
            ? Icon(Icons.lock_outline, size: 40, color: Colors.grey[300])
            : Image.asset(imgPath, height: 40, errorBuilder: (c, e, s) => Icon(Icons.stars, color: doremiYellow)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : doremiBrown)),
        ],
      ),
    );
  }

  // --- SETTINGS ---
  Widget _buildSettingsBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          _settingTile(Icons.volume_up, "Sound Effects", soundEffects, (v) => setState(() => soundEffects = v)),
          _settingTile(Icons.music_note, "Music", music, (v) => setState(() => music = v)),
          _settingTile(Icons.notifications, "Notifications", notifications, (v) => setState(() => notifications = v)),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, bool val, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: doremiBrown),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: doremiBrown)),
      trailing: Switch(
        value: val,
        onChanged: onChanged,
        activeColor: doremiYellow,
        activeTrackColor: doremiBrown,
      ),
    );
  }

  // --- NAVBAR ---
  Widget _buildFloatingNavbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 110,
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          width: 320,
          height: 70,
          decoration: BoxDecoration(
            color: doremiBrown,
            borderRadius: BorderRadius.circular(35),
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
      ),
    );
  }

  Widget _navIcon(IconData icon, int idx) {
    bool isSelected = _currentIndex == idx;
    return GestureDetector(
      onTap: () {
        if (idx == 0) {
          // Balik ke Home (Sangat Aman)
          Navigator.pop(context);
        } else if (idx == 1) {
          // Pindah ke Explore
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ListPage()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? doremiYellow : Colors.white.withOpacity(0.5), size: 28),
          const SizedBox(height: 4),
          if (isSelected)
            Container(height: 2, width: 18, decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: TextStyle(color: doremiBrown, fontSize: 22, fontWeight: FontWeight.bold));
}