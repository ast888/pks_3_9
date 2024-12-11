import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/pages/note_page.dart';

class CartPage extends StatelessWidget {
  final Cart cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: ValueListenableBuilder<List<Note>>(
        valueListenable: cart,
        builder: (context, items, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final Note note = items[index];

                    return Dismissible(
                      key: Key(note.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        cart.removeItem(note);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${note.title} удален из корзины')),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(note: note, cart: cart),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Изображение товара
                                  Image.network(
                                    note.photoId, // Изменено на Image.network для загрузки изображения по URL
                                    width: 80,
                                    height: 95,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16), // Отступ между изображением и текстом
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note.title,
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8), // Отступ между названием и ценой
                                        Text(
                                          '${double.parse(note.price) * note.quantity} ₽',
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 119, 40),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Количество товара
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (note.quantity > 1) {
                                                note.quantity--;
                                                cart.updateItem(note); // Обновляем товар в корзине
                                              }
                                            },
                                          ),
                                          Text('${note.quantity}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              note.quantity++;
                                              cart.updateItem(note); // Обновляем товар в корзине
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Цвет фона кнопки
                      foregroundColor: Colors.black, // Цвет текста кнопки
                      padding: const EdgeInsets.symmetric(vertical: 16.0), // Отступы
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Закругленные углы
                      ),
                    ),
                    onPressed: () {
                      // Логика оформления заказа
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Оформление заказа'),
                          content: const Text('Спасибо за ваш заказ!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                cart.clear(); // Очищаем корзину
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                                        child: const Text('Оформить заказ'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

