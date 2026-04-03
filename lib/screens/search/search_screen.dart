import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/search/search_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _initialized = false;
  bool _hasResults = false;
  bool _isLoading = false;
  int _tabIndex = 0;
  String _currentQuery = '';
  List<SearchResultItem> _results = [];

  final List<String> _recentSearches = [
    '충전기',
    '보조배터리',
    '맥북',
    'C타입',
    '정장',
  ];

  static const List<String> _popularSearches = [
    '충전기',
    '보조배터리',
    '교재',
    '정장',
    '우산',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      _controller.text = args;
      _onSearch(args);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _focusNode.unfocus();
    setState(() {
      _hasResults = true;
      _isLoading = true;
      _currentQuery = trimmed;
      _results = [];
    });
    _fetchResults(trimmed);
  }

  Future<void> _fetchResults(String query) async {
    final preview = _previewResultsForQuery(query, _tabIndex);
    if (preview.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _results = preview;
        _isLoading = false;
      });
      return;
    }

    final postType = _tabIndex == 0 ? 'BORROW' : 'LEND';
    final apiResults = await PostService.fetchPosts(
      postType: postType,
      keyword: query,
    );

    final mockResults = _filterResults(
      _tabIndex == 0 ? MockData.borrowRequests : MockData.posts,
      query,
    );
    final filteredApiResults = _filterResults(apiResults, query);

    final merged = <PostItem>[
      ...mockResults,
      ...filteredApiResults.where(
        (apiPost) => !mockResults.any((mockPost) => mockPost.id == apiPost.id),
      ),
    ];

    if (!mounted) return;
    setState(() {
      _results = merged
          .map(
            (post) => SearchResultItem(
              id: post.id,
              title: post.title,
              distance: post.distance,
              timeAgo: post.timeAgo,
              pricePerHour: post.pricePerHour <= 0 ? 1100 : post.pricePerHour,
              chatCount: post.chatCount,
              likeCount: post.likeCount,
              thumbnail: SearchThumbnailVariant.powerbankDark,
              sourcePost: post,
            ),
          )
          .toList();
      _isLoading = false;
    });
  }

  List<PostItem> _filterResults(List<PostItem> items, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return items;

    return items.where((post) {
      final haystacks = [
        post.title,
        post.category,
        post.description,
        post.location,
      ];
      return haystacks.any(
        (value) => value.toLowerCase().contains(normalized),
      );
    }).toList();
  }

  List<SearchResultItem> _previewResultsForQuery(String query, int tabIndex) {
    final normalized = query.trim().toLowerCase();

    if (normalized.contains('보조배터리')) {
      if (tabIndex == 0) {
        return const [
          SearchResultItem(
            id: 'preview-borrow-1',
            title: '보조배터리 구해요',
            distance: '150m',
            timeAgo: '방금 전',
            pricePerHour: 1100,
            chatCount: 0,
            likeCount: 0,
            thumbnail: SearchThumbnailVariant.powerbankDark,
          ),
          SearchResultItem(
            id: 'preview-borrow-2',
            title: '보조배터리 빌려주세요',
            distance: '180m',
            timeAgo: '2분 전',
            pricePerHour: 1100,
            chatCount: 0,
            likeCount: 0,
            thumbnail: SearchThumbnailVariant.powerbankWhite,
          ),
          SearchResultItem(
            id: 'preview-borrow-3',
            title: '보조배터리 구합니다',
            distance: '250m',
            timeAgo: '2분 전',
            pricePerHour: 1100,
            chatCount: 0,
            likeCount: 0,
            thumbnail: SearchThumbnailVariant.powerbankCable,
          ),
        ];
      }

      return const [
        SearchResultItem(
          id: 'preview-lend-1',
          title: '보조배터리 빌려드립니다',
          distance: '150m',
          timeAgo: '방금 전',
          pricePerHour: 1100,
          chatCount: 0,
          likeCount: 0,
          thumbnail: SearchThumbnailVariant.powerbankCable,
        ),
        SearchResultItem(
          id: 'preview-lend-2',
          title: '보조배터리 빌려드려요',
          distance: '150m',
          timeAgo: '2분 전',
          pricePerHour: 1100,
          chatCount: 0,
          likeCount: 0,
          thumbnail: SearchThumbnailVariant.powerbankDark,
        ),
      ];
    }

    return const [];
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _hasResults = false;
      _isLoading = false;
      _currentQuery = '';
      _results = [];
    });
    _focusNode.requestFocus();
  }

  PostItem? _resolveDetailPost(SearchResultItem item) {
    if (item.sourcePost != null) return item.sourcePost;

    if (item.id.startsWith('preview-borrow-')) {
      final index =
          int.tryParse(item.id.replaceFirst('preview-borrow-', '')) ?? 1;
      const borrowIndexes = [0, 2, 4];
      final mappedIndex = borrowIndexes[(index - 1).clamp(0, borrowIndexes.length - 1)];
      return MockData.borrowRequests[mappedIndex];
    }

    if (item.id.startsWith('preview-lend-')) {
      final index = int.tryParse(item.id.replaceFirst('preview-lend-', '')) ?? 1;
      final mappedIndex = (index - 1).clamp(0, 1);
      return MockData.posts[mappedIndex];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        titleSpacing: 16,
        title: Row(
          children: [
             GestureDetector(
               onTap: () => Navigator.pop(context),
               child: SvgPicture.asset(
                 'assets/icons/ic_back.svg',
                 width: 18,
                 height: 18,
               ),
             ),
            const SizedBox(width: 12),
            Expanded(
              child: SearchInput(
                controller: _controller,
                focusNode: _focusNode,
                showHint: !_focusNode.hasFocus && _controller.text.isEmpty,
                onChanged: (value) {
                  if (value.isEmpty) _clearSearch();
                },
                onSubmitted: _onSearch,
                onSearchTap: () => _onSearch(_controller.text),
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
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchSectionHeader(title: '최근 검색어'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _recentSearches
                  .map(
                    (term) => RecentSearchChip(
                      label: term,
                      onDelete: () => setState(() => _recentSearches.remove(term)),
                      onTap: () {
                        _controller.text = term;
                        _onSearch(term);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SearchSectionHeader(title: '많이 찾는 검색어'),
          ..._popularSearches.asMap().entries.map(
                (entry) => PopularSearchRow(
                  rank: entry.key + 1,
                  label: entry.value,
                  onTap: () {
                    _controller.text = entry.value;
                    _onSearch(entry.value);
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.divider),
              bottom: BorderSide(color: AppColors.divider),
            ),
          ),
          child: Row(
            children: [
              SearchTab(
                label: '빌려주세요',
                isActive: _tabIndex == 0,
                onTap: () {
                  setState(() {
                    _tabIndex = 0;
                    _isLoading = true;
                  });
                  _fetchResults(_currentQuery);
                },
              ),
              SearchTab(
                label: '빌려드려요',
                isActive: _tabIndex == 1,
                onTap: () {
                  setState(() {
                    _tabIndex = 1;
                    _isLoading = true;
                  });
                  _fetchResults(_currentQuery);
                },
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_results.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                '검색 결과가 없어요.',
                style: AppTypography.b2.copyWith(color: AppColors.textHint),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) => SearchResultCard(
                item: _results[index],
                onTap: () {
                  final sourcePost = _resolveDetailPost(_results[index]);
                  if (sourcePost == null) return;
                  Navigator.pushNamed(
                    context,
                    '/post-detail',
                    arguments: sourcePost,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
