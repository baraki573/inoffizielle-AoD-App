/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
class Anime {
  final String name;
  String imageUrl;
  String description;
  int year;
  int fsk;
  String genre;
  final int id;
  Anime({this.name,this.imageUrl,this.description,this.id,this.year,this.genre, this.fsk});
  static Anime fromMap(Map<String,String> animeMap){

    return Anime(
        id: int.parse(animeMap['id']),
        year: animeMap.containsKey("year") ? int.tryParse(animeMap["year"]) : 2000,
        genre: animeMap.containsKey("genre") ? animeMap["genre"] : "",
        fsk: animeMap.containsKey("fsk") ? int.tryParse(animeMap["fsk"]) : 0,
        name: animeMap['name'],
        description: animeMap['description'],
        imageUrl: animeMap['imageUrl']
    );
  }
  toMap(){
    return {
      'id': this.id.toString(),
      'year': this.year.toString(),
      'genre': this.genre,
      'fsk': this.fsk,
      'name': this.name,
      'description': this.description,
      'imageUrl': this.imageUrl
    };
  }
}