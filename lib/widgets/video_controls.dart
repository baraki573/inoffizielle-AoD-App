import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/player.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;


class VideoControls extends StatefulWidget {
  final PlayerState playerState;
  VideoControls(this.playerState);

  @override
  State<StatefulWidget> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {

  void jumpTo(TapDownDetails details){
    print('seek triggered');
    widget.playerState.initDelayedControlsHide();
    int seconds = (details.localPosition.dx*1.1) ~/ ((MediaQuery.of(context).size.width-100)/100)*(playerCache.controller.value.duration.inSeconds/100).floor();
    playerCache.controller.seekTo(Duration(seconds: seconds));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int positionSeconds = playerCache.controller.value.position.inSeconds == null ? 0 : playerCache.controller.value.position.inSeconds;
    int durationSeconds = playerCache.controller.value.duration == null ? 0 : playerCache.controller.value.duration.inSeconds;
    TextStyle timeStyle = TextStyle(
      color: Colors.white,
    );
    if(!widget.playerState.showControls){
      return Positioned(child: Container());
    }
    return Positioned(
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
            padding: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56,0.5),
            ),
            child:  Column(
                children: [
                  Row (
                    children: [
                      Container(
                          width: 70,
                          child: positionSeconds >= 3600?
                          Text(
                            (positionSeconds/3600).floor().toString()+':'+(positionSeconds%60>9?(((positionSeconds%3600)/60).floor().toString()):'0'+((positionSeconds%3600)/60).floor().toString())+':'+(positionSeconds%60>9?(positionSeconds%60).toString():'0'+(positionSeconds%60).toString()),
                            style: timeStyle,
                            textAlign: TextAlign.center,
                          ):
                          Text(
                            (positionSeconds/60).floor().toString()+':'+(positionSeconds%60>9?(positionSeconds%60).toString():'0'+(positionSeconds%60).toString()),
                            style: timeStyle,
                            textAlign: TextAlign.center,
                          )
                      ),

                      //width: MediaQuery.of(context).size.width - 102,
                      GestureDetector(
                        onTapDown: jumpTo,
                        child: Row(
                            children: [
                              Container(
                                transform: Matrix4.skewX(-0.5),
                                width: (positionSeconds / (durationSeconds/100))*((MediaQuery.of(context).size.width-142)/100),
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(171, 191, 57, 1),
                                ),
                              ),
                              Container(
                                width: (100 - (positionSeconds / (durationSeconds/100)))*((MediaQuery.of(context).size.width-142)/100),
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(53, 54, 56,0)
                                ),
                              ),
                            ]
                        ),
                      ),


                      Container(
                          width: 70,
                          child: durationSeconds >= 3600?
                          Text(
                              (durationSeconds/3600).floor().toString()+':'+(durationSeconds%60<=9?(((durationSeconds%3600)/60).floor().toString()):'0'+((durationSeconds%3600)/60).floor().toString())+':'+(durationSeconds%60>9?(durationSeconds%60).toString():'0'+(durationSeconds%60).toString()),
                              style: timeStyle,
                              textAlign: TextAlign.center
                          ):
                          Text(
                              (durationSeconds/60).floor().toString()+':'+(durationSeconds%60>9?(durationSeconds%60).toString():'0'+(durationSeconds%60).toString()),
                              style: timeStyle,
                              textAlign: TextAlign.center
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          playerCache.controller.seekTo(Duration(seconds: playerCache.controller.value.position.inSeconds-30));
                          setState(() {
                            widget.playerState.initDelayedControlsHide();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.replay_30,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          playerCache.controller.seekTo(Duration(seconds: playerCache.controller.value.position.inSeconds-10));
                          setState(() {
                            widget.playerState.initDelayedControlsHide();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.replay_10,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          playerCache.controller.value.isPlaying && playerCache.timeTrackThread.isActive
                              ? playerCache.timeTrackThread.cancel()
                              : playerCache.timeTrackThread = Timer.periodic(Duration(seconds: 30), widget.playerState.sendAodTrackingRequest);
                          playerCache.controller.value.isPlaying?playerCache.controller.pause():playerCache.controller.play();
                          setState(() {
                            widget.playerState.initDelayedControlsHide();
                            widget.playerState.saveEpisodeProgress();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              playerCache.controller.value.isPlaying?Icons.pause:Icons.play_arrow,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(playerCache.controller.value.duration.inSeconds <= playerCache.controller.value.position.inSeconds+10){
                            this.widget.playerState.jumpToNextEpisode();
                          }else {
                            playerCache.controller.seekTo(Duration(seconds: playerCache.controller
                                .value.position.inSeconds + 10));
                            setState(() {
                              widget.playerState.initDelayedControlsHide();
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.forward_10,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(playerCache.controller.value.duration.inSeconds <= playerCache.controller.value.position.inSeconds+30){
                            this.widget.playerState.jumpToNextEpisode();
                          }else{
                            playerCache.controller.seekTo(Duration(seconds: playerCache.controller.value.position.inSeconds+30));
                            setState(() {
                              widget.playerState.initDelayedControlsHide();
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.forward_30,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.playerState.jumpToNextEpisode();
                          //setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.skip_next,
                              color: Colors.white
                          ),
                        ),
                      )
                    ],
                  )
                ]
            )
        )
    );
  }

}