//+------------------------------------------------------------------+
//|                                _HPCS_ScalperEA_MT4_EA_V07_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property icon "\\Files\\hpcs_logo.ico"
#property link "https://www.hpcsphere.com"
#property copyright "Copyright 2011-2020, HPC Sphere Pvt. Ltd. India"
#property version "1.00"
#property strict


int _factor = 1;
datetime gdt_currentTime = Time[1];


enum lotstype
  {
   Fixedlot =1,         // Fixed Lot
   variablelot =2      // Variable Lots
  };



input string sec1 = "====== EA Inputs Parameter ======"; //==================
input lotstype ii_lotstype = 1;                    // Lots Type
input double id_lotSize = 0.01;                     // Lots Size
input int risk_p =10;                              // Risk %
input int ii_slippage =10;                         // Slippage (in Pips)
input int ii_magicNumber =95824;                 // Magic Number
input double id_takeProfit =10;                   // Take Profit(in pips)
input double id_stopLoss =10;                     // Stop Loss (in pips)


input string sec2 = "====== Trailling Stop Inputs Parameter ======"; //==================
input int ii_TS = 10;                              //Trailing Stop (in Pips)
input int ii_TSStart =10;                         //Trailing Stop Start (in Pips)
input int ii_TSStep = 4;                           //Trailing Stop Step (in Pips)

input string sec3 = "====== Breakeven Input Parameter ======"; //==================
input int ii_breakeven =10;                       // Breakeven(in pips)

int y=0;
double acbal=AccountBalance();
double ld_lots= id_lotSize;
int a;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   if(Digits() == 3 || Digits() == 5)
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
   double temp=Close[10];
   double temp1=Close[10];
   for(int i=50; i<10; i--)
     {

      if(temp<Close[i])
        {
         temp=Close[i];
        }
        if(temp1>Close[i])
        {
         temp1=Close[i];
        }

     }

   int  x=0;
   Print(OrdersTotal());
   if(OrdersTotal()!=0)
     {
      x=1;
     }
   else
     {
      x=0;
     }
   if(x==0 && y==0)
     {
      if(acbal<AccountBalance())
        {
         ld_lots=id_lotSize;
        }
      else
         if(acbal>AccountBalance())
           {
            ld_lots=ld_lots*2;
           }

      /*if(ld_lots>5)
        {
         ld_lots=id_lotSize;
        }*/
      acbal=AccountBalance();
      if((iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0))&& (iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0)>iMA(NULL,0,150,0,MODE_EMA,PRICE_CLOSE,0))&&(iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)<Close[0]))
        {

         if(temp>Close[0])
           {

            if(gdt_currentTime!= Time[0])
              {



               int li_ticket = PlaceMarketOrder_Generic(OP_BUY,ld_lots,_Symbol,id_stopLoss,id_takeProfit,ii_slippage,ii_magicNumber,"FIrst Order");
               if(li_ticket <0)
                 {
                  Print("Order Send Failed ! ", GetLastError());
                 }

               gdt_currentTime = Time[0];
               Print("Buy");
              }
           }
        }

      if((iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0))&& (iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0)<iMA(NULL,0,150,0,MODE_EMA,PRICE_CLOSE,0))&&(iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)>Close[0]))
        {
         if(temp1<Close[0])
           {

            if(gdt_currentTime != Time[0])
              {


               int li_ticket = PlaceMarketOrder_Generic(OP_SELL,ld_lots,_Symbol,id_stopLoss,id_takeProfit,ii_slippage,ii_magicNumber,"FIrst Order");
               if(li_ticket <0)
                 {
                  Print("Order Send Failed ! ", GetLastError());
                 }

               gdt_currentTime = Time[0];
               Print("Sell ");
              }
           }
        }
     }
   if(((iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0))&& (iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0)>iMA(NULL,0,150,0,MODE_EMA,PRICE_CLOSE,0))&&(iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)<Close[0]))||((iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0))&& (iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0)<iMA(NULL,0,150,0,MODE_EMA,PRICE_CLOSE,0))&&(iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0)>Close[0])))
     {
      y=1;

     }
   else
     {

      y=0;
     }




