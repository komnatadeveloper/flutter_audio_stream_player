import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';


/* 
  some useful & used resources:
  // https://pub.dev/documentation/flutter_sound_lite/latest/player/FlutterSoundPlayer-class.html
  // https://github.com/Canardoux/flutter_sound/issues/482


  // some music links for testing:
  https://assets.mixkit.co/music/preview/mixkit-trip-hop-vibes-149.mp3
  http://192.168.1.23:5000/api/user/listen-recorded-voice/620850011f6773a12d8b32a6
  https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
  some audios are also below:
  https://www.soundhelix.com/audio-examples



  

*/


class AudioStreamPlayerViaSoundLite extends StatefulWidget {
  const AudioStreamPlayerViaSoundLite({ Key? key }) : super(key: key);

  @override
  _AudioStreamPlayerViaSoundLiteState createState() => _AudioStreamPlayerViaSoundLiteState();
}




//- ------------------------- STATE --------------------------------
class _AudioStreamPlayerViaSoundLiteState extends State<AudioStreamPlayerViaSoundLite> {

  late TextEditingController _textController;


  FlutterSoundPlayer? _audioPlayer;
  bool get isPlaying {
    if ( _audioPlayer == null ) {
      return false;
    }
    return _audioPlayer!.isPlaying;
  }

  Duration duration = const Duration();
  Duration position = const Duration();

  String musicStreamUrl = '';

  bool _isLoading = false;

  Future _play () async {   
    setState(() {
      _isLoading = true;
    });
    
    var tempDuration = await _audioPlayer!.startPlayer(
      fromURI: musicStreamUrl,  
      // codec: Codec.mp3,  -> if it is mp3
      whenFinished: () {
        // print('AudioPlayerComponent -> _audioPlayer!.startPlayer -> whenFinished FIRED');
        setState(() {  });
      }
    );
    if ( tempDuration != null ) {
      duration = tempDuration;
    }

    
    setState(() {  
      _isLoading = false;
    });
  }

  Future _stop () async {
    await _audioPlayer!.stopPlayer(    );
  }

  Future togglePlaying () async {
    if ( _audioPlayer!.isStopped ) {
      await _play();
    }
    else {
      await _stop();
    }
    setState(() {  });
  }

  Future _initAudioPlayer () async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession(

    );
    _audioPlayer!.onProgress!.listen(
      (e) {
        setState(() {
          position = e.position;
        });
      }
    );

    

    

    // https://github.com/Canardoux/flutter_sound/issues/482
    await _audioPlayer!.setSubscriptionDuration( const Duration(milliseconds: 150));

  }

  void _disposeAudioPlayer () {    
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }



  



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
    return Slider.adaptive(
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      
      value: position.inSeconds.toDouble(), 
      onChanged: ( double val) {
        setState(() { 
          _audioPlayer?.seekToPlayer(Duration( seconds: val.toInt() ));
        });
      }
    );
  }



  Future<void> getAudio () async {
    try {
      if ( isPlaying ) {
        await _stop();
        setState(() {  });
      } else {  // Default : is NOT playing

        if ( musicStreamUrl == '') {
          _handleShowSnackbar( 'No Url!');
          return;
        }
        await _play();

        setState(() {   });

      }

    } catch ( err ) {
      _handleShowSnackbar('ERROR!');
    }  
  }  // End of getAudio



  @override
  void initState() {
    // TODO: implement initState
    _textController = TextEditingController( text: '');
    _initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
     _disposeAudioPlayer();
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
              padding:  const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
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

                  slider(),

                  InkWell(
                    onTap: _isLoading ? null : () {
                      getAudio();
                      // _play();
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
                  _isLoading 
                      ?
                      CircularProgressIndicator()
                      :
                  IconButton(
                    onPressed: isPlaying 
                      ? 
                      () {
                        _handleShowSnackbar('PLEASE STOP MUSIC!');
                      } 
                      :
                      ( _textController.text == '' )
                        ?
                        () {
                          _handleShowSnackbar('NO URL!');
                        } 
                        :
                        () {                        
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            musicStreamUrl = _textController.text;
                            _textController.text = '';
                          });
                          getAudio();
                        }, 
                    icon: 
                      const Icon(Icons.send, color: Colors.blue,),
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
