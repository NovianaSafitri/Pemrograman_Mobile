import 'package:flutter/material.dart';
import 'dart:async';

// ====================================================================
// BAGIAN 1: MODEL DATA (Dosen & Mahasiswa)
// ====================================================================

class Dosen {
  final String nama;
  final String nidn;
  final String kepakaran;
  final String deskripsi;
  final Color warnaAvatar;
  final String email;
  final String fakultas;
  final String prodi;

  const Dosen({
    required this.nama,
    required this.nidn,
    required this.kepakaran,
    required this.deskripsi,
    required this.warnaAvatar,
    required this.email,
    required this.fakultas,
    required this.prodi,
  });
}

class Mahasiswa {
  final String nama;
  final String nim;
  final String jurusan;
  final String password;
  final String dosenNim; // <-- TAMBAHAN BARU: NIDN Dosen Pembimbing

  const Mahasiswa({
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.password,
    required this.dosenNim, // <-- TAMBAHAN BARU
  });
}

// Data Dummy Dosen
const List<Dosen> daftarDosenDummy = [
  Dosen(
    nama: "Dr. Budi Santoso, S.Kom, M.T.",
    nidn: "0012097001",
    kepakaran: "Artificial Intelligence & Machine Learning",
    deskripsi: "Pakar di bidang Kecerdasan Buatan dan telah banyak menerbitkan jurnal internasional.",
    warnaAvatar: Color(0xFF1F1E85),
    email: "budi.santoso@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Teknik Informatika",
  ),
  Dosen(
    nama: "Prof. Ani Mardiana, Ph.D.",
    nidn: "0015036802",
    kepakaran: "Software Engineering & Mobile Development",
    deskripsi: "Spesialisasi pada rekayasa perangkat lunak metodologi Agile dan pengembangan aplikasi mobile.",
    warnaAvatar: Color(0xFFB565A7),
    email: "ani.mardiana@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Teknik Informatika",
  ),
  Dosen(
    nama: "Ir. Cahyo Wibowo, M.Eng.",
    nidn: "0020017503",
    kepakaran: "Database Systems & Data Mining",
    deskripsi: "Fokus pada perancangan sistem database terdistribusi dan teknik penambangan data.",
    warnaAvatar: Color(0xFF00BFA5),
    email: "cahyo.wibowo@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Sistem Informasi",
  ),
  Dosen(
    nama: "Dr. Eka Fitriani, M.Kom.",
    nidn: "0025078104",
    kepakaran: "Cyber Security & Cryptography",
    deskripsi: "Ahli dalam keamanan jaringan, penetration testing, dan pengembangan algoritma kriptografi modern.",
    warnaAvatar: Color(0xFFE57373),
    email: "eka.fitriani@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Sistem Informasi",
  ),
  Dosen(
    nama: "Prof. Nina Zaskia, Ph.D.",
    nidn: "0001026013",
    kepakaran: "Quantum Computing & Parallel Processing",
    deskripsi: "Salah satu pionir dalam komputasi kuantum di Indonesia dan sistem pemrosesan paralel.",
    warnaAvatar: Color(0xFF4DB6AC),
    email: "nina.zaskia@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Matematika",
  ),
  Dosen(
    nama: "Dr. Rahmat Hidayat, M.Si.",
    nidn: "0001026014",
    kepakaran: "Aljabar Abstrak dan Geometri",
    deskripsi: "Peneliti aktif di bidang aljabar, khususnya teori grup dan modul.",
    warnaAvatar: Color(0xFF4DB6AC),
    email: "rahmat.hidayat@univ.ac.id",
    fakultas: "Sains & Teknologi",
    prodi: "Matematika",
  ),
  Dosen(
    nama: "Prof. Ahmad Rijal, Ph.D.",
    nidn: "0004076015",
    kepakaran: "Ekonomi Syariah",
    deskripsi: "Spesialisasi dalam keuangan mikro syariah dan perbankan Islam.",
    warnaAvatar: Color(0xFF8D6E63),
    email: "ahmad.rijal@univ.ac.id",
    fakultas: "Ekonomi & Bisnis Islam",
    prodi: "Ekonomi Syariah",
  ),
  Dosen(
    nama: "Dr. Farah Najwa, M.Ak.",
    nidn: "0005087016",
    kepakaran: "Akuntansi Syariah",
    deskripsi: "Konsultan dan auditor di bidang akuntansi lembaga keuangan syariah.",
    warnaAvatar: Color(0xFF795548),
    email: "farah.najwa@univ.ac.id",
    fakultas: "Ekonomi & Bisnis Islam",
    prodi: "Akuntansi Syariah",
  ),
  Dosen(
    nama: "Dr. Hanif Putra, S.E., M.M.",
    nidn: "0006098017",
    kepakaran: "Manajemen Bisnis Islam",
    deskripsi: "Fokus pada etika bisnis dan manajemen sumber daya insani berbasis syariah.",
    warnaAvatar: Color(0xFF5D4037),
    email: "hanif.putra@univ.ac.id",
    fakultas: "Ekonomi & Bisnis Islam",
    prodi: "Manajemen Syariah",
  ),
  Dosen(
    nama: "Dr. Siti Aminah, M.A.",
    nidn: "0003056014",
    kepakaran: "Sejarah Islam",
    deskripsi: "Pakar sejarah peradaban Islam dan filologi.",
    warnaAvatar: Color(0xFF757575),
    email: "siti.aminah@univ.ac.id",
    fakultas: "Adab & Humaniora",
    prodi: "Sejarah Peradaban Islam",
  ),
  Dosen(
    nama: "Prof. Gema Lisan, Ph.D.",
    nidn: "0004067018",
    kepakaran: "Linguistik Arab",
    deskripsi: "Ahli dalam morfologi dan sintaksis bahasa Arab klasik.",
    warnaAvatar: Color(0xFF424242),
    email: "gema.lisan@univ.ac.id",
    fakultas: "Adab & Humaniora",
    prodi: "Bahasa dan Sastra Arab",
  ),
  Dosen(
    nama: "Dr. Laila Fauziah, M.H.",
    nidn: "0009017016",
    kepakaran: "Hukum Keluarga Islam",
    deskripsi: "Fokus pada studi hukum keluarga kontemporer dan sengketa waris.",
    warnaAvatar: Color(0xFF6D4C41),
    email: "laila.fauziah@univ.ac.id",
    fakultas: "Syariah",
    prodi: "Hukum Keluarga",
  ),
  Dosen(
    nama: "Prof. Faisal Rasyid, Ph.D.",
    nidn: "0010028017",
    kepakaran: "Hukum Tata Negara",
    deskripsi: "Spesialisasi dalam konstitusi Islam dan perbandingan hukum.",
    warnaAvatar: Color(0xFF4E342E),
    email: "faisal.rasyid@univ.ac.id",
    fakultas: "Syariah",
    prodi: "Hukum Tata Negara Islam",
  ),
];

