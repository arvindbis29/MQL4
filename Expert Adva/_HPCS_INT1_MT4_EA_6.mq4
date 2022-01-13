//+------------------------------------------------------------------+
//|                                          _HPCS_INT1_MT4_EA_6.mq4 |
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


datetime gdt_previous = Time[1];
int li_ticket=-1;
int li_ticketforsell=-1;
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

   int factor = 1;
   if(Digits() == 3 && Digits() == 5)
      factor = 10;


   if(iRSI(NULL,0,14,PRICE_CLOSE,0)>70 && iRSI(NULL,0,14,PRICE_CLOSE,1)<=70)
     {
      if(gdt_previous != Time[0])
        {
         double ld_takeprofit =  Ask +  ii_takeprofit *Point() * factor;
         double ld_stoploss = Ask - ii_stoploss * Point() * factor;
         if(ld_stoploss < Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
           {
            // that is fine
           }
         else
            ld_stoploss = Bid - MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();

         li_ticket = OrderSend(_Symbol,OP_SELL,id_lots,Ask, ii_slippage, 0, 0, " first Order",ii_magicno, 0, clrBlue);
         if(li_ticket < 0)
           {
            Print("Order send fail ",GetLastError());
           }
         if(OrderSelect(li_ticketforsell,SELECT_BY_TICKET,MODE_TRADES))
           {

            if(!OrderClose(li_ticketforsell,OrderLots(),OrderClosePrice(),10,clrBlue))
               Print("Order CLosed Failed ",GetLastError());

           }
         gdt_previous=Time[0];
        }
     }

   if(iRSI(NULL,0,14,PRICE_CLOSE,0) <30&& iRSI(NULL,0,14,PRICE_CLOSE,1)>=30)
     {
      if(gdt_previous != Time[0])
        {
         double ld_takeprofitforsell= Bid - ii_takeprofit*Point()*factor;
         double ld_stoplossforsell=Bid + ii_stoploss*Point()*factor;

         if(ld_stoplossforsell > Ask + MarketInfo(_Symbol,MODE_STOPLEVEL) *Point())
           {
            //////////
           }
         else
           {
            ld_stoplossforsell=Ask+ MarketInfo(_Symbol,MODE_STOPLEVEL) *Point();
           }
         li_ticketforsell = OrderSend(_Symbol,OP_SELL,20, Bid, 0, 0, 0, " first Order",0, 0, clrBlue);
         if(li_ticket < 0)
           {
            Print("Order send fail ",GetLastError());

           }


         if(OrderSelect(li_ticket,SELECT_BY_TICKET,MODE_TRADES))
           {

            if(!OrderClose(li_ticket,OrderLots(),OrderClosePrice(),10,clrBlue))
               Print("Order CLosed Failed ",GetLastError());
           }
         gdt_previous=Time[0];
        }
     }

  }




//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
