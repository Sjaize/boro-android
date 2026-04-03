import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';

class NotificationRangeSettingsScreen extends StatefulWidget {
  const NotificationRangeSettingsScreen({super.key});

  @override
  State<NotificationRangeSettingsScreen> createState() =>
      _NotificationRangeSettingsScreenState();
}

class _NotificationRangeSettingsScreenState
    extends State<NotificationRangeSettingsScreen> {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';
  static const List<int> _rangeSteps = [50, 100, 250, 500, 1000, 2000, 4000];
  
  double _sliderValue = 1;
  bool _isSaving = false;
  bool _isLoadingLocation = true;
  
  KakaoMapController? _mapController;
  MarkerIcon? _markerIcon;
  LatLng? _currentLocation;

  int get _selectedRangeMeters => _rangeSteps[_sliderValue.round()];
  String get _selectedRangeLabel => _rangeLabel(_selectedRangeMeters);

  String _rangeLabel(int meters) {
    if (meters < 1000) {
      return '${meters}m';
    }
    if (meters % 1000 == 0) {
      return '${meters ~/ 1000}km';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    _determinePosition();
  }

  Future<void> _loadMarkerIcon() async {
    final markerIcon = await MarkerIcon.fromAsset(
      'assets/images/location_pin.png',
    );
    if (!mounted) return;
    setState(() {
      _markerIcon = markerIcon;
    });
  }

  /// 현재 위치를 파악하고 지도의 중심점을 설정합니다.
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setDefaultLocation();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setDefaultLocation();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _setDefaultLocation();
      return;
    } 

    try {
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5),
      );
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        _adjustMapZoom();
        _mapController?.setCenter(_currentLocation!);
      }
    } catch (e) {
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(37.240869, 127.079651);
        _isLoadingLocation = false;
      });
      _adjustMapZoom();
      _mapController?.setCenter(_currentLocation!);
    }
  }

  CustomOverlay _buildRangeOverlay() {
    return CustomOverlay(
      customOverlayId: 'range_overlay',
      latLng: _currentLocation!,
      xAnchor: 0.5,
      yAnchor: 0.5,
      zIndex: 1,
      content: '''
        <div style="position: relative; width: 240px; height: 240px; pointer-events: none;">
          <style>
            @keyframes boroRipple {
              0% { transform: scale(0.42); opacity: 0.30; }
              70% { opacity: 0.10; }
              100% { transform: scale(1.0); opacity: 0.0; }
            }
          </style>
          <div style="
            position: absolute;
            left: 120px;
            top: 120px;
            width: 240px;
            height: 240px;
            margin-left: -120px;
            margin-top: -120px;
            border-radius: 50%;
            background: rgba(21, 112, 239, 0.12);
            animation: boroRipple 3.2s ease-out infinite;
          "></div>
          <div style="
            position: absolute;
            left: 120px;
            top: 120px;
            width: 240px;
            height: 240px;
            margin-left: -120px;
            margin-top: -120px;
            border-radius: 50%;
            background: rgba(21, 112, 239, 0.10);
            animation: boroRipple 3.2s ease-out infinite;
            animation-delay: 1.05s;
          "></div>
          <div style="
            position: absolute;
            left: 120px;
            top: 120px;
            width: 240px;
            height: 240px;
            margin-left: -120px;
            margin-top: -120px;
            border-radius: 50%;
            background: rgba(21, 112, 239, 0.08);
            animation: boroRipple 3.2s ease-out infinite;
            animation-delay: 2.1s;
          "></div>
          <div style="
            position: absolute;
            left: 70px;
            top: 70px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(21, 112, 239, 0.18);
          "></div>
        </div>
      ''',
    );
  }

  void _adjustMapZoom() {
    if (_mapController == null) return;

    int level;
    if (_selectedRangeMeters <= 100) {
      level = 3;
    } else if (_selectedRangeMeters <= 250) {
      level = 4;
    } else if (_selectedRangeMeters <= 500) {
      level = 5;
    } else if (_selectedRangeMeters <= 1000) {
      level = 6;
    } else if (_selectedRangeMeters <= 2000) {
      level = 7;
    } else {
      level = 8;
    }

    _mapController?.setLevel(level);
  }

  Future<void> _saveNotificationRadius() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final client = HttpClient();
    try {
      final request = await client.patchUrl(
        Uri.parse('$_baseUrl/api/users/me/settings'),
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.write(
        jsonEncode({
          'notification_radius_m': _selectedRangeMeters,
        }),
      );

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('알림 범위 저장 실패');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('알림 수신 범위를 $_selectedRangeLabel로 설정했습니다.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알림 범위 저장에 실패했습니다.')),
      );
    } finally {
      client.close(force: true);
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        showBottomDivider: false, 
        title: '알림 수신 범위 설정',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildMap(),
                ),
                if (_isLoadingLocation)
                  Container(
                    color: Colors.white.withValues(alpha: 0.8),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),
          _RangeBottomSheet(
            selectedRangeLabel: _selectedRangeLabel,
            sliderValue: _sliderValue,
            rangeSteps: _rangeSteps,
            rangeLabelBuilder: _rangeLabel,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              _adjustMapZoom();
              if (_currentLocation != null) {
                _mapController?.setCenter(_currentLocation!);
                _mapController?.addCustomOverlay(
                  customOverlays: [_buildRangeOverlay()],
                );
              }
            },
            isSaving: _isSaving,
            onApply: _saveNotificationRadius,
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_currentLocation == null || _markerIcon == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return KakaoMap(
      key: ValueKey('map_${_selectedRangeMeters}_${_markerIcon != null}'),
      onMapCreated: (controller) {
        _mapController = controller;
        _adjustMapZoom();
        _mapController?.setCenter(_currentLocation!);
        _mapController?.addCustomOverlay(
          customOverlays: [_buildRangeOverlay()],
        );
        _mapController?.addMarker(
          markers: [
            Marker(
              markerId: 'current_pos',
              latLng: _currentLocation!,
              width: 42,
              height: 56,
              offsetX: 21,
              offsetY: 56,
              icon: _markerIcon,
            ),
          ],
        );
      },
      center: _currentLocation,
      customOverlays: [
        _buildRangeOverlay(),
      ],
      markers: [
        Marker(
          markerId: 'current_pos',
          latLng: _currentLocation!,
          width: 42,
          height: 56,
          offsetX: 21,
          offsetY: 56,
          icon: _markerIcon,
        ),
      ],
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
    );
  }
}

