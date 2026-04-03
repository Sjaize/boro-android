import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'package:boro_android/data/mock_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasResults = false;
  int _tabIndex = 0;

  static const List<String> _recentSearches = ['충전기', '보조배터리', '맥북', 'C타입', '정장'];
  static const List<String> _popularSearches = ['충전기', '보조배터리', '교재', '정장', '우산'];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    _focusNode.unfocus();
    setState(() => _hasResults = true);
  }

  void _removeRecent(String term) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 17),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: _onSearch,
                        onChanged: (v) {
                          if (v.isEmpty) setState(() => _hasResults = false);
                        },
                        style: AppTypography.c2.copyWith(color: AppColors.textDark),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: '필요한 물건을 검색해보세요',
                          hintStyle: AppTypography.c2.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onSearch(_controller.text),
                      child: const Icon(Icons.search, color: AppColors.primary, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _hasResults ? _buildResults() : _buildInitial(),
    );
  }

  Widget _buildInitial() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          _SectionHeader(title: '최근 검색어'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _recentSearches.map((term) => _RecentChip(
                label: term,
                onDelete: () => _removeRecent(term),
                onTap: () {
                  _controller.text = term;
                  _onSearch(term);
                },
              )).toList(),
            ),
          ),
          // 많이 찾는 검색어
          _SectionHeader(title: '많이 찾는 검색어'),
          ..._popularSearches.asMap().entries.map((e) => _PopularItem(
            rank: e.key + 1,
            term: e.value,
            onTap: () {
              _controller.text = e.value;
              _onSearch(e.value);
            },
          )),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final posts = _tabIndex == 0 ? MockData.borrowRequests : MockData.posts;
    return Column(
      children: [
        // 탭
        Row(children: [
          _TabItem(
            label: '빌려주세요',
            isActive: _tabIndex == 0,
            onTap: () => setState(() => _tabIndex = 0),
          ),
          _TabItem(
            label: '빌려드려요',
            isActive: _tabIndex == 1,
            onTap: () => setState(() => _tabIndex = 1),
          ),
        ]),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => _SearchResultCard(
              post: posts[index],
              onTap: () => Navigator.pushNamed(context, '/post-detail', arguments: posts[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: AppTypography.h3.copyWith(color: AppColors.textDark)),
        ),
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const _RecentChip({required this.label, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 9, 8, 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.textHint),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTypography.c2.copyWith(color: AppColors.textHint)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.close, size: 6, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularItem extends StatelessWidget {
  final int rank;
  final String term;
  final VoidCallback onTap;
  const _PopularItem({required this.rank, required this.term, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('$rank', style: AppTypography.b4.copyWith(color: AppColors.textDark)),
            const SizedBox(width: 13),
            Text(term, style: AppTypography.b4.copyWith(color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(label,
                style: AppTypography.b4.copyWith(
                    color: isActive ? AppColors.textDark : AppColors.textLight)),
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final PostItem post;
  final VoidCallback onTap;
  const _SearchResultCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 127,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider),
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 32),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: SizedBox(
                height: 127,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0, top: 20, right: 30,
                      child: Text(post.title,
                          style: AppTypography.b4.copyWith(color: AppColors.textDark),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Positioned(
                      left: 0, top: 43,
                      child: Row(children: [
                        Text(post.distance, style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                        Text(' · ', style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                        Text(post.timeAgo, style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                      ]),
                    ),
                    const Positioned(
                      right: 10, top: 15,
                      child: Icon(Icons.more_vert, color: AppColors.textHint, size: 18),
                    ),
                    Positioned(
                      left: 0, top: 95,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${_fmt(post.pricePerHour)}원',
                              style: AppTypography.b1.copyWith(
                                  color: AppColors.textDark, fontWeight: FontWeight.w700)),
                          Text(' / 1시간',
                              style: AppTypography.c1.copyWith(color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10, top: 95,
                      child: Row(children: [
                        const Icon(Icons.chat_bubble_outline, size: 11, color: AppColors.textLight),
                        const SizedBox(width: 2),
                        Text('0', style: AppTypography.c2.copyWith(color: AppColors.textLight)),
                        const SizedBox(width: 9),
                        const Icon(Icons.favorite_border, size: 11, color: AppColors.textLight),
                        const SizedBox(width: 2),
                        Text('0', style: AppTypography.c2.copyWith(color: AppColors.textLight)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  String _fmt(int price) => price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
