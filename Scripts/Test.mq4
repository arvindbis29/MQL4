//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

input datetime time = D'2022.01.02 12:35:00' ;
datetime TimeCurrent();

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {


   /* int day=TimeDay(time);
    Print("timeday= ",day);
    int weekday=TimeDayOfWeek(time);
    Print("TImeof dayweek==",weekday);
    int nday=TimeDayOfYear(time);
    Print("TImeDayofYear",nday);
    bool is_siesta=false;
    if(Hour()>=12 && Hour()<17)
    is_siesta=true;
    Print("hour=",Hour());
    Print("day=",Day());
    Print("minutes=",Minute());
    Print("Month=",Month());
    Print("second=",Seconds());
    */

   if(Period() == PERIOD_H4)
      Print("Yes");
   else
      Print("No");

  }
//+------------------------------------------------------------------+
