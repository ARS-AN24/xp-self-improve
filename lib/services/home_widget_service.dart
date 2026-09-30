import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String widgetName = 'XSISWidgetProvider';

  static Future<void> update({
    required int totalXP,
    required int level,
    required int xpIntoLevel,
    required int xpNeededForLevel,
    required int todayXP,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('totalXP', totalXP);
      await HomeWidget.saveWidgetData<int>('level', level);
      await HomeWidget.saveWidgetData<int>('xpIntoLevel', xpIntoLevel);
      await HomeWidget.saveWidgetData<int>(
        'xpNeededForLevel',
        xpNeededForLevel,
      );
      await HomeWidget.saveWidgetData<int>('todayXP', todayXP);

      await HomeWidget.updateWidget(
        androidName: widgetName,
      );
    } catch (_) {
      // The app continues working if the widget is unavailable.
    }
  }
}