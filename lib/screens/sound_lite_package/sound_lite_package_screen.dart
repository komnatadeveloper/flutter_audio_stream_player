import 'package:flutter/material.dart';

// Widget
import '../../widgets/audio_stream_player_via_sound_lite.dart';

class SoundLitePackageScreen extends StatelessWidget {
  const SoundLitePackageScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_sound_lite package'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: AudioStreamPlayerViaSoundLite()
        ),
      ),
      
    );
  }
}