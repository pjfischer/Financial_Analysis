install.packages("tidyverse","PerformanceAnalytics",
                 "quantmod","yfR")


library(tidyverse)
library(PerformanceAnalytics)
library(quantmod)
library(yfR)




holdings <- read_csv("holdings.csv", col_types = cols(Acquired = col_date(format = "%m/%d/%Y"), 
                                                      `Today's Change (%)` = col_double(), 
                                                      `Today's Change ($)` = col_double()))
View(holdings)

tickers <- holdings$Symbol %>% na.omit %>% unique()
length(tickers)

Portfolio <- yf_get(
  tickers,
  first_date = Sys.Date() - 30,
  last_date = Sys.Date(),
  thresh_bad_data = 0.75,
  bench_ticker = "^GSPC",
  type_return = "log",
  freq_data = "daily",
  how_to_aggregate = "last",
  do_complete_data = FALSE,
  do_cache = TRUE,
  cache_folder = yf_cachefolder_get(),
  do_parallel = FALSE,
  be_quiet = FALSE
)
head(Portfolio)
tail(Portfolio)

cum_log_ret<-Portfolio %>% 
  group_by(Portfolio$ticker) %>% 
  summarize(log_ret = sum(ret_closing_prices, na.rm=TRUE))
cum_log_ret$log_ret

cum_ret <- exp(cum_log_ret$log_ret)-1
cum_ret
