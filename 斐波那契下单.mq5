//+------------------------------------------------------------------+
//|                                                        斐波下单.mq5 |
//|                                   Copyright 2022, MetaQuotes Ltd. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "XP_止盈功能修改,挂单功能修改"
#property link      "https://www.mql5.com"
#property version   "4.00"
#property script_show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
enum trade_entry
{
   entry_market,             // 现价入场
   entry_pending             // 挂单入场
};

enum trade_direction
{
   trade_buy,                 // 买单
   trade_sell                 // 卖单
};
enum take_profit_level
{
   tp_1618 = 1618,           //TP1
   tp_2618 = 2618,           //TP2
   tp_4236 = 4236              //TP3
};

enum pending_entry_level
{
   level_0236 = 236,    //Minor
   level_0382 = 382,    //Major 
   level_0500 = 500,    //61.8 %
   level_0618 = 618,      //50%
   level_0786 = 786,    //Pullback
   level_0880 = 880       //Breakout
};
//--- 输入参数
input trade_entry entry = entry_market;
input trade_direction order = trade_buy;
input double ratio = 0.05;
double volume = 0.01;
input take_profit_level take_profits = tp_2618;
input pending_entry_level entry_level = level_0786;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
{
   int object_total = ObjectsTotal(0, 0, OBJ_FIBO);
   long object_time = 0;
   string object_name = "";
   for (int i = 0; i < object_total; i++)
   {
      string name = ObjectName(0, i, 0, OBJ_FIBO);
      long time = ObjectGetInteger(0, name, OBJPROP_TIME);
      if (time > object_time)
      {
         object_time = time;
         object_name = name;
      }
   }
   double s1 = ObjectGetDouble(0, object_name, OBJPROP_PRICE, 0);
   double s2 = ObjectGetDouble(0, object_name, OBJPROP_PRICE, 1);

   double account_e = AccountInfoDouble(ACCOUNT_EQUITY);
   long digits = SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);

   if (order == trade_buy)
   {
      if (entry == entry_market)
      {
         // 现价买入
         MqlTradeRequest request = {};
         MqlTradeResult result = {};

         if (SymbolInfoDouble(_Symbol, SYMBOL_ASK) <= s2 || SymbolInfoDouble(_Symbol, SYMBOL_ASK) >= s1)
         {
            Alert("价格不在0-100之间");
            return;
         }

         double lots = account_e * ratio / ((SymbolInfoDouble(_Symbol, SYMBOL_ASK) - s2) * size);
         lots = NormalizeDouble(lots, 2);
double tp_percentage;
if (take_profits == tp_1618)
    tp_percentage = 161.8;
else if (take_profits == tp_2618)
    tp_percentage = 261.8;
else if (take_profits == tp_4236)
    tp_percentage = 423.6;
request.tp = s2 + tp_percentage * (s1 - s2) * 0.01;

         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.volume = lots;
         request.type = ORDER_TYPE_BUY;                       // 订单类型
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK); // 持仓价格
         request.deviation = 30;
         request.sl = s2;
         request.type_filling = ORDER_FILLING_IOC;

         if (!OrderSend(request, result))
         {
            request.type_filling = ORDER_FILLING_FOK;
            if (!OrderSend(request,result))
{
request.type_filling = ORDER_FILLING_RETURN;
if (!OrderSend(request, result))
{
printf("Open_Buy error %d", GetLastError());
}
}
}
}
else if (entry == entry_pending)
{
// 挂单买入
double entry_percentage;
if (entry_level == level_0236)
    entry_percentage = 0.236;
else if (entry_level == level_0382)
    entry_percentage = 0.382;
else if (entry_level == level_0500)
    entry_percentage = 0.5;
else if (entry_level == level_0618)
    entry_percentage = 0.618;
else if (entry_level == level_0786)
    entry_percentage = 0.786;
else if (entry_level == level_0880)
    entry_percentage = 0.88;
double entry_price = s2 - (s2 - s1) * entry_percentage;
     MqlTradeRequest request = {};
     MqlTradeResult result = {};
/*
     if (SymbolInfoDouble(_Symbol, SYMBOL_ASK) <= entry_price || SymbolInfoDouble(_Symbol, SYMBOL_ASK) >= s1)
     {
        Alert("价格不在0-100之间");
        return;
     }
*/
     double lots = account_e * ratio / ((entry_price - s2) * size);
     lots = NormalizeDouble(lots, 2);
double tp_percentage;
if (take_profits == tp_1618)
    tp_percentage = 161.8;
else if (take_profits == tp_2618)
    tp_percentage = 261.8;
else if (take_profits == tp_4236)
    tp_percentage = 423.6;
request.tp = s2 + tp_percentage * (s1 - s2) * 0.01;

     request.action = TRADE_ACTION_PENDING;
     request.symbol = _Symbol;
     request.volume = lots;
     request.type = ORDER_TYPE_BUY_LIMIT;                 // 挂单类型为Buy Stop
     request.price = entry_price;                        // 挂单价格为61.8%的水平
     request.deviation = 30;
     request.sl = s2;
     request.type_filling = ORDER_FILLING_IOC;

     if (!OrderSend(request, result))
     {
        request.type_filling = ORDER_FILLING_FOK;
        if (!OrderSend(request, result))
        {
           request.type_filling = ORDER_FILLING_RETURN;
           if (!OrderSend(request, result))
           {
              printf("Open_Buy_Stop error %d", GetLastError());
           }
        }
     }
  }
}
else if (order == trade_sell)
{
if (entry == entry_market)
{
// 现价卖出
MqlTradeRequest request = {};
MqlTradeResult result = {};
     if (SymbolInfoDouble(_Symbol, SYMBOL_BID) >= s2 || SymbolInfoDouble(_Symbol, SYMBOL_BID) <= s1)
     {
        Alert("价格不在0-100之间");
        return;
     }

     double lots = account_e * ratio / ((s2 - SymbolInfoDouble(_Symbol, SYMBOL_BID)) * size);
     lots = NormalizeDouble(lots, 2);
double tp_percentage;
if (take_profits == tp_1618)
    tp_percentage = 161.8;
else if (take_profits == tp_2618)
    tp_percentage = 261.8;
else if (take_profits == tp_4236)
    tp_percentage = 423.6;
request.tp = s2 + tp_percentage * (s1 - s2) * 0.01;

     request.action = TRADE_ACTION_DEAL;
     request.symbol = _Symbol;
     request.volume = lots;
     request.type = ORDER_TYPE_SELL;                      // 订单类型
     request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID); // 持仓价格
     request.deviation = 30;
     request.sl = s2;
     request.type_filling = ORDER_FILLING_IOC;

     if (!OrderSend(request, result))
     {
        request.type_filling = ORDER_FILLING_FOK;
        if (!OrderSend(request, result))
        {
           request.type_filling = ORDER_FILLING_RETURN;
           if (!OrderSend(request, result))
           {
              printf("Open_sell error %d", GetLastError());
           }
        }
     }
  }
  else if (entry == entry_pending)
  {
     // 挂单卖出
    double entry_percentage;
if (entry_level == level_0236)
    entry_percentage = 0.236;
else if (entry_level == level_0382)
    entry_percentage = 0.382;
else if (entry_level == level_0500)
    entry_percentage = 0.5;
else if (entry_level == level_0618)
    entry_percentage = 0.618;
else if (entry_level == level_0786)
    entry_percentage = 0.786;
else if (entry_level == level_0880)
    entry_percentage = 0.88;
double entry_price = s2 - (s2 - s1) * entry_percentage;

     MqlTradeRequest request = {};
     MqlTradeResult result = {};
/*
     if (SymbolInfoDouble(_Symbol, SYMBOL_BID) >= entry_price || SymbolInfoDouble(_Symbol, SYMBOL_BID) <= s1)
{
Alert("价格不在0-100之间");
return;
}	 */
	      double lots = account_e * ratio / ((s2 - entry_price) * size);
     lots = NormalizeDouble(lots, 2);
double tp_percentage;
if (take_profits == tp_1618)
    tp_percentage = 161.8;
else if (take_profits == tp_2618)
    tp_percentage = 261.8;
else if (take_profits == tp_4236)
    tp_percentage = 423.6;
request.tp = s2 + tp_percentage * (s1 - s2) * 0.01;

     request.action = TRADE_ACTION_PENDING;
     request.symbol = _Symbol;
     request.volume = lots;
     request.type = ORDER_TYPE_SELL_LIMIT;                // 挂单类型为Sell Stop
     request.price = entry_price;                        // 挂单价格为61.8%的水平
     request.deviation = 30;
     request.sl = s2;
     request.type_filling = ORDER_FILLING_IOC;

     if (!OrderSend(request, result))
     {
        request.type_filling = ORDER_FILLING_FOK;
        if (!OrderSend(request, result))
        {
           request.type_filling = ORDER_FILLING_RETURN;
           if (!OrderSend(request, result))
           {
              printf("Open_sell_Stop error %d", GetLastError());
           }
        }
     }
  }
}
}
