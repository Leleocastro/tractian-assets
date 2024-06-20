import 'package:flutter/material.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Buscar Ativo ou Local',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
          ),
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
