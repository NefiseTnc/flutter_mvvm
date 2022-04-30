import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mvvm/models/book_model.dart';

//todo Firestore servisinden kitapların verisini stream olarak alıp bu hizmeti sağlımak istiyorum(Metot)
//todo Firestore üzerindeki bir veriyi silme hizmeti vericek(metot)
//todo Firestore'a yeni veri ekleme ve güncelleme hizmeti (metotlar)

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookListFromApi(String referencePath) {
    return _firestore.collection(referencePath).snapshots();
  }

  Stream<DocumentSnapshot> getBook(
      {required String referencePath, required String id}) {
    return _firestore.collection(referencePath).doc(id).snapshots();
  }

  Future<void> deleteDocument(
      {required String referencePath, required String id}) async {
    await _firestore.collection(referencePath).doc(id).delete();
  }

  Future<void> setBookData(
      {required String collectionPath,
      required Map<String, dynamic> bookAsMap}) async {
    await _firestore
        .collection(collectionPath)
        .doc(Book.fromMap(bookAsMap).id)
        .set(bookAsMap);
  }
}
