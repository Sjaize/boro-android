import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class KeywordRegistrationScreen extends StatefulWidget {
  const KeywordRegistrationScreen({super.key});

  @override
  State<KeywordRegistrationScreen> createState() =>
      _KeywordRegistrationScreenState();
}

class _KeywordRegistrationScreenState extends State<KeywordRegistrationScreen> {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';
  final TextEditingController _controller = TextEditingController();

  final List<String> _registeredKeywords = ['충전기', '보조배터리', '우산'];
  bool _isSyncing = false;

  static const List<String> _suggestedKeywords = [
    '정장',
    '전시 소품',
    '계산기',
    '핸드폰 거치대',
    '필름카메라',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addKeyword(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;
    if (_registeredKeywords.contains(trimmed)) return;

    setState(() {
      _registeredKeywords.add(trimmed);
      _controller.clear();
    });
    _syncKeywords();
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _registeredKeywords.remove(keyword);
    });
    _syncKeywords();
  }

  Future<void> _syncKeywords() async {
    if (_isSyncing) return;
    if (!PostService.isAuthenticated) return;

    setState(() {
      _isSyncing = true;
    });

    final client = HttpClient();
    try {
      final request = await client.patchUrl(
        Uri.parse('$_baseUrl/api/users/me/settings'),
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );
      request.write(
        jsonEncode({
          'interest_keywords': _registeredKeywords,
        }),
      );

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          body.isNotEmpty
              ? '관심 키워드 저장에 실패했습니다. (${response.statusCode})'
              : '관심 키워드 저장에 실패했습니다.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심 키워드 저장에 실패했습니다.')),
      );
    } finally {
      client.close(force: true);
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(showBottomDivider: false, 
        title: '관심 키워드 등록',
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 9, 16, 10),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _addKeyword,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '알림 받을 키워드를 입력해주세요',
                        hintStyle: AppTypography.c2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _addKeyword(_controller.text),
                    child: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final keyword in _registeredKeywords)
            _RegisteredKeywordTile(
              keyword: keyword,
              onRemove: () => _removeKeyword(keyword),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
            child: Text(
              '최근 본 게시글의 키워드를 등록해보세요',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final keyword in _suggestedKeywords)
                  _KeywordChip(
                    label: keyword,
                    onTap: () => _addKeyword(keyword),
                  ),
              ],
            ),
          ),
          if (_isSyncing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '관심 키워드 저장 중...',
                    style: AppTypography.c2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RegisteredKeywordTile extends StatelessWidget {
  const _RegisteredKeywordTile({
    required this.keyword,
    required this.onRemove,
  });

  final String keyword;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              keyword,
              style: AppTypography.b4.copyWith(color: AppColors.textDark),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: AppColors.textDark,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: AppTypography.c1.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