// Data Dummy Mahasiswa (HANYA UNTUK LOGIN SIMULASI)
const List<Mahasiswa> daftarMahasiswaDummy = [
  // AKUN SIMULASI UTAMA
  Mahasiswa(
    nama: "Noviana Safitri",
    nim: "701230017",
    jurusan: "Sistem Informasi",
    password: "12345678",
    dosenNim: "0020017503", // NIDN Ir. Cahyo Wibowo
  ),
  // AKUN LAIN
  Mahasiswa(
    nama: "Aulia Nur Kholisah",
    nim: "2022001",
    jurusan: "Teknik Informatika",
    password: "123",
    dosenNim: "0012097001", // NIDN Dr. Budi Santoso
  ),
];

// ====================================================================
// BAGIAN 2: TITIK MASUK APLIKASI (main)
// ====================================================================

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1F1E85);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Dosen App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
        ).copyWith(
          secondary: const Color(0xFFffc107),
          primary: primaryBlue,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          elevation: 3.0,
        ),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}

// ====================================================================
// BAGIAN 3: SPLASH SCREEN
// ====================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.school,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            const Text(
              'PROFIL DOSEN APP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// BAGIAN 4: LOGIN SCREEN
// ====================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _doLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String nim = _nimController.text;
      final String password = _passwordController.text;

      Mahasiswa? user;
      try {
        user = daftarMahasiswaDummy.firstWhere(
              (mhs) => mhs.nim == nim && mhs.password == password,
        );
      } catch (e) {
        user = null;
      }

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainContentScreen(mahasiswa: user!)),
        );
        _nimController.clear();
        _passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("NIM atau Password salah!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/gedung.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(0xE6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_pin,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Portal Mahasiswa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(0xE10),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(230),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nimController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'NIM',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Masukkan NIM Anda' : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Masukkan Password Anda' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _doLogin(context),
                      child: const Text('LOGIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// BAGIAN 5: MAIN CONTENT SCREEN (Halaman Setelah Login)
// ====================================================================

class MainContentScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const MainContentScreen({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portal Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person, color: Colors.white), text: "Profil Saya"),
              Tab(icon: Icon(Icons.group, color: Colors.white), text: "Daftar Dosen"),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            MahasiswaProfileScreen(mahasiswa: mahasiswa),
            const DaftarDosenScreen(),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// BAGIAN 6: PROFIL MAHASISWA SCREEN (DENGAN DOSEN PA)
// ====================================================================

class MahasiswaProfileScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const MahasiswaProfileScreen({super.key, required this.mahasiswa});

  // Modifikasi _buildInfoRow untuk menerima warna background
  Widget _buildInfoRow(BuildContext context, IconData icon, String title, String subtitle, Color backgroundColor) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cari Dosen Pembimbing berdasarkan NIDN di data Mahasiswa
    final Dosen? dosenPA = daftarDosenDummy.cast<Dosen?>().firstWhere(
          (d) => d?.nidn == mahasiswa.dosenNim,
      orElse: () => null,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                mahasiswa.nama[0],
                style: const TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              mahasiswa.nama,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "NIM: ${mahasiswa.nim}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            ),
          ),
          const Divider(height: 40, thickness: 1),

          // --- INFORMASI AKADEMIK ---
          Text("Informasi Akademik", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 10),
          _buildInfoRow(context, Icons.school, "Jurusan", mahasiswa.jurusan, Theme.of(context).colorScheme.primary.withAlpha(204)),
          const SizedBox(height: 15),
          _buildInfoRow(context, Icons.calendar_month, "Angkatan", mahasiswa.nim.substring(0, 4), Theme.of(context).colorScheme.secondary.withAlpha(178)),
          const SizedBox(height: 15),
          _buildInfoRow(context, Icons.info_outline, "Status", "Aktif", Theme.of(context).colorScheme.primary.withAlpha(0xE8)),
          const SizedBox(height: 30),

          // --- DOSEN PEMBIMBING AKADEMIK (FITUR BARU) ---
          Text("Dosen Pembimbing Akademik (PA)", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 10),

          if (dosenPA != null)
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: dosenPA.warnaAvatar,
                  child: Text(dosenPA.nama[0]),
                ),
                title: Text(dosenPA.nama, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                subtitle: Text("NIDN: ${dosenPA.nidn}\nProdi: ${dosenPA.prodi}"),
                isThreeLine: true,
                trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                onTap: () {
                  // Navigasi ke detail Dosen PA
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailDosenScreen(dosen: dosenPA)));
                },
              ),
            )
          else
            const Text("Informasi Dosen PA tidak ditemukan.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red)),

        ],
      ),
    );
  }
}

