import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/text_style.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State createState() => _VideoPlayerWidgetState();
}

// Global mute notifier to synchronize mute state across all instances
final ValueNotifier<bool> globalMuteNotifier = ValueNotifier<bool>(true);

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late BetterPlayerController _betterPlayerController;
  bool _isPlaying = true;

  void _togglePlayPause() {
    if (_isPlaying) {
      _betterPlayerController.pause();
    } else {
      _betterPlayerController.play();
    }
    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _toggleMute() {
    globalMuteNotifier.value = !globalMuteNotifier.value;
  }

  @override
  void dispose() {
    globalMuteNotifier.removeListener(_updateMuteState);
    _betterPlayerController.dispose();
    super.dispose();
  }

  void _updateMuteState() {
    _betterPlayerController.setVolume(globalMuteNotifier.value ? 0.0 : 1.0);
  }

  @override
  void initState() {
    super.initState();

    // Configuration for BetterPlayer
    final betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: false,
      aspectRatio: 6 / 10,
      fit: BoxFit.cover,
      expandToFill: true,
      looping: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        backgroundColor: AppColors.white,
        controlBarColor: AppColors.appTransparent,
        iconsColor: AppColors.appTransparent,
        showControls: false,
      ),
      errorBuilder: (context, errorMessage) {
        return Container(
          color: Colors.grey.shade50,
          child:  Center(
            child: Text(
              AppString.couldNotLoadVideo,
              style: appTextStyle.appNormalSmallTextStyle(),
            ),
          ),
        );
      },
      showPlaceholderUntilPlay: true,
      placeholderOnTop: true,
      placeholder: Container(
        color: AppColors.appTransparent,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
        ),
      ),
    );

    // Data source with caching enabled
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 10 << 30,
        maxCacheFileSize: 100 * 1024 * 1024,
        preCacheSize: 10 << 30,
      ),
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);

    // Listen to global mute changes
    globalMuteNotifier.addListener(_updateMuteState);
    _betterPlayerController.setVolume(globalMuteNotifier.value ? 0.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 40) {
          // Play video when more than 40% visible
          _betterPlayerController.play();
          if (mounted) {
            setState(() {
              _isPlaying = true;
            });
          }
        } else {
          // Pause video when less than 40% visible
          _betterPlayerController.pause();
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          BetterPlayer(controller: _betterPlayerController),
          // Transparent GestureDetector to capture taps
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Central play/pause icon
          if (!_isPlaying)
            GestureDetector(
              onTap: _togglePlayPause,
              behavior: HitTestBehavior.opaque,
              child: const Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 50,
              ),
            ),
          // Mute toggle button
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _toggleMute,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: globalMuteNotifier,
                  builder: (context, isMuted, child) {
                    return Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: AppColors.white,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
