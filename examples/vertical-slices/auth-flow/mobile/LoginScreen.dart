// Mobile - Flutter LoginScreen
// This is how mobile initiates the auth flow

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      // HTTP request to gateway (NOT directly to service)
      // Gateway routes to identity-service
      final response = await http.post(
        Uri.parse('https://api.kinnectai.com/api/v1/login'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Version': '1',
          'X-Device-ID': 'mobile-app',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = data['user']['id'];

        // Store token securely
        // TODO: use flutter_secure_storage
        
        // Navigate to authenticated flow
        Navigator.of(context).pushReplacementNamed('/feed', 
          arguments: {'userId': userId, 'token': token}
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: Text(isLoading ? 'Logging in...' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
