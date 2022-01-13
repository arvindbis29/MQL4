//+------------------------------------------------------------------+
//|                                                       practi.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2;
input int tolerance=10; //input tolerance

double gd_buff_Upsignal[], gd_buff_downsignal[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_buff_Upsignal);
   SetIndexStyle(0,DRAW_ARROW,0,3,clrBlueViolet);
   SetIndexArrow(0,225);
   SetIndexBuffer(1,gd_buff_downsignal);
   SetIndexStyle(1,DRAW_ARROW,0,3,clrRed);
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

   int li_defference= (int)((Close[1]-Close[0])/Point());
   if(li_defference< tolerance)
      gd_buff_Upsignal[1]=High[1];
   else
      gd_buff_downsignal[1]=Low[1];
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
