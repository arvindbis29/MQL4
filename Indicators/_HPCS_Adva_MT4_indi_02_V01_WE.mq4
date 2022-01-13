//+------------------------------------------------------------------+
//|                                _HPCS_Adva_MT4_indi_02_V01_WE.mq4 |
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
int gi_ticks =0, gi_sec = 0;
datetime prevCandle = Time[0];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Buff_wick);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrBlue);
   SetIndexArrow(0,225);
   EventSetTimer(1);
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
   gi_ticks++;
   if(prevCandle != Time[0])
     {
      gi_sec = 0;
      gi_ticks = 0;
      prevCandle = Time[0];
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   gi_sec++;
   Print(gi_sec,"    ",gi_ticks);
   if(gi_sec >gi_ticks)
     {
      int li_missingticks = gi_sec - gi_ticks;
      ObjectDelete(0,"Missing Ticks " + TimeToStr(Time[0]));
      if(ObjectCreate(0,"Missing Ticks " + TimeToStr(Time[0]),OBJ_TEXT,0,Time[0], High[0] + 20 * Point()))

         //ObjectSetText("Missing Ticks " + TimeToStr(Time[0]),IntegerToString(li_missingticks),2,NULL,clrWheat);
         ObjectSetString(0,"Missing Ticks " + TimeToStr(Time[0]),OBJPROP_TEXT,IntegerToString(li_missingticks));
         ObjectSetInteger(0,"Missing Ticks " + TimeToStr(Time[0]),OBJPROP_COLOR,clrWhite);
     }

  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll(0,"Missing Ticks");
   EventKillTimer();
  }
//+------------------------------------------------------------------+
