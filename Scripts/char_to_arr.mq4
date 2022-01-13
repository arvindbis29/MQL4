//+------------------------------------------------------------------+
//|                                                  char_to_arr.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {
//---
  string s="";
   char a[] ={'A','R','V','I','n','d'};
  
   int a1=ArraySize(a);
   for(int i=0; i<a1; i++)
   {
        s=s+CharToStr(a[i]);
       
   }
   MessageBox("String=="+string(s));
   for (int i = 0; i <a1; i++) {
        a[i] = IntegerToString(s[i]);
        
    }
    for(int i=0; i<a1; i++)
   {
       MessageBox(String(a[i]));
       
   }
   

 
   
  }
//+------------------------------------------------------------------+
