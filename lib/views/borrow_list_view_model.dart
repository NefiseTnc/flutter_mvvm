import 'package:flutter/material.dart';
import 'package:flutter_mvvm/models/borrow_info_model.dart';
import 'package:flutter_mvvm/services/database.dart';

import '../models/book_model.dart';

class BorrowListViewModel extends ChangeNotifier {
  final Database _database = Database();
  String collectionPath = 'books';

  Future<void> updateBook({
    required List<BorrowInfo> borrowList,
    required Book book,
  }) async {
    Book newBook = Book(
        id: book.id,
        bookName: book.bookName,
        authorName: book.authorName,
        publishDate: book.publishDate,
        borrows: borrowList);

    //bu kitap bilgisini database servisi üzerinden Firestore 'a yazacak.
    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
