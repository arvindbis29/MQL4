//+------------------------------------------------------------------+
//|                                                           q3.mq4 |
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
   EventSetTimer(60);
   double high=iHigh(Symbol(),Period(),1); 
   double low=iLow(Symbol(),Period(),1); 
   double close=iClose(Symbol(),Period(),1); 
   double open=iOpen(Symbol(),Period(),1); 
   
   MessageBox("high=" +high+" low= "+low+" close=  "+close+ "  open=" +open);
   int ak=FileOpen("ak.csv",FILE_READ|FILE_WRITE|FILE_CSV);
   if(ak!=INVALID_HANDLE)
     {
     string ohlcvalue = DoubleToStr(open,5) + DoubleToStr(high,5) + DoubleToStr(low,5) + DoubleToStr(close,5);
     FileWriteString(ak,ohlcvalue);
     }
      FileClose(ak);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
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
