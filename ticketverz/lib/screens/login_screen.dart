import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ticketverz/widgets/my_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // API Base URL
  final String baseUrl = 'https://api.ticketverz.com/api';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  bool showPassword = false;
  bool isLoading = false;
  String selectedRole = 'Organizer';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final Color navbarColor = const Color.fromARGB(255, 8, 5, 61);

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future<void> onLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("Please fill all the fields");
      return;
    }

    final roleEndpoints = {
      'Organizer': '$baseUrl/auth/org/login',
      'Admin': '$baseUrl/admin/login',
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(roleEndpoints[selectedRole]!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save Admin Signature if provided
        if (response.headers.containsKey('set-cookie')) {
          final cookies = response.headers['set-cookie'];
          if (cookies != null) {
            final signature = RegExp(r'Admin-Signature=([^;]+)')
                .firstMatch(cookies)
                ?.group(1);
            if (signature != null) {
              await storage.write(key: 'Admin_Signature', value: signature);
              print('Admin-Signature saved: $signature');
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!")),
        );
        Navigator.pushNamed(context, '/qr_scanner');
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Login failed.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      _showError("Login failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final String? email = googleUser.email;
        final String? name = googleUser.displayName;

        print("Google User Name: $name");
        print("Google User Email: $email");

        Navigator.pushNamed(context, '/qr_scanner');
      }
    } catch (e) {
      _showError("Error during Google login: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String role,
    String? organizationName,
  }) async {
    final roleEndpoints = {
      'Organizer': '$baseUrl/auth/org/register',
      'Admin': '$baseUrl/admin/register',
    };

    try {
      Map<String, dynamic> body = {
        'username': username,
        'email': email,
        'password': password,
      };

      if (role == 'Organizer') {
        body['name'] = organizationName;
      } else {
        body['first_name'] = firstName;
        body['last_name'] = lastName;
      }

      final response = await http.post(
        Uri.parse(roleEndpoints[role]!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      _showError("Error during registration: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: navbarColor,
        title: Center(
          child: Image.asset(
            'assets/ticklogo_white.png',
            width: 200,
            height: 50,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login to Your Account',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: navbarColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Make your events visible by Ticketverse',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['Organizer', 'Admin'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                });
              },
              decoration: InputDecoration(
                hintText: 'Select Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: usernameController,
              hintText: "Username",
              obscureText: false,
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: !showPassword,
              suffixIcon: GestureDetector(
                onTap: togglePasswordVisibility,
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(navbarColor),
                  )
                : ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navbarColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _handleGoogleLogin,
              icon: ClipOval(
                child: Image.asset(
                  'assets/google.jpeg',
                  height: 20,
                  width: 20,
                ),
              ),
              label: Text(
                'Login with Google',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: navbarColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New User?', style: TextStyle(color: Colors.black)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: navbarColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

