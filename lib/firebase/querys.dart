import 'package:cloud_firestore/cloud_firestore.dart';


// Get all expenses per year from a unique user
Future<QuerySnapshot> getExpensesPerYear(user, year) {
  Future<QuerySnapshot> _query;

  FirebaseFirestore db = FirebaseFirestore.instance;
  _query = db
      .collection('users')
      .doc(user)
      .collection('expenses')
      .where("year", isEqualTo: year)
      .get();
  return _query;
}

// Get all expenses per month from a unique user
Stream<QuerySnapshot> getExpenses(user, currentPage, year) {
  Stream<QuerySnapshot>_query;

  FirebaseFirestore db = FirebaseFirestore.instance;
  _query = db
      .collection('users')
      .doc(user)
      .collection('expenses')
      .where("month", isEqualTo: currentPage + 1)
      .where("year", isEqualTo: year)
      .snapshots();
  return _query;
}

// add an expense
void setExpenses(user, data) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  db.collection('users')
      .doc(user)
      .collection('expenses')
      .add(data)
  ;
}

// Get all expenses per month and per category from a unique user
Stream<QuerySnapshot> getCategoryExpenses(user, currentPage, category, year) {
  Stream<QuerySnapshot>_query;

  FirebaseFirestore db = FirebaseFirestore.instance;
  _query = db
      .collection('users')
      .doc(user)
      .collection('expenses')
      .where("month", isEqualTo: currentPage + 1)
      .where("year", isEqualTo: year)
      .where("category", isEqualTo: category)
      .orderBy("day", descending: true)
      .snapshots();
  print(_query.length);
  return _query;
}

// delete an expense
void deleteExpense(user, id) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  db.collection('users')
      .doc(user)
      .collection('expenses')
      .doc(id)
      .delete()
  ;
}
