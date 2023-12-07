import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteSection extends StatelessWidget {
  final bool stateVote;
  final bool upVote;
  final bool downVote;
  final int score;
  final Function() onUpVote;
  final Function() onDownVote;

  const VoteSection({super.key,
    required this.stateVote,
    required this.upVote,
    required this.downVote,
    required this.score,
    required this.onUpVote,
    required this.onDownVote,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_drop_up,
              ),
              onPressed: () => !stateVote ? onUpVote() : null   ,
              iconSize: 36,
              color: upVote ? Colors.blue : null),
          Text('$score', style: const TextStyle(fontSize: 20)),
          IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              onPressed: () => !stateVote ? onDownVote() : null,
              color: downVote ? Colors.blue : null),
        ],
      ),
    );
  }
}
