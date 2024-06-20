import 'package:assets/binding.dart';
import 'package:assets/pages/assets/assets_controller.dart';
import 'package:assets/pages/assets/components/filter_item.dart';
import 'package:assets/pages/assets/components/search_component.dart';
import 'package:assets/pages/assets/components/tree_node_item.dart';
import 'package:assets/utils/assets.dart';
import 'package:assets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({
    super.key,
  });

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final companyId = Get.arguments as String;

  final controller = getIt<AssetsController>();

  @override
  void initState() {
    controller.fetch(companyId);
    controller.listenError.listen((error) {
      if (error.isNotEmpty) {
        Get.snackbar(
          'Erro',
          error,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColors.primary,
        title: const Text('Assets'),
        toolbarHeight: 48,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchComponent(
                  onChanged: (value) {
                    controller.query = value;
                    controller.filter();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterItem(
                      title: 'Sensor de Energia',
                      assetIcon: Assets.boltOutlined,
                      onChanged: (value) {
                        if (value) {
                          controller.type = 'energy';
                        } else {
                          controller.type = '';
                        }
                        controller.filter();
                      },
                    ),
                    FilterItem(
                      title: 'Crítico',
                      assetIcon: Assets.exclamationCircle,
                      onChanged: (value) {
                        if (value) {
                          controller.status = 'alert';
                        } else {
                          controller.status = '';
                        }
                        controller.filter();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: Obx(() {
              final root = controller.root;
              final loading = controller.loading;

              if (loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (root.children.isEmpty) {
                return const Center(
                  child: Text('No assets found'),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 4,
                ),
                itemCount: root.children.length,
                itemBuilder: (context, index) {
                  return TreeNodeItem(node: root.children[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
