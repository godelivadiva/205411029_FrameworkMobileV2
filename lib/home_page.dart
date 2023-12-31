import 'package:coba/src/menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'app_state.dart';
import 'src/authentication.dart';
import 'src/menu_page.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tanggal sekarang menggunakan package intl (bawaan flutter)
    DateTime now = DateTime.now();
    // Format tanggal menjadi 'Bulan tanggal, tahun'
    String formattedDate = DateFormat('MMMM d, yyyy').format(now);

    // Mendapatkan lokasi saat ini dengan geolocator (sesuai GPS)
    // jangan lupa untuk menambahkan akses permission location pada android dan ios
    Future<Position> getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Memeriksa apakah layanan lokasi diaktifkan (GPS)
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Layanan GPS tidak aktif, tampilkan error
        return Future.error('Layanan lokasi tidak aktif');
      }

      // Memeriksa izin akses lokasi
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Izin akses lokasi ditolak, minta izin
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Izin akses lokasi tetap ditolak, tampilkan error
          return Future.error('Izin akses lokasi ditolak');
        }
      }

      // Mendapatkan posisi saat ini (GPS)
      return await Geolocator.getCurrentPosition();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care'),
        /* Merubah warna background Appbar dengan gradasi, menggunakan
        flexibleSpace dan BoxDecoration */
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.grey,
                Colors.blue,
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pet-background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconAndDetail(Icons.calendar_today, formattedDate),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconAndDetail(Icons.location_on_outlined, 'Current Location'),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: FutureBuilder<Position>(
              future: getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Mendapatkan lokasi saat ini dari snapshot
                  double? latitude = snapshot.data?.latitude;
                  double? longitude = snapshot.data?.longitude;

                  // Menampilkan lokasi saat ini
                  String latitudeText = 'Latitude: $latitude';
                  String longitudeText = 'Longitude: $longitude';
                  IconData icon = Icons.map;

                  return LocationDataWidget(
                    locationData: LocationData(icon, latitudeText, longitudeText),
                  );
                } else if (snapshot.hasError) {
                  // Menampilkan pesan kesalahan jika terjadi masalah dalam mendapatkan lokasi
                  return IconAndDetail(Icons.location_city, 'Error: ${snapshot.error}');
                } else {
                  // Menampilkan indikator loading saat mendapatkan lokasi
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 20 / 2, // Menempatkan widget di tengah vertikal
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Header("Welcome to Pet Care"),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Menu'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set warna teks pada button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                  ),
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => AuthenticationPage(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      },
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
