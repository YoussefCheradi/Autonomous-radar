import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCounterCollection = FirebaseFirestore.instance.collection('usersCounter');
  final CollectionReference infractionCounterCollection = FirebaseFirestore.instance.collection('infractionCounter');

  // Method to get the next user collection name
  Future<String> _getNextUserCollectionName() async {
    // Get the document reference for the user counter
    DocumentReference counterDoc = userCounterCollection.doc('counter');
    DocumentSnapshot counterSnapshot = await counterDoc.get();

    int currentCount;
    if (counterSnapshot.exists) {
      currentCount = counterSnapshot.get('count');
      // Increment the count
      currentCount += 1;
      // Update the counter in Firestore
      await counterDoc.update({'count': currentCount});
    } else {
      // If the document doesn't exist, initialize it
      currentCount = 1;
      await counterDoc.set({'count': currentCount});
    }

    // Return the new collection name
    return '$uid';
  }

  // Method to get the next infraction collection name
  Future<String> _getNextInfractionCollectionName(String userCollectionName) async {
    // Get the document reference for the infraction counter
    DocumentReference counterDoc = infractionCounterCollection.doc(userCollectionName);
    DocumentSnapshot counterSnapshot = await counterDoc.get();

    int currentCount;
    if (counterSnapshot.exists) {
      currentCount = counterSnapshot.get('count');
      // Increment the count
      currentCount += 1;
      // Update the counter in Firestore
      await counterDoc.update({'count': currentCount});
    } else {
      // If the document doesn't exist, initialize it
      currentCount = 1;
      await counterDoc.set({'count': currentCount});
    }

    // Return the new collection name
    return 'infraction$currentCount';
  }

  // Method to update user data in a new infraction collection
  Future updateUserData(String MT) async {
    // Get the next user collection name
    String userCollectionName = await _getNextUserCollectionName();
    CollectionReference userCollection = FirebaseFirestore.instance.collection('users').doc(userCollectionName).collection('infractions');

    // Get the next infraction collection name
    String infractionCollectionName = await _getNextInfractionCollectionName(userCollectionName);

    // Create the infraction document within the user collection
    return await userCollection.doc(infractionCollectionName).set({
      "MT": MT,
    });
  }
}
