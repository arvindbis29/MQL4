//+------------------------------------------------------------------+
//|                                   _HPCS_beg6_MT4_Indi_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

input       int tolerance = 10;     // Input tolerance

double gd_Buff_Upsignal[], gd_Buff_DownSignal[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Buff_Upsignal);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrBlue);
   SetIndexArrow(0,225);

   SetIndexBuffer(1,gd_Buff_DownSignal);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,2,clrRed);
   SetIndexArrow(1,226);


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
   int difference = (int)((Close[1] - Close[0])/ Point());
   if(difference > tolerance)
      gd_Buff_Upsignal[1] = High[1];
   else
      gd_Buff_DownSignal[1] = Low[1];

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
