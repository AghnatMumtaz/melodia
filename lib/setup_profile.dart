import 'package:flutter/material.dart';
import 'home_page.dart'; 

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final Color doremiYellow = const Color(0xFFFFD93D);
  final Color doremiBrown = const Color(0xFF4D4112);
  final Color doremiBg = const Color(0xFFFAF9F6);
  
  final TextEditingController _nameController = TextEditingController();
  double _age = 17; 
  int _selectedAvatar = 0; 

  final List<String> _avatars = [
    'assets/images/avatar1.png', 'assets/images/avatar2.png', 'assets/images/avatar3.png',
    'assets/images/avatar4.png', 'assets/images/avatar5.png', 'assets/images/avatar6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: doremiBg,
      // Penting: true agar layar menyesuaikan saat keyboard muncul
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                const SizedBox(height: 10),
                Text(
                  "Create Your\nProfile", 
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.w900, 
                    color: doremiBrown, 
                    height: 1.1
                  )
                ),
                
                const SizedBox(height: 30),

                // --- AVATAR GRID ---
                const Text(
                  "Choose Your Avatar", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey)
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedAvatar == index;
                    bool hasImage = index < _avatars.length;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? doremiBrown : Colors.transparent, 
                            width: 3.5
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: hasImage 
                                ? Image.asset(
                                    _avatars[index],
                                    fit: BoxFit.contain,
                                    // Angka scale < 1.0 = Zoom In (Gambar makin besar)
                                    scale: 0.8, 
                                  )
                                : Icon(Icons.person, color: Colors.grey.shade300, size: 30),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // --- NICKNAME FIELD ---
                const Text(
                  "Nickname", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey)
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: doremiBrown, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Who are you?",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: doremiBrown, width: 2), 
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- AGE SLIDER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "How old are you?", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey)
                    ),
                    Text(
                      "${_age.toInt()} Years", 
                      style: TextStyle(color: doremiBrown, fontWeight: FontWeight.w900, fontSize: 18)
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    activeTrackColor: doremiYellow,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: doremiBrown,
                    overlayColor: doremiBrown.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _age,
                    min: 1,
                    max: 100,
                    onChanged: (value) => setState(() => _age = value),
                  ),
                ),

                // Jarak statis agar tidak tabrakan dengan tombol
                const SizedBox(height: 50),

                // --- BUTTON LETS GO ---
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doremiBrown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "LETS GO!", 
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontSize: 18, 
                        letterSpacing: 1.5
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}