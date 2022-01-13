//+------------------------------------------------------------------+
//|                                   _HPCS_INT1_Mt4_EA_5_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
input double id_lots = 0.01;  // Lots SIze
input int ii_stoploss = 10;  // Stop loss(in pips)
input int ii_takeprofit = 10; // Take Profit (in pips)
input int ii_magicno = 23846; // Magic Number
input int ii_slippage = 10; // Slippage

int li_ticket =-1;
datetime gdt_previous = Time[1];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   /* int factor = 1;
    if(Digits() == 3 && Digits() == 5)
       factor = 10;
    double ld_takeprofit =  Ask +  ii_takeprofit *Point() * factor;
    double ld_stoploss = Ask - ii_stoploss * Point() * factor;
    if(ld_stoploss < Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
      {
       // that is fine
      }
    else
       ld_stoploss = Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();



    li_ticket = OrderSend(_Symbol,OP_BUY,id_lots, Ask, ii_slippage, 0, 0, " first Order",ii_magicno, 0, clrBlue);
    if(li_ticket < 0)
      {
       Print("Order send fail ",GetLastError());
      }

    if(!OrderModify(li_ticket,0,ld_stoploss, ld_takeprofit, 0,clrRed))
      {
       Print("Order Modify Failed ! ",GetLastError());
      }*/
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

   if(Close[5]>Close[0])
     {
      if(gdt_previous != Time[0])
        {
         int factor = 1;
         if(Digits() == 3 && Digits() == 5)
            factor = 10;
         double ld_takeprofit =  Ask +  ii_takeprofit *Point() * factor;
         double ld_stoploss = Ask - ii_stoploss * Point() * factor;
         if(ld_stoploss < Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
           {
            // that is fine
           }
         else
            ld_stoploss = Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();



         li_ticket = OrderSend(_Symbol,OP_BUY,id_lots, Ask, ii_slippage,ld_stoploss, ld_takeprofit, " first Order",ii_magicno, 0, clrBlue);
         if(li_ticket < 0)
            Print("Order send fail ",GetLastError());
         else
            gdt_previous = Time[0];
        }

     }
  }
//+------------------------------------------------------------------+
