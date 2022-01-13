//+------------------------------------------------------------------+
//|                                 _HPCS_beg11_MT4_Indi_V011_WE.mq4 |
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
   SetIndexArrow(0,108);

   SetIndexBuffer(1,gd_Buff_sellSignal);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,2,clrRed);
   SetIndexArrow(1,108);
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
         if(iSAR(NULL,0,0.02,0.2, i) >High[i] && iSAR(NULL,0,0.02,0.2, i+1) <Low[i+1]  ){
            gd_Buff_buysignal[i] = High[i];}

         if(iSAR(NULL,0, 0.02,0.2, i) <Low[i] && iSAR(NULL,0, 0.02,0.2, i+1) >High[i+1]){
            gd_Buff_sellSignal[i] = High[i];}
        }
     }

   if(iSAR(NULL,0, 0.02,0.2,0) > High[0]){
      gd_Buff_buysignal[0] = High[0];}


   if(iSAR(NULL,0,0.02,0.2, 0) < Low[0]){
      gd_Buff_sellSignal[0] = High[0];}
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
