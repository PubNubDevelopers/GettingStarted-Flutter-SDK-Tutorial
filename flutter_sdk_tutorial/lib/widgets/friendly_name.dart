import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sdk_tutorial/providers/friendly_names.dart';
import 'package:pubnub/pubnub.dart';

import '../demo/demo_interface.dart';
import '../utils/app_state.dart';

class FriendlyNameWidget extends StatefulWidget {
  FriendlyNameWidget();

  @override
  _FriendlyNameWidget createState() => _FriendlyNameWidget();
}

class _FriendlyNameWidget extends State<FriendlyNameWidget> {
  final _controller = TextEditingController();
  bool _enabled = false;
  String _saveButtonText = "Edit";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<FriendlyNamesProvider>(context, listen: true);
    final currentName =
        product.resolveFriendlyName(AppState.deviceId.toString());
    _controller.text = currentName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "My Friendly Name:",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 5.0),
            child: TextField(
              enabled: _enabled,
              enableInteractiveSelection: _enabled,
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
              onPressed: _saveFriendlyName, child: Text(_saveButtonText)),
        ), //const Spacer(),
      ],
    );
  }

  //  User has pressed the 'Save' button.
  //  Persist the friendly name in PubNub App Context storage (this is the master record)
  //  App Context event will result in this app's UI being updated
  void _saveFriendlyName() async {
    if (_saveButtonText == "Edit") {
      //  Make the field editable
      setState(() => {_saveButtonText = "Save", _enabled = true});
    } else {
      //  Save the contents to PubNub App Context storage
      if (_controller.text.isNotEmpty) {
        setState(() => {_saveButtonText = "Edit", _enabled = false});
        var uuidMetadataInput = UuidMetadataInput(name: _controller.text);
        var result = await AppState.pubnub.instance.objects
            .setUUIDMetadata(uuidMetadataInput, uuid: AppState.deviceId);

        //  Interactive Demo only
        DemoInterface.actionCompleted("Change your friendly name");
      }
    }
  }
}
