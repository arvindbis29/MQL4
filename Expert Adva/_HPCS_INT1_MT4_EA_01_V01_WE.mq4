//+------------------------------------------------------------------+
//|                                  _HPCS_INT1_MT4_EA_01_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
//---
   string arr[];
   int li_handle=FileOpen("ak.csv",FILE_READ|FILE_WRITE|FILE_CSV);
   if(li_handle!=INVALID_HANDLE)
     {
      //--- read all data from the file to the array
      string ls_data = FileReadString(li_handle);
      StringSplit(ls_data,StringGetChar(",",0),arr);
      //FileReadArray(li_handle,arr);
      //--- receive the array size
      int size=ArraySize(arr);
      Print("Total data = ",size);
      //--- print data from the array
      for(int i=0; i<size; i++)
        {
         Print(arr[i],"\n");
        }
      //--- close the file
      FileClose(li_handle);
     }
     else
     {
     MessageBox("error");
     }
  }

//---


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

  }
//+------------------------------------------------------------------+
