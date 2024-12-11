import 'package:flutter/foundation.dart';
import 'note.dart';

class Cart extends ValueNotifier<List<Note>> {
  Cart() : super([]);

  // Добавить товар в корзину
  void addItem(Note note) {
    final existingNoteIndex = value.indexWhere((item) => item.id == note.id);
    if (existingNoteIndex >= 0) {
      // Если товар уже есть в корзине, увеличиваем его количество
      value[existingNoteIndex].quantity += note.quantity;
    } else {
      // Если товара нет, добавляем его в корзину
      value.add(note);
    }
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  // Удалить товар из корзины
  void removeItem(Note note) {
    value.removeWhere((item) => item.id == note.id);
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  // Обновить количество товара в корзине
  void updateItem(Note note) {
    final index = value.indexWhere((item) => item.id == note.id);
    if (index >= 0) {
      value[index] = note; // Обновляем товар в корзине
      notifyListeners(); // Уведомляем слушателей об изменении
    }
  }

  // Получить товары в корзине
  List<Note> get items => value;

  // Очистить корзину
  void clear() {
    value.clear();
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  // Получить общую стоимость товаров в корзине
  double get totalPrice {
    return value.fold(0, (sum, item) {
      String priceString = item.price.toString();
      return sum + double.parse(priceString.replaceAll(' ₽', '')) * item.quantity; // Учитываем количество
    });
  }
}
