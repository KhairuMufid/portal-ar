# kooka

A new Flutter project.

## Getting Started

# 🎭 Kooka - Portal Mainan Ajaib untuk Anak-Anak

Kooka adalah aplikasi Flutter yang dirancang sebagai portal AR (Augmented Reality) yang ceria dan magis untuk anak-anak, di mana mereka bisa mengunduh dan memainkan konten AR yang terhubung dengan buku fisik.

## ✨ Fitur Utama

### 🏠 Beranda (Katalog Mainan Ajaib)
- Grid visual yang menampilkan semua koleksi AR
- Status download yang jelas (ikon awan, progress bar, dan tombol play)
- Interface yang ceria dan mudah dipahami anak-anak

### 🧸 Koleksiku (Kotak Mainan Pribadi)
- Area khusus untuk konten AR yang sudah diunduh
- Akses cepat ke permainan favorit tanpa distraksi
- Filter untuk favorit dan konten terbaru

### ⚙️ Pengaturan (Area Orang Tua)
- Kontrol musik dan efek suara
- "Parent Gate" untuk melindungi pembelian yang tidak disengaja
- Tombol "Beli Buku" dengan verifikasi matematika sederhana

### 🌟 AR Viewer (Pintu Ajaib)
- Placeholder untuk integrasi Unity AR
- Kontrol sederhana untuk screenshot dan reset
- Tombol kembali yang jelas untuk navigasi mudah

## 🎨 Desain & Nuansa

### Neumorphism Ramah Anak
- Tombol dan kartu terlihat seperti mainan plastik empuk
- Efek shadow yang lembut dan natural
- Animasi yang responsif dan menyenangkan

### Palet Warna
- **Primer**: Oranye cerah (#F57C13) sebagai identitas utama
- **Sekunder**: Biru langit dan hijau daun untuk suasana hidup
- **Background**: Gradasi lembut dengan nuansa putih dan biru muda

### Tipografi
- Font **Nunito** dari Google Fonts
- Karakter bulat dan mudah dibaca untuk anak-anak
- Hierarki yang jelas untuk berbagai ukuran teks

## 🚀 Teknologi

### Flutter Framework
- **Provider** untuk state management yang efisien
- **SharedPreferences** untuk penyimpanan pengaturan lokal
- **Google Fonts** untuk tipografi konsisten

### Struktur Arsitektur
```
lib/
├── core/
│   ├── constants/     # Konstanta warna, ukuran, dan konfigurasi
│   └── theme/         # Tema aplikasi dan helper neumorphism
├── features/
│   ├── home/          # Halaman beranda dengan katalog AR
│   ├── collection/    # Halaman koleksi pribadi
│   ├── settings/      # Pengaturan dan parent gate
│   └── ar_viewer/     # Placeholder untuk Unity AR
└── shared/
    ├── models/        # Model data (ARContent)
    ├── providers/     # State management providers
    └── widgets/       # Widget reusable (NeumorphicButton, ARContentCard)
```

## 📱 Cara Menjalankan

### Prasyarat
- Flutter SDK (versi 3.7.2 atau lebih baru)
- Dart SDK
- Android Studio atau VS Code dengan extension Flutter

### Langkah Instalasi
1. Clone repository ini
2. Buka terminal di folder proyek
3. Jalankan `flutter pub get` untuk menginstall dependencies
4. Jalankan `flutter run` untuk menjalankan aplikasi

### Build APK
```bash
flutter build apk --release
```

## 🎯 Fitur Keamanan Anak

### Parent Gate
- Soal matematika sederhana untuk verifikasi orang tua
- Mencegah pembelian atau akses yang tidak disengaja
- Randomisasi pertanyaan untuk keamanan ekstra

### Orientasi Terkunci
- Aplikasi hanya berjalan dalam mode portrait
- Mencegah kebingungan navigasi pada anak-anak

### UI/UX Ramah Anak
- Tombol besar dan mudah ditekan
- Visual yang jelas dan tidak membingungkan
- Feedback animasi yang responsif

## 🔮 Roadmap Pengembangan

### Fase 1: Foundation (✅ Selesai)
- [x] Struktur aplikasi dasar
- [x] Desain neumorphism
- [x] Navigation dengan bottom tab
- [x] State management dengan Provider
- [x] Parent gate implementation

### Fase 2: Integrasi AR (🔄 Dalam Perencanaan)
- [ ] Integrasi Unity sebagai plugin
- [ ] Kamera AR untuk deteksi buku
- [ ] 3D object rendering dan interaksi
- [ ] Sistem tracking dan anchoring

### Fase 3: Content Management (🔄 Dalam Perencanaan)
- [ ] API backend untuk download konten
- [ ] Sistem caching dan storage
- [ ] Update otomatis konten baru
- [ ] Analytics dan tracking penggunaan

### Fase 4: Enhancement (🔄 Dalam Perencanaan)
- [ ] Multiplayer AR sessions
- [ ] Voice command integration
- [ ] Parental dashboard
- [ ] Educational progress tracking

## 🤝 Kontribusi

Kami menyambut kontribusi dari komunitas! Silakan:

1. Fork repository ini
2. Buat branch feature baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail lengkap.

## 👨‍💻 Tim Pengembang

- **Lead Developer**: 
- **UI/UX Designer**: 
- **AR Specialist**: 


**Dibuat dengan ❤️ untuk menciptakan pengalaman magical AR bagi anak-anak di seluruh dunia** 🌍✨
