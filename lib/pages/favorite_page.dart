import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/item_note.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/models/cart.dart';
import 'package:dio/dio.dart';

class FavoritesPage extends StatefulWidget {
  final Cart cart;
  final Function(Note) removeFromFavorites;

  const FavoritesPage({
    Key? key,
    required this.cart,
    required this.removeFromFavorites,
  }) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Note> favoriteNotes = [];
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchFavoriteNotes();
  }

  Future<void> fetchFavoriteNotes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get('http://10.0.2.2:8080/favorites');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        setState(() {
          favoriteNotes = jsonData.map((note) => Note.fromJson(note)).toList();
          isLoading = false;
        });
      } else {
        _showError('Не удалось загрузить избранные заметки');
      }
    } catch (e) {
      _showError('Ошибка: ${e.toString()}');
    }
  }

  Future<void> removeFromFavorites(Note note) async {
    try {
      final response = await _dio.delete('http://10.0.2.2:8080/favorites/${note.id}');
      if (response.statusCode == 204) {
        setState(() {
          favoriteNotes.remove(note);
        });
        widget.removeFromFavorites(note);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${note.title} удален из избранного')),
        );
      } else {
        _showError('Не удалось удалить из избранного');
      }
    } catch (e) {
      _showError('Ошибка: ${e.toString()}');
    }
  }

  void _showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteNotes.isEmpty
              ? const Center(
                  child: Text(
                    'Нет избранных товаров',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.45,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: favoriteNotes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemNote(
                      note: favoriteNotes[index],
                      cart: widget.cart,
                      onFavoriteToggle: (note, isFavorite) {
                        if (isFavorite) {
                          // Если убираем из избранного, вызываем метод удаления
                          removeFromFavorites(note);
                        } else {
                          // Если добавляем в избранное, вы можете добавить логику для добавления
                          // Например, вызов метода для добавления в избранное
                          // Здесь вы можете вызвать метод для добавления в избранное
                          // Например, вы можете сделать POST запрос на сервер
                          // и обновить состояние, если добавление прошло успешно
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${note.title} уже в избранном')),
                          );
                        }
                      },
                      isFavorite: true, // Здесь всегда true, так как это избранные заметки
                    );
                  },
                ),
    );
  }
}

