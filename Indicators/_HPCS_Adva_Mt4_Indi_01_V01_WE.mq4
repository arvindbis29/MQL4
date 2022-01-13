//+------------------------------------------------------------------+
//|                                _HPCS_Adva_Mt4_Indi_01_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
input int ii_limit = 10; // Limit
double gd_Buff_wick[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Buff_wick);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrBlue);
   SetIndexArrow(0,225);


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
      for(int i = Bars-2; i>0; i--)
        {
         int upperwick= (int)((High[i]- MathMax(Close[i],Open[i]))/ Point());
         int lowerwick= (int)((MathMin(Open[i],Close[i]) -Low[i]) /Point());
         if(upperwick>ii_limit&&lowerwick>ii_limit)
           {
            gd_Buff_wick[i]=High[i];

           }
        }
     }
      int upperwick= (int)((High[0]- MathMax(Close[0],Open[0]))/ Point());
         int lowerwick= (int)((MathMin(Open[0],Close[0]) -Low[0]) /Point());
         if(upperwick>ii_limit&&lowerwick>ii_limit)
           {
            gd_Buff_wick[0]=High[0];

           }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
