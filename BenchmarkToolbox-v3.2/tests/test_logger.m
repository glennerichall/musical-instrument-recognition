clc
mirverbose(0);

log = GetDefaultLogger();
log.Detail = LoggerDetail.Error;

f = @(x) mirgetdata(mirpitch(x));

eval_func(f,{'C:\UQAC-DATA\data\splitted\RWC\\RWC_I_08\Bassoon (Fagotto)-303\303FGVIP\5-303FGVIP.WAV'},'log',log);


