import 'package:coba/src/pet_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pet_page.dart';
import 'vaccines_page.dart';
import 'widgets.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              width: orientation == Orientation.portrait ? 300 : 500,
              height: orientation == Orientation.portrait ? 400 : 200,
              // Untuk scrollable list
              child: ListView(
                children: [
                  ListTile( // deklarasi item
                    leading: const Icon(Icons.pets),
                    title: const Text('Pets'),
                    onTap: () {
                      // Aksi ketika menu Pets di-tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PetListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.vaccines),
                    title: const Text('Vaccination'),
                    onTap: () {
                      // Aksi ketika menu Vaccination di-tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VaccinesScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      final User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        context.push('/profile');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomPopup(
                              title: 'Profile tidak ditemukan!',
                              message: 'Silakan Login terlebih dahulu.',
                              buttonText: 'OK',
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

