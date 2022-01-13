//+------------------------------------------------------------------+
//|                                                        test1.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
//Print("On InIt function");
   string indicatorname = ChartIndicatorName(0,2,0);
   Print("Name ",indicatorname);

// Ques 3

   double open = iOpen(Symbol(),Period(),1);
   double close = iClose(Symbol(),Period(),1);
   double high = iHigh(Symbol(),Period(),1);
   double low = iLow(Symbol(),Period(),1);

   int handle = FileOpen("externcsv",FILE_READ|FILE_WRITE|FILE_CSV);
   if(handle != INVALID_HANDLE)
     {
      string ohlcvalue = DoubleToStr(open,5) + DoubleToStr(high,5) + DoubleToStr(low,5) + DoubleToStr(close,5);
      FileWriteString(handle,ohlcvalue);
     }
   FileClose(handle);

//---`
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
// Print("On InDeinit function");
   string indicatorname = ChartIndicatorName(0,2,0);
   ChartIndicatorDelete(0,2,indicatorname);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//Print("On Tick function");

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
