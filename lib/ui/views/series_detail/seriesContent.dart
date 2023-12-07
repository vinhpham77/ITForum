import 'package:cay_khe/models/sp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
class SeriesContentWidget extends StatelessWidget {
  final Sp sp;

  const SeriesContentWidget({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
        //  TagListWidget(tags: ListTag),
          BodyContentWidget(sp: sp),
        ],
      ),
    );
  }
}

class BodyContentWidget extends StatelessWidget {
  final Sp sp;

  const BodyContentWidget({super.key, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: MarkdownBody(
        data: getMarkdown(),
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          // Các style tùy chọn của bạn ở đây
          textScaleFactor: 1.4,
          h1: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 32),
          h2: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 22),
          h3: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 18),
          h6: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 13),
          p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade700,
          ),
          // Custom blockquote style
          listBullet: const TextStyle(
              fontSize: 16), // Custom list item bullet style
        ),
        softLineBreak: true,
      ),
    );
  }

  String getMarkdown() {
    String titleRaw = sp.title;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String content = sp.content;
    String tags = "#";
    return '$title \n $content';
  }
}
