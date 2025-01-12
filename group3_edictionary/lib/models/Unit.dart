import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  dynamic docId;
  int bookId;
  String description;
  String name;
  int unitNumber;
  int totalWords;

  Unit({ this.docId, this.bookId, this.description, this.name, this.unitNumber, this.totalWords });

  factory Unit.fromSnapshot(DocumentSnapshot snapshot){
    return Unit(
      description: snapshot['description'],
      bookId: snapshot['book_id'],
      name: snapshot['name'],
      unitNumber: snapshot['number'],
      totalWords: snapshot['total_words'],
      docId : snapshot.documentID
    );
  }

  factory Unit.fromJson(Map<String, dynamic> data){
    return Unit(
      description: data['description'],
      bookId: data['book_id'],
      name: data['name'],
      unitNumber: data['number'],
      totalWords: data['total_words'],
      docId : data['id']
    );
  }

}