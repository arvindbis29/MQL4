//+------------------------------------------------------------------+
//|                             _HPCS_FastSlowMA_MT4_Indi_V01_WE.mq4 |
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
         if(iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,i)>iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,i) && iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,i+1)<=iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,i+1))
           {
            gd_Buff_buysignal[i] =  Low[i];
           }
         if(iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,i)<iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,i) && iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,i+1)>=iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,i+1))
           {
            gd_Buff_sellSignal[i] =  High[i];
           }
        }
     }

   if(iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,0)>iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,0) && iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,1)<=iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,1))
     {
      gd_Buff_buysignal[0] =  Low[0];
     }
   if(iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,0)<iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,0) && iMA(NULL,0,ii_fastPeriod,0,MODE_SMA,PRICE_CLOSE,1)>=iMA(NULL,0,ii_slowPeriod,0,MODE_SMA,PRICE_CLOSE,1))
     {
      gd_Buff_sellSignal[0] =  High[0];
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


/*1 trade 
0.1      Loss        -1 Doller
0.2      Loss        -2 Doller
0.4      Loss        -4 Doller
0.8      Profit      +8 Doller
                     +1
*/