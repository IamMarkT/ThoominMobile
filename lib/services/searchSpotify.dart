import 'package:spotify/spotify_io.dart';
import 'dart:io';
import 'dart:convert';


class SearchSpotify{
  Future<void> getArtist() async{
    try {
      String clientSecret = 'dc14074b6de442e0a07b790237247690';
      String clientId = '4b300f4c49d446289dc95fdb9c8a1069';

      var credentials = new SpotifyApiCredentials(clientId, clientSecret);
      var spotify = new SpotifyApi(credentials);

      print("\nSearching for \'Metallica\':");
      var search = await spotify.search
          .get("metallica")
          .first(2)
          .catchError((err) => print((err as SpotifyException).message));
      if (search == null) {
        print('ERROR');
        return;
      }
      search.forEach((pages) {
        pages.items.forEach((item) {
          if (item is PlaylistSimple) {
            print('Playlist: \n'
                'id: ${item.id}\n'
                'name: ${item.name}:\n'
                'collaborative: ${item.collaborative}\n'
                'href: ${item.href}\n'
                'trackslink: ${item.tracksLink.href}\n'
                'owner: ${item.owner}\n'
                'public: ${item.owner}\n'
                'snapshotId: ${item.snapshotId}\n'
                'type: ${item.type}\n'
                'uri: ${item.uri}\n'
                'images: ${item.images.length}\n'
                '-------------------------------');
          }
          if (item is Artist) {
            print('Artist: \n'
                'id: ${item.id}\n'
                'name: ${item.name}\n'
                'href: ${item.href}\n'
                'type: ${item.type}\n'
                'uri: ${item.uri}\n'
                '-------------------------------');
          }
          if (item is TrackSimple) {
            print('Track:\n'
                'id: ${item.id}\n'
                'name: ${item.name}\n'
                'href: ${item.href}\n'
                'type: ${item.type}\n'
                'uri: ${item.uri}\n'
                'isPlayable: ${item.isPlayable}\n'
                'artists: ${item.artists.length}\n'
                'availableMarkets: ${item.availableMarkets.length}\n'
                'discNumber: ${item.discNumber}\n'
                'trackNumber: ${item.trackNumber}\n'
                'explicit: ${item.explicit}\n'
                '-------------------------------');
          }
          if (item is AlbumSimple) {
            print('Album:\n'
                'id: ${item.id}\n'
                'name: ${item.name}\n'
                'href: ${item.href}\n'
                'type: ${item.type}\n'
                'uri: ${item.uri}\n'
                'albumType: ${item.albumType}\n'
                'artists: ${item.artists.length}\n'
                'availableMarkets: ${item.availableMarkets.length}\n'
                'images: ${item.images.length}\n'
                '-------------------------------');
          }
        });
      });
    }
    catch(e){
      print('caught error: $e');
    }
  }
}