//TrailingStop(ii_TS,ii_TSStart,ii_TSStep,ii_magicNumber);

   for(int i =0; i< OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderMagicNumber() == ii_magicNumber && OrderSymbol() == _Symbol)
           {
            func_BreakEvenStopLoss(OrderTicket(),ii_breakeven,_Symbol);
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|      Custom   Functions                                          |
//+------------------------------------------------------------------+
void TrailingStop(int _TrailStop_IN_PIPS, int _TrailingStopStart = 0,int _TrailingStopStep  = 0, int _MagicNumber = 0)
  {
   int total = OrdersTotal();
   for(int i =0; i < total; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS) == true)
        {
         if(OrderMagicNumber() == _MagicNumber && OrderSymbol() == Symbol())
           {
            if(OrderType() == OP_SELL)
              {
               if(_TrailStop_IN_PIPS > 0 && OrderCloseTime() == 0)
                 {
                  if((Ask <= (OrderOpenPrice() - (_TrailingStopStart*Point*_factor)))||(_TrailingStopStart == 0))
                    {
                     if((OrderStopLoss()-Ask) >= (Point*_factor*(_TrailStop_IN_PIPS+_TrailingStopStep))|| OrderStopLoss()==0)
                       {
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid+(Point*_factor*_TrailStop_IN_PIPS),OrderTakeProfit(),0,clrOrangeRed))
                          {
                           Print("Sell Modify _Error #",GetLastError());
                          }
                       }
                    }
                 }
              }
            else
               if(OrderType() == OP_BUY)
                 {
                  if(_TrailStop_IN_PIPS > 0 && OrderCloseTime() == 0)
                    {
                     if((Bid >= (OrderOpenPrice() + (_TrailingStopStart*Point*_factor)))||(_TrailingStopStart == 0))
                       {
                        if((Bid -OrderStopLoss()) >= (Point*_factor*(_TrailStop_IN_PIPS+_TrailingStopStep))|| OrderStopLoss()==0)
                          {
                           if(!OrderModify(OrderTicket(), OrderOpenPrice(), Ask-(Point*_factor*_TrailStop_IN_PIPS), OrderTakeProfit(),0,clrOrangeRed))
                             {
                              Print("Buy Modify _Error #",GetLastError());
                             }
                          }
                       }
                    }
                 }
           }
        }
     }
  }

