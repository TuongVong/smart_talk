import 'package:flutter/material.dart';
import 'package:smart_talk/screens/video_call_page.dart';
import 'package:smart_talk/screens/video_call_page2.dart';

class AppRoute {
  static const callingPage = '../screens/video_call_page';
  static const videoCallPage = '../screens/video_call_page2';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case callingPage:
        return MaterialPageRoute(
            builder: (_) => VideoCall(), settings: settings);
      case videoCallPage:
        return MaterialPageRoute(
            builder: (_) => const ZegoVideoCall(callID: 'room_00001',), settings: settings);
      default:
        return null;
    }
  }
}
