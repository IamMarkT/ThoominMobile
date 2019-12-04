class TrackQueue {
  List<Tracks> tracks;

  TrackQueue({this.tracks});

  TrackQueue.fromJson(Map<String, dynamic> json) {
    if (json['tracks'] != null) {
      tracks = new List<Tracks>();
      json['tracks'].forEach((v) {
        tracks.add(new Tracks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tracks != null) {
      data['tracks'] = this.tracks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tracks {
  String id;
  String name;
  List<String> artists;
  String image;

  Tracks({this.id, this.name, this.artists, this.image});

  Tracks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    artists = json['artists'].cast<String>();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['artists'] = this.artists;
    data['image'] = this.image;
    return data;
  }
}
