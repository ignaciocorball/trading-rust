//@version=5
// Made by Ignacio Corball
// Bollinger Bands with SMA trend filter and ATR-based stop loss and take profit
strategy("Bollinger Bands with SMA and ATR", overlay=true, initial_capital=50, currency=currency.USD, default_qty_type=strategy.percent_of_equity, default_qty_value=1)

// Bollinger Bands
src = input(close)
length = input.int(34, minval=1)
mult = input.float(2.0, minval=0.001, maxval=50)

basis = ta.sma(src, length)
dev = ta.stdev(src, length)
dev2 = mult * dev

upper1 = basis + dev
lower1 = basis - dev
upper2 = basis + dev2
lower2 = basis - dev2

colorBasis = src >= basis ? color.blue : color.orange

pBasis = plot(basis, linewidth=2, color=colorBasis)
pUpper1 = plot(upper1, color=color.blue, style=plot.style_circles)
pUpper2 = plot(upper2, color=color.blue)
pLower1 = plot(lower1, color=color.orange, style=plot.style_circles)
pLower2 = plot(lower2, color=color.orange)

fill(pBasis, pUpper2, color=color.blue, transp=95)
fill(pUpper1, pUpper2, color=color.blue, transp=95)
fill(pBasis, pLower2, color=color.orange, transp=95)
fill(pLower1, pLower2, color=color.orange, transp=95)

// SMA trend filter
ma_period = input.int(20, minval=1)
ma = ta.sma(close, ma_period)
plot(ma, title="SMA", color=color.green)

// ATR-based stop loss and take profit
atr_period = input.int(14, minval=1)
atr = ta.atr(atr_period)
stop_loss = input.float(1.5, title="Stop Loss %", minval=0.1, maxval=5.0, step=0.1)
take_profit = input.float(3.0, title="Take Profit %", minval=0.1, maxval=10.0, step=0.1)

// Entry and exit signals
if (close > upper2)
    strategy.order("long", strategy.long, stop=upper2, comment="Long")
if (close < lower2)
    strategy.order("short", strategy.short, stop=lower2, comment="Short")
if (strategy.position_size > 0)
    strategy.exit("long stop loss", "long", stop=stop_loss)
    strategy.exit("long take profit", "long", limit=take_profit)
if (strategy.position_size < 0)
    strategy.exit("short stop loss", "short", stop=stop_loss)
    strategy.exit("short take profit", "short", limit=take_profit)
