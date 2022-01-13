//+------------------------------------------------------------------+
//|                              _HPCS_INT_INDI_2D_MT4_EA-V01_WE.mq4 |
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
         if(iRSI(NULL,0,14,PRICE_CLOSE,i) >70 /*&& iRSI(NULL,0,14,PRICE_CLOSE,i+1) <=30 */)
           {
            ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,i,clrRed);
           }
         if(iRSI(NULL,0,14,PRICE_CLOSE,i) <30/* && iRSI(NULL,0,14,PRICE_CLOSE,i+1) >=70*/)
           {
            ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,i,clrBlue);
           }
        }
     }

   if((iRSI(NULL,0,14,PRICE_CLOSE,0))> 70)
     {
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,0,clrRed);
     }


   if((iRSI(NULL,0,14,PRICE_CLOSE,0)) < 30)
     {
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,0,clrBlue);;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
