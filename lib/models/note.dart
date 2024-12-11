import 'dart:convert';
import 'package:dio/dio.dart';

class Note {
  String id;
  String photoId;
  String title;
  String description;
  String price;
  String ram;
  String simCards;
  String supports5G;
  String screenSize;
  String refreshRate;
  String camera;
  String processor;
  bool isLiked;
  int quantity;

  Note({
    required this.id,
    required this.photoId,
    required this.title,
    required this.description,
    required this.price,
    required this.ram,
    required this.simCards,
    required this.supports5G,
    required this.screenSize,
    required this.refreshRate,
    required this.camera,
    required this.processor,
    this.isLiked = false,
    this.quantity = 1,
  });

  // Method to fetch all notes from the API
  static Future<List<Note>> fetchNotes() async {
    final dio = Dio();
    final response = await dio.get('http://10.0.2.2:8080/notes');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Method to create a new note on the API
  static Future<Note> createNote(Note note) async {
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8080/notes/create',
      data: note.toJson(), // Use toJson method
    );

    if (response.statusCode == 201) {
      return Note.fromJson(response.data);
    } else {
      throw Exception('Failed to create note');
    }
  }

  // Factory method to create a Note object from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      photoId: json['photo_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      ram: json['ram'],
      simCards: json['simCards'],
      supports5G: json['supports5G'],
      screenSize: json['screenSize'],
      refreshRate: json['refreshRate'],
      camera: json['camera'],
      processor: json['processor'],
      isLiked: json['isLiked'],
      quantity: json['quantity'],
    );
  }

  // Method to convert a Note object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_id': photoId,
      'title': title,
      'description': description,
      'price': price,
      'ram': ram,
      'simCards': simCards,
      'supports5G': supports5G,
      'screenSize': screenSize,
      'refreshRate': refreshRate,
      'camera': camera,
      'processor': processor,
      'isLiked': isLiked,
      'quantity': quantity,
    };
  }

  // Method to create a copy of the Note object with updated values
  Note copyWith({
    String? id,
    String? photoId,
    String? title,
    String? description,
    String? price,
    String? ram,
    String? simCards,
    String? supports5G,
    String? screenSize,
    String? refreshRate,
    String? camera,
    String? processor,
    bool? isLiked,
    int? quantity,
  }) {
    return Note(
      id: id ?? this.id,
      photoId: photoId ?? this.photoId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      ram: ram ?? this.ram,
      simCards: simCards ?? this.simCards,
      supports5G: supports5G ?? this.supports5G,
      screenSize: screenSize ?? this.screenSize,
      refreshRate: refreshRate ?? this.refreshRate,
      camera: camera ?? this.camera,
      processor: processor ?? this.processor,
      isLiked: isLiked ?? this.isLiked,
      quantity: quantity ?? this.quantity,
    );
  }
}
