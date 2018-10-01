#!/path/to/Rscript
#载入quantmod包以用于下载数据
library("quantmod")
#定义一个全局变量存储数据
stockData<- new.env()
#定义开始时间、截止时间
startDate = as.Date("2017-01-01")
endDate = as.Date("2017-12-31")
#选择需要查询的股票代号存入一个数组中
tickers <- c("AAPL")
#下载数据
getSymbols(tickers,env = stockData,src = "yahoo",from= startDate,to = endDate)
#options(max.print = 10000)
#print(stockData$AAPL)

#载入RODC包
library(RODBC)
#odbc建立连接
channel <-odbcConnect("stockdata",uid="sqlUser",pwd ="1234")
#查询数据库中已有表
sqlTables(channel)
#将数据存入一个数据框中
open <- stockData$AAPL[,1]
high <- stockData$AAPL[,2]
low <- stockData$AAPL[,3]
close <- stockData$AAPL[,4]
volume <- stockData$AAPL[,5]
adjusted <- stockData$AAPL[,6]
sheet<-data.frame(open,high,low,close,volume,adjusted)
#将该数据框sheet作为“stock_table”表存入数据库，将所有行名作为第一列保存
sqlSave(channel,sheet,tablename = "stock_table",rownames = TRUE)
