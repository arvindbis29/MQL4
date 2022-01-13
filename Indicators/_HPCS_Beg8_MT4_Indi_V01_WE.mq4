//+------------------------------------------------------------------+
//|                                   _HPCS_Beg8_MT4_Indi_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

double gd_Buff_bullishUp[], gd_Buff_bullishDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

SetIndexBuffer(0,gd_Buff_bullishUp);
SetIndexStyle(0,DRAW_HISTOGRAM,EMPTY,4,clrBlue);

SetIndexBuffer(1,gd_Buff_bullishDown);
SetIndexStyle(1,DRAW_HISTOGRAM,EMPTY,4,clrBlue);




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
   for(int i =0; i<Bars; i++)
     {
      if(Open[i]<Close[i])
        {
        gd_Buff_bullishDown[i] = Open[i];
        gd_Buff_bullishUp[i] = Close[i];
        }
      else
        {
         ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,0,clrRed);
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
