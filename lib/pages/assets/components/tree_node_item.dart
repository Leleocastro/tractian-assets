import 'package:assets/models/asset_model.dart';
import 'package:assets/models/component_model.dart';
import 'package:assets/models/location_model.dart';
import 'package:assets/models/tree_node_model.dart';
import 'package:assets/utils/assets.dart';
import 'package:assets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TreeNodeItem extends StatefulWidget {
  final TreeNodeModel node;

  const TreeNodeItem({
    required this.node,
    super.key,
  });

  @override
  State<TreeNodeItem> createState() => _TreeNodeItemState();
}

class _TreeNodeItemState extends State<TreeNodeItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.node.children.isNotEmpty
              ? () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: widget.node.children.isNotEmpty
                      ? Icon(
                          _expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                          size: 15,
                        )
                      : const SizedBox(
                          width: 7,
                          height: 7,
                        ),
                ),
                const SizedBox(width: 2),
                SvgPicture.asset(
                  widget.node is LocationModel
                      ? Assets.location
                      : widget.node is AssetModel
                          ? Assets.asset
                          : Assets.component,
                  colorFilter: const ColorFilter.mode(
                    MainColors.secondary,
                    BlendMode.srcIn,
                  ),
                  width: 22,
                  height: 22,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      widget.node.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (widget.node is ComponentModel && (widget.node as ComponentModel).sensorType == 'energy') ...[
                  SvgPicture.asset(
                    Assets.bolt,
                    colorFilter: const ColorFilter.mode(
                      Colors.green,
                      BlendMode.srcIn,
                    ),
                    height: 11.5,
                  ),
                  const SizedBox(width: 2),
                ],
                if (widget.node is ComponentModel && (widget.node as ComponentModel).status == 'alert')
                  const CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 4,
            ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.node.children.length,
            padding: const EdgeInsets.only(left: 16),
            itemBuilder: (context, index) {
              return TreeNodeItem(node: widget.node.children[index]);
            },
          ),
      ],
    );
  }
}
