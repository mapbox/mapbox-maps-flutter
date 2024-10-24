part of mapbox_maps_flutter;

final class EasingViewportTransition extends ViewportTransition {
  final Cubic curve;
  final Duration duration;

  // ignore: prefer_initializing_formals
  const EasingViewportTransition(
      {this.curve = Curves.easeInOut, required this.duration})
      : super();

  const EasingViewportTransition.linear({required this.duration})
      : curve = const Cubic(0, 0, 1, 1),
        super();
}
