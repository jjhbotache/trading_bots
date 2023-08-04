//
// EA Studio Expert Advisor
//
// Created with: Expert Advisor Studio
// Website: https://eas.forexsb.com
//
// Copyright 2023, Forex Software Ltd.
//
// Risk Disclosure
//
// Futures and forex trading contains substantial risk and is not for every investor.
// An investor could potentially lose all or more than the initial investment.
// Risk capital is money that can be lost without jeopardizing ones’ financial security or life style.
// Only risk capital should be used for trading and only those with sufficient risk capital should consider trading.

#property copyright "Forex Software Ltd."
#property version   "3.5"
#property strict

static input string _Properties_ = "------"; // --- Expert Properties ---
static input double Entry_Amount =     0.10; // Entry lots
       input int    Stop_Loss    =        0; // Stop Loss   (pips)
       input int    Take_Profit  =        0; // Take Profit (pips)


static input string __Options___ = "------"; // --- Options ---
static input int    Magic_Number = 10659525; // Magic Number
static input int    Max_Spread   =        0; // Max spread protection (points)
static input int    Min_Equity   =        0; // Min equity protection (currency)

#define TRADE_RETRY_COUNT   4
#define TRADE_RETRY_WAIT  100
#define OP_FLAT            -1

// Session time is set in seconds from 00:00
int  sessionSundayOpen          =     0; // 00:00
int  sessionSundayClose         = 86400; // 24:00
int  sessionMondayThursdayOpen  =     0; // 00:00
int  sessionMondayThursdayClose = 86400; // 24:00
int  sessionFridayOpen          =     0; // 00:00
int  sessionFridayClose         = 86400; // 24:00
bool sessionIgnoreSunday        = false;
bool sessionCloseAtSessionClose = false;
bool sessionCloseAtFridayClose  = false;

const double sigma        = 0.000001;
const int    requiredBars = 2;

double posType       = OP_FLAT;
int    posTicket     = 0;
double posLots       = 0;
double posStopLoss   = 0;
double posTakeProfit = 0;

datetime barTime;
double   pip;
double   stopLevel;
bool     isTrailingStop          = false;
bool     setProtectionSeparately = false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   barTime        = Time[0];
   stopLevel      = MarketInfo(_Symbol, MODE_STOPLEVEL);
   pip            = GetPipValue();
   isTrailingStop = isTrailingStop && Stop_Loss > 0;

   return ValidateInit();
  }
//+------------------------------------------------------------------+
double GetPipValue()
  {
   return _Digits == 4 || _Digits == 5 ? 0.0001
        : _Digits == 2 || _Digits == 3 ? 0.01
                        : _Digits == 1 ? 0.1 : 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_INIT_RETCODE ValidateInit()
  {
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
/*STRATEGY MARKET Pepperstone-Demo02; GBPJPY; H1 */
/*STRATEGY CODE {"properties":{"entryLots":0.1,"tradeDirectionMode":0,"oppositeEntrySignal":0,"stopLoss":100,"takeProfit":100,"useStopLoss":false,"useTakeProfit":false,"isTrailingStop":false},"openFilters":[],"closeFilters":[]} */
