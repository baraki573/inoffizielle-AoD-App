/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
class Episode {
  String name;
  String number = '';
  Uri imageUrl;
  int mediaId;
  List<String> playlistUrl = [];
  List<String> languages = [];
  String available = '';
  String noteText = '';
  bool watched = false;
}