//
//======================= BRING S/L TO BREAK-EVEN ========================//
//
void func_BreakEvenStopLoss(int _Ticket,int ip_pipsSLBreakevenEntry =10,string _Symb  = NULL)
  {
// check for break-even condition and modify stop-loss accordingly
//
   double _Points = MarketInfo(_Symb,MODE_POINT);
   _Points = _Points*10 ;
   if(OrderSelect(_Ticket, SELECT_BY_TICKET) == true)
     {
      // select the opened order
      //
      if(OrderCloseTime() == 0)
        {
         // ensure this order is open
         //
         //----- CHECK AND MODIFY STOP-LOSS TO BREAK-EVEN LEVEL -----//
         //
         // get break-even price from order's _Comment
         double lcl_priceOrderOpen  = OrderOpenPrice(),
                lcl_priceOrderClose = OrderClosePrice(),
                lcl_priceBreakEvenStopLoss = 0,
                lcl_priceFreezeLevel = MarketInfo(OrderSymbol(), MODE_FREEZELEVEL) * MarketInfo(OrderSymbol(), MODE_POINT);
         int lcl_OT = OrderType(),
             lcl_Digits = (int)MarketInfo(OrderSymbol(), MODE_DIGITS);
         //
         // order type and arrow color
         ENUM_ORDER_TYPE lcl_OrderType = WRONG_VALUE;
         color lcl_clrArrow = clrBlack;
         if(lcl_OT == 0)
           {
            lcl_OrderType = OP_BUY;
            lcl_clrArrow = clrBlueViolet;
            lcl_priceBreakEvenStopLoss = lcl_priceOrderOpen ;
           }
         else
            if(lcl_OT == 1)
              {
               lcl_OrderType = OP_SELL;
               lcl_clrArrow = clrOrangeRed;
               lcl_priceBreakEvenStopLoss = lcl_priceOrderOpen ;
              }
         //
         string gv_INFO_Msg = " order #" + IntegerToString(OrderTicket()) + " to break-even level " + DoubleToString(lcl_priceBreakEvenStopLoss, lcl_Digits);
         //
         bool lb_BreakEven = false;
         //
         if(lcl_OrderType == OP_BUY)
           {
            if(lcl_priceOrderClose >= (lcl_priceOrderOpen + (ip_pipsSLBreakevenEntry * _Points)))
              {
               if(lcl_priceBreakEvenStopLoss > OrderStopLoss())
                 {
                  if(lcl_priceBreakEvenStopLoss < (lcl_priceOrderClose - lcl_priceFreezeLevel))
                    {
                     gv_INFO_Msg = " stop-loss of buy" + gv_INFO_Msg ;
                     lb_BreakEven = true;
                    }
                 }
              }
           }
         else
           {
            if(lcl_OrderType == OP_SELL)
              {
               if(lcl_priceOrderClose <= (lcl_priceOrderOpen - (ip_pipsSLBreakevenEntry *_Points)))
                 {
                  if((lcl_priceBreakEvenStopLoss < OrderStopLoss()) || (OrderStopLoss() == 0))
                    {
                     if(lcl_priceBreakEvenStopLoss > (lcl_priceOrderClose + lcl_priceFreezeLevel))
                       {
                        gv_INFO_Msg = " stop-loss of sell" + gv_INFO_Msg;
                        lb_BreakEven = true;
                       }
                    }
                 }
              }
           }

         // bring S/L to break-even level
         //Print("lcl_priceBreakEvenStopLoss = ",lcl_priceBreakEvenStopLoss,"For Order",OrderTicket());
         //if((OrderClosePrice()> lcl_priceBreakEvenStopLoss && OrderStopLoss()<lcl_priceBreakEvenStopLoss && OrderType() == OP_BUY)||(OrderClosePrice()< lcl_priceBreakEvenStopLoss && ((OrderStopLoss()> lcl_priceBreakEvenStopLoss)||OrderStopLoss()==0 )&& OrderType() == OP_SELL))
         if(lb_BreakEven == true)
           {

            if(OrderModify(OrderTicket(), lcl_priceOrderOpen, lcl_priceBreakEvenStopLoss, OrderTakeProfit(), 0, lcl_clrArrow) == true)
              {
               Print("[INFO] Successfully brought" + gv_INFO_Msg);
              }
            else
              {
               Print("[ERROR #", GetLastError(),"] Couldn't bring" + gv_INFO_Msg);
              }
           }
         //
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
      /*
      if(rtrn_Ticket == -1) {
         int _Error = StringToInteger( Error_Description() ) ;
         if( _flagDEBUGMsg == true ) {
            Print( "Order Place Failed:", _Error );
         }
         //
         if( ( _Error == 129 ) || ( _Error == 135 ) || ( _Error == 136 ) || ( _Error == 138 ) || ( _Error == 146 ) ) {
         // Overcomable errors: 129(invalid price), 135(price changed), 136(no-quotes), 138(re-quotes), 146(busy trade subsystem)
            //if( _Error == 129 ) Alert("Invalid price. Retrying..");
            RefreshRates();                     // Update data
            rtrn_Ticket = PlaceMarketOrder_Generic( _OP, _Lots, _namePair,  _priceSL, _priceTP, _SlippageInPips, _MagicNumber, _Comment, _flagDEBUGMsg );
         }
       }
       */
     }
//
   return(rtrn_Ticket);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateLotUsingRiskPercentageOrRiskAmount(int _iCalculation_Type=0, int _iRisk_Percent=0, double _dRisk_Amount=0, ENUM_ORDER_TYPE _eOrder_Type=OP_BUY, double _dStopLoss_in_Pips=0)
  {
   int lcl_factor=10;         //1 Pip = 10 Point    << -- Variable to change from pips to point.
   double lcl_risk_amount;

   if((_eOrder_Type==OP_BUYLIMIT)||(_eOrder_Type==OP_BUYSTOP)||(_eOrder_Type==OP_SELLLIMIT)||(_eOrder_Type==OP_SELLSTOP))
     {
      Alert("[INFO]: Requested Order is a Pending Order. This function can't be used for Pending Orders.");
      return(0);           // return 0 - no calculations will be done and returns lot=0
     }

   if(_dStopLoss_in_Pips==0)
     {
      Alert("[INFO]: Requested Order's Stoploss is 0. This function can't be used for orders without Stop Loss due to infinite Loss.");
      Alert("[INFO]: Please enter a Valid Positive value for Stop Loss(Pips)");
      return(0);           // return 0 - no calculations will be done and returns lot=0
     }

   if(_iRisk_Percent==0 && _dRisk_Amount==0)
     {
      Alert("[INFO]: Risk Percent and Risk Amount both cannot be Zero in Function Call at the same time.");
      Alert("[INFO]: Please enter either Risk Percent or Risk Amount to calculate Lot Size");
      return(0);           // return 0 - no calculations will be done and returns lot=0
     }

   if(_iCalculation_Type==0)        //<<- Calculation_type 0 for calculation using risk %
     {
      lcl_risk_amount = (AccountFreeMargin() * _iRisk_Percent / 100);    //<<- RiskPercent is a positive integer "e.g. 2"
     }
   else
      if(_iCalculation_Type==1)        //<<- Calculation_type 0 for calculation using risk amount
        {
         lcl_risk_amount = _dRisk_Amount;     //<<- _dRisk_Amount is Risk in Currency "e.g. 200 $"
        }
      else
        {
         Alert("[INFO]: Please enter correct Calculation Type. 0 for calculation using Risk % and 1 for calculation using Risk Amount");
         return(0);                 // return 0 - no calculations will be done and returns lot=0
        }

   double lcl_Tick_Value = MarketInfo(Symbol(), MODE_TICKVALUE);

//-- Changing Stop Loss to Points and adding Spread to determine Order Loss --\\
   double lcl_StopLoss_in_Point  = (_dStopLoss_in_Pips * lcl_factor);

//-- Loss calculation for one Lot using maximum loss(i.e. Stop Loss) for the order on given Symbol --\\
   double lcl_Loss_for_1_lot = lcl_StopLoss_in_Point * lcl_Tick_Value  ;    // << -- "lcl_StopLoss_per_point" is the Maximum Loss for an Order in point(It includes Spread).

//-- Lots calculation for order on basis of calculated risk amount(i.e. if Order Closes by Stop Loss, Loss=Risk Amount) --\\
   double lcl_LotSize = (lcl_risk_amount / lcl_Loss_for_1_lot);

   return(lcl_LotSize);
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
