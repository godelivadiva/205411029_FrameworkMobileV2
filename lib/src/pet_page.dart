import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

/* Class Pet befungsi untuk mendefinisikan property dari masing-masing pet yang
didalamnya menampung name, gender, age, dan imageUrl */
class Pet {
  final String name;
  final String gender;
  final double age;
  final String imageUrl;

  Pet({required this.name, required this.gender, required this.age, required this.imageUrl});
}

/* PetListScreen widget menampilkan list dari pets dengan menggunakan
ListView.builder wdiget. */
class PetListScreen extends StatelessWidget {
  // fungsi untuk melakukan permintaan HTTP ke REST API dan mendapatkan responsenya:
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://63afb929649c73f572c113ad.mockapi.io/api/v1/cat_adoption_list'));
    if (response.statusCode == 200) {
      // Konversi response JSON menjadi List<dynamic>
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal menampilkan data!');
    }
  }
  /* Define sebuah array untuk menampung nama, gender, umur, dan link dari
  masing-masing pets yang akan ditambilkan ke dalam variabel pets. Untuk
  menyimpan source dari gambar, menggunakan variabel imageUrl */
  final List<Pet> pets = [
    Pet(name: 'Acle', gender: 'Jantan', age: 4, imageUrl: 'assets/images/acle.jpg'),
    Pet(name: 'Joko', gender: 'Jantan', age: 1.5, imageUrl: 'assets/images/joko.jpg'),
    Pet(name: 'Gato', gender: 'Betina', age: 3, imageUrl: 'assets/images/gato.jpg'),
    Pet(name: 'Mao', gender: 'Betina', age: 3, imageUrl: 'assets/images/mao.jpg'),
    Pet(name: 'Neko', gender: 'Jantan', age: 3, imageUrl: 'assets/images/neko.jpg'),
    Pet(name: 'Pytho', gender: 'Betina', age: 4, imageUrl: 'assets/images/pytho.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet List'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          /* Card dan ListTile widgets digunakan untuk membuat kartu for each pet
          di dalam array.*/
          return Card(
            child: ListTile(
              /* CircleAvatar class untuk menampilkan image ke dalam Card
              dengan backgroundImage property dengan value AssetImage karena
              akan mengambil dari folder assets */
              leading: CircleAvatar(
                backgroundImage: AssetImage(pets[index].imageUrl),
              ),
              /* Text widget untuk menampilkan nama, gender, dan umur di dalam
              card */
              title: Text(pets[index].name),
              subtitle: Text('${pets[index].gender} - ${pets[index].age} tahun'),
              onTap: () {
                String pet_name = pets[index].name;
                // menampilkan text dengan snackbar saat klik each ListTile
                ScaffoldMessenger.of(context).showSnackBar( // method for display SnackBar
                  SnackBar(
                    content: Text('Kamu memilih $pet_name !'), // text yang ditampilkan
                    duration: Duration(milliseconds: 500), // durasi menampilkan text
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}