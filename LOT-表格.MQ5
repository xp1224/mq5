//+------------------------------------------------------------------+
//| 手数计算.mq5                                                     |
//|                                                                  |
//| https://www.mql5.com                                             |
//+------------------------------------------------------------------+
#property copyright "xp"
#property link      "https://www.mql5.com"
#property version   "3.00"

/*
2.0:通过表格方式实现；
3.0:重新更改了计算方式
*/

#property indicator_chart_window
#property script_show_inputs

input string target_object_name = "1";
input color font_color = clrRed; // 默认字体颜色为红色
input double stop_loss_amount = 50.0;  //止损金额
input double risk_percentage = 5;//  百分比
input int cell_width = 100; // 单元格宽度
input int cell_height = 30; // 单元格高度
input int font_size = 12; // 字体大小
input int table_x = 10; // 表格 X 坐标
input int table_y = 10; // 表格 Y 坐标

// 定义指标属性
double previousS1 = 0.0;
double previousS2 = 0.0;

//+------------------------------------------------------------------+
//| 指标计算函数                                                     |
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
   // 获取目标 Fibonacci 对象的价格水平
   double s1 = ObjectGetDouble(0, target_object_name, OBJPROP_PRICE, 0);
   double s2 = ObjectGetDouble(0, target_object_name, OBJPROP_PRICE, 1);

   // 计算止损距离（以点为单位）
   double stop_loss_pips = MathAbs(s1 - s2);

   // 计算点值
   double lots = 0.0;
   double pointValue = _Point;
   
   // 根据货币对的特性调整点值
   if (StringFind(_Symbol, "XAU", 0) != -1 || StringFind(_Symbol, "BTC", 0) != -1) {
       pointValue = 0.01;    // 黄金或比特币，点值为0.01
   } else if (StringFind(_Symbol, "JPY", 0) != -1) {
       pointValue = 0.001;   // 日元交易，点值为0.001
   } else {
       pointValue = 0.00001; // 其他交易品种，点值为0.00001
   }

   // 计算手数
   if (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE) > 0.0) {
       double contract_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
       lots = stop_loss_amount / stop_loss_pips / contract_size;
   } else {
       double margin_required = SymbolInfoDouble(_Symbol, SYMBOL_MARGIN_INITIAL);
       lots = stop_loss_amount / stop_loss_pips * pointValue;
   }

   // 计算实际止损金额
   double actual_stop_loss_amount = lots * stop_loss_pips / pointValue;

   // 计算实际的止损金
   double accountPercentage = risk_percentage / 100.0 * AccountInfoDouble(ACCOUNT_BALANCE); // 风险金额为账户余额的百分比

   // 删除之前的对象
   for (int i = 0; i < 8; i++)
      ObjectDelete(0, "TableCell" + IntegerToString(i));

   // 获取图表的宽度和高度
   int chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);

   // 设置表格的行数和列数
   int rows = 4;
   int cols = 2;

   // 计算表格的起始位置（右下角）
   int startX = chartWidth - cell_width * cols - table_x;
   int startY = chartHeight - cell_height * rows - table_y;

   // 绘制表格
   for (int row = 0; row < rows; row++)
   {
      for (int col = 0; col < cols; col++)
      {
         int cellIndex = row * 2 + col;
         string cellText = "";

         // 设置单元格文本内容
         if (row == 0 && col == 0)
            cellText = "入场";
         else if (row == 0 && col == 1)
            cellText = DoubleToString(s1, _Digits);
         else if (row == 1 && col == 0)
            cellText = "止损";
         else if (row == 1 && col == 1)
            cellText = DoubleToString(s2, _Digits);
         else if (row == 2 && col == 0)
            cellText = "手数";
         else if (row == 2 && col == 1)
            cellText = DoubleToString(lots, 2);
         // 添加止损金额标签和值
         else if (row == 3 && col == 0)
            cellText = "5%";
         else if (row == 3 && col == 1)
            cellText = DoubleToString(accountPercentage, _Digits);

         // 创建单元格
         int cell = ObjectCreate(0, "TableCell" + IntegerToString(cellIndex), OBJ_LABEL, 0, 0, 0);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_XDISTANCE, startX + col * cell_width);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_YDISTANCE, startY + row * cell_height);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_WIDTH, cell_width);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_YSIZE, cell_height); // 设置单元格高度
         ObjectSetString(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_TEXT, cellText);
         ObjectSetString(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_COLOR, font_color);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_FONTSIZE, font_size);
      }
   }

   return(rates_total);
}
