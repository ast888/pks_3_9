import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/screen.dart'; // Импортируем новый экран
import 'package:flutter_application_1/models/cart.dart'; // Импортируем Cart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Создаем экземпляр Cart
    Cart cart = Cart(); // Инициализируем Cart

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Screen(cart: cart), // Передаем cart в Screen
    );
  }
}
