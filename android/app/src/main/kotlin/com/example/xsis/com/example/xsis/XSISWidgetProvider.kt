package com.example.xsis

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class XSISWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->

            val totalXP = widgetData.getInt("totalXP", 0)
            val level = widgetData.getInt("level", 1)
            val xpIntoLevel = widgetData.getInt("xpIntoLevel", 0)
            val xpNeededForLevel = widgetData.getInt("xpNeededForLevel", 100)
            val todayXP = widgetData.getInt("todayXP", 0)

            val progress = if (xpNeededForLevel > 0) {
                ((xpIntoLevel.toFloat() / xpNeededForLevel.toFloat()) * 100f)
                    .toInt()
                    .coerceIn(0, 100)
            } else {
                0
            }

            val views = RemoteViews(
                context.packageName,
                R.layout.xsis_widget
            ).apply {
                setTextViewText(
                    R.id.widget_level,
                    "LEVEL $level"
                )

                setTextViewText(
                    R.id.widget_xp,
                    "$xpIntoLevel / $xpNeededForLevel XP"
                )

                setTextViewText(
                    R.id.widget_total_xp,
                    "$totalXP TOTAL XP"
                )

                setTextViewText(
                    R.id.widget_today_xp,
                    "+$todayXP TODAY"
                )

                setProgressBar(
                    R.id.widget_progress,
                    100,
                    progress,
                    false
                )

                val launchIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )

                setOnClickPendingIntent(
                    R.id.widget_container,
                    launchIntent
                )
            }

            appWidgetManager.updateAppWidget(
                widgetId,
                views
            )
        }
    }
}
