import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/utils/utils.dart';
import '../models/song.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? currentSong;

  List<Song> songHistory = [];

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  bool isShuffle = false;
  Repeat isRepeat = Repeat.noRepeat;
  bool isPlaying = false;

  List<Song> songs = [];

  AudioPlayer get audioPlayer => _audioPlayer;

  AudioController() {
    _audioPlayer.playingStream.listen((playing) {
      isPlaying = playing;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      totalDuration = duration ?? Duration.zero;
      //notifyListeners();
    });

    // current position
    _audioPlayer.positionStream.listen((position) {
      currentPosition = position;
      //notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        switch (isRepeat){
          case Repeat.noRepeat :
            onPause();
            break;
          case Repeat.repeatOne :
            if(currentSong!=null){
              onPlay(currentSong!);
              break;
            }else{
              onStop();
              break;
            }
          case Repeat.repeatAll :
            skipToNext();
            break;
        }
      }
    });
  }

  void setSongList(List<Song> sharedSongs) {
    songs = sharedSongs;
  }

  Future<void> setPlaylistAndPlay(List<Song> newSongs, Song startSong) async {
    if (currentSong != startSong) {
      await onPlay(startSong);
    }
    if (!isSameList(newSongs, songs)) {
      songs = newSongs;
    }
  }

  Future<void> onPlay(Song song) async {
    currentSong = song;
    if (songs.isEmpty) return;
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(song.audioURL),
          tag: MediaItem(
            id: song.audioURL,
            album: "Album",
            title: song.songName,
            artist: song.songArtist,
            artUri: Uri.file(
              "https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800",
            ),
          ),
        ),
      );
      await _audioPlayer.play();
    } catch (e) {
      throw Exception("Lỗi khi phát nhạc: $e");
    }
    notifyListeners();
  }

  Future<void> onPause() async {
    await _audioPlayer.pause();
  }

  Future<void> onResume() async {
    await _audioPlayer.play();
  }

  Future<void> onStop() async {
    currentSong = null;
    await _audioPlayer.stop();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  Future<void> skipToNext() async {

    if (songs.isEmpty || currentSong == null) return;

    songHistory.add(currentSong!);
    int currentPlayingIndex = songs.indexOf(currentSong!);

    if (isShuffle) {
      final random = Random();
      int nextIndex;
      do {
        nextIndex = random.nextInt(songs.length);
      } while (currentPlayingIndex == nextIndex && songs.length > 1);
      currentPlayingIndex = nextIndex;
    } else {
      currentPlayingIndex = (currentPlayingIndex + 1) % songs.length;
    }
    await onPlay(songs[currentPlayingIndex]);
    notifyListeners();
  }

  Future<void> skipToPrevious() async {
    if (songs.isEmpty || currentSong == null) return;

    if (songHistory.isEmpty) {
      return;
    }
    currentSong = songHistory.removeLast();
    await onPlay(currentSong!);
    notifyListeners();
  }

  void toggleShuffle() {
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (isRepeat){
      case Repeat.noRepeat :
        isRepeat = Repeat.repeatAll;
        break;
      case Repeat.repeatOne :
        isRepeat = Repeat.noRepeat;
        break;
      case Repeat.repeatAll :
        isRepeat = Repeat.repeatOne;
        break;
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      if(_audioPlayer.processingState == ProcessingState.completed && currentSong!=null){
        onPlay(currentSong!);
      }else{
        await _audioPlayer.play();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  bool isSameList(List<Song> song1, List<Song> song2) {
    if (song1.length != song2.length) return false;
    final setA = song1.map((e) => e.id).toSet();
    final setB = song2.map((e) => e.id).toSet();
    return setA.containsAll(setB);
  }
}
