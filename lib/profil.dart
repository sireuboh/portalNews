import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'formlogin.dart';
import 'formregist.dart';
import 'main.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  var content;
  late SharedPreferences prefs; // Gunakan late untuk deklarasi

  @override
  void initState() {
    super.initState();
    startLaunch(); // Memastikan data diproses saat halaman pertama kali dimuat
  }

  // Fungsi untuk memeriksa status login
  Future<void> startLaunch() async {
    prefs =
        await SharedPreferences.getInstance(); // Mengambil instance SharedPreferences
    var login = prefs.getString('login'); // Mengambil data login
    if (login != null) {
      setState(() {
        content = sudahLogin(login); // Menampilkan halaman sudah login
      });
    } else {
      setState(() {
        content = belumLogin(); // Menampilkan halaman belum login
      });
    }
  }

  // Fungsi untuk logout
  Future<void> logOut() async {
    print('logout');
    prefs =
        await SharedPreferences.getInstance(); // Pastikan instance prefs ada
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          prefs.remove("login"); // Menghapus data login dari SharedPreferences
          return MyApp(initialPage: 2); // Mengarahkan kembali ke halaman utama
        },
      ),
    );
  }

  // Tampilan jika pengguna belum login
  belumLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_circle, size: 150, color: Colors.blue),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Masuk', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Belum memiliki akun? '),
            GestureDetector(
              child: Text(
                'Create Account',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Tampilan jika pengguna sudah login
  sudahLogin(String username) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_circle, size: 150, color: Colors.blue),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 3),
          ),
          child: Text(
            username,
            style: TextStyle(fontSize: 20),
          ), // Menampilkan nama pengguna
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            logOut(); // Memanggil logOut() saat keluar
          },
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: content); // Menampilkan konten sesuai status login
  }
}
