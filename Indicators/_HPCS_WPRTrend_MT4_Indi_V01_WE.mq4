//+------------------------------------------------------------------+
//|                               _HPCS_WPRTrend_MT4_Indi_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

input int ii_fastPeriod  = 14; // Fast MA Period
input int ii_slowPeriod  =21; // Slow MA Period
double gd_Buff_buysignal[], gd_Buff_sellSignal[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Buff_buysignal);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrBlue);
   SetIndexArrow(0,225);

   SetIndexBuffer(1,gd_Buff_sellSignal);
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
   if(prev_calculated == 0)
     {
      for(int i = Bars; i>0; i--)
        {
         if(iWPR(NULL,0,14,i)>-20 && iWPR(NULL,0,14,i+1)<=-20)
           {
            gd_Buff_buysignal[i] =  Low[i];
           }
         if(iWPR(NULL,0,14,i)<-80 && iWPR(NULL,0,14,i+1)>=-80)
           {
            gd_Buff_sellSignal[i] =  High[i];
           }
        }
     }

   if(viWPR(NULL,0,14,0)>-20 && iWPR(NULL,0,14,1)<=-20)
     {
      gd_Buff_buysignal[0] =  Low[0];
     }
   if(iWPR(NULL,0,14,)<-80 && iWPR(NULL,0,14,1)>=-80)
     {
      gd_Buff_sellSignal[0] =  High[0];
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
