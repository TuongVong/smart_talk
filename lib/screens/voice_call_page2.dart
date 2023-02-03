import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:agora_uikit/agora_uikit.dart';

import 'package:smart_talk/allConstants/all_constants.dart';

/// MultiChannel Example
class VoiceCall extends StatefulWidget {
  /// Construct the [JoinChannelVideo]
  final String receiverName;
  const VoiceCall({Key? key, required this.receiverName}) : super(key: key);

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
//  final AgoraClient client = AgoraClient(
//    agoraConnectionData: AgoraConnectionData(
//      appId: APP_ID,
//      channelName: 'voice_room_00001',
//      tempToken: "007eJxTYDj43Nvu44Ebcw9eKasO9Ph17Oy883o2z9/Nm51g7JyW2qmiwJBkbJlsZJhqmWJkYmKSkmqWmGKYlGyaZplmlGJgamhh7indltwQyMiQkSjGyMgAgSC+AENZfmZyanxRfn5uvAEQGDIwAADZcSTR",
//    ),
//    enabledPermission: [Permission.microphone],
//  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
//    await client.initialize();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Voice Call'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: AppColors.spaceCadet,
                ),
              ),
//              AgoraVideoButtons(
//                client: client,
//                enabledButtons: const [
//                  BuiltInButtons.callEnd,
//                  BuiltInButtons.toggleMic
//                ],
//              ),
            ],
          ),
        ),
      ),
    );
  }

//  Future<void> callEnd() async {
//    agoraEventHandlers:  AgoraRtcEventHandlers(
//        leaveChannel: (State) => Navigator.pop(context))
//    )
//  }

}