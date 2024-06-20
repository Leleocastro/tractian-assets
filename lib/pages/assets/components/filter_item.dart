import 'package:assets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterItem extends StatefulWidget {
  const FilterItem({
    required this.title,
    required this.assetIcon,
    required this.onChanged,
    super.key,
  });
  final String title;
  final String assetIcon;
  final ValueChanged<bool> onChanged;

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onChanged(_isSelected);
      },
      borderRadius: BorderRadius.circular(3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isSelected ? MainColors.secondary : null,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            width: 1,
            color: _isSelected ? MainColors.secondary : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.assetIcon,
              height: 13,
              colorFilter: ColorFilter.mode(
                _isSelected ? Colors.white : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                color: _isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
