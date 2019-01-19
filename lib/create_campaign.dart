import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'create_vendor.dart';

class CreateCampaign extends StatefulWidget{
  CreateCampaign({this.auth, this.uid});
  final BaseAuth auth;
  final String uid;

  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final GlobalObjectKey _formKey = new GlobalObjectKey(Form);
  String _campaignName;
  Map<String, dynamic> _vendors = {};
  bool _editingEnabled = false;

  @override
  void initState() {
    super.initState();
    _campaignName = '';
    _vendors = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Campaign'),
      ),
      body: Stack(
        children: <Widget>[
          _createForm(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          _editingEnabled ? Icons.check : Icons.create,
          color: Color(0xffFFB300),
        ),
        backgroundColor: Color(0xff00BCD4),
        onPressed: () {
          setState(() {
            _editingEnabled = !_editingEnabled;
          });
        },
      )
    );
  }

  Widget _createForm() {
    return Container(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _campaignNameField(),
                    _vendorManagement(context),
                    _submitButton(context),
                  ],
                  shrinkWrap: true,
                )
            )
        )
    );
  }

  Widget _campaignNameField() {
    return TextFormField(
      decoration: new InputDecoration(
          hintText: 'Campaign Name'
      ),
      validator: (value) => value.isEmpty ? 'Enter the campaign\'s name' : null,
      onSaved: (value) => _campaignName = value,
    );
  }

  void _addVendor(BuildContext context) async {
    Map<String, dynamic> _newVendor = await Navigator.of(context).push(
      new MaterialPageRoute<Map<String, dynamic>>(builder: (BuildContext context) {
        return new CreateVendor();
      })
    );
    setState(() {
      if (_newVendor != null) {
        _vendors.putIfAbsent(_newVendor['name'], () => {
          'name': _newVendor['name'],
          'items': _newVendor['items'],
          'isExpanded': false,
        });
      }
    });
//    print(_vendors);
  }

  Widget _vendorManagement(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Text('Add Vendor:',
                  style: new TextStyle(
                      fontSize: 16
                  ),
                ),
                IconButton(
                  icon: new Icon(
                      Icons.add_circle_outline
                  ),
                  onPressed: () => _addVendor(context),
                ),
              ],
            ),
          ),
          _expandableVendors(),
        ],
      ),
    );
  }

  Widget _expandableVendors() {
    return ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            String key = _vendors.keys.elementAt(index);
            setState(() {
              _vendors[key]['isExpanded'] = !_vendors[key]['isExpanded'];
            });
          },
          children: _vendors.keys.map((String key) {
            return new ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return new ListTile(
                  title: Text(_vendors[key]['name'].toString()),
                  leading: _editingEnabled ? new IconButton(
                    icon: new Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _vendors.remove(key);
                      });
                    },
                  ) : null,
                );
              },
              isExpanded: _vendors[key]['isExpanded'],
              body: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    children: _vendors[key]['items'].values.map<Widget>((item) {
                      return new ListTile(
                        title: Text(item['name'].toString()),
                        subtitle: Text(
                            'Magical: ' + item['magical'].toString() +
                                ', Value: ' + item['value']['platinum'].toString() + 'P:' +
                                item['value']['gold'].toString() + 'G:' +
                                item['value']['silver'].toString() + 'S:' +
                                item['value']['copper'].toString() + 'C'
                        ),
                      );
                    }).toList()
                ),
              ),
            );
          }).toList(),
        )
      ],
      shrinkWrap: true,
    );
  }

  bool validateSaveForm(BuildContext context) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submitCampaign(BuildContext context) async {
    if (validateSaveForm(context)){
      Map<String, dynamic> campaign = {
        'campaignName': _campaignName,
        'vendors': _vendors,
      };
      createCampaign(widget.uid, campaign);
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
          onPressed: () => _submitCampaign(context),
        )
      ],
    );
  }

}