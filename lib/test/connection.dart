import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

List<String> genres;

Future<List<String>> getGenres() async {
  var r = await http.get(Uri.parse("https://anime-on-demand.de/animes"));
  if (r.statusCode != 200) return null;

  var doc = parse(r.body);
  var d = doc.getElementsByClassName("clearfix")[1];

  genres = d
      .getElementsByClassName("inline-block-list-item clickable ")
      .map((e) => e.text.trim());
  return genres;
}

Future<Map> getData(String url) async {
  if (url == "FAV" || !url.contains("/anime/"))
    return {"title": url == "FAV" ? "Favoriten" : "AOD"};
  var r = await http.get(Uri.parse(url));
  if (r.statusCode != 200) return null;
  var doc = parse(r.body);
  if (!doc.head
      .getElementsByTagName("title")
      .first
      .text
      .contains(" bei Anime on Demand online schauen")) return null;

  var data = doc
      .getElementsByClassName("vertical-table")
      .first
      .getElementsByTagName("td");

  var title = doc.head
      .getElementsByTagName("title")
      .first
      .text
      .replaceAll(" bei Anime on Demand online schauen", "");

  bool isMovie = int.tryParse(data[5].text) == null ||
      title.toLowerCase().contains(" film") ||
      title.toLowerCase().contains(" movie");

  return {
    "title": title,
    "image": doc.body
        .getElementsByClassName("fullwidth-image anime-top-image")
        .first
        .attributes["src"],
    "type": isMovie ? "Film" : "Serie",
    "year": int.parse(data[0].text),
    "genre": data[3].text,
    "episodes": isMovie ? "1" : data[4].text.replaceAll("\n", "").trim(),
    "fsk": int.parse(data[isMovie ? 4 : 5].text),
    //"body": doc.body,
  };
}