// ====================================================================
// BAGIAN 7: WIDGET REUSE (Dosen Card Item)
// ====================================================================

class DosenCardItem extends StatelessWidget {
  final Dosen dosen;

  const DosenCardItem({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailDosenScreen(dosen: dosen),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Hero(
                tag: 'avatar-${dosen.nidn}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: dosen.warnaAvatar,
                  child: Text(
                    dosen.nama[0],
                    style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dosen.nama,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dosen.kepakaran,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    Text(
                      '${dosen.prodi} (${dosen.fakultas})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// BAGIAN 8: SEARCH DELEGATE (Logika Pencarian)
// ====================================================================

class DosenSearchDelegate extends SearchDelegate<Dosen> {
  final List<Dosen> dosenList;

  DosenSearchDelegate(this.dosenList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, dosenList[0]);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = dosenList.where((dosen) =>
    dosen.nama.toLowerCase().contains(query.toLowerCase()) ||
        dosen.kepakaran.toLowerCase().contains(query.toLowerCase()) ||
        dosen.fakultas.toLowerCase().contains(query.toLowerCase()) ||
        dosen.prodi.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return DosenCardItem(dosen: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = dosenList.where((dosen) =>
    dosen.nama.toLowerCase().contains(query.toLowerCase()) ||
        dosen.kepakaran.toLowerCase().contains(query.toLowerCase()) ||
        dosen.fakultas.toLowerCase().contains(query.toLowerCase()) ||
        dosen.prodi.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final dosen = suggestions[index];
        return ListTile(
          leading: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          title: Text(dosen.nama),
          subtitle: Text('${dosen.kepakaran} (${dosen.fakultas})', style: const TextStyle(fontSize: 12)),
          onTap: () {
            query = dosen.nama;
            showResults(context);
          },
        );
      },
    );
  }
}

// ====================================================================
// BAGIAN 9: HALAMAN 1 - DAFTAR DOSEN (DENGAN FILTER FAKULTAS)
// ====================================================================

class DaftarDosenScreen extends StatefulWidget {
  const DaftarDosenScreen({super.key});

  @override
  State<DaftarDosenScreen> createState() => _DaftarDosenScreenState();
}

class _DaftarDosenScreenState extends State<DaftarDosenScreen> {

  final List<String> _fakultasList = [
    'Semua Fakultas',
    ...daftarDosenDummy.map((dosen) => dosen.fakultas).toSet(),
  ];

  String _selectedFakultas = 'Semua Fakultas';

  @override
  Widget build(BuildContext context) {

    final filteredDosen = daftarDosenDummy.where((dosen) {
      if (_selectedFakultas == 'Semua Fakultas') {
        return true;
      }
      return dosen.fakultas == _selectedFakultas;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Daftar Dosen Pengajar', style: TextStyle(fontWeight: FontWeight.bold)),
          floating: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DosenSearchDelegate(daftarDosenDummy),
                );
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedFakultas,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Filter Fakultas',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary.withAlpha(0x15),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                  ),
                ),
                items: _fakultasList.map((String fakultas) {
                  return DropdownMenuItem<String>(
                    value: fakultas,
                    child: Text(fakultas, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFakultas = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final dosen = filteredDosen[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DosenCardItem(dosen: dosen),
              );
            },
            childCount: filteredDosen.length,
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// BAGIAN 10: HALAMAN 2 - DETAIL DOSEN
// ====================================================================

class DetailDosenScreen extends StatelessWidget {
  final Dosen dosen;

  const DetailDosenScreen({super.key, required this.dosen});

  void _handleContact(BuildContext context, String action, String data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$action: $data")),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required String content, required IconData icon, required Color color}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Dosen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'avatar-${dosen.nidn}',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: dosen.warnaAvatar,
                child: Text(
                  dosen.nama[0],
                  style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Text(
              dosen.nama,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 5),

            Text(
              "NIDN: ${dosen.nidn}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),

            const Divider(height: 30, thickness: 1),

            // Informasi Fakultas dan Prodi
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: [
                Chip(
                  avatar: const Icon(Icons.apartment, size: 18),
                  label: Text(dosen.fakultas),
                  backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(0xE1),
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                ),
                Chip(
                  avatar: const Icon(Icons.assignment, size: 18),
                  label: Text(dosen.prodi),
                  backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(0xE1),
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const Divider(height: 30, thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.email, size: 18, color: Colors.white),
                  label: const Text('Email', style: TextStyle(color: Colors.white)),
                  onPressed: () => _handleContact(context, "Kirim Email", dosen.email),
                  backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(0xE8),
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: const Icon(Icons.phone, size: 18, color: Colors.white),
                  label: const Text('Telepon', style: TextStyle(color: Colors.white)),
                  onPressed: () => _handleContact(context, "Telepon", "Nomor Rahasia"),
                  backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(0xE8),
                ),
              ],
            ),

            const Divider(height: 30, thickness: 1),

            _buildDetailCard(
                context,
                title: 'Bidang Kepakaran',
                content: dosen.kepakaran,
                icon: Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary.withAlpha(0xE8)
            ),

            const SizedBox(height: 20),

            _buildDetailCard(
                context,
                title: 'Riwayat Singkat',
                content: dosen.deskripsi,
                icon: Icons.description_outlined,
                color: Theme.of(context).colorScheme.secondary.withAlpha(0xE8)
            ),
          ],
        ),
      ),
    );
  }
}