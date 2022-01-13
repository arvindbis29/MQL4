//+------------------------------------------------------------------+
//|                                 _HPCS_INT_INDI_2B_MT4_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   string ls_close=iRSI(NULL,0,14,PRICE_CLOSE,0);
//ObjectDelete(0,"q4");
                        ObjectCreate(0,"q4",OBJ_LABEL,0,1,1);
                        ObjectSetInteger(0,"q4",OBJPROP_XDISTANCE,10);
                        ObjectSetInteger(0,"q4",OBJPROP_YDISTANCE,10);
                        ObjectSetInteger(0,"q4",OBJPROP_CORNER,CORNER_LEFT_UPPER);
                        ObjectSetString(0,"q4",OBJPROP_FONT,"Arial");
                        ObjectSetString(0,"q4",OBJPROP_TEXT,"current RSI VAlue="+ls_close);
                        ObjectSetInteger(0,"q4",OBJPROP_COLOR,clrRed);


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
