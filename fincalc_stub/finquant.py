import pandas as pd
import numpy as np
import yfinance as yf
import matplotlib.pyplot as plt
from pandas.plotting import autocorrelation_plot
from statsmodels.tsa.arima_model import ARIMA
from pmdarima.arima import auto_arima

class fin_quant:

    def log_returns(self, t1, t2):
        ret = np.log(t2 / t1)
        return ret

    def pull_ticker_data(self,ticker_name):
        ticker_data = yf.Ticker(ticker_name)
        ticker_data = ticker_data.history(period='max')
        return ticker_data

    def prepare_for_timeseries(self,ticker_data):
        ticker_data['close_lag'] = ticker_data['Close'].shift(1)
        ticker_data['log_returns'] = self.log_returns(ticker_data['close_lag'],ticker_data['Close'])
        return ticker_data

    def plot_time_series_diagnostics(self,ticker_data_series):
        print(plt.plot(ticker_data_series))
        #plt.subplot(2, 2, 2)
        #print(autocorrelation_plot(ticker_data_series))


finquant = fin_quant()
print(finquant.log_returns(1, 6))
df = finquant.pull_ticker_data('MSFT')
dx = finquant.prepare_for_timeseries(df)
finquant.plot_time_series_diagnostics(dx['log_returns'])


auto_arima(dx['log_returns'])



data = df.history(period='max')
plt.plot(data['Close'])
autocorrelation_plot(data['Close'])
data['close_lag'] = data['Close'].shift(1)
derp = finquant.log_returns(data['Close'],data['close_lag'])
plt.plot(derp)
