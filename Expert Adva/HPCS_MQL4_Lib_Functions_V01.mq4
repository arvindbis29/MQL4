#property copyright "Copyright 2018, HPC Sphere Pvt. Ltd."
#property link      "http://www.hpcsphere.com"
#property version   "01.00"
#property  library
#property strict
//
//-------------------- OBJECTS/LABELS ON CHART ---------------------//
//
//======================= CREATE LABEL ON CHART ========================//
//
void CreateLabel( string _name, int _x, int _y, int _corner, int _z, string _text, int _size, ENUM_ANCHOR_POINT _anchor = ANCHOR_LEFT, string _font="Arial" ) {
//
   if(ObjectFind(_name) == -1) {
      ObjectCreate(_name,OBJ_LABEL,0,0,0);
   }
  ObjectSet(_name,OBJPROP_CORNER,_corner);
  ObjectSet(_name,OBJPROP_COLOR,_z);
  ObjectSet(_name,OBJPROP_XDISTANCE,_x);
  ObjectSet(_name,OBJPROP_YDISTANCE,_y);
  ObjectSet(_name,OBJPROP_ANCHOR,_anchor);
  ObjectSetText(_name,_text,_size,_font,_z);
}
//
//======================= DELETE ALL HPCS_ OBJECTS ====================//
//
void Selected_Object_Delete() {
// delete all objects from the chart, whose object names are pre-fixed with "HPCS_"
//
   // go through all objects on the chart
   for( int li_ObjNum = ( ObjectsTotal() - 1 ); li_ObjNum >= 0; --li_ObjNum ) {
   // 
      // get object's prefix name
      string ls_ObjName = ObjectName( li_ObjNum );
      string ls_ObjNamePrefix = StringSubstr( ls_ObjName, 0, 5 );
      //Print( li_ObjNum, " ", ls_ObjNamePrefix );
      //
      // if "HPCS_" prefix is found
      if( StringCompare( ls_ObjNamePrefix, "HPCS_" ) == 0 ) {
      //
         // delete the object from chart
         ObjectDelete(ls_ObjName);
      }
   }
}
//
//------------------ CHECKS BEFORE PLACING ORDER -------------------//
//
// CHECKING ACCOUNT Free margin before placing trades
bool func_CheckAccountFreeMarginToPlaceOrder( ENUM_ORDER_TYPE _eOrderType, 
                                              double          _dLot ) {
//
   string ls_Symbol = Symbol();
   double lcl_PriceDifferenceForSell = 0;
   //
   // get equivalent market order type
   ENUM_ORDER_TYPE lcl_EquivalentMarketOrderType = WRONG_VALUE;
   if( ( _eOrderType == OP_BUY ) 
    || ( _eOrderType == OP_BUYLIMIT ) 
    || ( _eOrderType == OP_BUYSTOP ) ) {
   //
      lcl_EquivalentMarketOrderType = OP_BUY;
   }
   else if( ( _eOrderType == OP_SELL ) 
         || ( _eOrderType == OP_SELLLIMIT ) 
         || ( _eOrderType == OP_SELLSTOP ) ) {
   //
      lcl_EquivalentMarketOrderType = OP_SELL;
      lcl_PriceDifferenceForSell    = MarketInfo( ls_Symbol, MODE_SPREAD ) * Point;
   }
   //
   // check if any of the following conditions do not allow order to be placed
   if( lcl_EquivalentMarketOrderType == WRONG_VALUE ) {
   // wrong order type sent as parameter
      return( false );
   } 
   if ( AccountFreeMargin() < ( _dLot * MarketInfo( ls_Symbol, MODE_MARGININIT ) ) ) {
   // account free-margin is less than initial margin required 
      return( false );
   } 
   //
   // account's free margin left after a market order is placed
   double lcl_AccountFreeMarginLeftAfterPlacingMarketOrder = AccountFreeMarginCheck( ls_Symbol, lcl_EquivalentMarketOrderType, _dLot );
   if ( lcl_AccountFreeMarginLeftAfterPlacingMarketOrder < ( _dLot * ( MarketInfo( ls_Symbol, MODE_MARGINREQUIRED ) - lcl_PriceDifferenceForSell ) ) ) {
   // account free-margin left, after placing market order, is less than margin required 
      return( false );
   }
   //
   return( true );
}
//
// checks and ensures lot, being ordered, is within allowed limits
bool func_IsLotWithinAllowedLimits( double& chng_Lot,
                                    string _namePair            = NULL,
                                    bool   _flagChngToMinLotLmt = false,
                                    bool   _flagDEBUGMsg        = false ) {
//
// Error/Information codes, printed in Experts log by this function:
// I1( chng_Lot => nw_Lot, _LotMinStp ): [INFO]  Changed given chng_Lot to nw_Lot so as to ensure it follows broker's minimum lot-step, _LotMinStp
// I2( chng_Lot => _LotMax )           : [INFO]  Given chng_Lot > maximum allowed _LotMax. It is reset to the _LotMax to place order successfully.
// If _flagChngToMinLotLmt is false:
// E1( chng_Lot < _LotMin )            : [ERROR] Given chng_Lot < minimum allowed _LotMin. No order must be placed using this lot.
// If _flagChngToMinLotLmt is true: 
// I3( chng_Lot => _LotMin )           : [INFO]  Given chng_Lot > minimum allowed _LotMin. It is reset to the _LotMin to place order successfully.
//
   bool rtrn_flagLotWithinAllowedLimits = true;
   string lcl_MsgCode = NULL;
   //
   // get minimum, maximum and step-size permitted for a lot
   double lcl_MinPermittedLot = MarketInfo( _namePair, MODE_MINLOT ),
          lcl_MaxPermittedLot = MarketInfo( _namePair, MODE_MAXLOT ),
          lcl_MinPermittedLotStep = MarketInfo( _namePair, MODE_LOTSTEP );
   //
   int _LotDigits = 4;
   //
   if( NormalizeDouble( chng_Lot, _LotDigits ) != NormalizeDouble( MathRound( chng_Lot/lcl_MinPermittedLotStep ) * lcl_MinPermittedLotStep, _LotDigits ) ) {
   // ensure given lot follows lot-step
      lcl_MsgCode = "I1(" + DoubleToString( chng_Lot, _LotDigits ) + " => ";
      chng_Lot = MathRound( chng_Lot/lcl_MinPermittedLotStep ) * lcl_MinPermittedLotStep;
      lcl_MsgCode += DoubleToString( chng_Lot, _LotDigits ) + ", "
                   + DoubleToString( lcl_MinPermittedLotStep, _LotDigits ) + ")";
   }
   //
   if( NormalizeDouble( chng_Lot, _LotDigits ) > NormalizeDouble( lcl_MaxPermittedLot, _LotDigits ) ) { 
   // ensure lot is within the maximum allowed limit
      lcl_MsgCode = "I2(" + DoubleToString( chng_Lot, _LotDigits ) 
                  + " => " + DoubleToString( lcl_MaxPermittedLot, _LotDigits ) + ")";
      chng_Lot = lcl_MaxPermittedLot;
   }
   else if( NormalizeDouble( chng_Lot, _LotDigits ) < NormalizeDouble( lcl_MinPermittedLot, _LotDigits ) ) { 
   // lot must not be below the minimum allowed limit
      lcl_MsgCode = "E1(" + DoubleToString( chng_Lot, _LotDigits );
      if( _flagChngToMinLotLmt == true ) {
         chng_Lot = lcl_MinPermittedLot;
         lcl_MsgCode += " => ";
      }
      else if( _flagChngToMinLotLmt == false ) {
         rtrn_flagLotWithinAllowedLimits = false;
         lcl_MsgCode += " < ";
      }
      lcl_MsgCode += DoubleToString( lcl_MinPermittedLot, _LotDigits ) + ")";
   } 
   //
   // display appropriate code message
   if( _flagDEBUGMsg == true ) {
   if( lcl_MsgCode != NULL ) {
      Print( TimeToString( TimeCurrent(), TIME_DATE|TIME_SECONDS ) + " " 
           + __FUNCTION__ + ": " + lcl_MsgCode );
   }}
   //
   if( rtrn_flagLotWithinAllowedLimits == true ) {
   // normalize the lot
      //
      double _LotMicro = 0.01, // micro lots
             _LotMini  = 0.10, // mini lots
             _LotNrml  = 1.00;
      //
      if( lcl_MinPermittedLot == _LotMicro )
         _LotDigits = 2;
      else if(lcl_MinPermittedLot == _LotMini )
         _LotDigits = 1;
      else if(lcl_MinPermittedLot == _LotNrml )
         _LotDigits = 0;
      //
      chng_Lot = NormalizeDouble( chng_Lot, _LotDigits);
   }
   //
   return( rtrn_flagLotWithinAllowedLimits );
}
//
// ensures lot, being ordered, is within allowed limits 
void func_EnsureLotWithinAllowedLimits( double& chng_Lot,
                                        string _namePair = NULL) 
{
   //
   // Error/Information codes, printed in Experts log by this function:
   // I1( chng_Lot => nw_Lot, _LotMinStp ): [INFO]  Changed given chng_Lot to nw_Lot so as to ensure it follows broker's minimum lot-step, _LotMinStp
   // I2( chng_Lot => _LotMax )           : [INFO]  Given chng_Lot > maximum allowed _LotMax. It is reset to the _LotMax to place order successfully.
   // E1( chng_Lot < _LotMin )            : [ERROR] Given chng_Lot < minimum allowed _LotMin. No order must be placed using this lot.
   //
   string lcl_MsgCode = NULL;
   //
   // get minimum, maximum and step-size permitted for a lot
   double lcl_MinPermittedLot = MarketInfo( _namePair, MODE_MINLOT ),
          lcl_MaxPermittedLot = MarketInfo( _namePair, MODE_MAXLOT ),
          lcl_MinPermittedLotStep = MarketInfo( _namePair, MODE_LOTSTEP );
   //
   int _LotDigits = 4;
   double micro_lot = 0.01,mini_lot =0.1,lot1=1;
   
   if(chng_Lot < lcl_MinPermittedLot) 
   { 
      // lot must not be below the minimum allowed limit
      Print("[INFO]: Requested Lot(",DoubleToString(chng_Lot,NUM_OF_LOT_DIGITS),") < Minimum allowed lot(",DoubleToString(lcl_MinPermittedLot,NUM_OF_LOT_DIGITS),")");
      Print("[INFO]: Updated requested Lot to the Minimum allowed lot to place order successfully");
      chng_Lot = lcl_MinPermittedLot;
   } 
   else if(chng_Lot > lcl_MaxPermittedLot) 
   { 
      // lot must not be above the maximum allowed limit
      Print("[INFO]: Requested Lot(",DoubleToString(chng_Lot,NUM_OF_LOT_DIGITS),") > Maximum allowed lot(",DoubleToString(lcl_MaxPermittedLot,NUM_OF_LOT_DIGITS),")");
      Print("[INFO]: Updated requested Lot to the Maximum allowed lot to place order successfully");
      chng_Lot = lcl_MaxPermittedLot;
   }
   //
   // normalize the lot
   double _LotMicro = 0.01, // micro lots
          _LotMini  = 0.10, // mini lots
          _LotNrml  = 1.00;
   //
   if( lcl_MinPermittedLot == _LotMicro )
      _LotDigits = 2;
   else if(lcl_MinPermittedLot == _LotMini )
      _LotDigits = 1;
   else if(lcl_MinPermittedLot == _LotNrml )
      _LotDigits = 0;
   //
   chng_Lot = NormalizeDouble( chng_Lot, _LotDigits);
}
//
//------------------------- PLACE ORDERS ---------------------------//
//
//Place Market Order Generic for any currency pair symbol, checking stop-level
// Requires inclusion of ErrorDescription() code logic and int _factor = 10 (global level)
int PlaceMarketOrder_Generic( ENUM_ORDER_TYPE _OP, 
                              double          _Lots, 
                              string          _namePair       = NULL,
                              double          _SLinPips       = 0, 
                              double          _TPinPips       = 0, 
                              int             _SlippageInPips = 10, 
                              int             _MagicNumber    = 0, 
                              string          _Comment        = "MO_HPCS",
                              bool            _flagDEBUGMsg   = false ) {
//   
   int rtrn_Ticket = -1,
       __Digits    = (int)MarketInfo( _namePair, MODE_DIGITS );
   double _priceOpen = 0,
          _priceSL   = 0,
          _priceTP   = 0,
          _priceAsk  = MarketInfo( _namePair, MODE_ASK ),
          _priceBid  = MarketInfo( _namePair, MODE_BID ),
          _Points    = MarketInfo( _namePair, MODE_POINT ),
          _StopLevel = MarketInfo( _namePair, MODE_STOPLEVEL );
   color _colorArrow = clrBlack;
   //
   
   if( _OP > 1 ) {
      Alert( "Wrong Market Order type" );
   } else {
      //
      if( _OP == OP_BUY )
      {
         _priceOpen  = _priceAsk;
         _colorArrow = clrBlue;
      }
      else if( _OP == OP_SELL ) 
      {
         _priceOpen  = _priceBid;
         _colorArrow = clrRed;
      }//
  
      if( _SLinPips != 0 ) {
         if( _OP == OP_BUY )
         {     
            _priceSL = _priceAsk - ( _SLinPips * _Points * _factor );
            if( ( _priceBid - _priceSL ) >= ( _StopLevel * _Points ) )
            { // Refer: book.mql4.com/appendix/limits   
            }
            else
            {
               _priceSL = _priceBid - ( _StopLevel * _Points );
            }  
         }
         else if( _OP == OP_SELL )
         {
            _priceSL = _priceBid + ( _SLinPips * _Points * _factor );
            if( ( _priceSL - _priceAsk ) >= ( _StopLevel * _Points ) )
            { // Refer: book.mql4.com/appendix/limits      
            }
            else
            {
             _priceSL = _priceAsk + ( _StopLevel * _Points );
            }
         }
      }
      if( _TPinPips != 0 ) {
         if( _OP == OP_BUY )
         {
            _priceTP = _priceAsk + ( _TPinPips * _Points * _factor );
            if( ( _priceTP - _priceBid ) >= ( _StopLevel * _Points ) )
            { // Refer: book.mql4.com/appendix/limits   
            }
            else
            {
               _priceTP = _priceBid + ( _StopLevel * _Points );
            }
         }
         else if( _OP == OP_SELL )
         {
            _priceTP = _priceBid - ( _TPinPips * _Points * _factor );
            if( ( _priceAsk - _priceTP ) >= ( _StopLevel * _Points ) )
            { // Refer: book.mql4.com/appendix/limits      
            }
            else
            {
               _priceTP = _priceAsk - ( _StopLevel * _Points );
            }
         }
      }
      
      // normalize all price values to digits
      _priceOpen = NormalizeDouble( _priceOpen, __Digits );
      _priceSL   = NormalizeDouble( _priceSL, __Digits );
      _priceTP   = NormalizeDouble( _priceTP, __Digits );
   
      // place market order
      rtrn_Ticket = OrderSend( _namePair, _OP, _Lots, _priceOpen, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, 0, _colorArrow ); 
      if( _flagDEBUGMsg == true ) {
         Print( "[DE-BUG] " + TimeToString( TimeCurrent(), TIME_DATE|TIME_SECONDS ) + " Ticket = " + IntegerToString( rtrn_Ticket ) );           
      }
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
   }
   //
   return( rtrn_Ticket );
}
//
//Place Market Order for any currency pair symbol, where S/L and T/P are prices
int PlaceMarketOrder_Pair( ENUM_ORDER_TYPE _OP, 
                           double          _Lots, 
                           string          _namePair           = NULL,
                           double          _priceSL        = 0, 
                           double          _priceTP        = 0, 
                           int             _SlippageInPips = 10, 
                           int             _MagicNumber    = 0, 
                           string          _Comment        = "MO_HPCS", 
                           bool            _flagDEBUGMsg    = true ) {
//   
   //
   // Error code, printed in Experts log by this function for de-bugging:
   // E1( GetLastError(), _namePair ) : [ERROR # _Error] Placing market order for _namePair failed
   //
   int rtrn_Ticket = -1;
   double  _priceOpen =0;
   color _colorArrow = clrBlack;
  //
   if( _OP > 1 ) {
      Alert("Wrong Market Order type");
   } else {
      //
      if( _OP == OP_BUY )
      {
         _colorArrow = clrBlue;
         _priceOpen = MarketInfo(_namePair,MODE_ASK);
      }
      else if( _OP == OP_SELL ) 
      {
         _colorArrow = clrRed;
         _priceOpen = MarketInfo(_namePair,MODE_BID);
      }//
      func_EnsureLotWithinAllowedLimits(_Lots,_namePair);
      rtrn_Ticket = OrderSend( _namePair, _OP, _Lots, _priceOpen, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, 0, _colorArrow ); 
      Print( "[DE-BUG] " + TimeToString( TimeCurrent(), TIME_DATE|TIME_SECONDS ) + " Ticket = " + IntegerToString( rtrn_Ticket ) );           
      if(rtrn_Ticket == -1) {
         int _Error = GetLastError() ;
         Print("Order Place Failed:",_Error );
         //
         if( ( _Error == 129 ) || ( _Error == 135 ) || ( _Error == 136 ) || ( _Error == 138 ) || ( _Error == 146 ) ) {   
         // Overcomable errors: 129(invalid price), 135(price changed), 136(no-quotes), 138(re-quotes), 146(busy trade subsystem)
            //if( _Error == 129 ) Alert("Invalid price. Retrying..");
            RefreshRates();                     // Update data
            rtrn_Ticket = PlaceMarketOrder_Pair( _OP, _Lots, _namePair, _priceSL, _priceTP, _SlippageInPips, _MagicNumber, _Comment );
         }
       }
    }
    return rtrn_Ticket ;
}
//
//Place Pending Order for any symbols same as first PPO function with symbol select facility
int PlacePendingOrder_Generic( string   _namePair,
                               int      _OP,
                               double   _Lots,
                               int      _pipsTrgrPrcOfst,
                               int      _SLinPips       = 0,
                               int      _TPinPips       = 0,
                               int      _SlippageInPips = 10,
                               int      _MagicNumber    = 0,
                               datetime expiry          = 0,
                               string   _Comment        = "PO_HPCS" )
{
   //
   // Error code, printed in Experts log by this function for de-bugging:
   // E1( GetLastError() ) : [ERROR # _Error] Placing pending order failed
   //
   int rtrn_Ticket = -1,
       _Digit      = (int)MarketInfo( _namePair, MODE_DIGITS ),
       _StopLevel  = (int)MarketInfo( _namePair, MODE_STOPLEVEL );
   //
   double _priceSL   = 0,
          _priceTP   = 0,
          _priceTrgr = 0;
   //
   // get values for given currency pair symbol
   double _Points   = MarketInfo( _namePair, MODE_POINT ),
          _priceAsk = MarketInfo( _namePair, MODE_ASK ),
          _priceBid = MarketInfo( _namePair, MODE_BID ); 
   
   if( _OP == OP_BUYLIMIT )
   {
      _priceTrgr = _priceAsk - ( _pipsTrgrPrcOfst* _Points * _factor );
      if( _priceTrgr <= ( _priceAsk - ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Buy Limit Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0;
      }
      else 
      {
         _priceSL = _priceTrgr - ( _SLinPips * _Points * _factor );
         if( _priceSL <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr - ( _StopLevel * _Points );         
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else 
      {
         _priceTP = _priceTrgr + ( _TPinPips * _Points * _factor );
         if( _priceTP >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr + ( _StopLevel * _Points );         
         }
      }
   } 
   else if( _OP == OP_BUYSTOP )
   {
      _priceTrgr = _priceAsk + ( _pipsTrgrPrcOfst* _Points * _factor );
      if( _priceTrgr >= ( _priceAsk + ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Buy Stop Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0;
      }
      else 
      {
         _priceSL = _priceTrgr - ( _SLinPips * _Points * _factor );
         if( _priceSL <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr - ( _StopLevel * _Points );         
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else 
      {
         _priceTP = _priceTrgr + ( _TPinPips * _Points * _factor );
         if( _priceTP >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr + ( _StopLevel * _Points );         
         }
      }
   } 
   else if( _OP == OP_SELLLIMIT )
   {
      _priceTrgr = _priceBid + ( _pipsTrgrPrcOfst* _Points * _factor );
      if( _priceTrgr >= ( _priceBid + ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Sell Limit Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0 ;
      }
      else
      {
         _priceSL = _priceTrgr + ( _SLinPips * _Points * _factor );
         if( _priceSL >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr + ( _StopLevel * _Points );
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else
      {
         _priceTP = _priceTrgr - ( _TPinPips * _Points * _factor );
         if( _priceTP <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr - ( _StopLevel * _Points );
         }
      }
   } 
   else if( _OP == OP_SELLSTOP )
   {
      _priceTrgr = _priceBid - ( _pipsTrgrPrcOfst* _Points * _factor );
      if( _priceTrgr <= ( _priceBid - ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Sell Stop Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0 ;
      }
      else
      {
         _priceSL = _priceTrgr + ( _SLinPips * _Points * _factor );
         if( _priceSL >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr + ( _StopLevel * _Points );
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else
      {
         _priceTP = _priceTrgr - ( _TPinPips * _Points * _factor );
         if( _priceTP <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr - ( _StopLevel * _Points );
         }
      }
   }  
   
   // normalize all price values to digits
   _priceTrgr = NormalizeDouble( _priceTrgr, _Digit );
   _priceSL   = NormalizeDouble( _priceSL, _Digit );
   _priceTP   = NormalizeDouble( _priceTP, _Digit );
   
   // ensure lot is within allowed limits
   func_EnsureLotWithinAllowedLimits( _Lots, _namePair );
   
   // place a pending order
   switch( _OP )
   {
      case OP_BUYLIMIT  : rtrn_Ticket = OrderSend( _namePair, OP_BUYLIMIT, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrBlueViolet );
                          break;
      case OP_SELLLIMIT : rtrn_Ticket = OrderSend( _namePair, OP_SELLLIMIT, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrGold );
                          break;
      case OP_BUYSTOP   : rtrn_Ticket = OrderSend( _namePair, OP_BUYSTOP, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrBlueViolet );
                          break;
      case OP_SELLSTOP  : rtrn_Ticket = OrderSend( _namePair, OP_SELLSTOP, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrGold );                                          
                          break;
      default           : Alert( "Wrong Pending Order type" );
                          return( rtrn_Ticket );
   }
   
   // message error code for de-bugging, if order is not placed successfully
   if( rtrn_Ticket == -1 )
   {
      Print( TimeToString( TimeCurrent(), TIME_DATE|TIME_SECONDS ) + " " 
           + __FUNCTION__ + ": E1(" + IntegerToString( GetLastError() ) + ")" );    
   }
   //
   return( rtrn_Ticket );
} 
//
//Place Pending Order with prices for any symbols
int PlacePendingOrderWithPrice( string   _namePair,
                                int      _OP,
                                double   _Lots,
                                double   _priceTrgr,
                                int      _SLinPips       = 0,
                                int      _TPinPips       = 0,
                                int      _SlippageInPips = 10,
                                int      _MagicNumber    = 0,
                                datetime expiry          = 0,
                                string   _Comment        = "PO_HPCS" )
{
   //
   // Error code, printed in Experts log by this function for de-bugging:
   // E1( GetLastError() ) : [ERROR # _Error] Placing pending order failed
   //
   int rtrn_Ticket = -1,
       _Digit      = (int)MarketInfo( _namePair, MODE_DIGITS ),
       _StopLevel  = (int)MarketInfo( _namePair, MODE_STOPLEVEL );
   //
   double _priceSL = 0,
          _priceTP = 0;
   //
   // get values for given currency pair symbol
   double _Points   = MarketInfo( _namePair, MODE_POINT ),
          _priceAsk = MarketInfo( _namePair, MODE_ASK ),
          _priceBid = MarketInfo( _namePair, MODE_BID ); 
   
   if( _OP == OP_BUYLIMIT )
   {
      if( _priceTrgr <= ( _priceAsk - ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Buy Limit Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0;
      }
      else 
      {
         _priceSL = _priceTrgr - ( _SLinPips * _Points * _factor );
         if( _priceSL <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr - ( _StopLevel * _Points );         
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else 
      {
         _priceTP = _priceTrgr + ( _TPinPips * _Points * _factor );
         if( _priceTP >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr + ( _StopLevel * _Points );         
         }
      }
   } 
   else if( _OP == OP_BUYSTOP )
   {
      if( _priceTrgr >= ( _priceAsk + ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Buy Stop Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0;
      }
      else 
      {
         _priceSL = _priceTrgr - ( _SLinPips * _Points * _factor );
         if( _priceSL <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr - ( _StopLevel * _Points );         
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else 
      {
         _priceTP = _priceTrgr + ( _TPinPips * _Points * _factor );
         if( _priceTP >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr + ( _StopLevel * _Points );         
         }
      }
   } 
   else if( _OP == OP_SELLLIMIT )
   {
      if( _priceTrgr >= ( _priceBid + ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Sell Limit Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0 ;
      }
      else
      {
         _priceSL = _priceTrgr + ( _SLinPips * _Points * _factor );
         if( _priceSL >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr + ( _StopLevel * _Points );
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else
      {
         _priceTP = _priceTrgr - ( _TPinPips * _Points * _factor );
         if( _priceTP <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr - ( _StopLevel * _Points );
         }
      }
   } 
   else if( _OP == OP_SELLSTOP )
   {
      if( _priceTrgr <= ( _priceBid - ( _StopLevel * _Points ) ) )
      { // Refer: book.mql4.com/appendix/limits 
      }
      else
      {
         Alert( "Sell Stop Order Open Price is violating the minimum stop-level distance" );
         return( -1 );
      }
      if( _SLinPips == 0 )
      {
         _priceSL = 0 ;
      }
      else
      {
         _priceSL = _priceTrgr + ( _SLinPips * _Points * _factor );
         if( _priceSL >= ( _priceTrgr + ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceSL = _priceTrgr + ( _StopLevel * _Points );
         }
      }
      if( _TPinPips == 0 )
      {
         _priceTP = 0;
      }
      else
      {
         _priceTP = _priceTrgr - ( _TPinPips * _Points * _factor );
         if( _priceTP <= ( _priceTrgr - ( _StopLevel * _Points ) ) )
         { // Refer: book.mql4.com/appendix/limits 
         }
         else
         {
            _priceTP = _priceTrgr - ( _StopLevel * _Points );
         }
      }
   }
   
   // normalize all price values to digits
   _priceTrgr = NormalizeDouble( _priceTrgr, _Digit );
   _priceSL   = NormalizeDouble( _priceSL, _Digit );
   _priceTP   = NormalizeDouble( _priceTP, _Digit );
   
   // ensure lot is within allowed limits
   func_EnsureLotWithinAllowedLimits( _Lots, _namePair );
   
   // place a pending order
   switch( _OP )
   {
      case OP_BUYLIMIT  : rtrn_Ticket = OrderSend( _namePair, OP_BUYLIMIT, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrBlueViolet );
                          break;
      case OP_SELLLIMIT : rtrn_Ticket = OrderSend( _namePair, OP_SELLLIMIT, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrGold );
                          break;
      case OP_BUYSTOP   : rtrn_Ticket = OrderSend( _namePair, OP_BUYSTOP, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrBlueViolet );
                          break;
      case OP_SELLSTOP  : rtrn_Ticket = OrderSend( _namePair, OP_SELLSTOP, _Lots, _priceTrgr, _SlippageInPips, _priceSL, _priceTP, _Comment, _MagicNumber, expiry, clrGold );                                          
                          break;
      default           : Alert( "Wrong Pending Order type" );
                          return( rtrn_Ticket );
   }
   
   // message error code for de-bugging, if order is not placed successfully
   if( rtrn_Ticket == -1 )
   {
      Print( TimeToString( TimeCurrent(), TIME_DATE|TIME_SECONDS ) + " " 
           + __FUNCTION__ + ": E1(" + IntegerToString( GetLastError() ) + ")" );    
   }
   //
   return( rtrn_Ticket );
} 
