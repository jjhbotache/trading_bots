#property copyright "Forex Software Ltd."
#property version   "2.18"
#property strict

#include "../helpers/functions.mqh"


input int on_order_open_IMA_periods = 3; // Periodo para IMA de apertura de orden
input int on_order_close_IMA_periods = 3; // Periodo para IMA de cierre de orden
input double lotSize = 0.1; // Tamaño de lote para las órdenes

double orderResults[]; // Lista para almacenar los resultados de las órdenes
int prevBarCount = 0; // Número de velas en el tick anterior
string fileName = "OrderResults.txt"; // Nombre del archivo para guardar los resultados
// write  in the file the number of the order and the final balance



// Función para abrir una posición de ventaE
void OpenSellOrder(){
    double price = Bid;
    int ticket = OrderSend(Symbol(), OP_SELL, lotSize, price, 2, 0, 0, "", 0, clrNONE);
    if (ticket > 0) {
        int size = ArraySize(orderResults);
        ArrayResize(orderResults, size + 1);
        orderResults[size] = -price;
    }
}

// Función para cerrar una posición de venta
void CloseSellOrder() {
    double price = Ask;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderType() == OP_SELL) {
                double balanceBeforeClose = AccountBalance();
                OrderClose(OrderTicket(), OrderLots(), price, 2, clrNONE);
                double balanceAfterClose = AccountBalance();
                double orderBalance = balanceAfterClose - balanceBeforeClose;

                int size = ArraySize(orderResults);
                ArrayResize(orderResults, size + 1);
                orderResults[size] = price;

                string message = "Orden cerrada. Balance de la orden: $" + DoubleToString(orderBalance, 2);
                MessageBox(message, "Cierre de Orden #" + IntegerToString(OrderTicket()), MB_ICONINFORMATION);
            }
        }
    }
}

// Función para verificar la condición en cada tick
void OnTick() {
    write_on_file(fileName, "OrderResults");
    int currentBarCount = Bars;
    if (currentBarCount > prevBarCount) {
        Print("---------------");
        // Se ha formado una nueva vela, ejecutar el código actual
        if (RompimientoALaBaja( on_order_open_IMA_periods)) {
            Print("RompimientoALaBaja");
            OpenSellOrder();
        }

        if (RompimientoAlAlza( on_order_close_IMA_periods)) {
            CloseSellOrder();
        }
    }

    prevBarCount = currentBarCount;
}

// Función de inicio del robot
int OnInit() {
    OnTick(); // Ejecutar una vez al inicio para asegurarse de que se cumpla la condición inicial
    return 1;
}

double GetPipValue()
  {
   return _Digits == 4 || _Digits == 5 ? 0.0001
        : _Digits == 2 || _Digits == 3 ? 0.01
                        : _Digits == 1 ? 0.1 : 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+