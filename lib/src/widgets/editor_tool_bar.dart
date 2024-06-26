import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rich_editor/src/utils/javascript_executor_base.dart';
import 'package:rich_editor/src/widgets/check_dialog.dart';
import 'package:rich_editor/src/widgets/fonts_dialog.dart';
import 'package:rich_editor/src/widgets/insert_image_dialog.dart';
import 'package:rich_editor/src/widgets/insert_link_dialog.dart';
import 'package:rich_editor/src/widgets/tab_button.dart';

import 'color_picker_dialog.dart';
import 'font_size_dialog.dart';
import 'heading_dialog.dart';

class EditorToolBar extends StatelessWidget {
  final Function(File image)? getImageUrl;
  final Function(File video)? getVideoUrl;
  final JavascriptExecutorBase javascriptExecutor;
  final bool? enableVideo;

  EditorToolBar({
    this.getImageUrl,
    this.getVideoUrl,
    required this.javascriptExecutor,
    this.enableVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabButton(
            tooltip: 'Insert Image',
            icon: Icons.image,
            onTap: () async {
              var link = await showDialog(
                context: context,
                builder: (_) {
                  return InsertImageDialog();
                },
              );
              if (link != null) {
                if (getImageUrl != null && link[2]) {
                  link[0] = await getImageUrl!(File(link[0]));
                }
                await javascriptExecutor.insertImage(
                  link[0],
                  alt: link[1],
                );
              }
            },
          ),
          Visibility(
            visible: enableVideo!,
            child: TabButton(
              tooltip: 'Insert video',
              icon: Icons.video_call_sharp,
              onTap: () async {
                var link = await showDialog(
                  context: context,
                  builder: (_) {
                    return InsertImageDialog(isVideo: true);
                  },
                );
                if (link != null) {
                  if (getVideoUrl != null && link[2]) {
                    link[0] = await getVideoUrl!(File(link[0]));
                  }
                  await javascriptExecutor.insertVideo(
                    link[0],
                    fromDevice: link[2],
                  );
                }
              },
            ),
          ),
          TabButton(
            tooltip: 'Strike through',
            icon: Icons.format_strikethrough,
            onTap: () async {
              await javascriptExecutor.setStrikeThrough();
            },
          ),
          TabButton(
            tooltip: 'Superscript',
            icon: Icons.superscript,
            onTap: () async {
              await javascriptExecutor.setSuperscript();
            },
          ),
          TabButton(
            tooltip: 'Subscript',
            icon: Icons.subscript,
            onTap: () async {
              await javascriptExecutor.setSubscript();
            },
          ),
        ],
      ),
    );
  }
}
