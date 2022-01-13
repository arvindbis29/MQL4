//+------------------------------------------------------------------+
//|                                _HPCS_Adva_MT4_indi_05_V01_WE.mq4 |
//|                  Copyright 2011-2022, HPC Sphere Pvt. Ltd. India |
//|                                         http://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2022, HPC Sphere Pvt. Ltd. India"
#property link      "http://www.hpcsphere.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property script_show_inputs
#property description "Script creates the button on the chart."

input int ii_RSIperiod=14;
input int ii_KPeriod=5;
input int ii_DPeriod=3;
input int ii_Slowing=3;

int gi_RSIperiod= ii_RSIperiod;
int gi_KPeriod=ii_KPeriod;
int gi_DPeriod=ii_DPeriod;
int gi_Slowing=ii_Slowing;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ObjectsDeleteAll();
   BlankChart();
   string period[9] = {"M1", "M5", "M15", "M30", "h1", "H4", "D1", "W1", "MN1"};
   int x = 300;
   for(int i=0; i<9; i++)
     {
      CreateLabel("Headings" + period[i],x +i*130,40,0,clrWhite,period[i],10);
     }
   string rowHeading[4] = {"Time_period:-","RSI Value", "Stochatic Main Value",  " Stochastc Signal Value"};
   x= 100;
   int y = 40;
   for(int i=0; i<4; i++)
     {
      CreateLabel(" Row Headings" + rowHeading[i],x,y+ i*54,0,clrWhite,rowHeading[i],10);
     }


   int ls_timeperiod[9]= {1,5,15,30,60,240,1440,10080,43200};
   for(int i=0; i<9; i++)
     {
      CreateLabel(" RSI VAlues" + IntegerToString(ls_timeperiod[i]),300+i*130,100,0,clrWhite,DoubleToString(iRSI(NULL,ls_timeperiod[i],gi_RSIperiod,PRICE_CLOSE,0)),10);
     }

   for(int i=0; i<9; i++)
     {
      CreateLabel(" STochastic main values" + IntegerToString(ls_timeperiod[i]),300+i*130,150,0,clrWhite,DoubleToString(iStochastic(NULL,ls_timeperiod[i],gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0)),10);
     }
   for(int i=0; i<9; i++)
     {
      CreateLabel(" STochastic signal values" + IntegerToString(ls_timeperiod[i]),300+i*130,200,0,clrWhite,DoubleToString(iStochastic(NULL,ls_timeperiod[i],gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0)),10);
     }
   y = 300;
   string EditBoxValues[4];
   EditBoxValues[0] = IntegerToString(gi_RSIperiod);
   EditBoxValues[1] = IntegerToString(gi_DPeriod);
   EditBoxValues[2] = IntegerToString(gi_KPeriod);
   EditBoxValues[3] = IntegerToString(gi_Slowing);
   for(int i=0; i<4; i++)
     {
      func_EditBox("EditBox "+IntegerToString(i),200,y+i*50,60,40,EditBoxValues[i],clrWhite,clrGreen,clrYellow,10);
     }

   string Boxname[4]= {"RSIPeriod","DPeriod","Kperiod","Slowing"};

   for(int i=0; i<4; i++)
     {
      CreateLabel("Editboxname" + Boxname[i],120,323+i*50,0,clrWhite,Boxname[i],10);
     }
   string ButtonBox[2]= {"UPDATE","RESET"};

   for(int i=0; i<2; i++)
     {
      func_Button("BUTTON "+ButtonBox[i],400,320+i*80,90,40,ButtonBox[i],clrWhite,clrGreen,clrYellow,10);
     }
   /*ObjectsDeleteAll();
   double ld_RSIforM1=iRSI(NULL,1,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforM5=iRSI(NULL,5,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforM15=iRSI(NULL,15,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforM30=iRSI(NULL,30,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforH1=iRSI(NULL,60,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforH4=iRSI(NULL,240,gi_RSIperiod,PRICE_CLOSE,0);
   double ld_RSIforD1=iRSI(NULL,1440,gi_RSIperiod,PRICE_CLOSE,0);



   double ld_StocharM1=iStochastic(NULL,1,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharM5=iStochastic(NULL,5,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharM15=iStochastic(NULL,15,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharM30=iStochastic(NULL,30,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharH1=iStochastic(NULL,60,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharH4=iStochastic(NULL,240,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);
   double ld_StocharD1=iStochastic(NULL,1440,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0);


   double ld_StocharSignalM1=iStochastic(NULL,1,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalM5=iStochastic(NULL,5,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalM15=iStochastic(NULL,15,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalM30=iStochastic(NULL,30,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalH1=iStochastic(NULL,60,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalH4=iStochastic(NULL,240,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   double ld_StocharSignalD1=iStochastic(NULL,1440,gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0);
   if(!ObjectCreate(NULL,"Sto",OBJ_LABEL,0,0,0))
     {
      Print("Error: can't create label! code #",GetLastError());
      return(0);
     }
   ObjectSetInteger(NULL,"Sto",OBJPROP_COLOR,clrBlue);
   ObjectSetString(NULL,"Sto",OBJPROP_TEXT,"Stocharmain "+(DoubleToString(ld_StocharM1)+"   "+DoubleToString(ld_StocharM5)+"   "+DoubleToString(ld_StocharM15)+"   "+DoubleToString(ld_StocharM30)+"   "+DoubleToString(ld_StocharH1)+"  "+DoubleToString(ld_StocharH4)+"    "+DoubleToString(ld_StocharD1)));
   ChartRedraw(0);
   ObjectSetInteger(0,"Sto",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"Sto",OBJPROP_YDISTANCE,70);
   if(!ObjectCreate(NULL,"RSI",OBJ_LABEL,0,0,0))
     {
      Print("Error: can't create label! code #",GetLastError());
      return(0);
     }
   ObjectSetInteger(NULL,"RSI",OBJPROP_COLOR,clrRed);
   ObjectSetString(NULL,"RSI",OBJPROP_TEXT," rsi"+ (DoubleToString(ld_RSIforM1)+"  "+DoubleToString(ld_RSIforM5)+"  "+DoubleToString(ld_RSIforM15)+"  "+DoubleToString(ld_RSIforM30)+"  "+DoubleToString(ld_RSIforH1)+"  "+DoubleToString(ld_RSIforH4)+"  "+DoubleToString(ld_RSIforD1)));
   ChartRedraw(0);
   ObjectSetInteger(0,"RSI",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,"RSI",OBJPROP_YDISTANCE,90);



   if(!ObjectCreate(NULL,"StocharSignal",OBJ_LABEL,0,0,0))
     {
      Print("Error: can't create label! code #",GetLastError());
      return(0);
     }
   ObjectSetInteger(NULL,"StocharSignal",OBJPROP_COLOR,clrAliceBlue);
   ObjectSetString(NULL,"StocharSignal",OBJPROP_TEXT,"  StocharSignal  "+ (DoubleToString(ld_StocharSignalM1)+"  "+DoubleToString(ld_StocharSignalM5)+"  "+DoubleToString(ld_StocharSignalM15)+"  "+DoubleToString(ld_StocharSignalM30)+"  "+DoubleToString(ld_StocharSignalH1)+"  "+DoubleToString(ld_StocharSignalH4)+"  "+DoubleToString(ld_StocharSignalD1)));
   ChartRedraw(0);
   ObjectSetInteger(0,"StocharSignal",OBJPROP_CORNER,CORNER_LEFT_UPPER);
   */
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int ls_timeperiod[9]= {1,5,15,30,60,240,1440,10080,43200};
   for(int i=0; i<9; i++)
     {
      ObjectSetString(0," RSI VAlues" + IntegerToString(ls_timeperiod[i]),OBJPROP_TEXT,DoubleToString(iRSI(NULL,ls_timeperiod[i],gi_RSIperiod,PRICE_CLOSE,0)));
     }

   for(int i=0; i<9; i++)
     {
      ObjectSetString(0," STochastic main values" + IntegerToString(ls_timeperiod[i]),OBJPROP_TEXT,DoubleToString(iStochastic(NULL,ls_timeperiod[i],gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_MAIN,0)));
     }
   for(int i=0; i<9; i++)
     {
      ObjectSetString(0," STochastic signal values" + IntegerToString(ls_timeperiod[i]),OBJPROP_TEXT,DoubleToString(iStochastic(NULL,ls_timeperiod[i],gi_KPeriod,gi_DPeriod,gi_Slowing,MODE_SMA,0,MODE_SIGNAL,0)));
     }




