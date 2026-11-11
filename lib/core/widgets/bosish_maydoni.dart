import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Kichik bosiladigan elementning bosish maydonini ko'rinmas holda kamida
/// [engKam]×[engKam] gacha kengaytiradi. Layout o'zgarmaydi: element o'z o'lchamida
/// qoladi, faqat atrofidagi bosish va ekran o'qigich chegarasi kattalashadi.
///
/// Atrofdagi ota widget kengaytirilgan maydonni sig'dirishi kerak (bosish ota chegarasidan
/// tashqariga chiqmaydi).
class BosishMaydoni extends SingleChildRenderObjectWidget {
  const BosishMaydoni({super.key, this.engKam = 48, required Widget super.child});

  final double engKam;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBosishMaydoni(engKam);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderBosishMaydoni).engKam = engKam;
  }
}

class _RenderBosishMaydoni extends RenderProxyBox {
  _RenderBosishMaydoni(this._engKam);

  double _engKam;
  set engKam(double v) {
    if (v == _engKam) return;
    _engKam = v;
    markNeedsSemanticsUpdate();
  }

  Rect get _maydon {
    final dx = math.max(0.0, (_engKam - size.width) / 2);
    final dy = math.max(0.0, (_engKam - size.height) / 2);
    return Rect.fromLTRB(-dx, -dy, size.width + dx, size.height + dy);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!_maydon.contains(position)) return false;
    // Kengaytirilgan maydondagi nuqta elementning eng yaqin ichki nuqtasiga o'tkaziladi.
    final ichki = Offset(
      position.dx.clamp(0.0, math.max(0.0, size.width - 0.01)),
      position.dy.clamp(0.0, math.max(0.0, size.height - 0.01)),
    );
    return super.hitTest(result, position: ichki);
  }

  @override
  Rect get semanticBounds => _maydon;

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    // Ichidagi tugma semantikasi shu tugunga yig'iladi: ekran o'qigich 48×48 ko'radi.
    config.isSemanticBoundary = true;
  }
}
