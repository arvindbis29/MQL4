//+------------------------------------------------------------------+
//|                                  _HPCS_Adva_MT4_EA_02_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property  library

input double id_lots = 0.01;  // Lots SIze
input double  id_stoploss = 10;  // Stop loss(in pips)
input double id_takeprofit = 10; // Take Profit (in pips)
input int ii_magicno = 23846; // Magic Number
input int ii_slippage = 10; // Slippage




datetime gdt_previous = Time[1];
int li_ticket=-1;
int li_ticketforsell=-1;
int _factor = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(Digits() == 3 && Digits() == 5)
     {
      _factor = 10;
     }
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
   double ld_buy = iCustom(_Symbol, _Period, "_Hpcs_PosNegDIsCrossOver_MT4_Indi_V01_WE",0,0);
   double ld_Sell = iCustom(_Symbol, _Period, "_Hpcs_PosNegDIsCrossOver_MT4_Indi_V01_WE",1,0);

   if(ld_buy != EMPTY_VALUE)
     {
      if(gdt_previous != Time[0])
        {


         li_ticket = PlaceMarketOrder_Generic(OP_BUY,id_lots,_Symbol,id_stoploss,id_takeprofit,ii_slippage,ii_magicno);
         if(li_ticket < 0)
           {
            Print("Order send fail ",GetLastError());
           }

         gdt_previous=Time[0];

        }
     }
   if(ld_Sell != EMPTY_VALUE)
     {
      if(gdt_previous != Time[0])
        {

         li_ticketforsell = PlaceMarketOrder_Generic(OP_SELL,id_lots,_Symbol,id_stoploss,id_takeprofit,ii_slippage,ii_magicno);
         if(li_ticketforsell < 0)
           {
            Print("Order send fail ",GetLastError());
           }

         gdt_previous=Time[0];

        }
     }
  }
//+------------------------------------------------------------------+
int PlaceMarketOrder_Generic(ENUM_ORDER_TYPE _OP,
                             double          _Lots,
                             string          _namePair       = NULL,
                             double          _SLinPips       = 0,
                             double          _TPinPips       = 0,
                             int             _SlippageInPips = 10,
                             int             _MagicNumber    = 0,
                             string          _Comment        = "MO_HPCS",
                             bool            _flagDEBUGMsg   = false)
  {
//
   int rtrn_Ticket = -1,
       __Digits    = (int)MarketInfo(_namePair, MODE_DIGITS);
   double _priceOpen = 0,
          _priceSL   = 0,
          _priceTP   = 0,
          _priceAsk  = MarketInfo(_namePair, MODE_ASK),
          _priceBid  = MarketInfo(_namePair, MODE_BID),
          _Points    = MarketInfo(_namePair, MODE_POINT),
          _StopLevel = MarketInfo(_namePair, MODE_STOPLEVEL);
   color _colorArrow = clrBlack;
//

   if(_OP > 1)
     {
      Alert("Wrong Market Order type");
     }
   else
     {
      //
      if(_OP == OP_BUY)
        {
         _priceOpen  = _priceAsk;
         _colorArrow = clrBlue;
        }
      else
         if(_OP == OP_SELL)
           {
            _priceOpen  = _priceBid;
            _colorArrow = clrRed;
           }//

      if(_SLinPips != 0)
        {
         if(_OP == OP_BUY)
           {
            _priceSL = _priceAsk - (_SLinPips * _Points * _factor);
            if((_priceBid - _priceSL) >= (_StopLevel * _Points))
              {
               // Refer: book.mql4.com/appendix/limits
              }
            else
              {
               _priceSL = _priceBid - (_StopLevel * _Points);
              }
           }
         else
            if(_OP == OP_SELL)
              {
               _priceSL = _priceBid + (_SLinPips * _Points * _factor);
               if((_priceSL - _priceAsk) >= (_StopLevel * _Points))
                 {
                  // Refer: book.mql4.com/appendix/limits
                 }
               else
                 {
                  _priceSL = _priceAsk + (_StopLevel * _Points);
                 }
              }
        }
      if(_TPinPips != 0)
        {
         if(_OP == OP_BUY)
           {
            _priceTP = _priceAsk + (_TPinPips * _Points * _factor);
            if((_priceTP - _priceBid) >= (_StopLevel * _Points))
              {
               // Refer: book.mql4.com/appendix/limits
              }
            else
              {
               _priceTP = _priceBid + (_StopLevel * _Points);
              }
           }
         else
            if(_OP == OP_SELL)
              {
               _priceTP = _priceBid - (_TPinPips * _Points * _factor);
               if((_priceAsk - _priceTP) >= (_StopLevel * _Points))
                 {
                  // Refer: book.mql4.com/appendix/limits
                 }
               else
                 {
                  _priceTP = _priceAsk - (_StopLevel * _Points);
                 }
              }
        }

      // normalize all price values to digits
      _priceOpen = NormalizeDouble(_priceOpen, __Digits);
      _priceSL   = NormalizeDouble(_priceSL, __Digits);
      _priceTP   = NormalizeDouble(_priceTP, __Digits);

      // place market order
      rtrn_Ticket = OrderSend(_namePair, _OP, _Lots, _priceOpen, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, 0, _colorArrow);
      if(_flagDEBUGMsg == true)
        {
         Print("[DE-BUG] " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + " Ticket = " + IntegerToString(rtrn_Ticket));
        }
      if(rtrn_Ticket == -1)
        {
         int _Error = GetLastError();
         if(_flagDEBUGMsg == true)
           {
            Print("Order Place Failed:", _Error);
           }
         //
         if((_Error == 129) || (_Error == 135) || (_Error == 136) || (_Error == 138) || (_Error == 146))
           {
            // Overcomable errors: 129(invalid price), 135(price changed), 136(no-quotes), 138(re-quotes), 146(busy trade subsystem)
            //if( _Error == 129 ) Alert("Invalid price. Retrying..");
            RefreshRates();                     // Update data
            rtrn_Ticket = PlaceMarketOrder_Generic(_OP, _Lots, _namePair,  _priceSL, _priceTP, _SlippageInPips, _MagicNumber, _Comment, _flagDEBUGMsg);
           }
        }
     }
//
   return(rtrn_Ticket);
  }
//+------------------------------------------------------------------+
