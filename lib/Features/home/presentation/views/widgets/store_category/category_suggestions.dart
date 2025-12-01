import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String? imageUrl;

  Category({required this.id, required this.name, this.imageUrl});
}

class CategorySuggestions extends StatefulWidget {
  final List<Category> categories;
  final Function(String) onCategorySelected;

  const CategorySuggestions({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategorySuggestions> createState() => _CategorySuggestionsState();
}

class _CategorySuggestionsState extends State<CategorySuggestions> {
  String selectedCategoryId = 'all';

  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = selectedCategoryId == category.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryId = category.id;
              });
              widget.onCategorySelected(category.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    darken(Theme.of(context).colorScheme.secondary, 0.18),
                    darken(Theme.of(context).colorScheme.secondary, 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected ? null : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.15 : 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.9) : Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (category.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: category.imageUrl!,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,

                        errorWidget: (context, url, error) => Icon(
                          Icons.category,
                          size: 30,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.category,
                      size: 25,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  const SizedBox(width: 6),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}