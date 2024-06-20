import 'package:assets/models/company_model.dart';
import 'package:assets/utils/assets.dart';
import 'package:assets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CompanyItem extends StatelessWidget {
  const CompanyItem({
    required this.company,
    super.key,
  });
  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/assets',
          arguments: company.id,
        );
      },
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: MainColors.secondary,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 26,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.menuItem,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              company.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
