class Track {
  String id;
  String name;
  List<String> artists;
  String image;

  Track({this.id, this.name, this.artists, this.image});

  Track.fromJson(Map<String, dynamic> json) {
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