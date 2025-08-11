//@version=5
// Modified by: Ignacio Corball
// Bollinger Bands: Madrid : 14/SEP/2014 11:07 : 2.0
// This displays the traditional Bollinger Bands, the difference is 
// that the 1st and 2nd StdDev are outlined with two colors and two
// different levels, one for each Standard Deviation
strategy(shorttitle="MBB", title="Bollinger Bands", overlay=true, currency=currency.NONE, initial_capital=50, default_qty_type=strategy.percent_of_equity, default_qty_value=5)
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

fill(pBasis, pUpper2, color=color.blue, transp=80)
fill(pUpper1, pUpper2, color=color.blue, transp=80)
fill(pBasis, pLower2, color=color.orange, transp=80)
fill(pLower1, pLower2, color=color.orange, transp=80)

if (close > upper2)
    strategy.entry("long", strategy.long)
if (close < lower2)
    strategy.entry("short", strategy.short)
if (close <= upper2)
    strategy.close("long")
if (close >= lower2)
    strategy.close("short")
