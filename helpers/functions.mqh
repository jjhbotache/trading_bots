double ima(int period, int shift) {
    return iMA(NULL, 0, period, 0, MODE_EMA, PRICE_CLOSE, shift);
}

bool breaking(double price,bool breaking_to_up){
    double openPrice = iOpen(Symbol(), 0, 1);
    double closePrice = iClose(Symbol(), 0, 1);
    if(breaking_to_up){
        return openPrice > price && closePrice < price;
    }else{
        return openPrice < price && closePrice > price;
    }
}

bool RompimientoAlAlza(int periods) {
    double openPrice = iOpen(Symbol(), 0, 1);
    double closePrice = iClose(Symbol(), 0, 1);
    double emaValue = ima(periods, 1);

    return openPrice > emaValue && closePrice < emaValue;
}

// Función para verificar la condición de rompimiento a la baja
bool RompimientoALaBaja(int periods) {
    double openPrice = iOpen(Symbol(), 0, 1);
    double closePrice = iClose(Symbol(), 0, 1);
    double emaValue = ima(periods, 1);

    return openPrice < emaValue && closePrice > emaValue;
}

void write_on_file(string file, string txt) {
    int fileHandle = FileOpen(file, FILE_WRITE | FILE_CSV, ';');
    if (fileHandle > 0) {
        FileWrite(fileHandle, txt);
        FileClose(fileHandle);
    }
}

double CalculatePipsDistance(double price1, double price2)
{
    double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT); // Obtiene el valor del pip para el símbolo actual
    double pipsDistance = MathAbs(price1 - price2) / point;
    return pipsDistance;
}


class Order {
public:
    int ticket;
    int magicNumber;
    string symbol;
    int openTime;
    int closeTime;
    double openPrice;
    double closePrice;
    double lots;
    double stopLoss;
    double takeProfit;
    double commission;
    double swap;
    double profit;
    int type;
    int state;
    int deviation;
    string comment;

    // Constructor
    Order(int t) {
        ticket = t;

        if (OrderSelect(ticket, SELECT_BY_TICKET)) {
            magicNumber = OrderMagicNumber();
            symbol = OrderSymbol();
            openTime = OrderOpenTime();
            closeTime = OrderCloseTime();
            openPrice = OrderOpenPrice();
            closePrice = OrderClosePrice();
            lots = OrderLots();
            stopLoss = OrderStopLoss();
            takeProfit = OrderTakeProfit();
            commission = OrderCommission();
            swap = OrderSwap();
            profit = OrderProfit();
            type = OrderType();
            state = OrderType();
            deviation = OrderType();
            comment = OrderComment();
        } else {
            Print("No se pudo seleccionar la orden con el ticket ", ticket);
        }
    }
};

