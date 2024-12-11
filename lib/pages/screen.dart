import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/favorite_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart'; // Импортируем ProfilePage
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/models/cart.dart';



class Screen extends StatefulWidget {
  final Cart cart; // Добавлено

  const Screen({Key? key, required this.cart}) : super(key: key);

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  int _selectedIndex = 0;
  List<Note> favoriteNotes = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToFavorites(Note note) {
    setState(() {
      if (!favoriteNotes.contains(note)) {
        favoriteNotes.add(note);
      }
    });
  }

  void removeFromFavorites(Note note) {
    setState(() {
      favoriteNotes.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomePage(
              favoriteNotes: favoriteNotes,
              addToFavorites: addToFavorites,
              removeFromFavorites: removeFromFavorites,
            )
          : _selectedIndex == 1
              ? FavoritesPage(
                  cart: widget.cart, 
                  removeFromFavorites: removeFromFavorites,
                )
              : const ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 32, 100, 156),
        onTap: _onItemTapped,
      ),
    );
  }
}
