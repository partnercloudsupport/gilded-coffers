import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String name;
  final String campaignRef;
  final String coinBalance;
  final Map<dynamic, dynamic> inventory;
  final int platinum;
  final int gold;
  final int silver;
  final int copper;
//  final DocumentSnapshot snapshot;

  final DocumentReference reference;

  Character.fromMap(Map<dynamic, dynamic> map, {this.reference}) :
        assert(map['campaignRef'] != null),
        assert(map['platinum'] != null),
        assert(map['gold'] != null),
        assert(map['silver'] != null),
        assert(map['copper'] != null),
        assert(map['inventory'] != null),
        name = reference.documentID,
        campaignRef = map['campaignRef'],
        platinum = map['platinum'],
        gold = map['gold'],
        silver = map['silver'],
        copper = map['copper'],
        inventory = map['inventory'],
        coinBalance = map['platinum'].toString() + 'P-' +
            map['gold'].toString() + 'G-' +
            map['silver'].toString() + 'S-' +
            map['copper'].toString() + 'C';

  Character.fromSnapshot(DocumentSnapshot snapshot) :
        this.fromMap(snapshot.data, reference: snapshot.reference);

//  @override
//  String toString() => "Record<$name:$coinBalance>";
}