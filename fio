//+------------------------------------------------------------------+
//|                                                           ea.mq5 |
//|                                  版权所有 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "版权所有 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| 专家顾问                                                         |
//| 寻找最低和最高收盘价的K线，在最低K线之后寻找UPDB信号           |
//+------------------------------------------------------------------+
input int candlesToAnalyze = 2000; // 分析的K线数量

//+------------------------------------------------------------------+
//| 专家初始化函数                                                  |
//+------------------------------------------------------------------+
void OnInit()
{
    MqlRates rates[];
    ArraySetAsSeries(rates, true);

    int copied = CopyRates(_Symbol, _Period, 0, candlesToAnalyze, rates);
    if (copied > 0)
    {
        double lowestClose = rates[0].close;
        int lowestCloseIndex = 0;

        // 寻找具有最低收盘价的K线
        for (int i = 1; i < copied; i++)
        {
            if (rates[i].close < lowestClose)
            {
                lowestClose = rates[i].close;
                lowestCloseIndex = i;
            }
        }

        // 输出UPIB K线的详细信息
        Print("UPIB 最低价格：", lowestClose, "，UPIB K线收盘价格：", rates[lowestCloseIndex].close, "，UPIB K线时间：", TimeToString(rates[lowestCloseIndex].time));

        

        // 寻找 UPDB 信号
        int UPDBSignalIndex = -1;
        for (int i = lowestCloseIndex + 1; i < copied; i++)
        {
            if (rates[i].close > rates[i].open)
            {
                UPDBSignalIndex = i;
                break; // 找到上涨K线，结束循环
            }
        }

        // 输出 UPDB 信号的详细信息
        string UPDBSignal = "UPDB 信号";
        if (UPDBSignalIndex != -1)
        {
            Print("在UPIB K线后找到上涨K线，开盘价格标记为：", UPDBSignal, "，开盘价：", rates[UPDBSignalIndex].open, "，时间：", TimeToString(rates[UPDBSignalIndex].time));

            // 寻找 UPDB 突破
            for (int i = UPDBSignalIndex - 1; i >= 0; i--)
            {
                if (rates[i].close > rates[UPDBSignalIndex].open)
                {
                    rates[i].close = rates[i].close + 0.001; // 修改符合条件的K线的收盘价格为 UPDB 突破的收盘价格
                    string UPDBBreakout = "UPDB 突破";
                    Print("UPDB 突破：收盘价格高于 UPDB 信号K线的开盘价格。收盘价：", rates[i].close, "，时间：", TimeToString(rates[i].time));
                    break; // 找到符合条件的K线后结束循环
                }
            }
 // 确定斐波那契回调的最低和最高价格水平
    double UPDBBreakoutClose = 0.0; // 初始化UPDB突破的收盘价格
    double lowestLow = rates[lowestCloseIndex].low; // UPIB K线的最低价格

    // 寻找 UPDB 突破，并确定其收盘价格
    if (UPDBSignalIndex != -1) {
        for (int i = UPDBSignalIndex - 1; i >= 0; i--) {
            if (rates[i].close > rates[UPDBSignalIndex].open) {
                UPDBBreakoutClose = rates[i].close;
                break;
            }
        }
    }

    // 计算最低和最高价格之间的差值
    double priceDifference = UPDBBreakoutClose - lowestLow;

    // 计算斐波那契水平
    double fib0 = lowestLow;
    double fib100 = UPDBBreakoutClose;
    double fib23_6 = lowestLow + (priceDifference * 0.236);
    double fib38_2 = lowestLow + (priceDifference * 0.382);
    double fib61_8 = lowestLow + (priceDifference * 0.618);
    double fib161_8 = lowestLow + (priceDifference * 1.618);
    double fib261_8 = lowestLow + (priceDifference * 2.618);
    double fib423_6 = lowestLow + (priceDifference * 4.236);
   
    // 输出斐波那契水平
    Print("斐波那契水平：");
    Print("0%（IB 最低点）：", fib0);
    Print("23.6%：", fib23_6);
    Print("38.2%：", fib38_2);
    Print("61.8%：", fib61_8);
    Print("161.8% （TP1）：", fib161_8);
    Print("261.8%（TP2）：", fib261_8);
    Print("423.6%（TP3）：", fib423_6);
    Print("100%（UPDB 突破收盘价格）：", fib100);
   
        }
        else
        {
            Print("未找到 UPDB 信号");
        }
    }
    else
    {
        Print("无法获取K线数据。错误代码: ", GetLastError());
    }
}
