// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';


// import 'package:audioplayers/audioplayers_api.dart';

// import 'logger.dart';



// class AudioStreamPlayer extends StatefulWidget {
//   const AudioStreamPlayer({ Key? key }) : super(key: key);

//   @override
//   State<AudioStreamPlayer> createState() => _AudioStreamPlayerState();
// }


// //---------------------------- STATE  ----------------------------
// class _AudioStreamPlayerState extends State<AudioStreamPlayer> {

//   static final MethodChannel _channel =
//       const MethodChannel('xyz.luan/audioplayers')
//         ..setMethodCallHandler(platformCallHandler);



//   static Future<void> platformCallHandler(MethodCall call) async {
//     try {
//       _doHandlePlatformCall(call);
//     } catch (ex) {
//       Logger.error('Unexpected error: $ex');
//     }
//   }

//   static Future<void> _doHandlePlatformCall(MethodCall call) async {
//     final callArgs = call.arguments as Map<dynamic, dynamic>;
//     Logger.info('_platformCallHandler call ${call.method} $callArgs');

//     final playerId = callArgs['playerId'] as String;
//     final player = players[playerId];

//     if (!kReleaseMode && _isAndroid() && player == null) {
//       final oldPlayer = AudioPlayer(playerId: playerId);
//       await oldPlayer.release();
//       oldPlayer.dispose();
//       players.remove(playerId);
//       return;
//     }
//     if (player == null) {
//       return;
//     }

//     switch (call.method) {
//       case 'audio.onNotificationPlayerStateChanged':
//         final isPlaying = callArgs['value'] as bool;
//         player.notificationState =
//             isPlaying ? PlayerState.playing : PlayerState.paused;
//         break;
//       case 'audio.onDuration':
//         final millis = callArgs['value'] as int;
//         final newDuration = Duration(milliseconds: millis);
//         player._durationController.add(newDuration);
//         break;
//       case 'audio.onCurrentPosition':
//         final millis = callArgs['value'] as int;
//         final newDuration = Duration(milliseconds: millis);
//         player._positionController.add(newDuration);
//         break;
//       case 'audio.onComplete':
//         player.state = PlayerState.completed;
//         player._completionController.add(null);
//         break;
//       case 'audio.onSeekComplete':
//         final complete = callArgs['value'] as bool;
//         player._seekCompleteController.add(complete);
//         break;
//       case 'audio.onError':
//         final error = callArgs['value'] as String;
//         player.state = PlayerState.stopped;
//         player._errorController.add(error);
//         break;
//       case 'audio.onGotNextTrackCommand':
//         player.notificationService.notifyNextTrack();
//         break;
//       case 'audio.onGotPreviousTrackCommand':
//         player.notificationService.notifyPreviousTrack();
//         break;
//       default:
//         Logger.error('Unknown method ${call.method} ');
//     }
//   }








//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }