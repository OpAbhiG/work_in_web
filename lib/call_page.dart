import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'common.dart';

class CallPage extends StatelessWidget {
  final String localUserId;
  final String id;
  const CallPage({super.key,
    required this.id,
    required this.localUserId});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      /////////////////////////////// zego id

      appID: 1663527651,
      appSign: "7e19617938c7d4aae5e8aac866475d2ce4f1be465b7ad23640b6009fe975e19e",

      //////////////////////////////
      userID: 'user_id',
      userName: '$localUserId',
      callID: id,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()

      /// support minimizing
        ..topMenuBar.isVisible = true
        ..topMenuBar.buttons = [
          ZegoCallMenuBarButtonName.minimizingButton,
          ZegoCallMenuBarButtonName.showMemberListButton,
          // ZegoCallMenuBarButtonName.soundEffectButton,
        ]
        ..avatarBuilder = customAvatarBuilder,
    );
  }
}
