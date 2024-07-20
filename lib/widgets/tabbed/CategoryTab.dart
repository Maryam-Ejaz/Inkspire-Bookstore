import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../buttons/category_button.dart';

class CategoryTab extends StatelessWidget {
  final int selectedCategory;
  final Function(int) onCategorySelected;

  const CategoryTab({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < categoryList.length; i++)
            CategoryButton(
              name: categoryList[i].name,
              iconPath: categoryList[i].iconPath,
              isSelected: (i == selectedCategory),
              onTap: () => onCategorySelected(i),
            )
        ],
      ),
    );
  }
}
