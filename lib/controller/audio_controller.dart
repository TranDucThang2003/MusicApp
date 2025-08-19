import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/song.dart';

class AudioController {

  final AudioPlayer _audioPlayer = AudioPlayer();

  final ValueNotifier<int?> _currentPlayingIndex = ValueNotifier(null);
  final ValueNotifier<Duration> _currentPosition = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _totalDuration = ValueNotifier(Duration.zero);
  int? _previousIndex ;
  List<Song> songs;

  bool isShuffle = false ;
  bool isRepeat = false ;

  AudioController({this.songs = const []});

  ValueNotifier<int?> get currentPlayingIndex => _currentPlayingIndex;

  Future<void> onPlay(int index) async{
    try{
      _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(songs[index].audioURL),
          tag: MediaItem(
            id: songs[index].audioURL,
            album: "Album",
            title: songs[index].songName,
            artist: songs[index].songArtist,
            artUri: Uri.parse("https://noithatbinhminh.com.vn/wp-content/uploads/2022/08/anh-dep-28.jpg"),
          ),
        ),
      );
      await _audioPlayer.play();

      _currentPlayingIndex.value = index;
    }catch(e){
      print("Loi khi phat nhac : $e");
    }
  }

  Future<void> onPause() async{
    await _audioPlayer.pause();
  }

  Future<void> onResume() async{
    await _audioPlayer.play();
  }

  Future<void> onStop() async{
    await _audioPlayer.stop();
  }

  void skipToNext(){
    _previousIndex = _currentPlayingIndex.value!;
    if (isShuffle) {
      _currentPlayingIndex.value = ((_currentPlayingIndex.value! + (1 + DateTime.now().millisecond) % songs.length) % songs.length);
    } else {
      _currentPlayingIndex.value = (_currentPlayingIndex.value! + 1) % songs.length;
    }
    onPlay(_currentPlayingIndex.value!);
  }

  void skipToPrevious(){
    if(_previousIndex!=null){
      _currentPlayingIndex.value = _previousIndex;
    }
    onPlay(_currentPlayingIndex.value!);
  }

  void setShuffle(){
    isShuffle = !isShuffle;
  }

  void setRepeat(){
    isRepeat = !isRepeat;
  }

  void listenDuration(){
    _audioPlayer.durationStream.listen((duration){
      _totalDuration.value = duration ?? Duration.zero;
    });
    _audioPlayer.positionStream.listen((position){
      _currentPosition.value = position;
    });
  }

  void listenPlayerState(){
    _audioPlayer.playerStateStream.listen((state){
      if(state.processingState == ProcessingState.completed){
        if(isRepeat && _currentPlayingIndex.value != null){
          onPlay(_currentPlayingIndex.value!);
        }else{
          skipToNext();
        }
      }
    });
  }
}