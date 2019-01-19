import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInEP(String email, String password);
  Future<String> signUpEP(String email, String password);
  Future<void> initialSetup(String uid, String name);
  Future<FirebaseUser> getCurrentUser();
  Future<String> getEmailOfCurrentUser();
  Future<String> getNameOfCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInEP(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUpEP(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    return user.uid;
  }

  Future<void> initialSetup(String uid, String name) async {
//    owner = name;
    await Firestore.instance.document('users/$uid').setData({
      'hasCampaign': false,
      'name': name,
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
//    print(user.uid);
    return user;
  }

  Future<String> getEmailOfCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<String> getNameOfCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
//    DocumentReference docRed =
    return await Firestore.instance.document('users/${user.uid}').get().then((result) {
      return result.data['name'];
    });

  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  //TODO: setup google signin function with auth class
}

//TODO: create edit and delete functions for campaigns and characters

void createCharacter(String uid, Map<String, dynamic> character) async {
  //TODO: create nameExists function, error on true and proceed on false
  String charName = character['name'];
  DocumentReference charDocRef = Firestore.instance.document('users/$uid/characters/$charName');
  charDocRef.setData({
    'copper': character['copper'],
    'silver': character['silver'],
    'gold': character['gold'],
    'platinum': character['platinum'],
    'campaignRef': character['campaign'],
    'inventory': character['inventory'],
  });
}

void deleteCharacter(DocumentReference docRef) async {
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot snapshot = await tx.get(docRef);
    if (snapshot.exists){
      await tx.delete(docRef);
    }
  });
}

void createCampaign(String uid, Map<String, dynamic> campaign) async {
  String campaignName = campaign['campaignName'] + ':' + uid.substring(0, 5);
//  print(campaignName);
  DocumentReference campaignDocRef = Firestore.instance.document('campaigns/$campaignName');
  campaignDocRef.setData({
    'vendors': campaign['vendors'],
    'owner': uid,
    'campaignName': campaign['campaignName'],
  });
  DocumentReference userCampaignRef = Firestore.instance.document('users/$uid/campaigns/$campaignName');
  userCampaignRef.setData({
    'campaignName': campaign['campaignName'],
    'playerReference': campaignName,
  });
  //TODO: test and ensure that following action changes hasCampaign field for user.
  DocumentReference userHasCampaign = Firestore.instance.document('users/$uid');
  userHasCampaign.updateData({
    'hasCampaign': true
  });

}

//TODO: setup other commonly used firebase functions in this file.