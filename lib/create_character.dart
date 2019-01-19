import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'package:flutter/material.dart';

class CreateCharacter extends StatefulWidget{
  CreateCharacter({this.auth, this.uid});
  final BaseAuth auth;
  final String uid;

  @override
  _CreateCharacterState createState() => _CreateCharacterState();
}

class _CreateCharacterState extends State<CreateCharacter> {
  final GlobalObjectKey _formKey = new GlobalObjectKey(Form);
  String _campaign;
  String _name;
  Map<String, dynamic> _inventory;

  @override
  void initState() {
    super.initState();
    _campaign = '';
    _name = '';
    _inventory = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Character'),
      ),
      body: Stack(
        children: <Widget>[
          _createForm(),
        ],
      ),
    );
  }

  Widget _createForm() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _nameField(),
  //                _ownerField(),
                _campaignField(),
//                _coinsField(),
  //                _inventoryManagement(),
                _submitButton(context),
              ],
              shrinkWrap: true,
            )
          )
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: new InputDecoration(
        hintText: 'Character Name'
      ),
      validator: (value) => value.isEmpty ? 'Enter the characters\'s name' : null,
      onSaved: (value) => _name = value,
    );
  }

//  Widget _ownerField() {
//    getOwnerName();
//    return Text(
//      _owner,
//    );
//  }
//
//  Future<void> getOwnerName() async {
//    String temp = await widget.auth.getNameOfCurrentUser();
//    if (temp != null){
//      setState(() {
//        _owner = temp;
//      });
//    }
//  }

  Widget _campaignField() {
    return TextFormField(
      decoration: new InputDecoration(
          hintText: 'Campaign Invite Code'
      ),
      validator: (value) => value.isEmpty ? 'Enter the Campaign\'s invite code' : null,
      onSaved: (value) => _campaign = value,
    );
  }

//  Widget _coinsField() {
//    return Column(
//      children: <Widget>[
//        TextFormField(
//          decoration: new InputDecoration(
//            hintText: 'Number of Copper Coins',
//          ),
//          validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
//          onSaved: (value) => _copper = int.parse(value),
//        ),
//        TextFormField(
//          decoration: new InputDecoration(
//            hintText: 'Number of Silver Coins',
//          ),
//          validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
//          onSaved: (value) => _silver = int.parse(value),
//        ),
//        TextFormField(
//          decoration: new InputDecoration(
//            hintText: 'Number of Gold Coins',
//          ),
//          validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
//          onSaved: (value) => _gold = int.parse(value),
//        ),
//        TextFormField(
//          decoration: new InputDecoration(
//            hintText: 'Number of Platinum Coins',
//          ),
//          validator: (value) => value.isEmpty ? 'Enter an number!' : null,
//          onSaved: (value) => _platinum = int.parse(value),
//        ),
//      ]
//    );
//  }

//  Widget _inventoryManagement() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//            Padding(
//              padding: EdgeInsets.all(0.0),
//              child: Row(
//                children: <Widget>[
//                  Text('Inventory:',
//                    style: new TextStyle(
//                      fontSize: 16
//                    ),
//                  ),
//                  Spacer(),
////                  IconButton(
////                    icon: new Icon(
////                        Icons.remove_circle
////                    ),
////                    onPressed: () => print('remove!'),
////                  ),
//                  IconButton(
//                    icon: new Icon(
//                        Icons.add_circle_outline
//                    ),
//                    onPressed: () => _addItemToInventory,
//                  )
//                ],
//              ),
//            ),
//            Row(
//              children: <Widget>[
//                Flexible(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 10.0),
//                      child: TextFormField(
//                        decoration: new InputDecoration(
//                          hintText: 'Item Name',
//                        ),
//                      ),
//                    ),
//                ),
//                Flexible(
//                  child: Padding(
//                    padding: EdgeInsets.only(right: 10.0),
//                    child: TextFormField(
//                      decoration: new InputDecoration(
//                        hintText: 'Magical?',
//                      ),
//                    ),
//                  ),
//                ),
//                Flexible(
//                  child: Padding(
//                    padding: EdgeInsets.only(left: 0.0),
//                    child: TextFormField(
//                      decoration: new InputDecoration(
//                        hintText: 'Quantity',
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            ListView.builder(
//                itemCount: _inventory.length,
//                itemBuilder: (BuildContext context, int index){
//                    String key = _inventory.keys.elementAt(index);
//                    return Column(
//                        children: <Widget>[
//                            new ListTile(
//                                title: Text(key.toString()),
//                                subtitle: Text(
//                                    'Magical: ' + _inventory[key]['magical'].toString() +
//                                    ', Quantity: ' + _inventory[key]['quantity'].toString() +
//                                    (_inventory[key]['metric'] != null ? ' ' + _inventory[key]['metric'].toString(): '')
//                                ),
//                            ),
//                            new Divider(height: 2.0)
//                        ]
//                    );
//                },
//                shrinkWrap: true,
//            )
//        ],
//      ),
//    );
//  }

  bool validateSaveForm(BuildContext context) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _createCharacterSubmit(BuildContext context) async {
    if (validateSaveForm(context)){
      Map<String, dynamic> character = {
        'name': _name,
        'campaign': _campaign,
        'copper': 0,
        'silver': 0,
        'gold': 0,
        'platinum': 0,
        'inventory': _inventory,
      };
      createCharacter(widget.uid, character);
      Navigator.of(context).pop();
    } else {
      print('there be an error with the form i think');
    }
  }

  Widget _submitButton(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        RaisedButton(
          child: Text('CREATE'),
          onPressed: () => _createCharacterSubmit(context),
        ),
      ],
    );
  }

}