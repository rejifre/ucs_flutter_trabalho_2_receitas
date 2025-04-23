import 'package:flutter/material.dart';

import '../routes/routes.dart';
import '../ui/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 32.0,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 64),
                      Text(
                        "App Receitas",
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      },
                      child: Text("Entrar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
