//+------------------------------------------------------------------+
//|                                                   K-TimeLeft.mq5 |
//|                                          Copyright 2014,fxMeter. |
//|                            https://www.mql5.com/en/users/fxmeter |
//+------------------------------------------------------------------+
//2020-06-13 updated.  iTime() and iClose() have been implemented as API,just need to directly call it.
//2017-11-13 publish to MQL5.COM code base
//2014-11-15 create
#property copyright "Copyright 2014,fxMeter."
#property link      "https://mql5.com/en/users/fxmeter"
#property version   "1.00"
#property indicator_chart_window
#define  OBJ_NAME "time_left_label"
#define  FONT_NAME "Microsoft YaHei"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_POS_TL
{
   FOLLOW_PRICE,
   FIXED_POSITION
};
input color  LabelColor = clrOrangeRed;
input ENUM_POS_TL LabelPosition = FIXED_POSITION;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteLabel()
{
   int try = 10;
   while (ObjectFind(0, OBJ_NAME) == 0)
   {
      ObjectDelete(0, OBJ_NAME);
      if (try-- <= 0) break;
   }
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- indicator buffers mapping
   EventSetTimer(1);
   DeleteLabel();

   //---
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   DeleteLabel();
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //---

   //--- return value of prev_calculated for next call
   return (rates_total);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   //---
   UpdateTimeLeft();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateTimeLeft()
{
   int seconds = 0; // 当前柱的剩余秒数
   int h = 0;       // 小时
   int m = 0;       // 分钟
   int s = 0;       // 秒钟  hh:mm:ss

   // 获取当前柱的时间和收盘价
   datetime time = iTime(Symbol(), PERIOD_CURRENT, 0);
   double close = iClose(Symbol(), PERIOD_CURRENT, 0);

   // 计算剩余时间
   seconds = PeriodSeconds(PERIOD_CURRENT) - (int)(TimeCurrent() - time);
   h = seconds / 3600;
   m = (seconds - h * 3600) / 60;
   s = (seconds - h * 3600 - m * 60);

   // 获取经纪商服务器的 GMT 偏移量
   int gmtOffset = TimeGMTOffset();

  
 // 获取当前北京时间
datetime beijingTime = TimeLocal();


  

// 构建要显示的文本
string text = "  >>> " +
               StringFormat("%02d", h) + ":" +
               StringFormat("%02d", m) + ":" +
               StringFormat("%02d", s) +
               "  北京时间: " + TimeToString(beijingTime, TIME_DATE | TIME_MINUTES | TIME_SECONDS);





   // 选择标签位置
   if (LabelPosition == FOLLOW_PRICE)
   {
      if (ObjectFind(0, OBJ_NAME) != 0)
      {
         ObjectCreate(0, OBJ_NAME, OBJ_TEXT, 0, time, close + _Point);
         ObjectSetString(0, OBJ_NAME, OBJPROP_TEXT, text);
         ObjectSetString(0, OBJ_NAME, OBJPROP_FONT, FONT_NAME);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_FONTSIZE, 12);
      }
      else
      {
         ObjectSetString(0, OBJ_NAME, OBJPROP_TEXT, text);
         ObjectMove(0, OBJ_NAME, 0, time, close + _Point);
      }
   }
   else if (LabelPosition == FIXED_POSITION)
   {
      if (ObjectFind(0, OBJ_NAME) != 0)
      {
         ObjectCreate(0, OBJ_NAME, OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_XDISTANCE, 200);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_YDISTANCE, 2);
         ObjectSetString(0, OBJ_NAME, OBJPROP_TEXT, text);
         ObjectSetString(0, OBJ_NAME, OBJPROP_FONT, FONT_NAME);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_COLOR, LabelColor);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_SELECTABLE, true);
         ObjectSetInteger(0, OBJ_NAME, OBJPROP_FONTSIZE, 12);
      }
      else
         ObjectSetString(0, OBJ_NAME, OBJPROP_TEXT, text);
   }
}
//+------------------------------------------------------------------+
