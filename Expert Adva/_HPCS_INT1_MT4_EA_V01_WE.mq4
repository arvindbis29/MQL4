//+------------------------------------------------------------------+
//|                                     _HPCS_INT1_MT4_EA_V01_WE.mq4 |
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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---



   int factor = 1;
   if(Digits() == 3 && Digits() == 5)
      factor = 10;



   int li_total= OrdersHistoryTotal();
   int counter = 0;
   for(int i=0; i<li_total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         OrderPrint();
         if(OrderProfit() > 0)
           {
            counter++;
           }

        }
     }
   Print("total profit order are : ",counter);



// Ques -3
   double ld_takeprofit =  Ask +  ii_takeprofit *Point() * factor;
   double ld_stoploss = Ask - ii_stoploss * Point() * factor;
   if(ld_stoploss < Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
     {
      // that is fine
     }
   else
      ld_stoploss = Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();

 double ld_takeprofitforsell= Bid - ii_takeprofit*Point()*factor;
 double ld_stoplossforsell=Bid + ii_stoploss*Point()*factor;
 
 if(ld_stoplossforsell > Ask + MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
 {
 
 }
 else
 {
    ld_stoplossforsell=Ask+ MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();
 }
   li_ticket = OrderSend(_Symbol,OP_SELL,id_lots,Ask, ii_slippage, 0, 0, " first Order",ii_magicno, 0, clrBlue);
   if(li_ticket < 0)
     {
      Print("Order send fail ",GetLastError());
     }

   if(!OrderModify(li_ticket,0,ld_stoploss, ld_takeprofit, 0,clrRed))
     {
      Print("Order Modify Failed ! ",GetLastError());
     }

   EventSetTimer(300);
//1 point = 0.00001 price;

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
void OnTimer()
  {
   if(OrderSelect(li_ticket,SELECT_BY_TICKET,MODE_TRADES))
      if(OrderCloseTime() == 0)
         if(!OrderClose(li_ticket,OrderLots(),OrderClosePrice(),10,clrBlue))
            Print("Order CLosed Failed ",GetLastError());


  }
//+------------------------------------------------------------------+
