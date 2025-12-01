import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor_e_commerce_app/core/models/rate_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import '../../../models/product_model.dart';

class ProductReviewsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = LanguageHelper.isArabic();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? S.of(context).product_reviews_ar : S.of(context).product_reviews_en,
          semanticsLabel: isArabic ? S.of(context).product_reviews_ar : S.of(context).product_reviews_en,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(context, theme, isArabic),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, bool isArabic) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildReviewsSummary(context, theme, isArabic),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Divider(color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        product.rates.isEmpty
            ? SliverFillRemaining(
          child: _buildEmptyState(context, theme),
        )
            : SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final rate = product.rates[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _buildReviewCard(context, rate, theme, isArabic),
                ),
              );
            },
            childCount: product.rates.length,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 64,
            color: theme.colorScheme.secondary.withOpacity(0.5),
            semanticLabel: 'No reviews icon',
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).no_reviews,
            style: AppStyles.bold20(context).copyWith(
              color: theme.colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSummary(BuildContext context, ThemeData theme, bool isArabic) {
    final averageRating = product.rates.isEmpty
        ? 0.0
        : product.rates.map((e) => e.rate).reduce((a, b) => a + b) / product.rates.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary.withOpacity(0.2), theme.colorScheme.secondary.withOpacity(0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: AppStyles.bold32(context).copyWith(
                  color: theme.colorScheme.primary,
                ),
                semanticsLabel: 'Average rating: $averageRating',
              ),
              const SizedBox(height: 4),
              RatingStars(
                value: averageRating,
                starCount: 5,
                starSize: 20,
                valueLabelVisibility: false,
                starColor: theme.colorScheme.secondary,
                starOffColor: theme.colorScheme.onSurface.withOpacity(0.3),
                maxValue: 5.0,
              ),
              const SizedBox(height: 8),
              Text(
                '${product.rates.length} ${S.of(context).review}',
                style: AppStyles.semiBold16(context).copyWith(),
              ),
            ],
          ),
          Container(
            height: 60,
            width: 1,
            color: theme.dividerColor.withOpacity(0.3),
          ),
          Column(
            children: List.generate(
              5,
                  (index) => _buildRatingBar(context, 5 - index, theme, isArabic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, int rating, ThemeData theme, bool isArabic) {
    final count = product.rates.where((rate) => rate.rate == rating).length;
    final percentage = product.rates.isEmpty ? 0 : (count / product.rates.length) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rating',
            style: AppStyles.semiBold14(context).copyWith(),
          ),
          const SizedBox(width: 8),
          Icon(Icons.star, size: 16, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${percentage.round()}%',
            style: AppStyles.semiBold14(context).copyWith(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, RateModel rate, ThemeData theme, bool isArabic) {
    return Card(
      elevation: 3,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _ReviewCardContent(rate: rate, theme: theme, isArabic: isArabic),
      ),
    );
  }
}

class _ReviewCardContent extends StatefulWidget {
  final RateModel rate;
  final ThemeData theme;
  final bool isArabic;

  const _ReviewCardContent({
    required this.rate,
    required this.theme,
    required this.isArabic,
  });

  @override
  _ReviewCardContentState createState() => _ReviewCardContentState();
}

class _ReviewCardContentState extends State<_ReviewCardContent> {
  bool _isCommentExpanded = false;
  bool _isReplyExpanded = false;
  bool _isReplyVisible = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = 3;
    final hasLongComment = (widget.rate.comment?.length ?? 0) > 100;
    final hasReply = widget.rate.replay != null && widget.rate.replay!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User avatar, name, rating, and date
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                widget.rate.userName.isNotEmpty ? widget.rate.userName[0].toUpperCase() : '?',
                style: AppStyles.bold16(context).copyWith(
                  color: widget.theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.rate.userName,
                          style: AppStyles.bold20(context).copyWith(),
                          overflow: TextOverflow.ellipsis,
                          semanticsLabel: 'Reviewer: ${widget.rate.userName}',
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd(widget.isArabic ? 'ar' : 'en').format(widget.rate.createdAt),
                        style: AppStyles.semiBold14(context).copyWith(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RatingStars(
                    value: widget.rate.rate.toDouble(),
                    starCount: 5,
                    starSize: 18,
                    valueLabelVisibility: false,
                    starColor: widget.theme.colorScheme.secondary,
                    starOffColor: widget.theme.colorScheme.onSurface.withOpacity(0.3),
                    maxValue: 5.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Comment with Read More
        if (widget.rate.comment != null && widget.rate.comment!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Text(
                  widget.rate.comment!,
                  maxLines: _isCommentExpanded ? null : maxLines,
                  overflow: _isCommentExpanded ? null : TextOverflow.ellipsis,
                  style: AppStyles.semiBold18(context).copyWith(
                    height: 1.4,
                  ),
                  semanticsLabel: 'Comment: ${widget.rate.comment}',
                ),
              ),
              if (hasLongComment)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isCommentExpanded = !_isCommentExpanded;
                    });
                  },
                  child: Text(
                    _isCommentExpanded
                        ? S.of(context).read_less
                        :  S.of(context).read_more,
                    style: AppStyles.semiBold16(context).copyWith(
                      color: widget.theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        // Admin Reply Toggle Button
        if (hasReply)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextButton.icon(
                icon: Icon(
                  _isReplyVisible ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: widget.theme.colorScheme.primary,
                ),
                label: Text(
                  _isReplyVisible
                      ? (widget.isArabic ? 'إخفاء رد الأدمن' : 'Hide Admin Reply')
                      : (widget.isArabic ? 'عرض رد الأدمن' : 'Show Admin Reply'),
                  style: AppStyles.semiBold16(context).copyWith(
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isReplyVisible = !_isReplyVisible;
                  });
                },
              ),
              // Admin Reply with Read More
              if (_isReplyVisible)
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.theme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              size: 18,
                              color: widget.theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              S.of(context).admin_reply,
                              style: AppStyles.bold16(context).copyWith(
                                color: widget.theme.colorScheme.primary,
                              ),
                              semanticsLabel: 'Admin reply',
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.rate.replay!,
                          maxLines: _isReplyExpanded ? null : maxLines,
                          overflow: _isReplyExpanded ? null : TextOverflow.ellipsis,
                          style: AppStyles.semiBold16(context).copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                          semanticsLabel: 'Admin reply: ${widget.rate.replay}',
                        ),
                        if (widget.rate.replay!.length > 100)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isReplyExpanded = !_isReplyExpanded;
                              });
                            },
                            child: Text(
                              _isReplyExpanded
                                  ? (widget.isArabic ? 'عرض أقل' : 'Read Less')
                                  : (widget.isArabic ? 'اقرأ المزيد' : 'Read More'),
                              style: AppStyles.semiBold16(context).copyWith(
                                color: widget.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}