import 'package:flutter/material.dart';

// Widget
import '../../widgets/audio_stream_player_via_audioplayers.dart';

class AudioPlayersPackageScreen extends StatelessWidget {
  const AudioPlayersPackageScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('audioplayers package'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: AudioStreamPlayerViaAudioplayers()
        ),
      ),
      
    );
  }
}