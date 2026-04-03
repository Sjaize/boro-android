import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/common_app_bar.dart';
import 'trade_history_card.dart';
import 'trade_history_model.dart';
import 'trade_history_service.dart';

class TradeHistoryScreen extends StatefulWidget {
  const TradeHistoryScreen({super.key});

  @override
  State<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  final TradeService _tradeService = TradeService();
  int _selectedTab = 0;
  late Future<List<TradeHistoryItem>> _transactionsFuture;

  static const List<String> _tabs = ['내가 빌린 물건', '내가 빌려준 물건'];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final role = _selectedTab == 0 ? 'borrower' : 'lender';
    setState(() {
      _transactionsFuture = _tradeService.fetchTransactions(role: role);
    });
  }

  void _showPendingMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: CommonAppBar(
        title: '거래내역',
        showBackButton: true,
        backgroundColor: AppColors.bgPage,
        showBottomDivider: false,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          Expanded(
            child: FutureBuilder<List<TradeHistoryItem>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return _TradeHistoryErrorState(onRetry: _loadTransactions);
                }

                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return _TradeHistoryEmptyState(tabLabel: _tabs[_selectedTab]);
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return TradeHistoryCard(
                      item: item,
                      onMoreTap: () => _showPendingMessage('더보기'),
                      onReviewTap: () =>
                          _showPendingMessage(item.reviewButtonText),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_selectedTab == i) return;
                  setState(() {
                    _selectedTab = i;
                    _loadTransactions();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgPage,
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == i
                            ? AppColors.primary
                            : AppColors.divider,
                        width: _selectedTab == i ? 2 : 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _tabs[i],
                    style: AppTypography.b4.copyWith(
                      color: _selectedTab == i
                          ? AppColors.textDark
                          : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TradeHistoryErrorState extends StatelessWidget {
  const _TradeHistoryErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.textHint,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              '거래내역을 불러오지 못했습니다.',
              textAlign: TextAlign.center,
              style: AppTypography.b4.copyWith(color: AppColors.textMedium),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeHistoryEmptyState extends StatelessWidget {
  const _TradeHistoryEmptyState({required this.tabLabel});

  final String tabLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          '$tabLabel 거래내역이 아직 없습니다.',
          textAlign: TextAlign.center,
          style: AppTypography.b4.copyWith(color: AppColors.textMedium),
        ),
      ),
    );
  }
}
