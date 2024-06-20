import 'package:assets/binding.dart';
import 'package:assets/pages/menu/company_controller.dart';
import 'package:assets/pages/menu/components/company_item.dart';
import 'package:assets/utils/assets.dart';
import 'package:assets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final controller = getIt<CompanyController>();

  @override
  void initState() {
    controller.fetchCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColors.primary,
        title: SvgPicture.asset(
          Assets.logo,
          width: 126,
          height: 17,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        toolbarHeight: 48,
        shadowColor: Colors.transparent,
      ),
      body: Obx(
        () {
          final loading = controller.loading;
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final companies = controller.companies;
          if (companies.isEmpty) {
            return const Center(
              child: Text('Companies not found.'),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 40,
              );
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 30,
            ),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return CompanyItem(
                company: companies[index],
              );
            },
          );
        },
      ),
    );
  }
}
