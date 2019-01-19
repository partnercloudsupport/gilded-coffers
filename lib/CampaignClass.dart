import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final String name;
  final String campaignRef;
//  final Map<String, dynamic> vendors;
//  final int platinum;
//  final int gold;
//  final int silver;
//  final int copper;
//  final DocumentSnapshot snapshot;

  final DocumentReference reference;

  Campaign.fromMap(Map<dynamic, dynamic> map, {this.reference}) :
        assert(map['campaignName'] != null),
        assert(map['playerReference'] != null),
        name = map['campaignName'],
        campaignRef = map['playerReference'];

  Campaign.fromSnapshot(DocumentSnapshot snapshot) :
        this.fromMap(snapshot.data, reference: snapshot.reference);

//  @override
//  String toString() => "Record<$name:$coinBalance>";
}