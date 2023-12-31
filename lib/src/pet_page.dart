import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// mendapatkan list dari pet yang di-parse dari API
Future<List<Pets>> fetchPets() async {
  final response = await http
      .get(Uri.parse('https://63afb929649c73f572c113ad.mockapi.io/api/v1/cat_adoption_list'));
  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Pets> pets = jsonData.map((data) => Pets.fromJson(data)).toList();
    return pets;
  } else {
    // error ketika API gagal dimuat
    throw Exception('Gagal menampilkan data!');
  }
}

// class definition untuk Pets
class Pets {
  final String name;
  final String gender;
  final String description;
  final int age;
  final String? imageUrl;

  const Pets({
    required this.name,
    required this.gender,
    required this.description,
    required this.age,
    required this.imageUrl,
  });

  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
      name: json['name'],
      gender: json['gender'],
      description: json['description'],
      age: json['age'],
      imageUrl: json['image_url'],

    );
  }
}

class PetListScreen extends StatefulWidget {
  const PetListScreen({Key? key}) : super(key: key);

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<Pets>> futurePets;

  @override
  void initState() {
    super.initState();
    futurePets = fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet List'),
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
      body: Center(
        child: FutureBuilder<List<Pets>>(
          future: futurePets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Pets> pets = snapshot.data!;
              return ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  Pets pet = pets[index];
                  return Card(
                      child: ListTile(
                        /* CircleAvatar class untuk menampilkan image ke dalam Card
                        dengan backgroundImage property dengan value NetworkImage karena
                        akan mengambil dari folder internet */
                        leading: pet.imageUrl != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(pet.imageUrl!),
                        )
                            : CircleAvatar(
                          backgroundImage: AssetImage('assets/images/placeholder_image.png'),
                        ),
                        /* Text widget untuk menampilkan detail pet di dalam card */
                        title: Text('${pet.name} - ${pet.age} tahun'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.gender),
                            Text(pet.description),
                          ],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kamu memilih "${pet.name}"'),
                              )
                          );
                        },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}