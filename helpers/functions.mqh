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

