// import 'package:flutter/cupertino.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   // final AgoraClient _client = AgoraClient(
//   //     agoraConnectionData: AgoraConnectionData(
//   //       appId: '<YOUR APP ID>',
//   //       channelName: '<YOUR CHANNEL NAME>',
//   //       tempToken:
//   //       '<YOUR TOKEN>',
//   //     ));
//
//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }
//
//   Future<void> _initAgora() async {
//     await _client.initialize();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Video Call'),
//           ),
//           body: SafeArea(
//             child: Stack(
//               children: [
//                 AgoraVideoViewer(
//                   client: _client,
//                   layoutType: Layout.floating,
//                   showNumberOfUsers: true,
//                 ),
//                 AgoraVideoButtons(
//                   client: _client,
//                   enabledButtons: const [
//                     BuiltInButtons.toggleCamera,
//                     BuiltInButtons.switchCamera,
//                     BuiltInButtons.callEnd,
//                     BuiltInButtons.toggleMic,
//                   ],
//                 )
//               ],
//             ),
//           )),
//     );
//   }
// }
