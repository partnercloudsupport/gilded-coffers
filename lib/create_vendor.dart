import 'package:flutter/material.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';

class CreateVendor extends StatefulWidget {

  @override
  _CreateVendorState createState() => _CreateVendorState();
}

class _CreateVendorState extends State<CreateVendor> {
  final GlobalObjectKey _vendorKey = new GlobalObjectKey(Text('Vendor'));

  final _itemNameController = new TextEditingController();
  final _itemPlatController = new TextEditingController();
  final _itemGoldController = new TextEditingController();
  final _itemSilController = new TextEditingController();
  final _itemCopController = new TextEditingController();

  String _vendorType;
  bool _addItemEnabled = false;
  bool _currentItemIsMagical = false;
  int _itemPlatVal = 0;
  int _itemGoldVal = 0;
  int _itemSilVal = 0;
  int _itemCopVal = 0;
  String _itemName = '';

  Map<String, dynamic> _vendorItems = {};

  @override
  void initState() {
    _vendorType = '';
    _vendorItems = {};
    _addItemEnabled = false;
//    _itemPlatController.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vendor'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.save),
            onPressed: () => _saveVendorAndReturn(),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
            key: _vendorKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Vendor Type (i.e. Blacksmith)',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter a Vendor Type' : null,
                  onSaved: (value) => _vendorType = value,
                  autovalidate: false,
                ),
                Row(
                  children: <Widget>[
                    Text('Add Item:',
                      style: new TextStyle(
                          fontSize: 16
                      ),
                    ),
                    IconButton(
                      icon: new Icon(
                          Icons.add_circle_outline
                      ),
                      onPressed: () => _toggleItemForm(),
                    ),
                  ],
                ),
                _showNewItemForm(),
                Expanded(
                    child: ListView.builder(
                      itemCount: _vendorItems.length,
                      itemBuilder: (BuildContext context, int index){
                        String key = _vendorItems.keys.elementAt(index);
                        return new ListTile(
                          title: Text(key.toString()),
                          subtitle: Text(
                              'Magical: ' + _vendorItems[key]['magical'].toString() +
                                  ', Value: ' + _vendorItems[key]['value']['platinum'].toString() + 'P:' +
                                  _vendorItems[key]['value']['gold'].toString() + 'G:' +
                                  _vendorItems[key]['value']['silver'].toString() + 'S:' +
                                  _vendorItems[key]['value']['copper'].toString() + 'C'
                          ),
                          trailing: new IconButton(
                              icon: new Icon(
                                  Icons.clear
                              ),
                              onPressed: () {
                                setState(() {
                                  _vendorItems.remove(key);
                                  index--;
                                });
                              }
                          ),
                        );
                      },
                      shrinkWrap: true,
                    )
                ),
              ],
            ),
        ),
      ),
    );
  }

  void _toggleItemForm() {
//    print('inside');
    setState(() {
      _addItemEnabled = !_addItemEnabled;
    });
  }

  Widget _showNewItemForm() {
    if (_addItemEnabled) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: TextFormField(
                    decoration: new InputDecoration(
                      hintText: 'Item Name',
                    ),
                    validator: (value) => value.isEmpty ? 'Enter an Name!' : null,
                    onSaved: (value) => _itemName = value,
                    controller: _itemNameController,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: CheckboxListTile(
                      title: Text('Magical?'),
                      value: _currentItemIsMagical,
                      onChanged: (bool value) {
                        setState(() {
                            _currentItemIsMagical = value;
                        });
                      },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: Text('Cost/Value:')
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: new InputDecoration(
                      hintText: 'Platinum',
                    ),
                    validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
                    onSaved: (value) => _itemPlatVal = int.parse(value),
                    controller: _itemPlatController,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: new InputDecoration(
                      hintText: 'Gold',
                    ),
                    validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
                    onSaved: (value) => _itemGoldVal = int.parse(value),
                    controller: _itemGoldController,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: new InputDecoration(
                      hintText: 'Silver',
                    ),
                    validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
                    onSaved: (value) => _itemSilVal = int.parse(value),
                    controller: _itemSilController,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: new InputDecoration(
                      hintText: 'Copper',
                    ),
                    validator: (value) => value.isEmpty || int.tryParse(value) == null ? 'Enter an number!' : null,
                    onSaved: (value) => _itemCopVal = int.parse(value),
                    controller: _itemCopController,
                  ),
                ),
              ),
            ],
          ),
          ButtonBar(
            children: <Widget>[
                RaisedButton(
                    child: Text('Add Item'),
                    onPressed: () => _addItemToVendorPool()
                )
            ]
          ),
        ],
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  bool validateSaveForm() {
    final FormState form = _vendorKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _addItemToVendorPool() {
    if (validateSaveForm()) {
      Map<String, dynamic> _item = {
        'name': _itemName,
        'magical': _currentItemIsMagical,
        'value':
            {
              'platinum': _itemPlatVal,
              'gold': _itemGoldVal,
              'silver': _itemSilVal,
              'copper': _itemCopVal,
            }
      };
      _vendorItems.putIfAbsent(_item['name'], () => _item);
//      print(_vendorItems);
      _toggleItemForm();
      _itemNameController.clear();
      _itemPlatController.clear();
      _itemGoldController.clear();
      _itemSilController.clear();
      _itemCopController.clear();
      setState(() {
        _currentItemIsMagical = false;
      });
    }

  }

  void _saveVendorAndReturn() {
    Map<String, dynamic> _vendor = {
      'name' : _vendorType,
      'items' : _vendorItems,
    };
    Navigator.of(context).pop(_vendor);
  }
}