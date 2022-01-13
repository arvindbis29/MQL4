//+------------------------------------------------------------------+
//|                            _HPCS_MT4_Training_Demo_EA_V01_WE.mq4 |
//|                  Copyright 2011-2020, HPC Sphere Pvt. Ltd. India |
//|                                         https://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property strict
#property icon "\\Files\\hpcs_logo.ico"
#property link "https://www.hpcsphere.com"
#property copyright "Copyright 2011-2020, HPC Sphere Pvt. Ltd. India"
#property version "1.00"

input int gd_minLots; //Minimum lots to be allowed

input int gd_maxLots=8; //Maximum lots to be allowed
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

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

  }
//+------------------------------------------------------------------+
