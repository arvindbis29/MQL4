//+------------------------------------------------------------------+
//|                                 _HPCS_Inter1_MT4_Indi_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

double gd_Buff_buysignal[], gd_Buff_sellSignal[];
// No of Previous Candle
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
      for(int i = Bars-100; i>0; i+(iBars(0,PERIOD_H1)))
        {
        
          
         int x=i+(iBars(0,PERIOD_H1));
         int li_index = iHighest(_Symbol,PERIOD_H1,MODE_HIGH,10,i+1);//show index number of highest
         // Print(li_index);
          gd_Buff_buysignal[i] = High[li_index];  //iHigh(_Symbol, _Period,li_index);// show the price value of highest

         int li_index1 = iHighest(_Symbol,PERIOD_H1,MODE_LOW,10,x);//show index number of highest
         gd_Buff_sellSignal[i]=Low[li_index1];
         //--- return value of prev_calculated for next call
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
