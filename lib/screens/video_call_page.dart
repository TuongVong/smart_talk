import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:agora_uikit/agora_uikit.dart';

import 'package:smart_talk/allConstants/all_constants.dart';

/// MultiChannel Example
class VideoCall extends StatefulWidget {
  /// Construct the [JoinChannelVideo]
  const VideoCall({Key? key}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
//  final AgoraClient client = AgoraClient(
//    agoraConnectionData: AgoraConnectionData(
//      appId: APP_ID,
//      channelName: "AZ Room",
//      tempToken: Token,
//    ),
//    enabledPermission: [Permission.camera, Permission.microphone],
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
          title: const Text('Video Call'),
          centerTitle: true,
        ),
//        body: SafeArea(
//          child: Stack(
//            children: [
//              AgoraVideoViewer(
//                client: client,
//                layoutType: Layout.floating,
//                enableHostControls: true, // Add this to enable host controls
//                showNumberOfUsers: true,
//              ),
//              AgoraVideoButtons(
//                client: client,
//                enabledButtons: const [
//                  BuiltInButtons.toggleCamera,
//                  BuiltInButtons.callEnd,
//                  BuiltInButtons.toggleMic
//                ],
//              ),
//            ],
//          ),
//        ),
      ),
    );
  }

//  Future<void> callEnd() async {
//    agoraEventHandlers:  AgoraRtcEventHandlers(
//        leaveChannel: (State) => Navigator.pop(context))
//    )
//  }

}