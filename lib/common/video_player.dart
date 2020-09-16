// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YouTubePlayer extends StatefulWidget {
//   final String videoID;
//   final bool mute;
//   final bool autoPlay;

//   const YouTubePlayer({
//     Key key,
//     @required this.videoID,
//     this.mute = false,
//     this.autoPlay = false,
//   }) : super(key: key);

//   @override
//   _YouTubePlayerState createState() => _YouTubePlayerState();
// }

// class _YouTubePlayerState extends State<YouTubePlayer> {
//   YoutubePlayerController _controller;

//   PlayerState _playerState;
//   YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;

//   @override
//   void initState() {
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoID,
//       flags: YoutubePlayerFlags(
//         autoPlay: widget.autoPlay,
//         mute: widget.mute,
//       ),
//     );
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.amber,
//         onReady: () => _controller.addListener(listener),
//       ),
//     );
//   }
// }
