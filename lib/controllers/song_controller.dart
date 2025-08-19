import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/database.dart';
import '../models/song.dart';

class SongController extends ChangeNotifier{
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<Song> _songs = [];
  List<Song> get songs => _songs;

  Future<void> loadSongsOffline() async {
    _songs = await DatabaseHelper.instance.getSongs();
    notifyListeners();
  }

  Future<void> requestPermissionAndLoadSongs() async {
    var storageStatus = await Permission.storage.status;
    var audioStatus = await Permission.audio.status;

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (storageStatus.isGranted && audioStatus.isGranted) {
      await loadSongsFromDevices();
    } else if(Platform.isAndroid){
      await [
        Permission.storage,
        Permission.audio,
        Permission.mediaLibrary,
      ].request();
      await loadSongsFromDevices();
    }
  }

  Future<String?> saveArtworkToFile(int songId) async {
    final Uint8List? artwork = await OnAudioQuery().queryArtwork(songId, ArtworkType.AUDIO);

    if (artwork == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/artwork_$songId.png');
    await file.writeAsBytes(artwork);
    return file.path;
  }

  Future<void> loadSongsFromDevices() async {
    List<SongModel> songOnQuery = await _audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs.clear();
    for (var song in songOnQuery){
      String? artworkPath = await saveArtworkToFile(song.id);
      print(song.id);
      songs.add(
          Song(
              id: song.id,
              songName: song.title,
              songArtist: song.artist ?? "unknown",
              audioURL: song.data,
              backgroundURL: artworkPath ?? ""));
    }
    await syncSongs(songs);
    notifyListeners();
  }

  Future<void> syncSongs(List<Song> deviceSongs) async{
    for(var song in deviceSongs){
      await DatabaseHelper.instance.insertIfNotExists(song);
    }
  }

  Future<void> handleFavoriteSong(Song song) async{
    song.isFavorite = !song.isFavorite;
    notifyListeners();
    await DatabaseHelper.instance.favoriteSong(song.id, song.isFavorite);
  }
}