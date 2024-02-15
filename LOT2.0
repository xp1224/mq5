//+------------------------------------------------------------------+
//| 手数计算.mq5                                                     |
//|                                                                  |
//| https://www.mql5.com                                             |
//+------------------------------------------------------------------+
#property copyright "xp"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property indicator_chart_window
#property script_show_inputs

input string target_object_name = "1";
input color font_color = clrWhite;
input double stop_loss_amount = 50.0;
input double risk_percentage = 5;
input int cell_width = 150; // 单元格宽度
input int cell_height = 30; // 单元格高度
input int font_size = 10; // 字体大小

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

   // 计算止损距离
   double stop_loss_pips = MathAbs(s1 - s2);

   // 计算手数
   double margin_required = SymbolInfoDouble(_Symbol, SYMBOL_MARGIN_INITIAL);
   double lots = stop_loss_amount / stop_loss_pips * _Point;

   // 计算实际的止损金
  
   double accountPercentage = risk_percentage / 100.0 * AccountInfoDouble(ACCOUNT_BALANCE); // 风险金额为账户余额的百分比

   // 获取图表的宽度和高度
   int chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);

   // 设置表格的行数和列数
   int rows = 4;
   int cols = 2;

   // 计算表格的起始位置
   int startX = chartWidth - cell_width * cols;
   int startY = chartHeight - 300; // 您可以根据需要调整表格的位置

   // 删除之前的对象
   for (int i = 0; i < rows * cols; i++)
      ObjectDelete(0, "TableCell" + IntegerToString(i));

   // 绘制表格
   for (int row = 0; row < rows; row++)
   {
      for (int col = 0; col < cols; col++)
      {
         int cellIndex = row * cols + col;
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
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_YDISTANCE, startY + row * cell_height); // 调整单元格的垂直间距
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_WIDTH, cell_width);
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_YSIZE, cell_height); // 设置单元格高度
         ObjectSetString(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_TEXT, cellText);
         ObjectSetString(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_COLOR, font_color); // 将字体颜色设置为用户输入的颜色 // 将字体颜色设置为黑色
         ObjectSetInteger(0, "TableCell" + IntegerToString(cellIndex), OBJPROP_FONTSIZE, font_size); // 设置字体大小
      }
   }

   return(rates_total);
}
