//+------------------------------------------------------------------+
//|                                _HPCS_Adva_MT4_indi_04_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
double gd_Buff_wick[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   takeSnapshot();
   
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
//--- takeSnapshot();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void takeSnapshot()
  {
//need to be set timer in EventSetTimer in Init and call this function in OnTimer and then EventSetTimer in Init
   static int snapshot_counter = 0 ;
   ChartScreenShot(0,StringConcatenate("snap_",snapshot_counter),800,600,ALIGN_CENTER);
   snapshot_counter++;
  }
//+------------------------------------------------------------------+
