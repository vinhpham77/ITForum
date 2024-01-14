import 'package:flutter/material.dart';
import 'package:cay_khe/models/tag.dart';

class TagDropdown extends StatefulWidget {
  final String label;
  final List<Tag> tags;
  final Function(Tag) onTagSelected;

  const TagDropdown({super.key, required this.tags, required this.onTagSelected, required this.label});

  @override
  State<TagDropdown> createState() => _TagDropdownState();
}

class _TagDropdownState extends State<TagDropdown> {
  final TextEditingController tagController = TextEditingController();
  Tag? selectedTag;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<Tag>> tagEntries = widget.tags.map((Tag tag) {
      return DropdownMenuEntry<Tag>(
        value: tag,
        labelWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${tag.name}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              maxLines: 1,
            ),
            Text(
              tag.description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
              softWrap: true,
            ),
          ],
        ),
        label: tag.name,
      );
    }).toList();

    return DropdownMenu<Tag>(
      controller: tagController,
      menuHeight: 320,
      enableFilter: true,
      initialSelection: null,
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      hintText: widget.label,
      dropdownMenuEntries: tagEntries,
      onSelected: (Tag? tag) {
        widget.onTagSelected(tag!);
        setState(() {
          tagController.text = '';
        });
      },
    );
  }
}