//--- return value of prev_calculated for next call
   return(rates_total);
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
   if(sparam == "BUTTON UPDATE")
      func_update();

   if(sparam == "BUTTON RESET")
      func_RESET();

  }
//+------------------------------------------------------------------+
//
void CreateLabel(string _name, int _x, int _y, int _corner, int _z, string _text, int _size, ENUM_ANCHOR_POINT _anchor = ANCHOR_LEFT, string _font="Arial")
  {
//
   if(ObjectFind(_name) == -1)
     {
      ObjectCreate(_name,OBJ_LABEL,0,0,0);
     }
   ObjectSet(_name,OBJPROP_CORNER,_corner);
   ObjectSet(_name,OBJPROP_COLOR,_z);
   ObjectSet(_name,OBJPROP_XDISTANCE,_x);
   ObjectSet(_name,OBJPROP_YDISTANCE,_y);
   ObjectSet(_name,OBJPROP_ANCHOR,_anchor);
   ObjectSetText(_name,_text,_size,_font,_z);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Chart Blank                                                      |
//+------------------------------------------------------------------+
void BlankChart()
  {
   int handle=0;
   ChartSetInteger(handle,CHART_MODE,2);
   ChartSetInteger(handle,CHART_COLOR_CHART_LINE,ChartGetInteger(handle,CHART_COLOR_BACKGROUND));
   ChartSetInteger(handle,CHART_SHOW_BID_LINE,0);
   ChartSetInteger(handle,CHART_SHOW_ASK_LINE,0);
   ChartSetInteger(handle,CHART_SHOW_OHLC,0);
   ChartSetInteger(handle,CHART_SHOW_GRID,0,0);
   ChartSetInteger(handle,CHART_SHOW_DATE_SCALE,0,0);
   ChartSetInteger(handle,CHART_SHOW_VOLUMES,0,0);
   ChartSetInteger(handle,CHART_SHOW_PRICE_SCALE,0,0);
   ChartSetInteger(handle,CHART_SHOW_ONE_CLICK,0,0);
   ChartSetInteger(handle,CHART_SHOW_LAST_LINE,0,0);
   ChartSetInteger(handle,CHART_SHOW_OBJECT_DESCR,0,0);
   ChartSetInteger(handle,CHART_SHOW_PERIOD_SEP,0,0);
   ChartSetInteger(handle,CHART_SHOW_TRADE_LEVELS,0,0);
   ChartRedraw();
  }
//+------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void func_EditBox(string name, int x, int y, int xsize, int ysize, string text, color clr, color clrBack, color border_clr, int fontsize)
  {
   int chart_ID=0;
   ObjectCreate(0,name, OBJ_EDIT, 0, 0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(0,name,OBJPROP_XSIZE,xsize);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,ysize);
//--- set the text
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,fontsize);

//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,false);
//--- set the chart's corner, relative to which object coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,0);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrBack);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void func_Button(string name, int x, int y, int xsize, int ysize, string text, color clr, color clrBack, color border_clr, int fontsize)
  {

   int chart_ID=0;
   ObjectCreate(0,name, OBJ_BUTTON, 0, 0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(0,name,OBJPROP_XSIZE,xsize);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,ysize);
//--- set the text
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,fontsize);

//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,true);
//--- set the chart's corner, relative to which object coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,0);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrBack);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void func_update()
  {
   string rsiPerriod = ObjectGetString(0,"EditBox "+IntegerToString(0),OBJPROP_TEXT);
   gi_RSIperiod =(int) StringToInteger(rsiPerriod);

   string DPerriod = ObjectGetString(0,"EditBox "+IntegerToString(1),OBJPROP_TEXT);
   gi_DPeriod = (int) StringToInteger(DPerriod);

   string KPerriod = ObjectGetString(0,"EditBox "+IntegerToString(2),OBJPROP_TEXT);
   gi_KPeriod =(int) StringToInteger(KPerriod);

   string Slowing = ObjectGetString(0,"EditBox "+IntegerToString(3),OBJPROP_TEXT);
   gi_Slowing = (int) StringToInteger(Slowing);
  }
//+------------------------------------------------------------------+
void func_RESET()
  {
   ObjectSetString(0,"EditBox "+IntegerToString(0),OBJPROP_TEXT,"14");
   ObjectSetString(0,"EditBox "+IntegerToString(1),OBJPROP_TEXT,"3");
   ObjectSetString(0,"EditBox "+IntegerToString(2),OBJPROP_TEXT,"5");
   ObjectSetString(0,"EditBox "+IntegerToString(3),OBJPROP_TEXT,"3");
   gi_RSIperiod =14;
   gi_DPeriod =3;
   gi_KPeriod =5;
   gi_Slowing = 3;

  }
//+------------------------------------------------------------------+
