// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:smart_talk/allConstants/all_constants.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class ZegoVideoCall extends StatefulWidget {
  final String callID;
//  final String targetUserID;
  const ZegoVideoCall({
    Key? key,
    required this.callID,
//    required this.targetUserID,
  }) : super(key: key);

  @override
  State<ZegoVideoCall> createState() => _ZegoVideoCallState();
}

class _ZegoVideoCallState extends State<ZegoVideoCall> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: ZEGO_APP_ID,
        appSign: ZEGO_APP_SYGN,
        userID: "${localUserID}",
        userName: "user_${localUserID}",
        callID: widget.callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..onOnlySelfInRoom = (context) {
            Navigator.of(context).pop();
          },
      ),
    );
  }

  Widget callButton(bool isVideoCall) {
    return ZegoStartCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: getInvitesFromTextCtrl("BJc0ufgjK6cbdP3PivmYNWGwtfZ2", "Wall World"),
      iconSize: const Size(40, 40),
      buttonSize: const Size(50, 50),
      onPressed: (String code, String message, List<String> errorInvitees) {
        if (errorInvitees.isNotEmpty) {
          String userIDs = "";
          for (int index = 0; index < errorInvitees.length; index++) {
            if (index >= 5) {
              userIDs += '... ';
              break;
            }

            var userID = errorInvitees.elementAt(index);
            userIDs += userID + ' ';
          }
          if (userIDs.isNotEmpty) {
            userIDs = userIDs.substring(0, userIDs.length - 1);
          }

          var message = 'User doesn\'t exist or is offline: $userIDs';
          if (code.isNotEmpty) {
            message += ', code: $code, message:$message';
          }
          Fluttertoast.showToast(
              backgroundColor: Colors.red, msg: message);
        } else if (code.isNotEmpty) {
          Fluttertoast.showToast(
              backgroundColor: Colors.grey, msg: 'code: $code, message:$message');
        }
      },
    );
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String userID, String userName) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = userID.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: userName,
      ));
    });

    return invitees;
  }
}
