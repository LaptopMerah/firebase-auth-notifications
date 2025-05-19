import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  final Color darkGreen = const Color(0xFF537D5D);
  final Color mediumGreen = const Color(0xFF73946B);
  final Color lightGreen = const Color(0xFF9EBC8A);
  final Color beige = const Color(0xFFD2D0A0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        title: const Text('USER PROFILE', style: TextStyle(color: Colors.white, letterSpacing: 2,),),
        centerTitle: true,
        backgroundColor: darkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_rounded,
                size: 130,
                color: darkGreen,
              ),
              const SizedBox(height: 20),
              if (user != null)
                Text(
                  "${user.email}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                )
              else
                Text(
                  "No user logged in.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: mediumGreen,
                  ),
                ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: darkGreen.withOpacity(0.5),
                  ),
                  child: const Text("LOGOUT", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
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
