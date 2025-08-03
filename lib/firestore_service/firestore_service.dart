
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/model/journal_model.dart';

class FirestoreService{
  
  final firestore = FirebaseFirestore.instance;

   CollectionReference<Map<String,dynamic>> _journalCollection(String uid){
    return firestore.collection('users').doc(uid).collection('journals');
  }

  Stream<List<JournalModel>> getJournals(String uid){
    return _journalCollection(uid).orderBy('date',descending: true).snapshots().map((snapshot){
       return snapshot.docs.map((doc)=>JournalModel.fromMap(doc.id,doc.data())).toList();
     });
  }

  Future<List<JournalModel>> getJournalsForRefresh(String uid)async{
    final snapshot = await firestore.collection('users').doc(uid).collection('journals').get(); //ekbar call kore
    return snapshot.docs.map((doc)=>JournalModel.fromMap(doc.id, doc.data())).toList();
  }

   Future<void> addJournal(JournalModel journal)async{
     await _journalCollection(journal.uid).add(journal.toMap());
   }

   Future<void> updateJournal(JournalModel journal)async{
     await _journalCollection(journal.uid).doc(journal.id).update(journal.toMap());
   }

   Future<void> deleteJournal(String id, String uid)async{
     await _journalCollection(uid).doc(id).delete();
   }

}