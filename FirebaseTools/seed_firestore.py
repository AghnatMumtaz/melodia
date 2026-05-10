import firebase_admin
from firebase_admin import credentials, firestore
import datetime

# --- Inisialisasi Firebase Admin SDK ---
# Pastikan Anda telah mengunduh file kunci akun layanan (service account key)
# dari konsol Firebase Anda dan menyimpannya di direktori yang sama dengan script ini.
# Ganti 'path/to/your/serviceAccountKey.json' dengan jalur yang benar ke file Anda.
try:
    cred = credentials.Certificate("pemob2026-firebase-adminsdk-fbsvc-73da881810.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("Firebase Admin SDK berhasil diinisialisasi.")
except Exception as e:
    print(f"Error saat menginisialisasi Firebase Admin SDK: {e}")
    print("Pastikan file 'pemob2026-firebase-adminsdk-fbsvc-73da881810.json' ada dan jalurnya benar.")
    exit()

# --- Fungsi Pembantu untuk URL Firebase Storage (Dihapus) ---
# Karena kita tidak menggunakan Firebase Storage, fungsi ini tidak lagi diperlukan.

# PROJECT_ID tidak lagi diperlukan karena kita menggunakan jalur aset lokal.

# --- Data Dummy untuk Setiap Koleksi ---

# 1. Koleksi: users
users_data = [
    {
        "uid": "user1_uid_example",
        "name": "Budi Santoso",
        "age": 28,
        "rank_title": "Young Musician",
        "pict_path": "assets/images/profile_pictures/budi_santoso.png", # DIUBAH ke jalur aset lokal
        "stats": {
            "explore": 150,
            "pitch": 85,
            "accuracy": 92,
            "lessons_done": 10
        },
        "settings": {
            "sound": True,
            "music": True,
            "notif": False
        },
        "last_played": "inst001"
    },
    {
        "uid": "user2_uid_example",
        "name": "Siti Aminah",
        "age": 22,
        "rank_title": "Rookie Virtuoso",
        "pict_path": "assets/images/profile_pictures/siti_aminah.png", # DIUBAH ke jalur aset lokal
        "stats": {
            "explore": 80,
            "pitch": 70,
            "accuracy": 88,
            "lessons_done": 5
        },
        "settings": {
            "sound": False,
            "music": True,
            "notif": True
        },
        "last_played": "inst002"
    }
]

# 2. Koleksi: instruments (dengan sub-koleksi chapters dan pages)
instruments_data = [
    {
        "inst_id": "inst001",
        "name": "Gitar Akustik",
        "origin": "Spanyol",
        "type": "Senar",
        "play_style": "Memetik",
        "thumbnail_path": "assets/images/instrument_thumbnails/gitar_akustik.png", # DIUBAH ke jalur aset lokal
        "chapters": [
            {
                "chap_id": "chap1",
                "title": "Dasar-Dasar Gitar",
                "order": 1,
                "thumbnail_path": "assets/images/chapter_thumbnails/gitar_dasar.png", # DIUBAH ke jalur aset lokal
                "pages": [
                    {
                        "page_id": "page1_1",
                        "header": "Anatomi Gitar",
                        "chap_id": "chap1",
                        "content": "Pelajari bagian-bagian dasar gitar dan fungsinya.",
                        "media_path": "assets/media/page_media/gitar_anatomi.mp4" # DIUBAH ke jalur aset lokal
                    },
                    {
                        "page_id": "page1_2",
                        "header": "Memegang Gitar",
                        "chap_id": "chap1",
                        "content": "Posisi yang benar saat memegang gitar untuk kenyamanan dan suara yang baik.",
                        "media_path": "assets/media/page_media/memegang_gitar.mp4" # DIUBAH ke jalur aset lokal
                    }
                ]
            },
            {
                "chap_id": "chap2",
                "title": "Kunci Dasar",
                "order": 2,
                "thumbnail_path": "assets/images/chapter_thumbnails/kunci_dasar_gitar.png", # DIUBAH ke jalur aset lokal
                "pages": [
                    {
                        "page_id": "page2_1",
                        "header": "Kunci G Mayor",
                        "chap_id": "chap2",
                        "content": "Cara membentuk kunci G mayor dan latihan transisi.",
                        "media_path": "assets/media/page_media/g_mayor.mp4" # DIUBAH ke jalur aset lokal
                    }
                ]
            }
        ]
    },
    {
        "inst_id": "inst002",
        "name": "Piano Digital",
        "origin": "Jerman",
        "type": "Papan Nada",
        "play_style": "Menekan",
        "thumbnail_path": "assets/images/instrument_thumbnails/piano_digital.png", # DIUBAH ke jalur aset lokal
        "chapters": [
            {
                "chap_id": "chap3",
                "title": "Pengenalan Piano",
                "order": 1,
                "thumbnail_path": "assets/images/chapter_thumbnails/piano_pengenalan.png", # DIUBAH ke jalur aset lokal
                "pages": [
                    {
                        "page_id": "page3_1",
                        "header": "Tata Letak Tombol",
                        "chap_id": "chap3",
                        "content": "Memahami tata letak tuts putih dan hitam di piano.",
                        "media_path": "assets/media/page_media/piano_tuts.mp4" # DIUBAH ke jalur aset lokal
                    }
                ]
            }
        ]
    }
]

# 3. Koleksi: chords
chords_data = [
    {
        "chord_id": "chord_g_major_gitar",
        "chord_image_path": "assets/images/chord_diagrams/g_major_diagram.png", # DIUBAH ke jalur aset lokal
        "inst_id": "inst001",
        "chord_name": "G Mayor",
        "sample_audio_path": "assets/audio/chord_samples/g_major_sample.mp3" # DIUBAH ke jalur aset lokal
    },
    {
        "chord_id": "chord_c_major_gitar",
        "chord_image_path": "assets/images/chord_diagrams/c_major_diagram.png", # DIUBAH ke jalur aset lokal
        "inst_id": "inst001",
        "chord_name": "C Mayor",
        "sample_audio_path": "assets/audio/chord_samples/c_major_sample.mp3" # DIUBAH ke jalur aset lokal
    }
]

# 4. Koleksi: songs
songs_data = [
    {
        "song_id": "song001",
        "song_audio_path": "assets/audio/songs/twinkle_twinkle.mp3", # DIUBAH ke jalur aset lokal
        "inst_id": "inst001",
        "title": "Twinkle Twinkle Little Star"
    },
    {
        "song_id": "song002",
        "song_audio_path": "assets/audio/songs/ode_to_joy.mp3", # DIUBAH ke jalur aset lokal
        "inst_id": "inst002",
        "title": "Ode to Joy"
    }
]

# 5. Koleksi: badges
badges_data = [
    {
        "badge_id": "badge001",
        "title": "First Strum",
        "badge_icon_path": "assets/images/badge_icons/first_strum.png", # DIUBAH ke jalur aset lokal
        "earned_by": 100,
        "desc": "Selesaikan pelajaran pertama Anda."
    },
    {
        "badge_id": "badge002",
        "title": "Chord Master",
        "badge_icon_path": "assets/images/badge_icons/chord_master.png", # DIUBAH ke jalur aset lokal
        "earned_by": 50,
        "desc": "Kuasai 5 kunci dasar."
    }
]

# 6. Koleksi: user_progress (tidak ada perubahan pada bagian ini)
user_progress_data = [
    {
        "uid": "user1_uid_example",
        "inst_id": "inst001",
        "completed_chaps": ["chap1"],
        "total_progress": 25
    },
    {
        "uid": "user2_uid_example",
        "inst_id": "inst002",
        "completed_chaps": [],
        "total_progress": 0
    }
]

# 7. Koleksi: user_badges (tidak ada perubahan pada bagian ini)
user_badges_data = [
    {
        "uid": "user1_uid_example",
        "badge_id": "badge001",
        "earned_at": datetime.datetime.now()
    }
]

# --- Fungsi untuk Melakukan Seeding ---
def seed_firestore():
    print("\nMemulai seeding data ke Cloud Firestore...")

    # Seeding users
    for user in users_data:
        doc_ref = db.collection("users").document(user["uid"])
        doc_ref.set(user)
        print(f"Ditambahkan user: {user['name']}")

    # Seeding instruments dan sub-koleksinya
    for instrument in instruments_data:
        inst_id = instrument["inst_id"]
        chapters_to_seed = instrument.pop("chapters", []) # Hapus sub-koleksi dari objek utama agar tidak disimpan di dokumen utama instrument
        
        inst_doc_ref = db.collection("instruments").document(inst_id)
        inst_doc_ref.set(instrument)
        print(f"Ditambahkan instrument: {instrument['name']}")

        # Seeding chapters
        for chapter in chapters_to_seed:
            chap_id = chapter["chap_id"]
            pages_to_seed = chapter.pop("pages", []) # Hapus sub-koleksi dari objek utama agar tidak disimpan di dokumen utama chapter
            
            chap_doc_ref = inst_doc_ref.collection("chapters").document(chap_id)
            chap_doc_ref.set(chapter)
            print(f"  Ditambahkan chapter untuk {instrument['name']}: {chapter['title']}")

            # Seeding pages
            for page in pages_to_seed:
                page_id = page["page_id"]
                page_doc_ref = chap_doc_ref.collection("pages").document(page_id)
                page_doc_ref.set(page)
                print(f"    Ditambahkan page untuk {chapter['title']}: {page['header']}")

    # Seeding chords
    for chord in chords_data:
        doc_ref = db.collection("chords").document(chord["chord_id"])
        doc_ref.set(chord)
        print(f"Ditambahkan chord: {chord['chord_name']}")

    # Seeding songs
    for song in songs_data:
        doc_ref = db.collection("songs").document(song["song_id"])
        doc_ref.set(song)
        print(f"Ditambahkan song: {song['title']}")

    # Seeding badges
    for badge in badges_data:
        doc_ref = db.collection("badges").document(badge["badge_id"])
        doc_ref.set(badge)
        print(f"Ditambahkan badge: {badge['title']}")

    # Seeding user_progress
    for progress in user_progress_data:
        doc_id = f"{progress['uid']}_{progress['inst_id']}"
        doc_ref = db.collection("user_progress").document(doc_id)
        doc_ref.set(progress)
        print(f"Ditambahkan user_progress untuk {progress['uid']} di {progress['inst_id']}")

    # Seeding user_badges
    for user_badge in user_badges_data:
        doc_id = f"{user_badge['uid']}_{user_badge['badge_id']}"
        doc_ref = db.collection("user_badges").document(doc_id)
        doc_ref.set(user_badge)
        print(f"Ditambahkan user_badge untuk {user_badge['uid']} - {user_badge['badge_id']}")

    print("\nSeeding data selesai.")

# Jalankan fungsi seeding
if __name__ == "__main__":
    seed_firestore()
