//+------------------------------------------------------------------+
//|                                                           q5.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input string starttime  = "HH:MM";
input string stoptime   = "HH:MM";
bool Terminated = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime prevCandleTime = iTime(_Symbol,_Period,0);
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ObjectDelete(0,"EA Operation");
   if(!ObjectCreate(0,"EA Operation",OBJ_LABEL,0,1,1))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
     }
   else
     {
      MessageBox("Object Created");
     }
//ObjectSet(0,OBJPROP_CORNER,0);
   ObjectSetInteger(0,"EA OPeration",OBJPROP_XDISTANCE,10);
   ObjectSetInteger(0,"EA OPeration",OBJPROP_YDISTANCE,10);
   ObjectSetInteger(0,"EA Operation",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetString(0,"EA Operation",OBJPROP_TEXT,"IT is a trade day");
   ObjectSetInteger(0,"EA Operation",OBJPROP_COLOR,clrDarkGreen);
   ObjectSetString(0,"EA Operation",OBJPROP_FONT,"Arial");

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   datetime ldt_startime = StringToTime(starttime);
   datetime ldt_stoptime = StringToTime(stoptime);

   if(TimeCurrent() > ldt_startime && TimeCurrent() < ldt_stoptime)
     {
      ObjectSetInteger(0,"EA Operation",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetString(0,"EA Operation",OBJPROP_TEXT,"EA operating");
      ObjectSetInteger(0,"EA Operation",OBJPROP_COLOR,clrDarkGreen);
     }
   else
     {

      ObjectSetInteger(0,"EA Operation",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetString(0,"EA Operation",OBJPROP_TEXT,"Outside time duration");
      ObjectSetInteger(0,"EA Operation",OBJPROP_COLOR,clrRed);
     }

   /* if(prevCandleTime != iTime(_Symbol,_Period,0))
      {
       Alert("New candle formed");
      }
   */



    if (Terminated == true)
      {
      Comment("EA is Currently Terminated.");


      }
   datetime ldt_stoptime = StringToTime(stoptime);

    if (TimeCurrent()>=ldt_stoptime)
       {
         ExpertRemove();
         }       
  }
//+------------------------------------------------------------------+
