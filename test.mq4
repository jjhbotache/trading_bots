
#include "helpers/functions.mqh"
#include <WinUser32.mqh>

// comentario de una linea
/* 
comentario de varias lineas
// nested comment
 */

bool boleano = false;
int entero = 1;
double decimal = 1.1;
string cadena = "hola mundo";
datetime fecha = D'2021.01.01 00:00';
color Color = clrRed;
enum Enumeracion {valor1, valor2, valor3};


class Carro{
  public:
    int ruedas;

    Carro(int r = 4){
        Print("Soy un carro: "+ r );
        ruedas = r;
    }

    void avanzar(){
      Print("avanzando");
    }
};


int orders[];

int OnInit(){
  CreateButton("MiBoton", "Presionar", 10, 10, 100, 30, 1);

  // create a btn
  ObjectCreate("btn", OBJ_BUTTON, 0, 0, 0);
  ObjectSet("btn", OBJPROP_XDISTANCE, 10);
  ObjectSet("btn", OBJPROP_YDISTANCE, 10);
  ObjectSet("btn", OBJPROP_XSIZE, 100);
  ObjectSet("btn", OBJPROP_YSIZE, 50);
  ObjectSet("btn", OBJPROP_BACK, true);
  ObjectSetText("btn", "print", 10, "Arial", clrRed);

  Print("hola mundo");

  ArrayResize(orders, ArraySize(orders)+1);
  orders[ArraySize(orders)-1] = OrderSend(_Symbol, OP_SELL, 1, Bid, 5, 0, 0);
  // create an order instance  from  the  ticket
  Order order(orders[0]);
  // print each property
  Sleep(30000);
  Print("order.ticket: ", order.ticket);
  Print("order.openPrice: ", order.openPrice);
  Print("order.closePrice: ", order.closePrice);
  Print("order.type: ", order.type);
  Print("order.lots: ", order.lots);
  Print("order.stopLoss: ", order.stopLoss);
  Print("order.takeProfit: ", order.takeProfit);
  Print("order.commission: ", order.commission);
  Print("order.swap: ", order.swap);
  Print("order.profit: ", order.profit);
  Print("order.state: ", order.state);
  Print("order.deviation: ", order.deviation);
  Print("order.comment: ", order.comment);
  Print("order.openTime: ", order.openTime);
  Print("order.closeTime: ", order.closeTime);
  Print("order.magicNumber: ", order.magicNumber);

  // get the info of an order
  // Print("--");
  // int ticket = orders[0];
  // OrderInfo orderInfo = GetOrderInfo(ticket);
  // Print("orderInfo.openPrice: ", orderInfo.openPrice);

  return(1);
}

void print_array(int &array[]){
  for(int i = 0; i < ArraySize(array); i++){
    Print("array["+i+"]: ",array[i]);
  }
}

// when clicked, print the array
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam){
  Print("id: ", id);
  Print("lparam: ", lparam);
  Print("dparam: ", dparam);
  Print("sparam: ", sparam);
  if(id == CHARTEVENT_OBJECT_CLICK && sparam == "btn"){
    print_array(orders);
    Print("hola");
  }
}