import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  late FToast fToast;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> loginUser(String username, String password) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      "https://e-commerce-store.glitch.me/login",
    ); // Ganti jika perlu

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true) {
          final user = data['data']['user'];
          final token = data['data']['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', user['username']);
          await prefs.setString('token', token);

          showToast("Login berhasil");
          return Navigator.pop(context);
        } else {
          showToast("Login gagal: ${data['message'] ?? 'Data tidak valid'}");
        }
      } else {
        showToast("Terjadi kesalahan server: ${response.statusCode}");
      }
    } catch (e) {
      showToast("Terjadi kesalahan jaringan: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showToast(String message) {
    fToast.showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.blueAccent,
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: userController,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Back",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () {
                              final username = userController.text.trim();
                              final password = passController.text.trim();
                              if (username.isEmpty || password.isEmpty) {
                                showToast("Harap isi semua kolom");
                              } else {
                                loginUser(username, password);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
