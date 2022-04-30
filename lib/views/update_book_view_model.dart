import 'package:flutter/material.dart';
import 'package:flutter_mvvm/services/database.dart';
import '../models/book_model.dart';
import '../services/calculator.dart';

class UpdateBookViewModel extends ChangeNotifier {
  //todo Update metot

  final Database _database = Database();
  String collectionPath = 'books';

  Future<void> updateBook(
      {required Book book,
      required String bookName,
      required String authorName,
      required DateTime publishDate}) async {
    //* Form alanındaki veriler ile önce bir book objesi oluşturacak
    //* Bu kitap bilgisini Database servisi üzerinden FireStore'a yazacak.

    Book updateBook = Book(
        id: book.id,
        bookName: bookName,
        authorName: authorName,
        publishDate: Calculator.dateTimeToTimestamp(publishDate),
        borrows: book.borrows
        );

    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: updateBook.toMap());
  }
}
