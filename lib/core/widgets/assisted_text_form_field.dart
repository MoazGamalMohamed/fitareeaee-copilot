import 'package:flutter/material.dart';

class AssistedTextFormField extends StatefulWidget {
  const AssistedTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.suggestions,
    this.onSelected,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Iterable<String> suggestions;
  final ValueChanged<String>? onSelected;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  @override
  State<AssistedTextFormField> createState() => _AssistedTextFormFieldState();
}

class _AssistedTextFormFieldState extends State<AssistedTextFormField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      displayStringForOption: (option) => option,
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        if (query.length < 2) return const Iterable<String>.empty();
        return widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query))
            .take(7);
      },
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => onSubmitted(),
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            helperText:
                'Start typing for suggestions, or enter your own value.',
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.suffixIcon,
            border: const OutlineInputBorder(),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final values = options.toList(growable: false);
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280, maxWidth: 520),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: values.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final option = values[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
