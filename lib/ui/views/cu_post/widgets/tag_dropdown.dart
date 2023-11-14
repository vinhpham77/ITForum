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
        label: '#${tag.name} - ${tag.description}',
      );
    }).toList();

    return DropdownMenu<Tag>(
      controller: tagController,
      enableFilter: true,
      initialSelection: null,
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      hintText: widget.label,
      // max width as able
      width: 228,
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
