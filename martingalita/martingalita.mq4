#property copyright "Forex Software Ltd."
#property version   "2.18"
#property strict
#include "../helpers/functions.mqh"

input double lots = 0.1;//lotes iniciales
input double multiplier = 1.3;//multiplicador de lotes
input int BB_period = 20;
input int BB_desviaton = 2;


//+------------------------------------------------------------------+
bool ordered_in_the_actual_bar = false;
double TPg;
double Nbuy;
double lots_accumulated;

double point = Point * 10;// Obtiene el valor del pip para el símbolo actual



int prevBarCount = Bars;

void closeAllOrders()
{
  // get all orders active
  int totalOrders = OrdersTotal();
  // close all of them
  for (int i = totalOrders - 1; i >= 0; i--)
  {
    if (OrderSelect(i, SELECT_BY_POS))OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 2, clrNONE);
  }
}

void OnInit()
{
  // print point
  // get the pip value
  closeAllOrders();
}

void OnTick(){
  int currentBarCount = Bars;
  if (currentBarCount > prevBarCount) {
    OnNewBar();
  }
  prevBarCount = currentBarCount;  



  // if there is any order open 
  if(OrdersTotal() > 0){
    // print bid and Nbuy
    
    // if the price is equal or lower than the Nbuy
    if (Bid <= Nbuy)
    {
      Print("======================");
      // print lotas accumulated
      Print("lots_accumulated: ", lots_accumulated);
      Print("======================");
      lots_accumulated *= multiplier;
      // open a buy order with the current price and the initial lots
      OrderSend(Symbol(), OP_BUY, lots_accumulated, Ask, 3, 0, TPg, "Buy from martingalita");
      // set the Nbuy to the current price minus 20 pips
      Nbuy = Bid - (20 * point);
      Print(GetLastError());
    }
  }else{
    // if the Bolliger Bands lower is bigger than the current price
    if (iBands(Symbol(), 0, BB_period, BB_desviaton, 0, PRICE_CLOSE, MODE_LOWER, 0) > Bid)
    {
      // set TPg to the current price plus 20 pips
      TPg = Bid + (20 * point);
      // set the Nbuy to the current price minus 20 pips
      Nbuy = Bid - (20 * point);
      // open a buy order with the current price and the initial lots
      OrderSend(Symbol(), OP_BUY, lots, Ask, 3, 0, TPg, "Buy from martingalita");

      ordered_in_the_actual_bar = true;
      lots_accumulated = lots;

    }
  }
}

void OnNewBar(){
  ordered_in_the_actual_bar = false;
}