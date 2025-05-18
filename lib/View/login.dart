import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), // Light minty background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Sign In/Up
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/images/icon.png'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00796B),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xFF00796B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Welcome Back Text
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Cursive', 
                  color: Colors.teal,
                ),
              ),
              const Text(
                'Back,',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Cursive',
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),

              // Email Input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Input
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),

              const SizedBox(height: 40),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Forgot Password
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
