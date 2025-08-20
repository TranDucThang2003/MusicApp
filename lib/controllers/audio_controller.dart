import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/song.dart';

class AudioController extends ChangeNotifier{

  final AudioPlayer _audioPlayer = AudioPlayer();

  int? currentPlayingIndex ;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isShuffle = false;
  bool isRepeat = false;
  bool isPlaying = false;

  int? previousIndex ;
  List<Song> songs = [];

  AudioController() {
    listenDuration();
    listenPlayerState();

    _audioPlayer.playingStream.listen((playing) {
      isPlaying = playing;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });

    // current position
    _audioPlayer.positionStream.listen((position) {
      currentPosition = position;
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (isRepeat && currentPlayingIndex != null) {
          onPlay(currentPlayingIndex!);
        } else {
          skipToNext();
        }
      }
    });
  }

  void setSongList(List<Song> sharedSongs) {
    songs = sharedSongs;
    notifyListeners();
  }

  Future<void> onPlay(int index) async{

    if (songs.isEmpty || index < 0 || index >= songs.length) return;

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
      currentPlayingIndex = index;
      notifyListeners();
    }catch(e){
      print("Loi khi phat nhac : $e");
    }
  }

  Future<void> onPause() async{ await _audioPlayer.pause(); }
  Future<void> onResume() async{ await _audioPlayer.play();}
  Future<void> onStop() async{ await _audioPlayer.stop(); }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void skipToNext(){
    if (songs.isEmpty || currentPlayingIndex == null) return;

    previousIndex = currentPlayingIndex!;

    if (isShuffle) {
      currentPlayingIndex = ((currentPlayingIndex! + (1 + DateTime.now().millisecond) % songs.length) % songs.length);
    } else {
      currentPlayingIndex = (currentPlayingIndex! + 1) % songs.length;
    }
    onPlay(currentPlayingIndex!);
  }

  void skipToPrevious(){
    if (songs.isEmpty || currentPlayingIndex == null) return;

    if(previousIndex!=null){
      currentPlayingIndex = previousIndex;
    }
    onPlay(currentPlayingIndex!);
  }

  void toggleShuffle(){ isShuffle = !isShuffle; }

  void toggleRepeat(){ isRepeat= !isRepeat ;}

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      isPlaying = false;
    } else {
      await _audioPlayer.play();
      isPlaying = true;
    }
  }

  void listenDuration(){
    _audioPlayer.durationStream.listen((duration){
      totalDuration = duration ?? Duration.zero;
    });
    _audioPlayer.positionStream.listen((position){
      currentPosition = position;
    });
  }

  void listenPlayerState(){
    _audioPlayer.playerStateStream.listen((state){
      if(state.processingState == ProcessingState.completed){
        if(isRepeat && currentPlayingIndex != null){
          onPlay(currentPlayingIndex!);
        }else{
          skipToNext();
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}