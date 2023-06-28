import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'widgets.dart';

import 'package:http/http.dart' as http;

// mendapatkan list dari vaksin-vaksin yang di-parse dari API
Future<List<Vaccines>> fetchVaccines() async {
  final response = await http
      .get(Uri.parse('https://63afb929649c73f572c113ad.mockapi.io/api/v1/cat_vaccine'));
  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Vaccines> vaccines = jsonData.map((data) => Vaccines.fromJson(data)).toList();
    return vaccines;
  } else {
    // error ketika API gagal di muat
    throw Exception('Gagal menampilkan data!');
  }
}

// class definition untuk variabel yang akan ditampilkan pada widget
class Vaccines {
  final String level;
  final String name;
  final String age;
  final String description;

  const Vaccines({
    required this.level,
    required this.name,
    required this.age,
    required this.description,
  });

  factory Vaccines.fromJson(Map<String, dynamic> json) {
    return Vaccines(
      level: json['level'],
      name: json['name'],
      age: json['age'],
      description: json['description'],

    );
  }
}

class VaccinesScreen extends StatefulWidget {
  const VaccinesScreen({Key? key}) : super(key: key);

  @override
  State<VaccinesScreen> createState() => _VaccinesScreen();
}

class _VaccinesScreen extends State<VaccinesScreen> {
  late Future<List<Vaccines>> futureVaccines;

  @override
  void initState() {
    super.initState();
    futureVaccines = fetchVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination'),
        /* Merubah warna background Appbar dengan gradasi, menggunakan
        flexibleSpace dan BoxDecoration */
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.grey,
                    Colors.blue
                  ])
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Vaccines>>(
          future: futureVaccines,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Vaccines> vaccines = snapshot.data!;
              return ListView.builder(
                itemCount: vaccines.length,
                itemBuilder: (context, index) {
                  Vaccines vaccine = vaccines[index];
                  return Card(
                    child: ListTile(
                      //
                      title: VaccineDetailWidget(data: {
                        'level': vaccine.level,
                        'age': vaccine.age,
                        'name': vaccine.name,
                        'description': vaccine.description,
                      }),
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