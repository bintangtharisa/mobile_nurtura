import 'package:flutter/material.dart';
import 'features/ibu/widgets/tips_populer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TipsPopuler(
        title: "Tips Populer",
        subtitle: "Tips untuk ibu hamil",
        image: const NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aHVuZ2VyaWx8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60"),
      ),
    );
  }
}