class Song {
  final int id;
  final String songName;
  final String songArtist;
  final String audioURL;
  final String backgroundURL;
  bool isFavorite;

  Song({
    required this.id,
    required this.songName,
    required this.songArtist,
    required this.audioURL,
    required this.backgroundURL,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "song_name": songName,
      "song_artist": songArtist,
      "audio_url": audioURL,
      "background_url": backgroundURL,
      "is_favorite": isFavorite ? 1 : 0,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      songName: map['song_name'],
      songArtist: map['song_artist'],
      audioURL: map['audio_url'],
      backgroundURL: map['background_url'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}
