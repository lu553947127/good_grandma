import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

///大图浏览页面
typedef DoubleClickAnimationListener = void Function();

class PicSwiperRoute extends StatefulWidget {
  final int index;
  final List<String> pics;
  PicSwiperRoute({
    @required this.index,
    @required this.pics,
  });
  @override
  State<StatefulWidget> createState() => _PicSwiperRouteState();
}

class _PicSwiperRouteState extends State<PicSwiperRoute>
    with TickerProviderStateMixin {
  AnimationController _doubleClickAnimationController;
  AnimationController _slideEndAnimationController;
  Animation<double> _slideEndAnimation;
  Animation<double> _doubleClickAnimation;
  DoubleClickAnimationListener _doubleClickAnimationListener;
  final StreamController<int> _rebuildIndex = StreamController<int>.broadcast();
  final StreamController<bool> _rebuildSwiper =
      StreamController<bool>.broadcast();
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  bool _showSwiper = true;
  double _imageDetailY = 0;
  List<double> _doubleTapScales = <double>[1.0, 2.0];
  final Map<int, ImageDetailInfo> detailKeys = <int, ImageDetailInfo>{};

  @override
  void initState() {
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);

    _slideEndAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideEndAnimationController.addListener(() {
      _imageDetailY = _slideEndAnimation.value;
      if (_imageDetailY == 0) {
        _showSwiper = true;
        _rebuildSwiper.add(_showSwiper);
      }
      _rebuildDetail.sink.add(_imageDetailY);
    });
    super.initState();
  }

  @override
  void dispose() {
    _rebuildIndex.close();
    _rebuildSwiper.close();
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    _slideEndAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: ExtendedImageGesturePageView.builder(
        controller: PageController(
          initialPage: widget.index,
        ),
        itemBuilder: (BuildContext context, int index) {
          final String item = widget.pics[index];

          Widget image = ExtendedImage.network(
            item,
            fit: BoxFit.contain,
            enableSlideOutPage: true,
            mode: ExtendedImageMode.gesture,
            heroBuilderForSlidingPage: (Widget result) {
              if (index < min(9, widget.pics.length)) {
                return Hero(
                  tag: item,
                  child: result,
                  flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) {
                    final Hero hero =
                        (flightDirection == HeroFlightDirection.pop
                            ? fromHeroContext.widget
                            : toHeroContext.widget) as Hero;
                    return hero.child;
                  },
                );
              } else {
                return result;
              }
            },
            initGestureConfigHandler: (ExtendedImageState state) {
              double initialScale = 1.0;

              if (state.extendedImageInfo != null &&
                  state.extendedImageInfo.image != null) {
                initialScale = initScale(
                    size: size,
                    initialScale: initialScale,
                    imageSize: Size(
                        state.extendedImageInfo.image.width.toDouble(),
                        state.extendedImageInfo.image.height.toDouble()));
              }
              return GestureConfig(
                  inPageView: true,
                  initialScale: initialScale,
                  maxScale: max(initialScale, 5.0),
                  animationMaxScale: max(initialScale, 5.0),
                  initialAlignment: InitialAlignment.center,
                  //you can cache gesture state even though page view page change.
                  //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                  cacheGesture: false);
            },
            onDoubleTap: (ExtendedImageGestureState state) {
              ///you can use define pointerDownPosition as you can,
              ///default value is double tap pointer down postion.
              final Offset pointerDownPosition = state.pointerDownPosition;
              final double begin = state.gestureDetails.totalScale;
              double end;

              //remove old
              _doubleClickAnimation
                  ?.removeListener(_doubleClickAnimationListener);

              //stop pre
              _doubleClickAnimationController.stop();

              //reset to use
              _doubleClickAnimationController.reset();

              if (begin == _doubleTapScales[0]) {
                end = _doubleTapScales[1];
              } else {
                end = _doubleTapScales[0];
              }

              _doubleClickAnimationListener = () {
                //print(_animation.value);
                state.handleDoubleTap(
                    scale: _doubleClickAnimation.value,
                    doubleTapPosition: pointerDownPosition);
              };
              _doubleClickAnimation = _doubleClickAnimationController
                  .drive(Tween<double>(begin: begin, end: end));

              _doubleClickAnimation.addListener(_doubleClickAnimationListener);

              _doubleClickAnimationController.forward();
            },
            loadStateChanged: (ExtendedImageState state) {
              if (state.extendedImageLoadState == LoadState.completed) {
                final Rect imageDRect = getDestinationRect(
                  rect: Offset.zero & size,
                  inputSize: Size(
                    state.extendedImageInfo.image.width.toDouble(),
                    state.extendedImageInfo.image.height.toDouble(),
                  ),
                  fit: BoxFit.contain,
                );

                detailKeys[index] ??= ImageDetailInfo(
                  imageDRect: imageDRect,
                  pageSize: size,
                  imageInfo: state.extendedImageInfo,
                );
                // final ImageDetailInfo imageDetailInfo = detailKeys[index];
                return StreamBuilder<double>(
                  builder: (BuildContext context, AsyncSnapshot<double> data) {
                    return ExtendedImageGesture(
                      state,
                      canScaleImage: (_) => _imageDetailY == 0,
                      imageBuilder: (Widget image) {
                        return Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: image,
                              top: _imageDetailY,
                              bottom: -_imageDetailY,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  initialData: _imageDetailY,
                  stream: _rebuildDetail.stream,
                );
              }
              return null;
            },
          );
          image = GestureDetector(
            child: image,
            onTap: () {
              Navigator.pop(context);
            },
          );
          return image;
        },
        itemCount: widget.pics.length,
        onPageChanged: (int index) {
          _rebuildIndex.add(index);
          if (_imageDetailY != 0) {
            _imageDetailY = 0;
            _rebuildDetail.sink.add(_imageDetailY);
          }
          _showSwiper = true;
          _rebuildSwiper.add(_showSwiper);
        },
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  static double initScale({Size imageSize, Size size, double initialScale}) {
    final double n1 = imageSize.height / imageSize.width;
    final double n2 = size.height / size.width;
    if (n1 > n2) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.width / destinationSize.width;
    } else if (n1 / n2 < 1 / 4) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      final Size destinationSize = fittedSizes.destination;
      return size.height / destinationSize.height;
    }

    return initialScale;
  }
}

class ImageDetailInfo {
  ImageDetailInfo({
    @required this.imageDRect,
    @required this.pageSize,
    @required this.imageInfo,
  });

  final GlobalKey<State<StatefulWidget>> key = GlobalKey<State>();

  final Rect imageDRect;

  final Size pageSize;

  final ImageInfo imageInfo;

  double get imageBottom => imageDRect.bottom - 20;

  double _maxImageDetailY;
  double get maxImageDetailY {
    try {
      //
      return _maxImageDetailY ??= max(
          key.currentContext.size.height - (pageSize.height - imageBottom),
          0.1);
    } catch (e) {
      //currentContext is not ready
      return 100.0;
    }
  }
}
