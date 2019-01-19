import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'CharacterClass.dart';

class CharacterPage extends StatefulWidget {
  CharacterPage({this.auth, this.character});
  final BaseAuth auth;
  final Character character;

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage>{
  bool _editingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Character Information'),
          actions: <Widget>[
            _deleteIcon(),
          ],
        ),
        body: new ListView(
            padding: const EdgeInsets.only(top: 20.0),
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.only(bottom: 30.0),
                  child: Center(
                    child: Text(widget.character.name.toString(),
                        textScaleFactor: 3.0
                    ),
                  )
              ),
              new Divider(height: 2.0),
              new ListTile(
                title: Text('Coins: '),
                trailing: Text(widget.character.coinBalance),
              ),
              new Divider(height: 2.0),
              Padding(
                padding: new EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                    child: Text('Inventory',
                      textScaleFactor: 1.5,
                    )
                ),
              ),
              Column(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        String key = widget.character.inventory.keys.elementAt(index);
                        return Column(
                            children: <Widget>[
                              new ListTile(
                                title: Text(key.toString()),
                                subtitle: Text(
                                    'Magical: ' + widget.character.inventory[key]['magical'].toString() +
                                        ', Quantity: ' + widget.character.inventory[key]['quantity'].toString() +
                                        (widget.character.inventory[key]['metric'] != null ? ' ' + widget.character.inventory[key]['metric'].toString(): '')
                                ),
                              ),
                              new Divider(
                                  height: 2.0
                              )
                            ]
                        );
                      },
                      itemCount: widget.character.inventory.length,
                    )
                  ]
              )
            ]
        ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(
            _editingEnabled ? Icons.check : Icons.create,
            color: Color(0xffFFB300),
          ),
          backgroundColor: Color(0xff00BCD4),
          onPressed: _editCharacter,
      )
    );
  }

  void _editCharacter() {
    setState(() {
      _editingEnabled = !_editingEnabled;
    });
  }

  Widget _deleteIcon() {
    return IconButton(
        icon: new Icon(
          _editingEnabled ? Icons.delete : null,
          color: Colors.pinkAccent,
        ),
        onPressed: _deleteConfirmation
    );
  }

  void _confirmedDeleteCharacter() {
    Navigator.of(context).pop();
    deleteCharacter(widget.character.reference);
    Navigator.of(context).pop();
  }

  Future<Widget> _deleteConfirmation() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS){
          return CupertinoAlertDialog(
            title: Text(
                'Are you sure you wish to delete ${widget.character.name}?'
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () => _confirmedDeleteCharacter(),
                  child: Text('CONFIRM'),
                  isDefaultAction: false,
                  isDestructiveAction: true,
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
                isDestructiveAction: false,
                isDefaultAction: true,
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
                'Are you sure you wish to delete ${widget.character.name}?'
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
              ),
              FlatButton(
                  onPressed: () => _confirmedDeleteCharacter(),
                  child: Text('CONFIRM')
              ),
            ],
          );
        }
      }
    );
  }

}