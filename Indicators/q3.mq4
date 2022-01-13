//+------------------------------------------------------------------+
//|                                                           q3.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ObjectDelete("q3");
   if(ObjectCreate(0,"q3",OBJ_TRIANGLE,0,Time[0],High[1],Time[4],Low[3],Time[6],High[5]))
     {
      MessageBox("Created");
      //--- set triangle color
      ObjectSetInteger(0,"q3",OBJPROP_COLOR,clrRed);
      //--- set style of triangle lines
      ObjectSetInteger(0,"q3",OBJPROP_STYLE,STYLE_SOLID);
      //--- set width of triangle lines
      ObjectSetInteger(0,"q3",OBJPROP_WIDTH,1);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(0,"q3",OBJPROP_BACK,false);
      //--- enable (true) or disable (false) the mode of highlighting the triangle for moving
      //--- when creating a graphical object using ObjectCreate function, the object cannot be
      //--- highlighted and moved by default. Inside this method, selection parameter
      //--- is true by default making it possible to highlight and move the object
      ObjectSetInteger(0,"q3",OBJPROP_SELECTABLE,true);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(0,"q3",OBJPROP_HIDDEN,true);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(0,"q3",OBJPROP_ZORDER,0);
      //--- successful execution
     }
//---
   return(INIT_SUCCEEDED);
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
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
