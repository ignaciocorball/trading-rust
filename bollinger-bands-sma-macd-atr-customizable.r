//@version=5
// Bollinger Bands with SMA trend filter, MACD confirmation, and ATR-based stop loss and take profit

strategy("Bollinger Bands with SMA and MACD", overlay=true, initial_capital=10000, currency=currency.USD, default_qty_type=strategy.percent_of_equity, default_qty_value=1)

// Bollinger Bands
src = input(close)
bb_length = input.int(20, title="Bollinger Bands Length")
bb_mult = input.float(2.0, title="Bollinger Bands Multiplier")

basis = ta.sma(src, bb_length)
dev = ta.stdev(src, bb_length)
dev2 = bb_mult * dev

upper1 = basis + dev
lower1 = basis - dev
upper2 = basis + dev2
lower2 = basis - dev2

bb_color = src >= basis ? color.blue : color.orange

p_basis = plot(basis, linewidth=2, color=bb_color)
p_upper1 = plot(upper1, color=color.blue, style=plot.style_circles)
p_upper2 = plot(upper2, color=color.blue)
p_lower1 = plot(lower1, color=color.orange, style=plot.style_circles)
p_lower2 = plot(lower2, color=color.orange)

fill(p_basis, p_upper2, color=color.blue, transp=95)
fill(p_upper1, p_upper2, color=color.blue, transp=95)
fill(p_basis, p_lower2, color=color.orange, transp=95)
fill(p_lower1, p_lower2, color=color.orange, transp=95)

// SMA and MACD trend filter
sma_period = input.int(50, title="SMA Period")
sma = ta.sma(close, sma_period)

macd_fast = input.int(12, title="MACD Fast Period")
macd_slow = input.int(26, title="MACD Slow Period")
macd_signal = input.int(9, title="MACD Signal Period")
[macd_line, macd_signal_line, _] = ta.macd(close, macd_fast, macd_slow, macd_signal)

// ATR-based stop loss and take profit
atr_period = input.int(14, title="ATR Period")
atr = ta.atr(atr_period)
stop_loss_pct = input.float(1.5, title="Stop Loss %", minval=0.1, maxval=5.0, step=0.1)
take_profit_pct = input.float(3.0, title="Take Profit %", minval=0.1, maxval=10.0, step=0.1)

// Risk management
risk_pct = input.float(2.0, title="Risk % per Trade", minval=0.1, maxval=5.0, step=0.1)
risk_amt = strategy.equity * (risk_pct / 100)

// Entry and exit signals
if (close > upper2)
    strategy.entry("long", strategy.long, stop=upper2, comment="Long")
if (close < lower2)
    strategy.entry("short", strategy.short, stop=lower2, comment="Short")
if (strategy.position_size > 0)
    strategy.exit("long", "long stop loss", stop=stop_loss)
    strategy.exit("long", "long take profit", limit=take_profit)
if (strategy.position_size < 0)
    strategy.exit("short", "short stop loss", stop=stop_loss)
    strategy.exit("short", "short take profit", limit=take_profit)
