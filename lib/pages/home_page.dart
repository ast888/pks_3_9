import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/item_note.dart';
import 'package:flutter_application_1/models/cart.dart';
import 'package:flutter_application_1/pages/cart_page.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  final List<Note> favoriteNotes; // Список избранных заметок
  final Function(Note) addToFavorites; // Функция добавления в избранное
  final Function(Note) removeFromFavorites; // Функция удаления из избранного

  const HomePage({
    super.key,
    required this.favoriteNotes,
    required this.addToFavorites,
    required this.removeFromFavorites,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Cart cart = Cart(); // Создаем корзину
  final Dio _dio = Dio(); // Инициализация Dio
  List<Note> notes = []; // Список заметок, загружаемых из API
  bool isLoading = true; // Состояние загрузки

  @override
  void initState() {
    super.initState();
    fetchNotes(); // Загружаем заметки при инициализации
  }

  Future<void> fetchNotes() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/notes'); // Замените на ваш URL API
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        setState(() {
          notes = jsonData.map((note) => Note.fromJson(note)).toList(); // Преобразуем JSON в список объектов Note
          isLoading = false; // Устанавливаем состояние загрузки в false
        });
      } else {
        throw Exception('Не удалось загрузить заметки');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Устанавливаем состояние загрузки в false в случае ошибки
      });
      // Обработка ошибок, например, показать сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  Future<void> addToFavorites(Note note) async {
  try {
    final response = await _dio.post('http://10.0.2.2:8080/favorites/add', data: note.toJson());
    if (response.statusCode == 200) {
      setState(() {
        widget.favoriteNotes.add(note);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${note.title} добавлен в избранное')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: ${e.toString()}')),
    );
  }
}

Future<void> removeFromFavorites(Note note) async {
  try {
    final response = await _dio.delete('http://10.0.2.2:8080/favorites/${note.id}');
    if (response.statusCode == 204) {
      setState(() {
        widget.favoriteNotes.remove(note);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${note.title} удален из избранного')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: ${e.toString()}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Горбушкин Дворик')),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart), // Переход на страницу корзины
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Индикатор загрузки
          : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.45,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNote(
                  note: notes[index],
                  cart: cart,
                  onFavoriteToggle: (note, isFavorite) {
                    if (isFavorite) {
                      // Если добавляем в избранное, вызываем метод добавления
                      addToFavorites(note);
                    } else {
                      // Если убираем из избранного, вызываем метод удаления
                      removeFromFavorites(note);
                    }
                  },
                  isFavorite: widget.favoriteNotes.contains(notes[index]),
                );
              },
            ),
    );
  }
}

