//+------------------------------------------------------------------+
//|                                                          Q55.mq4 |
//|                  Copyright 2011-2020, HPC Sphere Pvt. Ltd. India |
//|                                         https://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property strict
#property icon "\\Files\\hpcs_logo.ico"
#property link "https://www.hpcsphere.com"
#property copyright "Copyright 2011-2020, HPC Sphere Pvt. Ltd. India"
#property version "1.00"

double gd_Arr_number[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   if(FolderCreate("new_folder",0))
     {
      Print("Folder created!");
      int li_handle = FileOpen("new_folder\\newfile.csv",FILE_WRITE|FILE_READ|FILE_CSV);
      double ld_open = iOpen(Symbol(),Period(),1);
      double ld_close = iClose(Symbol(),Period(),1);
      double high = iHigh(Symbol(),Period(),1);
      double low = iLow(Symbol(),Period(),1);

      //int li_handle = FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV);
      if(li_handle != INVALID_HANDLE)
        {
         Print("File Created");
         string ohlcvalue = DoubleToStr(open,5) + DoubleToStr(high,5) + DoubleToStr(low,5) + DoubleToStr(close,5);
         FileWriteString(handle,ohlcvalue);
        }
      Print("file size : ",FileSize(li_handle));
      FileClose(handle);
      FileDelete(filename);


     }
   if(FolderDelete("new_folder",0))
     {
      Print("floder deleted");
     }
   EventSetTimer(60);

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
