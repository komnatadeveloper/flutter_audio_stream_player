import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


/* 
  some useful & used resources:
  // https://www.youtube.com/watch?v=mvUpjwTUd0o
  // https://www.youtube.com/watch?v=h-sFLjxTm00
  // https://pub.dev/packages/audioplayers


  // some music links for testing:
  https://assets.mixkit.co/music/preview/mixkit-trip-hop-vibes-149.mp3
  http://192.168.1.23:5000/api/user/listen-recorded-voice/620850011f6773a12d8b32a6
  https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
  some audios are also below:
  https://www.soundhelix.com/audio-examples



  // IMPORTANT:
  ******* 1 *************
  for being able to use http NOT HTTPS: 
  android/app/src/main/AndroidManifest.xml -> inside 
    <application 
      android:usesCleartextTraffic="true"


  ******* 2 *************
  for being able to use without debugging mode : 
  android/app/src/main/AndroidManifest.xml -> inside 
  <manifest 
   <uses-permission android:name="android.permission.INTERNET" />


  ******* 3 *************
  android/app/build.gradle
    compileSdkVersion 31
    minSdkVersion 23
    targetSdkVersion 29


  ******* 4 *************
  android/build.gradle
  // https://stackoverflow.com/questions/70919127/your-project-requires-a-newer-version-of-the-kotlin-gradle-plugin-android-stud
    ext.kotlin_version = '1.6.10'

*/


class AudioStreamPlayerViaAudioplayers extends StatefulWidget {
  const AudioStreamPlayerViaAudioplayers({ Key? key }) : super(key: key);

  @override
  _AudioStreamPlayerViaAudioplayersState createState() => _AudioStreamPlayerViaAudioplayersState();
}




//- ------------------------- STATE --------------------------------
class _AudioStreamPlayerViaAudioplayersState extends State<AudioStreamPlayerViaAudioplayers> {

  late TextEditingController _textController;

  AudioPlayer audioPlayer =  AudioPlayer(
    mode: PlayerMode.MEDIA_PLAYER

  );
  Duration duration = const Duration();
  Duration position = const Duration();

  bool isPlaying = false;

  String musicStreamUrl = '';
  // String musicStreamUrl = 'https://assets.mixkit.co/music/preview/mixkit-trip-hop-vibes-149.mp3';



  String durationToTextConverter ( Duration d ) {
    return d.toString().split('.').first;
  }

  TextStyle timeTextStyle = const TextStyle(
    fontSize: 22,
    color: Colors.white
  );


  void _handleShowSnackbar (String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text( text,  textAlign: TextAlign.center,)
      )
    );
  }




  Widget slider () {
    try {

      return Slider.adaptive(
        min: 0.0,
        max: duration.inSeconds.toDouble() + 0.1,
        
        value: position.inSeconds.toDouble(), 
        onChanged: ( double val) {
          setState(() { 
            audioPlayer.seek(
              Duration( seconds: val.toInt() )
            );
          });
        }
      );
    } catch (err ) {
      return Text('ERROR ON SLIDER');
    }
  }



  Future<void> getAudio () async {
    try {
      if ( isPlaying ) {
        var res = await audioPlayer.pause();
        if ( res == 1 ) {
          setState(() {
            isPlaying = false;
          });
        }
      } else {  // Default : is NOT playing

        if ( musicStreamUrl == '') {
          _handleShowSnackbar( 'No Url!');
          return;
        }
        
        var res = await audioPlayer.play(
          musicStreamUrl          
        );

        if ( res == 1 ) {
          setState(() {
            isPlaying = true;
          });
        }
      }
      audioPlayer.onAudioPositionChanged.listen(
        (Duration d) { 
          setState(() {
            position = d;
          });
        }
      );

      audioPlayer.onDurationChanged.listen((Duration d) { 
        setState(() {
          duration = d;
        });
      });

      audioPlayer.onPlayerCompletion.listen(( _ ) { 
        setState(() {
          isPlaying= false;
        });
      });

    } catch ( err ) {
      _handleShowSnackbar('ERROR!');
    }  
  }  // End of getAudio



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController( text: '');
    // play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    _textController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus( FocusNode());
      },
      child: SingleChildScrollView(
        child: Column(
          children: [

            if ( musicStreamUrl == '') 
            const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12),
              child:  Text(
                'NO URL PROVIDED!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,                  
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (musicStreamUrl != '') 
             Padding(
              padding:  EdgeInsets.symmetric(vertical: 16, horizontal: 6),
              child:  Text(
                musicStreamUrl,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16, 
                  decoration: TextDecoration.underline                 
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              height: 300,
              color: Colors.orange,
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(durationToTextConverter(position), style: timeTextStyle,),
                        Text(' / ', style: timeTextStyle,),
                        Text(durationToTextConverter(duration), style: timeTextStyle,),
                      ],
                    ),
                  ),
                  const Icon( Icons.music_video, size: 150, color: Colors.blue,),

                  if (musicStreamUrl != '') 
                  slider(),
                  if (musicStreamUrl != '') 
                  InkWell(
                    onTap: () {
                      getAudio();
                    },
                    child: Icon(
                      isPlaying == false
                        ? Icons.play_circle_fill_outlined
                        : Icons.pause_circle_filled_outlined,
                      size: 50,
                      color: Colors.blue,
                    ),
                  )

                ],
              ),
            ),

            const SizedBox( height:  36,),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: isPlaying == false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      controller: _textController,
                      onChanged: (newVal) {
                        setState((){ });                        
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: isPlaying 
                      ? 
                      () {
                        _handleShowSnackbar('PLEASE STOP MUSIC!');
                      } 
                      :  
                      () {
                          musicStreamUrl = _textController.text;
                          _textController.text = '';
                        setState(() {
                        });
                        // FocusScope.of(context).requestFocus(FocusNode());
                      }, 
                    icon: const Icon(Icons.send, color: Colors.blue,),
                  )
                ],
              ),
            )            

          ],
          
        ),
      ),
    );
  }
}