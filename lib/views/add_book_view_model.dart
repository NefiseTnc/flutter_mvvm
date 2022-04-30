import 'package:flutter/material.dart';
import 'package:flutter_mvvm/models/book_model.dart';
import 'package:flutter_mvvm/services/calculator.dart';
import 'package:flutter_mvvm/services/database.dart';

class AddBookViewModel extends ChangeNotifier {
  //todo Create metot(add book)

  final Database _database = Database();
  String collectionPath = 'books';

  Future<void> addNewBook(
      {required String bookName,
      required String authorName,
      required DateTime publishDate}) async {
    //* Form alanındaki veriler ile önce bir book objesi oluşturacak
    //* Bu kitap bilgisini Database servisi üzerinden FireStore'a yazacak.

    Book newBook = Book(
        id: DateTime.now().toIso8601String(),
        bookName: bookName,
        authorName: authorName,
        publishDate: Calculator.dateTimeToTimestamp(publishDate),
        borrows: []);

    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
