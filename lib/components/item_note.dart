import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/pages/note_page.dart';
import 'package:flutter_application_1/models/cart.dart';

class ItemNote extends StatefulWidget {
  const ItemNote({
    Key? key,
    required this.note,
    required this.cart,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  final Note note;
  final Cart cart;
  final Function(Note, bool) onFavoriteToggle;
  final bool isFavorite;

  @override
  _ItemNoteState createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  final Dio _dio = Dio();
  late Note note; // Локальная копия заметки для редактирования

  @override
  void initState() {
    super.initState();
    note = widget.note; // Инициализация локальной копии
  }

  Future<void> updateNoteWithDio(Note updatedNote) async {
    try {
      final response = await _dio.put(
        'http://10.0.2.2:8080/notes/update/${updatedNote.id}',
        data: updatedNote.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update note. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating note: $e');
    }
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: note.title);
    final descriptionController = TextEditingController(text: note.description);
    final photoUrlController = TextEditingController(text: note.photoId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать заметку'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
                TextField(
                  controller: photoUrlController,
                  decoration: const InputDecoration(labelText: 'URL фото'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                // Обновляем локальный объект
                final updatedNote = note.copyWith(
                  title: titleController.text,
                  description: descriptionController.text,
                  photoId: photoUrlController.text,
                );

                // Сразу обновляем состояние
                setState(() {
                  note = updatedNote;
                });

                // Закрываем диалог
                Navigator.of(context).pop();

                // Отправляем изменения на сервер
                try {
                  await updateNoteWithDio(updatedNote);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заметка обновлена успешно!')),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка обновления: $error')),
                  );
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(note: note, cart: widget.cart),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(205, 255, 255, 255),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: const Color.fromARGB(115, 255, 255, 255),
              width: 4.0,
            ),
          ),
          width: double.infinity,
          height: 600,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    note.photoId,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Ошибка загрузки изображения'));
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${note.price} ₽',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 128, 0, 0)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note.title,
                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.cart.addItem(note);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Вы добавили в корзину ${note.title} за ${note.price}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Icon(Icons.shopping_cart, size: 24),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: widget.isFavorite ? Colors.red : const Color.fromARGB(255, 198, 187, 186),
                      ),
                      onPressed: () async {
                        if (widget.isFavorite) {
                          await widget.onFavoriteToggle(note, false);
                        } else {
                          await widget.onFavoriteToggle(note, true);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
