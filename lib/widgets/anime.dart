/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/episode.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/test/connection.dart';
import 'package:unoffical_aod_app/test/consts.dart';
import 'package:unoffical_aod_app/test/moor.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:html_unescape/html_unescape.dart';

class AnimeWidget extends StatefulWidget {
  final Anime anime;

  AnimeWidget(this.anime);

  @override
  State<StatefulWidget> createState() => AnimeWidgetState(this.anime);
}

class AnimeWidgetState extends State<AnimeWidget> {
  Anime _anime;
  List<Episode> episodes = [];
  String _csrf;
  bool movie = false;
  bool showFullDescription = false;
  bool bootUp = true;
  int episodeIndex = 0;
  List<FocusNode> germanFocusNodes = [];
  List<FocusNode> omuFocusNodes = [];
  FocusNode readMoreFocusNode;
  FocusNode backFocusNode;
  FocusNode mainFocusNode;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    this.generateFixedFocusNode();
    super.initState();
  }

  void generateFixedFocusNode() {
    this.readMoreFocusNode =
        FocusNode(onKey: (FocusNode focusNode, RawKeyEvent keyEvent) {
      if (Platform.isAndroid &&
          keyEvent.data is RawKeyEventDataAndroid &&
          keyEvent.runtimeType == RawKeyUpEvent) {
        RawKeyEventDataAndroid rawKeyEventData = keyEvent.data;
        FocusScopeNode focusScope = FocusScope.of(context);
        switch (rawKeyEventData.keyCode) {
          case KEY_DOWN:
            focusScope.requestFocus(this.germanFocusNodes.first);
            RenderBox box =
                this.germanFocusNodes.first.context.findRenderObject();
            this._scrollController.jumpTo(
                this._scrollController.position.pixels +
                    box.localToGlobal(Offset.zero).dy -
                    (MediaQuery.of(context).size.height * 0.5));
            break;
          case KEY_UP:
            focusScope.requestFocus(this.backFocusNode);
            break;
          case KEY_CENTER:
            this.showFullDescription = !this.showFullDescription;
            break;
          case KEY_MEDIA_PLAY_PAUSE:
            this.continueSeries();
            break;
          case KEY_BACK:
            Navigator.pop(context);
            return KeyEventResult.handled;
        }
        setState(() {});
      }
      return KeyEventResult.handled;
    });
    this.backFocusNode =
        FocusNode(onKey: (FocusNode focusNode, RawKeyEvent keyEvent) {
      if (Platform.isAndroid &&
          keyEvent.data is RawKeyEventDataAndroid &&
          keyEvent.runtimeType == RawKeyUpEvent) {
        RawKeyEventDataAndroid rawKeyEventData = keyEvent.data;
        FocusScopeNode focusScope = FocusScope.of(context);
        switch (rawKeyEventData.keyCode) {
          case KEY_DOWN:
            focusScope.requestFocus(this.readMoreFocusNode);
            setState(() {});
            RenderBox box = this.readMoreFocusNode.context.findRenderObject();
            this._scrollController.jumpTo(
                this._scrollController.position.pixels +
                    box.localToGlobal(Offset.zero).dy -
                    (MediaQuery.of(context).size.height * 0.5));
            break;
          case KEY_MEDIA_PLAY_PAUSE:
            this.continueSeries();
            break;
          case KEY_CENTER:
            Navigator.pop(context);
            break;
        }
      }
      return KeyEventResult.handled;
    });
  }

  void handleKeys(int keyCode) {
    print('episodeIndex before: $episodeIndex');
    if (keyCode == KEY_DOWN) {
      if (this.episodeIndex < (this.episodes.length - 1)) {
        this.episodeIndex++;
      }
    } else if (keyCode == KEY_UP) {
      if (episodeIndex > 0) {
        this.episodeIndex--;
      } else {
        print('try to jump to readmore');
        FocusScope.of(context).requestFocus(this.readMoreFocusNode);
        setState(() {});
        RenderBox box = this.readMoreFocusNode.context.findRenderObject();
        this._scrollController.jumpTo(this._scrollController.position.pixels +
            box.localToGlobal(Offset.zero).dy -
            (MediaQuery.of(context).size.height * 0.5));
      }
    }
  }

  void generateEpisodesFocusNodes() {
    this.germanFocusNodes.clear();
    this.omuFocusNodes.clear();
    this.episodes.forEach((_) {
      this
          .germanFocusNodes
          .add(FocusNode(onKey: (FocusNode focusNode, RawKeyEvent keyEvent) {
        if (Platform.isAndroid &&
            keyEvent.data is RawKeyEventDataAndroid &&
            keyEvent.runtimeType == RawKeyUpEvent) {
          RawKeyEventDataAndroid rawKeyEventData = keyEvent.data;
          if (rawKeyEventData.keyCode == KEY_BACK) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          } else if (rawKeyEventData.keyCode == KEY_RIGHT) {
            FocusScope.of(context)
                .requestFocus(this.omuFocusNodes[this.episodeIndex]);
            return KeyEventResult.ignored;
          } else if (rawKeyEventData.keyCode == KEY_CENTER) {
            Episode episode = this.episodes[episodeIndex];
            if (episode.languages.indexOf('Deutsch') != -1) {
              Navigator.pushNamed(context, '/player',
                  arguments: PlayerTransfer(
                      episode,
                      episode.languages.indexOf('Deutsch'),
                      this._csrf,
                      this._anime,
                      this.episodeIndex,
                      this.episodes.length,
                      false));
            }
            return KeyEventResult.handled;
          } else if (rawKeyEventData.keyCode == KEY_MEDIA_PLAY_PAUSE) {
            this.continueSeries();
            return KeyEventResult.handled;
          } else {
            int oldIndex = this.episodeIndex;
            handleKeys(rawKeyEventData.keyCode);
            if (this.episodeIndex == oldIndex) {
              return KeyEventResult.ignored;
            }
          }
          setState(() {});
          FocusScope.of(context)
              .requestFocus(this.germanFocusNodes[this.episodeIndex]);
          RenderBox box = this
              .germanFocusNodes[this.episodeIndex]
              .context
              .findRenderObject();
          this._scrollController.jumpTo(this._scrollController.position.pixels +
              box.localToGlobal(Offset.zero).dy -
              (MediaQuery.of(context).size.height * 0.5));
        }
        return KeyEventResult.handled;
      }));
      this
          .omuFocusNodes
          .add(FocusNode(onKey: (FocusNode focusNode, RawKeyEvent keyEvent) {
        if (Platform.isAndroid &&
            keyEvent.data is RawKeyEventDataAndroid &&
            keyEvent.runtimeType == RawKeyUpEvent) {
          RawKeyEventDataAndroid rawKeyEventData = keyEvent.data;
          if (rawKeyEventData.keyCode == KEY_BACK) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          } else if (rawKeyEventData.keyCode == KEY_LEFT) {
            FocusScope.of(context)
                .requestFocus(this.germanFocusNodes[this.episodeIndex]);
            setState(() {});
            return KeyEventResult.handled;
          } else if (rawKeyEventData.keyCode == KEY_CENTER) {
            Episode episode = this.episodes[episodeIndex];
            if (episode.languages.indexOf('Japanisch (UT)') != -1) {
              Navigator.pushNamed(context, '/player',
                  arguments: PlayerTransfer(
                      episode,
                      episode.languages.indexOf('Japanisch (UT)'),
                      this._csrf,
                      this._anime,
                      this.episodeIndex,
                      this.episodes.length,
                      false));
            }
          } else if (rawKeyEventData.keyCode == KEY_MEDIA_PLAY_PAUSE) {
            this.continueSeries();
            return KeyEventResult.handled;
          } else {
            int oldIndex = this.episodeIndex;
            handleKeys(rawKeyEventData.keyCode);
            if (this.episodeIndex == oldIndex) {
              return KeyEventResult.handled;
            }
          }
          setState(() {});
          FocusScope.of(context)
              .requestFocus(this.omuFocusNodes[this.episodeIndex]);
          RenderBox box =
              this.omuFocusNodes[this.episodeIndex].context.findRenderObject();
          this._scrollController.jumpTo(this._scrollController.position.pixels +
              box.localToGlobal(Offset.zero).dy -
              (MediaQuery.of(context).size.height * 0.5));
        }
        return KeyEventResult.handled;
      }));
    });
  }

  Future getAnime() async {
    print('get anime init');
    http.Response res;
    try {
      res = await http.get(
          Uri.tryParse(
              'https://anime-on-demand.de/anime/' + this._anime.id.toString()),
          headers: headerHandler.getHeaders());
    } catch (exception) {
      connectionError = true;
      return false;
    }
    if (!res.body.contains("anime-top-image")) {
      Navigator.pop(context, false);
      return;
    }
    dom.Document doc = parse(res.body);
    headerHandler.decodeCookiesString(res.headers['set-cookie']);
    this._csrf =
        doc.querySelector('meta[name=csrf-token]').attributes['content'];
    List<dom.Element> episodesRaw =
        doc.querySelectorAll('div.three-box.episodebox.flip-container');
    if (episodesRaw.isEmpty) {
      movie = true;
      episodesRaw = doc.querySelectorAll('.two-column-container');
    }
    this._anime.imageUrl = doc
        .querySelector('img.fullwidth-image.anime-top-image')
        .attributes['src'];
    this._anime.description =
        parse(doc.querySelector('div[itemprop=description] > p').innerHtml)
            .documentElement
            .text
            .replaceAll('\n', '');
    var data = doc
        .getElementsByClassName("vertical-table")
        .first
        .getElementsByTagName("td");
    this._anime.year = int.parse(data[0].text);
    this._anime.genre = data[3].text;

    bool isMovie = int.tryParse(data[5].text) == null ||
        _anime.name.toLowerCase().contains(" film") ||
        _anime.name.toLowerCase().contains(" movie");
    this._anime.fsk = int.parse(data[isMovie ? 4 : 5].text);

    print('init anime episodes iterating');
    List<Episode> episodes = [];
    episodesRaw.forEach((element) {
      List<dom.Element> playButtons =
          element.querySelectorAll('input.highlight.streamstarter_html5');
      print('start anime episodes play button count');

      print('end anime episodes play button count');
      Episode tmpEpisode = Episode();
      print('start anime episodes play button parsing');
      if (playButtons.length > 0) {
        tmpEpisode.mediaId = int.tryParse(
            playButtons[0].attributes['data-playlist'].split('/')[2]);
      }
      playButtons.forEach((dom.Element playButton) {
        tmpEpisode.languages.add(playButton.attributes['value']);
        tmpEpisode.playlistUrl.add('https://anime-on-demand.de' +
            playButton.attributes['data-playlist']);
      });

      String tmpNameString;
      if (movie) {
        tmpEpisode.name = doc.querySelector('h1[itemprop=name]').text;
        tmpEpisode.imageUrl = Uri.parse(
            doc.querySelector('img.anime-top-image').attributes['src']);
      } else {
        //dom.Element content = ;
        tmpEpisode.noteText =
            element.querySelector('.episodebox-shorttext').text;
        //if (content.children.last.className.isEmpty) {
        //tmpEpisode.noteText = "TEST";//content.children.last.text;
        //}

        dom.Element content =
            element.querySelector(".besides-episodes").previousElementSibling;
        if (content.attributes["style"] != null)
          tmpEpisode.available = content.text.trim();

        tmpEpisode.imageUrl = Uri.parse(element
            .querySelector('.episodebox-image')
            .children[0]
            .attributes['src']);
        tmpNameString = element
            .querySelector('h3.episodebox-title')
            .innerHtml
            .replaceAll('<br>', ' - ');
        List<String> tmpNameList = tmpNameString.split(' - ');
        if (tmpNameList.length > 1) {
          tmpEpisode.name = tmpNameList[1];
        } else {
          tmpEpisode.name = '';
        }
        tmpEpisode.number =
            tmpNameList[0].replaceAll(RegExp('(?:OVA\ |Episode\ )'), '');

        var watched = element.querySelector('div.status-icon');
        if (watched != null)
          tmpEpisode.watched = watched.attributes["title"].toLowerCase() ==
              "diese episode hast du bereits geschaut";
      }
      print('end anime episodes play button parsing');
      episodes.add(tmpEpisode);
    });
    this.episodes = episodes;
    this.generateEpisodesFocusNodes();

    print('end anime episodes iterating');
  }

  continueSeries() {
    PlayerTransfer playerTransfer = PlayerTransfer(this.episodes[0], 0,
        this._csrf, this._anime, 0, this.episodes.length, true);
    int episodesCounter = 0;
    this.episodes.forEach((Episode episode) {
      int langCounter = 0;
      episode.languages.forEach((String lang) {
        if (episodeProgressCache
                .getEpisodeDuration(episode.mediaId, lang)
                .inSeconds >
            0) {
          playerTransfer = PlayerTransfer(episode, langCounter, this._csrf,
              this._anime, episodesCounter, episodes.length, true);
          langCounter++;
        }
      });
      episodesCounter++;
    });
    Navigator.pushNamed(context, '/player', arguments: playerTransfer);
  }

  AnimeWidgetState(Anime anime) {
    Wakelock.disable();
    this._anime = anime;
    this.getAnime().then((element) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Orientation deviceOrientation = mediaQuery.orientation;
    double width = mediaQuery.size.width;
    double padding = 0;
    if (mediaQuery.orientation == Orientation.landscape) {
      padding = width * 0.25;
    }

    if (connectionError) {
      /*showDialog(
          context: context,
          child: AnimeLoadingConnectionErrorDialog(this._anime),
      );*/
    }
    if (this.episodes.isNotEmpty) {
      HtmlUnescape unescape = HtmlUnescape();
      double firstWidth = deviceOrientation == Orientation.landscape
          ? (width - 60) * 0.25
          : (width - 30) * 0.5;
      double secondWidth = firstWidth - 5;
      int gerCount = -1;
      int japCount = -1;
      this.mainFocusNode = FocusNode();
      return RawKeyboardListener(
          focusNode: this.mainFocusNode,
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (this.mainFocusNode.hasPrimaryFocus) {
              FocusScope.of(context).requestFocus(this.backFocusNode);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(this._anime.name),
              backgroundColor: Theme.of(context).primaryColor,
              leading: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                focusNode: this.backFocusNode,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            floatingActionButton: _floatingButtonBackup(),
            body: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: ListView(controller: this._scrollController, children: [
                  Container(
                    height: deviceOrientation == Orientation.landscape
                        ? mediaQuery.size.height * 0.4
                        : width / 16 * 9,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          repeat: ImageRepeat.noRepeat,
                          image: CachedNetworkImageProvider(
                              this._anime.imageUrl,
                              scale: 0.1)),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        color: Colors.black.withOpacity(0.1),
                        child:
                            CachedNetworkImage(imageUrl: this._anime.imageUrl),
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    "${_anime.year}, FSK ${_anime.fsk}\n${_anime.genre}",
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15, top: 10),
                    child: Text(
                      showFullDescription ||
                              this._anime.description.length <= 150
                          ? this._anime.description
                          : this._anime.description.substring(0,
                                  this._anime.description.indexOf(' ', 150)) +
                              ' ...',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  this._anime.description.length > 150
                      ? Container(
                          margin: EdgeInsets.only(right: 15, left: 15),
                          child: FlatButton(
                            focusNode: this.readMoreFocusNode,
                            focusColor: Theme.of(context).accentColor,
                            onPressed: () {
                              this.showFullDescription =
                                  !this.showFullDescription;
                              this.generateFixedFocusNode();
                              setState(() {});
                            },
                            child: Text(
                              showFullDescription
                                  ? 'Weniger anzeigen'
                                  : 'Mehr anzeigen',
                              style: TextStyle(
                                  color: this.readMoreFocusNode.hasPrimaryFocus
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).accentColor),
                            ),
                          ))
                      : Container(),
                  !aboActive
                      ? Container(
                          margin: EdgeInsets.only(right: 15, left: 15, top: 10),
                          child: Text(
                            'Ohne Premium Abo hast du gegebenenfalls nur eingeschränkt Zugriff auf die Inhalte',
                            style: TextStyle(color: Colors.redAccent),
                          ))
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    height: 1,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 0, 0, 0),
                      Theme.of(context).accentColor,
                      Theme.of(context).accentColor,
                      Color.fromRGBO(0, 0, 0, 0)
                    ])),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: padding, right: padding),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: this.episodes.map((Episode episode) {
                          int gerIndex = ++gerCount;
                          int japIndex = ++japCount;
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15),
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Row(
                                        children: [
                                          _imageDescr(episode,
                                              deviceOrientation, width),
                                          Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: !this.movie
                                                    ? Text(
                                                        'Folge ${episode.number} ',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      )
                                                    : Container(),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                width: deviceOrientation ==
                                                        Orientation.landscape
                                                    ? (width - 60) * 0.25 - 10
                                                    : (width - 30) * 0.5 - 10,
                                                child: Text(
                                                  unescape
                                                      .convert(episode.name),
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                          right: 12,
                                          top: 5,
                                          child: _watched(episode)),
                                    ],
                                  ),
                                  Container(
                                      child: Row(
                                    children: [
                                      FlatButton(
                                          focusColor: Colors.white,
                                          focusNode:
                                              this.germanFocusNodes[gerIndex],
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (episode.languages
                                                    .indexOf('Deutsch') !=
                                                -1) {
                                              Navigator.pushNamed(
                                                  context, '/player',
                                                  arguments: PlayerTransfer(
                                                      episode,
                                                      0,
                                                      this._csrf,
                                                      this._anime,
                                                      gerIndex,
                                                      this.episodes.length,
                                                      true));
                                            }
                                          },
                                          child: Container(
                                            width: this
                                                    .germanFocusNodes[gerIndex]
                                                    .hasPrimaryFocus
                                                ? firstWidth - 2.5
                                                : firstWidth,
                                            margin: EdgeInsets.only(
                                                top: 2.5,
                                                left: this
                                                        .germanFocusNodes[
                                                            gerIndex]
                                                        .hasPrimaryFocus
                                                    ? 2.5
                                                    : 0,
                                                right: 2.5,
                                                bottom: 2.5),
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            decoration: BoxDecoration(
                                                color: episode.languages
                                                                .length >
                                                            0 &&
                                                        episode.languages[0] ==
                                                            'Deutsch'
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Colors.grey),
                                            child: Row(children: [
                                              Icon(Icons.play_arrow),
                                              Text(
                                                'Deutsch',
                                                textAlign: TextAlign.center,
                                              )
                                            ]),
                                          )),
                                      FlatButton(
                                          focusNode:
                                              this.omuFocusNodes[japIndex],
                                          focusColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (episode.languages.indexOf(
                                                    'Japanisch (UT)') !=
                                                -1) {
                                              Navigator.pushNamed(
                                                  context, '/player',
                                                  arguments: PlayerTransfer(
                                                      episode,
                                                      episode.languages.indexOf(
                                                          'Japanisch (UT)'),
                                                      this._csrf,
                                                      this._anime,
                                                      japIndex,
                                                      this.episodes.length,
                                                      true));
                                            }
                                          },
                                          child: Container(
                                            width: secondWidth - 2.5,
                                            margin: EdgeInsets.only(
                                              top: 2.5,
                                              left: 2.5,
                                              right: 2.5,
                                              bottom: 2.5,
                                            ),
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            decoration: BoxDecoration(
                                                color: episode.languages.indexOf(
                                                            'Japanisch (UT)') !=
                                                        -1
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Colors.grey),
                                            child: Row(children: [
                                              Icon(Icons.play_arrow),
                                              Text(
                                                'Japanisch (UT)',
                                                textAlign: TextAlign.center,
                                              )
                                            ]),
                                          ))
                                    ],
                                  )),
                                  episode.available.isNotEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            episode.available,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                      : Container()
                                ],
                              ));
                        }).toList(),
                      ))
                ])),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(this._anime.name),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Die Episodenliste wird geladen",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Bitte warten",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),
          ));
    }
  }

  Widget _imageDescr(Episode episode, deviceOrientation, width) {
    return Container(
      width: deviceOrientation == Orientation.landscape
          ? (width - 60) * 0.25
          : (width - 30) * 0.5,
      child: FlipCard(
        flipOnTouch: episode.noteText.isNotEmpty,
        front: CachedNetworkImage(
          imageUrl: 'https://' + episode.imageUrl.host + episode.imageUrl.path,
          fit: BoxFit.fill,
        ),
        back: Text(
          episode.noteText,
          style: TextStyle(fontSize: 11),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _watched(Episode episode) {
    return GestureDetector(
      onTap: () {
        episode.watched = !episode.watched;
        setState(() {});
      },
      child: Icon(
        episode.watched ? Icons.check_circle_outline : Icons.circle_outlined,
        size: 27,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _floatingButtonBackup() {
    int id = _anime.id;
    var children = <Widget>[
      FutureBuilder(
        future: Database().isFav(id),
        builder: (context, snap) {
          if (snap.hasError || !snap.hasData) return Container(height: 0);
          bool b = snap.data;

          return FloatingActionButton(
            onPressed: () async {
              if (b)
                Database().deleteEntry(id);
              else {
                var d = await getData(HOME_PAGE + "anime/${_anime.id}");
                Database().putEntry(
                  id,
                  name: d["title"],
                  image: d["image"],
                  type: d["type"],
                  prodYear: d["year"],
                  genre: d["genre"],
                  epNum: d["episodes"],
                  fsk: d["fsk"],
                );
              }
              setState(() {});
            },
            child:
                Icon(b ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
            backgroundColor: Theme.of(context).accentColor,
          );
        },
      ),
      Container(width: 10, height: 0),
      settings.playerSettings.saveEpisodeProgress && aboActive
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.play_arrow,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: continueSeries,
            )
          : Container()
    ];

    return Row(children: children, mainAxisSize: MainAxisSize.min);
  }
}
