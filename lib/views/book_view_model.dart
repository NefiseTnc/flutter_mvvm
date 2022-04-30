import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/models/book_model.dart';
import 'package:flutter_mvvm/services/database.dart';

// ? Bookview in state bilgisini tutmak
// ? Bookview in arayüzünün ihtiyacı olan metotları ve hesaplamaları yapmak.
// ? gerekli servislerle konuşmak

class BookViewModel extends ChangeNotifier {
  final Database _database = Database();

  final String _collectionPath = 'books';

  Stream<List<Book>> getBookList() {
    //todo Stream<QuerySnapshot> --> Stream<List<DocumentSnapshot>>

    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getBookListFromApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    //todo Stream<List<DocumentSnapshot>>  --> Stream<List<Book>>

    Stream<List<Book>> streamListBook = streamListDocument.map(
        (listOfDocSnap) => listOfDocSnap
            .map((docSnap) =>
                Book.fromMap(docSnap.data() as Map<dynamic, dynamic>))
            .toList());

    return streamListBook;
  }

  Future<void> deleteBook(String id) async {
    await _database.deleteDocument(referencePath: _collectionPath, id: id);
  }
}
