import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:dnd_coin_balancer/CampaignClass.dart';

class CampaignPage extends StatefulWidget {
  CampaignPage({this.auth, this.campaign});
  final BaseAuth auth;
  final Campaign campaign;

  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.campaign.name.toString()),
      ),
      body: new ListView(
        children: <Widget>[],
      ),
    );
  }

}