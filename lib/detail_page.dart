import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class DetailPage extends StatefulWidget {
  final String name;
  final String maskotImg;
  final String instrumentImg;

  const DetailPage({
    super.key,
    required this.name,
    required this.maskotImg,
    required this.instrumentImg,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  final Color doremiYellow = const Color(0xFFFFD93D);
  final Color doremiBrown = const Color(0xFF4D4112);
  final Color doremiBg = const Color(0xFFFAF9F6);

  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _selectedNote = 'C';
  String _selectedSong = "Burung Kakatua";
  String _playingChord = ""; 
  bool _isPlayingSong = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlayingSong = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _playChord(String fileName, String chordName) async {
    if (fileName.isEmpty) return;
    setState(() => _playingChord = chordName);
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('audios/$fileName'));
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _playingChord = "");
    });
  }

  void _toggleSong() async {
    if (_isPlayingSong) {
      await _audioPlayer.pause();
      setState(() => _isPlayingSong = false);
    } else {
      String file = _selectedSong == "Burung Kakatua" ? "burungkakatua.mp3" : "puncakgunung.mp3";
      await _audioPlayer.play(AssetSource('audios/$file'));
      setState(() => _isPlayingSong = true);
    }
  }

  // --- MODIFIKASI OVERLAY DISINI ---
  void _showPartOverlay(String name) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header & Image Section (White)
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new, color: doremiBrown),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              color: doremiBrown,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Pastikan aset ini ada di folder assets/
                      Image.asset(
                        "assets/images/tuningpegs.png", 
                        height: 180, 
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                // Details Section (Yellow)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  color: doremiYellow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Function",
                        style: TextStyle(color: doremiBrown, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Adjust string tension to change pitch",
                        style: TextStyle(color: doremiBrown.withOpacity(0.9), fontSize: 16),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "How It Works",
                        style: TextStyle(color: doremiBrown, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildBulletPoint("Turning the peg tightens or loosens the string"),
                      _buildBulletPoint("Tighter string → higher pitch"),
                      _buildBulletPoint("Looser string → lower pitch"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(color: doremiBrown, fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: doremiBrown.withOpacity(0.9), fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: doremiBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: doremiBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: doremiBrown),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(widget.name, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold)),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Image.asset(widget.maskotImg, fit: BoxFit.contain),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(_buildCustomTabBar()),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(child: _buildAboutContent()),
            SingleChildScrollView(child: _buildSoundContent()),
            SingleChildScrollView(child: _buildExerciseContent()), 
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseContent() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Challenge",
            style: TextStyle(color: doremiBrown, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: doremiYellow,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: doremiYellow.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Guess the chord",
                  style: TextStyle(color: doremiBrown, fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _challengeInfo("2 min"),
                    _dotSeparator(),
                    _challengeInfo("Easy"),
                    _dotSeparator(),
                    _challengeInfo("10 Xp"),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doremiBrown,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Play",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildMinorChallenge("Speed Strumming", "5 min", "Hard", "50 Xp"),
        ],
      ),
    );
  }

  Widget _challengeInfo(String text) {
    return Text(text, style: TextStyle(color: doremiBrown.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600));
  }

  Widget _dotSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.circle, size: 4, color: doremiBrown.withOpacity(0.5)),
    );
  }

  Widget _buildMinorChallenge(String title, String time, String level, String xp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text("$time • $level", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Icon(Icons.play_circle_fill, color: doremiBrown, size: 40),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: BoxDecoration(color: doremiBg, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ]),
      child: TabBar(
        controller: _tabController,
        labelColor: doremiBrown,
        unselectedLabelColor: Colors.grey,
        indicatorColor: doremiBrown,
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [Tab(text: "About"), Tab(text: "Sound"), Tab(text: "Exercise")],
      ),
    );
  }

  Widget _buildSoundContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How's ${widget.name} Sound?", style: TextStyle(color: doremiBrown, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Select type and the chord to hear the sound", style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['C', 'D', 'E', 'F', 'G', 'A', 'B'].map((note) {
                bool isSelected = _selectedNote == note;
                return GestureDetector(
                  onTap: () => setState(() => _selectedNote = note),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? doremiBrown : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(note, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildFilterChip("By Family", true),
              const SizedBox(width: 8),
              _buildFilterChip("By Variation", false),
            ],
          ),
          const SizedBox(height: 10), 
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildChordCard(_selectedNote, "Mayor", "cmayor.mp3"),
              _buildChordCard("${_selectedNote}m", "Minor", "cminor.mpeg"),
              _buildChordCard("${_selectedNote}#", "Sharp", ""),
              _buildChordCard("${_selectedNote}b", "Flat", ""),
              _buildChordCard("${_selectedNote}7", "Seven", ""),
              _buildChordCard("${_selectedNote}dim", "Dim", ""), 
              _buildChordCard("${_selectedNote}aug", "Aug", ""), 
            ],
          ),
          const SizedBox(height: 25), 
          Text("Let's Listen!", style: TextStyle(color: doremiBrown, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSong,
                isExpanded: true,
                menuMaxHeight: 250,
                borderRadius: BorderRadius.circular(20),
                icon: Icon(Icons.keyboard_arrow_down, color: doremiBrown),
                style: TextStyle(color: doremiBrown, fontSize: 16, fontWeight: FontWeight.bold),
                items: ["Burung Kakatua", "Naik Ke Puncak Gunung"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSong = val!;
                    _audioPlayer.stop();
                    _isPlayingSong = false;
                    _position = Duration.zero;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(45)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleSong,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(_isPlayingSong ? Icons.pause_rounded : Icons.play_arrow_rounded, color: doremiBrown, size: 30),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${_formatDuration(_position)} / ${_formatDuration(_duration)}", 
                          style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(22, (i) => _VisualizerBar(isPlaying: _isPlayingSong, index: i)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? doremiBrown : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildChordCard(String title, String subtitle, String audio) {
    bool isPlaying = _playingChord == title;
    return GestureDetector(
      onTap: audio.isNotEmpty ? () => _playChord(audio, title) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isPlaying ? doremiBrown : doremiYellow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: isPlaying ? Colors.white : doremiBrown, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: isPlaying ? Colors.white70 : doremiBrown, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoBox(Icons.star, "Beginner"),
            _infoBox(Icons.music_note, "6-String"),
            _infoBox(Icons.queue_music, "Acoustic"),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          color: doremiYellow,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Know More About\n${widget.name}", style: TextStyle(color: doremiBrown, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 20),
              Text(
                "The guitar is a string instrument that originated from ancient instruments like the oud and lute in the Middle East.\n\nIt developed into its modern form in Spain around the 18th century.",
                style: TextStyle(color: doremiBrown.withOpacity(0.8), fontSize: 14, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildStyledFunFact(),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Part of ${widget.name}", style: TextStyle(color: doremiBrown, fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Tap the blinking dots to learn more", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildInteractiveGuitar(),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStyledFunFact() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 65, 25, 30),
            decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(25)),
            child: Text("Did you know? rabbits can hear guitar music from far away", textAlign: TextAlign.center, style: TextStyle(color: doremiBrown, fontSize: 17, height: 1.5)),
          ),
          Positioned(
            top: -28, left: 20,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                color: Colors.black,
                child: const Text("Fun Fact!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveGuitar() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: "hero_${widget.name}",
            child: RotatedBox(
              quarterTurns: 5,
              child: Image.asset(widget.instrumentImg, height: 500, fit: BoxFit.contain),
            ),
          ),
          // MODIFIKASI: Parameter partName disesuaikan
          _blinkDot(top: 50, left: 185, partName: "Tuning Pegs"),
        ],
      ),
    );
  }

  Widget _infoBox(IconData icon, String label) {
    return Container(
      width: 100, padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: doremiYellow, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [Icon(icon, color: doremiBrown), const SizedBox(height: 8), Text(label, style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }

  // MODIFIKASI: blinkDot hanya butuh name
  Widget _blinkDot({required double top, required double left, required String partName}) {
    return Positioned(top: top, left: left, child: GestureDetector(onTap: () => _showPartOverlay(partName), child: const _BlinkingCircle()));
  }
}

// --- DELEGATE & ANIMATION CLASSES ---

class _VisualizerBar extends StatefulWidget {
  final bool isPlaying;
  final int index;
  const _VisualizerBar({required this.isPlaying, required this.index});
  @override State<_VisualizerBar> createState() => _VisualizerBarState();
}
class _VisualizerBarState extends State<_VisualizerBar> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<double> _a;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: 250 + (widget.index * 60)));
    _a = Tween<double>(begin: 4, end: 22).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    if (widget.isPlaying) _c.repeat(reverse: true);
  }
  @override void didUpdateWidget(old) { super.didUpdateWidget(old); widget.isPlaying ? _c.repeat(reverse: true) : _c.stop(); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(context) => AnimatedBuilder(animation: _a, builder: (c, w) => Container(width: 4, height: widget.isPlaying ? _a.value : 4, decoration: BoxDecoration(color: const Color(0xFF4D4112), borderRadius: BorderRadius.circular(2))));
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final Widget _tabBar;
  @override double get minExtent => 50; @override double get maxExtent => 50;
  @override Widget build(c, o, ov) => Material(elevation: 0, child: _tabBar);
  @override bool shouldRebuild(old) => false;
}

class _BlinkingCircle extends StatefulWidget {
  const _BlinkingCircle();
  @override State<_BlinkingCircle> createState() => _BlinkingCircleState();
}
class _BlinkingCircleState extends State<_BlinkingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(context) => FadeTransition(opacity: _c, child: Container(width: 20, height: 20, decoration: BoxDecoration(color: const Color(0xFFFFD93D), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)])));
}