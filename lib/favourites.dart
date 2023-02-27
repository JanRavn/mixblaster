import 'package:shared_preferences/shared_preferences.dart';

class FavouritesStore {
  final _prefs = SharedPreferences.getInstance();

  Future<List<String>> listFavourites() async {
    final prefs = await _prefs;
    final favs = prefs.getStringList("favourites");
    return favs ?? [];
  }

  Future<void> addFavourite(String fav) async {
    final prefs = await _prefs;
    final favs = prefs.getStringList("favourites") ?? [];
    favs.add(fav);
    prefs.setStringList("favourites", favs);
  }

  Future<void> saveFavourites(List<String> favs) async {
    final prefs = await _prefs;
    prefs.setStringList("favourites", favs);
  }
}