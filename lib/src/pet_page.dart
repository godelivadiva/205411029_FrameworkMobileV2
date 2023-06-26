import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

Future<List<Pets>> fetchPets() async {
  final response = await http
      .get(Uri.parse('https://63afb929649c73f572c113ad.mockapi.io/api/v1/cat_adoption_list'));
      // .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Pets> pets = jsonData.map((data) => Pets.fromJson(data)).toList();
    return pets;
  } else {
    throw Exception('Gagal menampilkan data!');
  }
}

class Pets {
  // final int userId;
  // final int id;
  final String title;
  // final String name;
  // final String gender;
  // final double age;
  // final String imageUrl;

  const Pets({
    // required this.userId,
    // required this.id,
    required this.title,
    // required this.name,
    // required this.gender,
    // required this.age,
    // required this.imageUrl,
  });

  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
      // userId: json['userId'],
      // id: json['id'],
      title: json['name'],
      // name: json['name'],
      // gender: json['gender'],
      // age: json['age'],
      // imageUrl: json['imageUrl'],

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
                        title: Text(pet.title),
                        // subtitle: Text('${pet.userId} tahun'),
                        onTap: () {
                          String petTitle = pet.title;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kamu memilih album "$petTitle"'),
                              )
                          );
                        },
                    ),
                  );
                },
              );
              // return Card(
              //     child: ListTile(
              //       leading: CircleAvatar(
              //         // backgroundImage: AssetImage(pet['imageUrl']),
              //       ),
              //       title: Text(snapshot.data!.title),
              //       subtitle: Text('${snapshot.data!.userId} tahun'),
              //       onTap: () {
              //         String petName = snapshot.data!.title;
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: Text('Kamu memilih $petName !'),
              //             duration: Duration(milliseconds: 500),
              //           ),
              //         );
              //       },
              //     ),
              // );
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