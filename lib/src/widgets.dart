import 'package:flutter/material.dart';

// Widget untuk styling pada header
class Header extends StatelessWidget {
  const Header(this.heading, {super.key});
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      heading,
      style: const TextStyle(fontSize: 24),
    ),
  );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      content,
      style: const TextStyle(fontSize: 18),
    ),
  );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 7),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        )
      ],
    ),
  );
}

class LocationData {
  final IconData icon;
  final String latitudeValue;
  final String longitudeValue;

  LocationData(this.icon, this.latitudeValue, this.longitudeValue);
}

class LocationDataWidget extends StatelessWidget {
  final LocationData locationData;

  LocationDataWidget({required this.locationData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconAndDetail(
          locationData.icon,
          locationData.latitudeValue,
        ),
        IconAndDetail(
          locationData.icon,
          locationData.longitudeValue,
        ),
      ],
    );
  }
}


class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.indigo, // Set warna teks pada button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

// Widget untuk tampilan vaccine agar lebih bewarna
class VaccineDetailWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const VaccineDetailWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: data.entries.map((entry) {
          Color backgroundColor;
          Color textColor;
          if (entry.key == 'level') {
            backgroundColor = Colors.red.shade200;
            textColor = Colors.white;
          } else if (entry.key == 'age') {
            backgroundColor = Colors.teal.shade300;
            textColor = Colors.white;
          } else if (entry.key == 'name') {
            backgroundColor = Colors.lightGreen.shade600;
            textColor = Colors.white;
          } else {
            backgroundColor = Colors.blueGrey;
            textColor = Colors.white;
          }
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (entry.key == 'age' || entry.key == 'name')
                  ? '${entry.key} : ${entry.value}'
                  : '${entry.value}',
              style: TextStyle(color: textColor),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget untuk menampilkan pop-up warning/notification, dimana judul dan messagenya sesuai yang diinputkan
class CustomPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const CustomPopup({
    required this.title,
    required this.message,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}