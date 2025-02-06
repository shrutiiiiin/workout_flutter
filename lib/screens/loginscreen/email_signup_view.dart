import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmailSignupView extends StatefulWidget {
  const EmailSignupView({super.key});

  @override
  State<EmailSignupView> createState() => _EmailSignupViewState();
}

class _EmailSignupViewState extends State<EmailSignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create an account',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Join us and start your fitness journey with Pump&Pulse',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        Controller: _nameController,
                        iconData: Icons.person,
                        isPassword: false,
                        hintText: 'Enter your name',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _buildTextField(
                        Controller: _nameController,
                        iconData: Icons.person,
                        isPassword: false,
                        hintText: 'Enter your name',
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class _buildTextField extends StatelessWidget {
  final TextEditingController Controller;
  final IconData iconData;
  bool isPassword;
  String hintText;

  _buildTextField(
      {super.key,
      required this.Controller,
      required this.iconData,
      required this.isPassword,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      controller: Controller,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            iconData,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Color(0xFF333333),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return ' Please $hintText';
        }
      },
    );
  }
}
