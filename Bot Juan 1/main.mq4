#include "../helpers/functions.mqh"

input int N = 3; // Periodo de la media exponencial
input double lotSize = 0.1; // Tamaño de lote para las órdenes

double orderResults[]; // Lista para almacenar los resultados de las órdenes
int prevBarCount = 0; // Número de velas en el tick anterior
string fileName = "OrderResults.txt"; // Nombre del archivo para guardar los resultados

// Función para verificar la condición de rompimiento al alza
bool RompimientoAlAlza() {
    double openPrice = iOpen(Symbol(), 0, 1);
    double closePrice = iClose(Symbol(), 0, 1);
    double emaValue = ima(N, 1);

    return openPrice < emaValue && closePrice > emaValue;
}

// Función para verificar la condición de rompimiento a la baja
bool RompimientoALaBaja() {
    double openPrice = iOpen(Symbol(), 0, 1);
    double closePrice = iClose(Symbol(), 0, 1);
    double emaValue = ima(N, 1);

    return openPrice > emaValue && closePrice < emaValue;
}

// Función para abrir una posición de compra
void OpenBuyOrder() {
    double price = Ask;
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, price, 2, 0, 0, "", 0, clrNONE);
    if (ticket > 0) {
        int size = ArraySize(orderResults);
        ArrayResize(orderResults, size + 1);
        orderResults[size] = price;
    }
}

// Función para cerrar una posición de compra
void CloseBuyOrder() {
    double price = Bid;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderType() == OP_BUY) {
                double balanceBeforeClose = AccountBalance();
                OrderClose(OrderTicket(), OrderLots(), price, 2, clrNONE);
                double balanceAfterClose = AccountBalance();
                double orderBalance = balanceAfterClose - balanceBeforeClose;

                int size = ArraySize(orderResults);
                ArrayResize(orderResults, size + 1);
                orderResults[size] = -price;

                string message = "Orden cerrada. Balance de la orden: $" + DoubleToString(orderBalance, 2);
                MessageBox(message, "Cierre de Orden #" + IntegerToString(OrderTicket()), MB_ICONINFORMATION);

            }
        }
    }
}

// Función para verificar la condición en cada tick
void OnTick() {
    int currentBarCount = Bars;
    if (currentBarCount > prevBarCount) {
        Print("---------------");
        // Se ha formado una nueva vela, ejecutar el código actual
        if (RompimientoAlAlza()) {
            Print("RompimientoAlAlza");
            OpenBuyOrder();
        }

        if (RompimientoALaBaja()) {
            CloseBuyOrder();
        }
    }

    prevBarCount = currentBarCount;
}

// Función de inicio del robot
void OnInit() {
    ArrayResize(orderResults, 0);
    prevBarCount = Bars; // Inicializar prevBarCount con el número actual de velas
    OnTick(); // Ejecutar una vez al inicio para asegurarse de que se cumpla la condición inicial
}
