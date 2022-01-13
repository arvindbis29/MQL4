//+------------------------------------------------------------------+
//|                              _HPCS_INT_NIDI_2C_MT4_EA_V01_WE.mq4 |
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
      for(int i = Bars-3; i>0; i--)
        {
         if(iRSI(NULL,0,14,PRICE_CLOSE,i) >iRSI(NULL,0,14,PRICE_CLOSE,i+1) && iRSI(NULL,0,14,PRICE_CLOSE,i) >iRSI(NULL,0,14,PRICE_CLOSE,i-1))
           {
            gd_Buff_buysignal[i] = High[i];
           }
         if(iRSI(NULL,0,14,PRICE_CLOSE,i) <iRSI(NULL,0,14,PRICE_CLOSE,i+1) && iRSI(NULL,0,14,PRICE_CLOSE,i) <iRSI(NULL,0,14,PRICE_CLOSE,i-1))
           {
            gd_Buff_sellSignal[i] = Low[i];
           }
        }
     }

   if(iRSI(NULL,0,14,PRICE_CLOSE,1) >iRSI(NULL,0,14,PRICE_CLOSE,2) && iRSI(NULL,0,14,PRICE_CLOSE,1) >iRSI(NULL,0,14,PRICE_CLOSE,0))
  {
             gd_Buff_buysignal[1]= High[1];
     }


   if(iRSI(NULL,0,14,PRICE_CLOSE,1) >iRSI(NULL,0,14,PRICE_CLOSE,2) && iRSI(NULL,0,14,PRICE_CLOSE,1) >iRSI(NULL,0,14,PRICE_CLOSE,0))
  {
              gd_Buff_sellSignal[1] = Low[1];

     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
