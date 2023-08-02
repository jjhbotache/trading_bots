double ima(int period, int shift) {
    return iMA(NULL, 0, period, 0, MODE_EMA, PRICE_CLOSE, shift);
}
