import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../scene_scaffold.dart';
import 'lut_builder.dart';
import 'mood.dart';
import 'mood_controller.dart';

/// Returns the preset chips and the Tune panel of the Moods scene.
List<Widget> moodControls(MoodController controller) {
  final mood = controller.mood;
  final lut = mood.lut;

  void edit(Mood next) => controller.update(next, dragging: true);
  void editLut(LutParams next) => edit(mood.copyWith(lut: next));
  void release(double _) => controller.settle();

  return [
    ControlRow(
      label: 'Mood',
      child: ControlChoices<MoodPreset?>(
        options: {for (final preset in moodPresets) preset: preset.name},
        value: controller.preset,
        onChanged: (preset) {
          if (preset != null) controller.selectPreset(preset);
        },
      ),
    ),
    ControlSwitch(
      label: 'Keep true colors on the route',
      icon: Icons.route_outlined,
      value: controller.keepTrueColors,
      onChanged: controller.setKeepTrueColors,
    ),
    const SizedBox(height: 8),
    LutPreview(lut: controller.lutPng),
    const _Section('Color grade'),
    ControlSlider(
      label: 'Temperature',
      value: lut.temperature,
      min: -1,
      max: 1,
      fractionDigits: 2,
      onChanged: (v) => editLut(lut.copyWith(temperature: v)),
      onChangeEnd: release,
    ),
    ControlSlider(
      label: 'Tint',
      value: lut.tint,
      min: -1,
      max: 1,
      fractionDigits: 2,
      onChanged: (v) => editLut(lut.copyWith(tint: v)),
      onChangeEnd: release,
    ),
    ControlSlider(
      label: 'Hue shift',
      value: lut.hueShift,
      min: -180,
      max: 180,
      fractionDigits: 0,
      unit: '°',
      onChanged: (v) => editLut(lut.copyWith(hueShift: v)),
      onChangeEnd: release,
    ),
    ControlSlider(
      label: 'Saturation',
      value: lut.saturation,
      min: 0,
      max: 2,
      fractionDigits: 2,
      onChanged: (v) => editLut(lut.copyWith(saturation: v)),
      onChangeEnd: release,
    ),
    ControlSlider(
      label: 'Contrast',
      value: lut.contrast,
      min: 0.5,
      max: 1.5,
      fractionDigits: 2,
      onChanged: (v) => editLut(lut.copyWith(contrast: v)),
      onChangeEnd: release,
    ),
    ControlColor(
      label: 'Shadows',
      color: lut.shadowColor,
      saturationLabel: 'Strength',
      onChanged: (c) => editLut(lut.copyWith(shadowColor: c)),
      onChangeEnd: controller.settle,
    ),
    ControlColor(
      label: 'Highlights',
      color: lut.highlightColor,
      saturationLabel: 'Strength',
      onChanged: (c) => editLut(lut.copyWith(highlightColor: c)),
      onChangeEnd: controller.settle,
    ),
    const _Section('Atmosphere'),
    ControlColor(
      label: 'Fog',
      color: mood.fogColor,
      onChanged: (c) => edit(mood.copyWith(fogColor: c)),
    ),
    ControlColor(
      label: 'Sky',
      color: mood.highColor,
      onChanged: (c) => edit(mood.copyWith(highColor: c)),
    ),
    ControlColor(
      label: 'Space',
      color: mood.spaceColor,
      onChanged: (c) => edit(mood.copyWith(spaceColor: c)),
    ),
    ControlSlider(
      label: 'Horizon blend',
      value: mood.horizonBlend,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (v) => edit(mood.copyWith(horizonBlend: v)),
    ),
    ControlSlider(
      label: 'Stars',
      value: mood.starIntensity,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (v) => edit(mood.copyWith(starIntensity: v)),
    ),
    ControlSwitch(
      label: 'Aurora pulse',
      icon: Icons.auto_awesome_outlined,
      value: mood.pulse,
      onChanged: (v) => edit(mood.copyWith(pulse: v)),
    ),
    const _Section('Weather'),
    ControlChoices<Weather>(
      options: const {
        Weather.none: 'Clear',
        Weather.snow: 'Snow',
        Weather.rain: 'Rain',
      },
      columns: 3,
      value: mood.weather,
      onChanged: (v) => edit(
        mood.copyWith(
          weather: v,
          weatherIntensity: mood.weatherIntensity == 0 ? 0.6 : null,
          weatherDensity: mood.weatherDensity == 0 ? 0.6 : null,
        ),
      ),
    ),
    const SizedBox(height: 10),
    if (mood.weather != Weather.none) ...[
      ControlSlider(
        label: 'Intensity',
        value: mood.weatherIntensity,
        min: 0,
        max: 1,
        fractionDigits: 2,
        onChanged: (v) => edit(mood.copyWith(weatherIntensity: v)),
      ),
      ControlSlider(
        label: 'Density',
        value: mood.weatherDensity,
        min: 0,
        max: 1,
        fractionDigits: 2,
        onChanged: (v) => edit(mood.copyWith(weatherDensity: v)),
      ),
      ControlColor(
        label: mood.weather == Weather.snow ? 'Snow' : 'Rain',
        color: mood.weatherColor,
        onChanged: (c) => edit(mood.copyWith(weatherColor: c)),
      ),
    ],
    const _Section('Light'),
    ControlRow(
      label: 'Light preset',
      child: ControlChoices<String>(
        options: const {
          'dawn': 'Dawn',
          'day': 'Day',
          'dusk': 'Dusk',
          'night': 'Night',
        },
        columns: 4,
        value: mood.lightPreset,
        onChanged: (v) => edit(mood.copyWith(lightPreset: v)),
      ),
    ),
    ControlColor(
      label: 'Ambient',
      color: mood.ambientColor,
      onChanged: (c) => edit(mood.copyWith(ambientColor: c)),
    ),
    ControlSlider(
      label: 'Ambient intensity',
      value: mood.ambientIntensity,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (v) => edit(mood.copyWith(ambientIntensity: v)),
    ),
    const SizedBox(height: 4),
    Text(
      'A preset only fills these values. The color grade is a look-up '
      'table (LUT) that the app builds at runtime and sends to '
      'setStyleColorTheme. The route sets line-color-use-theme to none, so '
      'it keeps its true color.'
      '${kIsWeb ? ' On web, snow and rain colors always follow the theme.' : ''}',
      style: const TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 8),
    child: GlassSectionLabel(title),
  );
}

