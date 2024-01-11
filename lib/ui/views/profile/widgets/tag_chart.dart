import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../dtos/tag_count.dart';
import 'indicator.dart';

class TagChart extends StatelessWidget {
  final List<TagCount> tagCounts;

  const TagChart({super.key, required this.tagCounts});

  @override
  Widget build(BuildContext context) {
    List<TagCount> topTagCounts = getOnlyTop5TagCounts(tagCounts);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'XU HƯỚNG BÀI VIẾT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 12, left: 12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: Row(
              children: [
                _buildTagPieChartSections(topTagCounts),
                _buildIndicators(topTagCounts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AspectRatio _buildTagPieChartSections(List<TagCount> topTagCounts) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: PieChart(
        PieChartData(
            sections: topTagCounts
                .map((item) => PieChartSectionData(
                    color: Colors.accents[
                        topTagCounts.indexOf(item) % Colors.primaries.length],
                    value: item.count.toDouble(),
                    title: '${getTagPercent(item.tag, topTagCounts)}%',
                    titleStyle: TextStyle(
                        color: getContrastColor(Colors.accents[
                            topTagCounts.indexOf(item) %
                                Colors.primaries.length])),
                    radius: 70))
                .toList(),
            sectionsSpace: 0,
            centerSpaceRadius: 35,
            startDegreeOffset: -90),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  Column _buildIndicators(List<TagCount> topTagCounts) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in topTagCounts)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Indicator(
              color: Colors.accents[
                  topTagCounts.indexOf(item) % Colors.primaries.length],
              text: item.tag,
              isSquare: true,
            ),
          ),
      ],
    );
  }

  String getTagPercent(String tag, List<TagCount> topTagCounts) {
    final tagCount = topTagCounts.firstWhere((element) => element.tag == tag);
    final percent = tagCount.count /
        topTagCounts
            .map((e) => e.count)
            .reduce((value, element) => value + element) *
        100;
    return percent.toStringAsFixed(2);
  }

  Color getContrastColor(Color color) {
    return (color.computeLuminance() > 0.5) ? Colors.black : Colors.white;
  }

  List<TagCount> getOnlyTop5TagCounts(List<TagCount> tagCounts) {
    tagCounts.sort((a, b) => b.count.compareTo(a.count));

    List<TagCount> top5 = tagCounts.take(5).toList();

    int otherCount =
        tagCounts.skip(5).fold(0, (prev, item) => prev + item.count);

    if (otherCount > 0) {
      TagCount other = TagCount(tag: 'Khac', count: otherCount);
      top5.add(other);
    }

    return top5;
  }
}
