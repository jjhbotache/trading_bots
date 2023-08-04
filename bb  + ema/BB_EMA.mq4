// Parámetros de entrada
input int EMA_Period = 8;// Período de la media móvil exponencial
input int BB_Period = 20;// Período de las bandas de Bollinger
input int BB_desviation = 4; // Desviación de las bandas de Bollinger

input double LotSize = 0.1; // Tamaño de la orden en lotes

#include "../helpers/functions.mqh"

// Variables globales


int prevBarCount=Bars;
void OnTick()
{
  int currentBarCount = Bars;
  if (currentBarCount > prevBarCount) {
    OnNewBar();
  }
  prevBarCount = currentBarCount;    
}

void OnNewBar(){
  Print("----------------");
  // get the value of the EMA of the last bar
  double EMA_2 = iMA(NULL, 0, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, 2);
  double EMA_1 = iMA(NULL, 0, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, 1);
  double EMA = iMA(NULL, 0, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, 0);

    // Calcula la banda media de Bollinger de x períodos
    
  double BB_Upper = iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_UPPER, 0);
  double BB_Lower = iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_LOWER, 0);
  double BB_Middle = (BB_Upper + BB_Lower) / 2;

  double BBM_2 = (iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_UPPER, 2) + iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_LOWER, 2)) / 2;
  double BBM_1 = (iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_UPPER, 1) + iBands(NULL, 0, BB_Period, BB_desviation, 0, PRICE_CLOSE, MODE_LOWER, 1)) / 2;


  // comment all the actual ema an bollinger bands values
  Comment("EMA: ", EMA, "\n",
  "BB_Upper: ", BB_Upper, "\n",
  "BB_Lower: ", BB_Lower, "\n",
  "BB_Middle: ", BB_Middle, "\n");
  
  // Verifica si la EMA cruza por encima de la banda media de Bollinger
  if (EMA_2 < BBM_2 && EMA_1 > BBM_1)
  {
    Print("dfmfwdfmwodmwoS");
      // crea un msg box 
      MessageBox("EMA cruza por encima de la banda media de Bollinger", "Alerta", MB_ICONINFORMATION);

      

      double stopLoss = BB_Upper;
      double takeProfit = BB_Lower;

      //    OrderSend(_Symbol, OP_SELL, LotSize, Bid, 2, 0, 0);
      int ticket = OrderSend(_Symbol, OP_SELL, LotSize, Bid, 0, stopLoss, takeProfit);
      MessageBox("ticket: "+ticket, "ticket", MB_ICONINFORMATION);
      if (ticket > 0){
          Print("Orden de compra abierta con éxito. Ticket: ", ticket);
      }
      else{
          Print("Error al abrir la orden de compra. Código de error: ", GetLastError());
      }
  }
}
