import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/cart.dart';

class NotePage extends StatelessWidget {
  final Note note;
  final Cart cart; // Добавили объект корзины

  const NotePage({super.key, required this.note, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0), // Измените цвет текста на черный
          fontSize: 24,
        ),
        title: const Center(child: Text('Магаз на Горбушке')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.network(
                  note.photoId, // Используем Image.network для загрузки изображения из сети
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Ошибка загрузки изображения'));
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Раздел технических характеристик
              const Text(
                'Технические характеристики:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Оперативная память: ${note.ram}'),
              Text('Количество SIM-карт: ${note.simCards}'),
              Text('Поддержка 5G: ${note.supports5G}'),
              Text('Диагональ экрана: ${note.screenSize}'),
              Text('Частота обновления: ${note.refreshRate}'),
              Text('Камера: ${note.camera}'),
              Text('Процессор: ${note.processor}'),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black38),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    onPressed: () {
                      cart.addItem(note); // Добавляем товар в корзину
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Спасибо за покупку',
                            style: TextStyle(fontSize: 36),
                          ),
                          backgroundColor: Color.fromARGB(255, 0, 255, 13),
                        ),
                      );
                    },
                    child: Text(
                      'Купить за ${note.price}', // Отображение цены в кнопке
                      style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
