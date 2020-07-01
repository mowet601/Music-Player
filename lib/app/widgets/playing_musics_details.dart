import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:music_player/app/app_controller.dart';

class PlayingMusicsDetails extends StatefulWidget {
  @override
  _PlayingMusicsDetailsState createState() => _PlayingMusicsDetailsState();
}

class _PlayingMusicsDetailsState extends State<PlayingMusicsDetails> {
  final controller = Modular.get<AppController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Observer(
        builder: (_) {
          return ImplicitlyAnimatedReorderableList<Audio>(
            items: controller.audioManager.assetsAudioPlayer.playlist.audios,
            areItemsTheSame: (oldItem, newItem) => oldItem.path == newItem.path,
            onReorderFinished: (item, from, to, newItems) {
              controller.audioManager.modifyPosition(to, from);
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item),
                builder: (context, dragAnimation, inDrag) {
                  final t = dragAnimation.value;
                  final elevation = lerpDouble(0, 8, t);
                  final color = Color.lerp(Colors.white, Colors.white, t);
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: itemAnimation,
                    child: Material(
                      color: color,
                      elevation: elevation,
                      child: Card(
                        child: ListTile(
                          title: Text(
                            item.metas.title,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            item.metas.artist,
                            maxLines: 1,
                          ),
                          leading: Handle(
                            delay: const Duration(milliseconds: 1),
                            child: Icon(
                              Icons.list,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () => controller.audioManager
                              .playMusicOnPlaylist(index),
                          trailing: Observer(
                            builder: (_) {
                              return Icon(
                                Icons.play_circle_filled,
                                color:
                                    controller.audioManager.atualMusic.audio ==
                                            item
                                        ? Colors.green
                                        : Colors.grey,
                                size:
                                    controller.audioManager.atualMusic.audio ==
                                            item
                                        ? 35
                                        : 0,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
