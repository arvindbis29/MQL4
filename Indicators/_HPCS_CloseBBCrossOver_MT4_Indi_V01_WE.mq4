//+------------------------------------------------------------------+
//|                       _HPCS_CloseBBCrossOver_MT4_Indi_V01_WE.mq4 |
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
         if(iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_LOWER,i)>=Close[i] && iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_LOWER,i)<=Open[i])
           {
            gd_Buff_buysignal[i] =  Low[i];
           }
         if(iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_UPPER,i)>=Close[i] && iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_UPPER,i)<=Open[i])
           {
            gd_Buff_sellSignal[i] =  High[i];
           }
        }
     }

   if(iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_LOWER,0)>=Close[0] && iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_LOWER,0)<=Open[0])
     {
      gd_Buff_buysignal[0] =  Low[0];
     }
   if(iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_UPPER,0)>=Close[0] && iBands(NULL,0,0,0,0,PRICE_CLOSE,MODE_LOWER,0)<=Open[0])
     {
      gd_Buff_sellSignal[0] =  High[0];
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