class _RangeBottomSheet extends StatelessWidget {
  const _RangeBottomSheet({
    required this.selectedRangeLabel,
    required this.sliderValue,
    required this.rangeSteps,
    required this.rangeLabelBuilder,
    required this.onChanged,
    required this.isSaving,
    required this.onApply,
  });

  final String selectedRangeLabel;
  final double sliderValue;
  final List<int> rangeSteps;
  final String Function(int) rangeLabelBuilder;
  final ValueChanged<double> onChanged;
  final bool isSaving;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '범위 설정',
                  style: AppTypography.h2.copyWith(color: AppColors.textDark),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedRangeLabel,
                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '반경 $selectedRangeLabel 이내 새 물품 등록 시 알림을 받아요',
              style: AppTypography.c2.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: AppColors.border,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.10),
                      trackHeight: 2,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0,
                      max: (rangeSteps.length - 1).toDouble(),
                      divisions: rangeSteps.length - 1,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final step in rangeSteps)
                    Expanded(
                      child: Text(
                        rangeLabelBuilder(step),
                        textAlign: TextAlign.center,
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textLight,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CommonButton(
              text: isSaving ? '저장 중...' : '적용하기',
              type: ButtonType.primary,
              height: 40,
              onPressed: isSaving ? null : onApply,
            ),
          ],
        ),
      ),
    );
  }
}
