import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<NotificationItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _isRefreshing = true);
    } else {
      setState(() => _isLoading = true);
    }

    final items = await NotificationService.fetchNotifications();
    if (!mounted) return;

    setState(() {
      _items = items;
      _isLoading = false;
      _isRefreshing = false;
    });
  }

  Future<void> _markRead(NotificationItem item) async {
    if (item.isRead) return;

    final success = await NotificationService.markRead(item.id);
    if (!mounted || !success) return;

    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? NotificationItem(
                    id: current.id,
                    type: current.type,
                    title: current.title,
                    body: current.body,
                    relatedPostId: current.relatedPostId,
                    relatedChatRoomId: current.relatedChatRoomId,
                    isRead: true,
                    createdAt: current.createdAt,
                  )
                : current,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/ic_back.svg',
            width: 18,
            height: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          '알림',
          style: AppTypography.b2.copyWith(color: AppColors.textDark),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const _NotificationEmptyState()
              : RefreshIndicator(
                  onRefresh: () => _loadNotifications(isRefresh: true),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _NotificationListTile(
                        item: item,
                        onTap: () => _markRead(item),
                      );
                    },
                  ),
                ),
      floatingActionButton: _isRefreshing
          ? null
          : FloatingActionButton.small(
              onPressed: () => _loadNotifications(isRefresh: true),
              backgroundColor: AppColors.white,
              elevation: 2,
              child: const Icon(
                Icons.refresh,
                color: AppColors.textDark,
                size: 18,
              ),
            ),
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_notification_empty.svg',
            width: 110,
            height: 110,
          ),
          const SizedBox(height: 38),
          Text(
            '받은 새 소식이 없어요.',
            style: AppTypography.h3.copyWith(
              color: const Color(0xFFA4A7AE),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationListTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationListTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isRead ? AppColors.bgPage : const Color(0xFFEFF8FF),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: item.isRead ? Colors.transparent : AppColors.primary,
                  shape: BoxShape.circle,
                  border: item.isRead
                      ? Border.all(color: AppColors.border)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title.isEmpty ? '알림' : item.title,
                            style: AppTypography.b4.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.createdAt,
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.body,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textMedium,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