// The current LUT. Tap to enlarge.
class LutPreview extends StatelessWidget {
  const LutPreview({super.key, required this.lut});

  final Uint8List? lut;

  @override
  Widget build(BuildContext context) {
    final lut = this.lut;
    if (lut == null) return const SizedBox(height: 24);
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: MapboxGlass.fill,
          insetPadding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GlassSectionLabel('Color theme LUT'),
                const SizedBox(height: 10),
                _strip(lut, 32 / 1024),
                const SizedBox(height: 10),
                const Text(
                  'How the map recolors. Each original color has a fixed spot in '
                  'this strip, and the map draws the color found at that spot.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: MapboxGlass.labelFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MapboxRadius.small),
        child: SizedBox(height: 24, child: _strip(lut, null)),
      ),
    );
  }

  /// Draws a PNG without smoothing, so each LUT pixel stays sharp.
  static Widget _strip(Uint8List png, double? aspect) {
    final image = Image.memory(
      png,
      fit: BoxFit.fill,
      width: double.infinity,
      filterQuality: FilterQuality.none,
      gaplessPlayback: true,
    );
    return aspect == null
        ? image
        : AspectRatio(aspectRatio: 1 / aspect, child: image);
  }
}

/// A color control with hue and saturation sliders.
///
/// It shows a swatch row. A tap opens the sliders.
class ControlColor extends StatefulWidget {
  const ControlColor({
    super.key,
    required this.label,
    required this.color,
    required this.onChanged,
    this.onChangeEnd,
    this.saturationLabel = 'Saturation',
  });

  final String label;
  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final VoidCallback? onChangeEnd;
  final String saturationLabel;

  @override
  State<ControlColor> createState() => _ControlColorState();
}

class _ControlColorState extends State<ControlColor> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final end = widget.onChangeEnd == null
        ? null
        : (double _) => widget.onChangeEnd!();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(MapboxRadius.small),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color.toColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: MapboxGlass.borderStrong),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MapboxGlass.label,
                    ),
                  ),
                ),
                Text(
                  '${color.hue.round()}° · '
                  '${(color.saturation * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: MapboxGlass.labelMuted,
                  ),
                ),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  size: 16,
                  color: MapboxGlass.labelFaint,
                ),
              ],
            ),
          ),
        ),
        if (_open) ...[
          Container(
            height: 4,
            margin: const EdgeInsets.only(top: 2, bottom: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [
                  for (var hue = 0.0; hue <= 360; hue += 60)
                    color.withHue(hue % 360).withSaturation(1).toColor(),
                ],
              ),
            ),
          ),
          ControlSlider(
            label: 'Hue',
            value: color.hue,
            min: 0,
            max: 359,
            fractionDigits: 0,
            unit: '°',
            onChanged: (v) => widget.onChanged(color.withHue(v)),
            onChangeEnd: end,
          ),
          ControlSlider(
            label: widget.saturationLabel,
            value: color.saturation,
            min: 0,
            max: 1,
            fractionDigits: 2,
            onChanged: (v) => widget.onChanged(color.withSaturation(v)),
            onChangeEnd: end,
          ),
        ],
      ],
    );
  }
}
