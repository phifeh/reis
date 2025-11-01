import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reis/core/services/background_location_service.dart';
import 'package:reis/core/services/battery_monitor_service.dart';
import 'package:reis/core/theme/retro_theme.dart';
import 'package:reis/core/providers/providers.dart';

final backgroundTrackingProvider = StateProvider<bool>((ref) => false);
final trackingIntervalProvider = StateProvider<int>((ref) => 5);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _locationService = BackgroundLocationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundTrackingProvider.notifier).state =
          _locationService.isTracking;
      ref.read(batteryMonitorServiceProvider).initialize();
    });
  }

  Future<void> _toggleTracking(bool value) async {
    if (value) {
      final batteryService = ref.read(batteryMonitorServiceProvider);
      final powerMode = ref.read(powerModeProvider);
      
      Duration interval;
      switch (powerMode) {
        case PowerMode.normal:
          interval = const Duration(minutes: 5);
          break;
        case PowerMode.balanced:
          interval = const Duration(minutes: 10);
          break;
        case PowerMode.saving:
          interval = const Duration(minutes: 15);
          break;
      }
      
      ref.read(trackingIntervalProvider.notifier).state = interval.inMinutes;
      
      final success = await _locationService.startTracking(
        interval: interval,
      );

      if (success) {
        ref.read(backgroundTrackingProvider.notifier).state = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location tracking started (${interval.inMinutes} min intervals)'),
              backgroundColor: RetroTheme.mutedTeal,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
              backgroundColor: RetroTheme.dustyRose,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      await _locationService.stopTracking();
      ref.read(backgroundTrackingProvider.notifier).state = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location tracking stopped'),
            backgroundColor: RetroTheme.deepTaupe,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTracking = ref.watch(backgroundTrackingProvider);
    final interval = ref.watch(trackingIntervalProvider);

    return Scaffold(
      backgroundColor: RetroTheme.softCream,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'Spectral',
                letterSpacing: 1.2,
              ),
        ),
        backgroundColor: RetroTheme.warmBeige,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBatteryStatus(),
          const SizedBox(height: 24),
          _buildSectionHeader('Background Tracking'),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.info_outline,
            text:
                'Enable background location tracking to automatically log your journey '
                'even when the app is closed. Battery efficient with configurable intervals.',
          ),
          const SizedBox(height: 16),
          _buildTrackingSwitch(isTracking),
          if (isTracking) ...[
            const SizedBox(height: 24),
            _buildIntervalSelector(interval),
            const SizedBox(height: 24),
            _buildLocationStatus(),
          ],
          const SizedBox(height: 32),
          _buildSectionHeader('About Background Tracking'),
          const SizedBox(height: 12),
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildBatteryStatus() {
    final batteryLevel = ref.watch(batteryLevelProvider).value ?? 100;
    final powerMode = ref.watch(powerModeProvider);
    
    IconData batteryIcon;
    Color batteryColor;
    
    if (batteryLevel > 80) {
      batteryIcon = Icons.battery_full;
      batteryColor = RetroTheme.mutedTeal;
    } else if (batteryLevel > 50) {
      batteryIcon = Icons.battery_5_bar;
      batteryColor = RetroTheme.mutedTeal;
    } else if (batteryLevel > 20) {
      batteryIcon = Icons.battery_3_bar;
      batteryColor = RetroTheme.vintageOrange;
    } else {
      batteryIcon = Icons.battery_1_bar;
      batteryColor = RetroTheme.dustyRose;
    }
    
    String modeText;
    String modeEmoji;
    switch (powerMode) {
      case PowerMode.normal:
        modeText = 'Normal Mode';
        modeEmoji = '🔋';
        break;
      case PowerMode.balanced:
        modeText = 'Balanced Mode';
        modeEmoji = '⚡';
        break;
      case PowerMode.saving:
        modeText = 'Power Saving';
        modeEmoji = '🪫';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RetroTheme.warmBeige.withOpacity(0.7),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.paleOlive, width: 2),
      ),
      child: Row(
        children: [
          Icon(batteryIcon, color: batteryColor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$batteryLevel%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: batteryColor,
                            fontFamily: 'Courier',
                          ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$modeEmoji $modeText',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: RetroTheme.sageBrown,
                            fontFamily: 'Spectral',
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getPowerModeDescription(powerMode),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: RetroTheme.deepTaupe,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getPowerModeDescription(PowerMode mode) {
    switch (mode) {
      case PowerMode.normal:
        return 'Tracking: 5 min intervals, high accuracy';
      case PowerMode.balanced:
        return 'Tracking: 10 min intervals, medium accuracy';
      case PowerMode.saving:
        return 'Tracking: 15 min intervals, low accuracy';
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: RetroTheme.deepTaupe,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
            fontFamily: 'Spectral',
          ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.softMint.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.mutedTeal.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: RetroTheme.mutedTeal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: RetroTheme.deepTaupe,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingSwitch(bool isTracking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.warmBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.paleOlive),
      ),
      child: Row(
        children: [
          Icon(
            isTracking ? Icons.location_on : Icons.location_off,
            color: isTracking ? RetroTheme.mutedTeal : RetroTheme.sageBrown,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Background Tracking',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Spectral',
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isTracking ? 'Active' : 'Disabled',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: RetroTheme.sageBrown,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: isTracking,
            onChanged: _toggleTracking,
            activeColor: RetroTheme.vintageOrange,
            activeTrackColor: RetroTheme.vintageOrange.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalSelector(int interval) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.warmBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.paleOlive),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: RetroTheme.sageBrown, size: 24),
              const SizedBox(width: 12),
              Text(
                'Tracking Interval',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Spectral',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: interval.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  activeColor: RetroTheme.vintageOrange,
                  inactiveColor: RetroTheme.paleOlive.withOpacity(0.3),
                  label: '$interval min',
                  onChanged: (value) {
                    ref.read(trackingIntervalProvider.notifier).state =
                        value.toInt();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: RetroTheme.vintageOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '$interval min',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: RetroTheme.deepTaupe,
                        fontFamily: 'Courier',
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lower values use more battery but provide more accurate tracking',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: RetroTheme.sageBrown,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatus() {
    // final lastLocation = _locationService.currentLocation;
    // final lastTime = _locationService.lastLocationTime;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.softMint.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.mutedTeal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: RetroTheme.mutedTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                'Last Location',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Spectral',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // if (lastLocation != null) ...[
          //   _buildLocationRow(
          //     'Coordinates',
          //     '${lastLocation.latitude.toStringAsFixed(6)}, '
          //         '${lastLocation.longitude.toStringAsFixed(6)}',
          //   ),
          //   const SizedBox(height: 8),
          //   _buildLocationRow(
          //     'Accuracy',
          //     '±${lastLocation.accuracy?.toStringAsFixed(0) ?? '?'}m',
          //   ),
          //   if (lastTime != null) ...[
          //     const SizedBox(height: 8),
          //     _buildLocationRow(
          //       'Updated',
          //       _formatTimeAgo(lastTime),
          //     ),
          //   ],
          // ] else
            Text(
              'Background tracking will be available soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RetroTheme.sageBrown,
                    fontStyle: FontStyle.italic,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: RetroTheme.sageBrown,
                ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.w600,
                  color: RetroTheme.deepTaupe,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Works even when app is closed',
      'Battery optimized location updates',
      'Configurable tracking intervals (1-30 min)',
      'Medium accuracy for battery efficiency',
      'Automatic location logging',
      'No data sent to external servers',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RetroTheme.warmBeige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.paleOlive),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features
            .map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: RetroTheme.mutedTeal,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}
