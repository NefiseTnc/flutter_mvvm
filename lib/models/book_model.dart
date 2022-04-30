import 'package:cloud_firestore/cloud_firestore.dart';

import 'borrow_info_model.dart';

//? Objeden map oluşturan bir metot lazım.
//? Mapden obje oluşturan bir yapıcı lazım.

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;
  List<BorrowInfo>? borrows;

  Book(
      {required this.id,
      required this.bookName,
      required this.authorName,
      required this.publishDate,
      this.borrows});

  Map<String, dynamic> toMap() {
    //* List<BorrowInfo>  -> List<Map<String,dynamic>>

    List<Map<String, dynamic>> borrows =
        this.borrows!.map((bookInfo) => bookInfo.toMap()).toList();

    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'publishDate': publishDate,
      'borrows': borrows,
    };
  }

  factory Book.fromMap(Map map) {
    //* List<Map<String,dynamic>> ->List<BorrowInfo>

    List<BorrowInfo>? borrowListAsMap = (map['borrows'] as List)
        .map((borrowAsMap) => BorrowInfo.formJson(borrowAsMap))
        .toList();

    return Book(
      id: map['id'],
      bookName: map['bookName'],
      authorName: map['authorName'],
      publishDate: map['publishDate'],
      borrows: borrowListAsMap,
    );
  }
}
