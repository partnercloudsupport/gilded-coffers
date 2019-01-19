import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'create_character.dart';
import 'create_campaign.dart';
import 'character_page.dart';
import 'campaign_page.dart';
import 'CharacterClass.dart';
import 'CampaignClass.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.uid, this.onSignOut});
  final BaseAuth auth;
  final String uid;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName;
  String _userEmail;

  @override
  void initState() {
    _userName = '-';
    _userEmail = '';
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
            children: <Widget>[
              Container(
                height: 170.0,
                child: DrawerHeader(
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.all(0.0),
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture: new CircleAvatar(
                      child: Text(_userName[0]),
                      backgroundColor: Colors.cyanAccent,
                    ),
                    accountName: Text(_userName),
                    accountEmail: Text(_userEmail),
                    decoration: BoxDecoration(
//                          color: Color(0xffe0f7fa),
                    ),
//                      margin: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                ),
              ),
              ListTile(
                title: Text('Create Character',
                  style: new TextStyle(
                      color: new Color(0xffffca28),
                  ),
                ),
                onTap: _createCharacter,
              ),
              new Divider(height: 1.0,),
              ListTile(
                title: Text('Create Campaign',
                    style: new TextStyle(
                      color: new Color(0xffffca28),
                    )
                ),
                onTap: _createCampaign,
              ),
              new Divider(height: 1.0,),
              ListTile(
                leading: new Icon(Icons.directions_run),
                title: Text('Logout'),
                onTap: widget.onSignOut,
              )
            ],
        ),
        elevation: 20.0,
      ),
      appBar: AppBar(
          title: Text('Gilded Coffers'),
          actions: <Widget>[
//            FlatButton(
//              onPressed: widget.onSignOut,
//              child: Text('Logout')
//            )
          ]
      ),
      body: _buildBody(context),
    );
  }

  //TODO: Potentially switch from lists to cards for characters
  Widget _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _characterSection(context),
          _campaignSection(context),
        ],
      ),
    );
  }

  Widget _campaignSection(BuildContext context){
    CollectionReference collection = Firestore.instance.collection('users').document(widget.uid).collection('campaigns');
//    Query query = collection.where(field)
    
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(widget.uid).collection('campaigns').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
//        Firestore.instance.collection('campaigns/')
        return _buildCampaignList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildCampaignList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildCampaignListItem(context, data)).toList(),
      shrinkWrap: true,
    );
  }

  Widget _buildCampaignListItem(BuildContext context, DocumentSnapshot snapshot) {
//    final DocumentReference campaignDetails = await Firestore.instance.collection('campaigns').document(snapshot.documentID).get();
    final campaign = Campaign.fromSnapshot(snapshot);

    return Padding(
      key: ValueKey(campaign.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(campaign.name),
          onTap: () => _openCampaign(campaign),
        ),
      ),
    );
  }

  void _openCampaign(Campaign campaign){
    Navigator.of(context).push(
      new MaterialPageRoute<void>(builder: (BuildContext context) {

        return new CampaignPage(
          auth: widget.auth,
          campaign: campaign,
        );
      }),
    );
  }

  Widget _characterSection(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(widget.uid).collection('characters').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildCharacterList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildCharacterList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildCharacterListItem(context, data)).toList(),
      shrinkWrap: true,
    );
  }

  Widget _buildCharacterListItem(BuildContext context, DocumentSnapshot snapshot) {
    final character = Character.fromSnapshot(snapshot);

    return Padding(
      key: ValueKey(character.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(character.name),
          trailing: Text(character.coinBalance.toString()),
          onTap: () => _openCharacter(character),
        ),
      ),
    );
  }

  void _getUserInfo() async {
    String tempName = await widget.auth.getNameOfCurrentUser();
    String tempEmail = await widget.auth.getEmailOfCurrentUser();
    setState(() {
      _userName = tempName;
      _userEmail = tempEmail;
    });
  }

  void _openCharacter(Character character){
    Navigator.of(context).push(
      new MaterialPageRoute<void>(builder: (BuildContext context) {

        return new CharacterPage(
          auth: widget.auth,
          character: character,
        );
      }),
    );
  }

  _createCharacter() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      new MaterialPageRoute<void>(builder: (BuildContext context) {
        return new CreateCharacter(
          auth: widget.auth,
          uid: widget.uid,
        );
      })
    );
  }

  _createCampaign() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
        new MaterialPageRoute<void>(builder: (BuildContext context) {
          return new CreateCampaign(
            auth: widget.auth,
            uid: widget.uid,
          );
        })
    );
  }
}