% Create feature extraction functions and binds them into an array of
% Observatinos
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0


%% utilities
colvec = @(x)x(:);
rowvec = @(x)x(:)';
hcat = @(x)[x{:}];
getdata = @(varargin)cellfun(@(y)colvec(mirgetdata(y)),varargin,'uniformoutput',false);


if(~exist('options','var'))
    makeconfiguration;
end

if(~exist('cache','var') && options.environment.cache.usecache)
    cache = Cache([options.environment.cache.basedir filesep options.extraction.cache],...
        'autocommit',options.extraction.autocommit);
end

%% MFCC
obsmfcc = Observation(13,cache);
obsmfcc.name = 'MFCC';
obsmfcc.extractionfun = funchain(@mirmfcc,@mirgetdata,1,@transpose);
obsmfcc.varnames = 'mfcc';
obsmfcc.stats = options.extraction.aggregetaion;
obsmfcc.parameters = {'Frame'};

%% LPC
obslpc = Observation(14,cache);
obslpc.name = 'LPC';
obslpc.extractionfun = funchain(@miraudio,@mirgetdata,1,{14},@lpc,1,@(x)x(:,2:end));
obslpc.varnames = 'lpc';
obslpc.stats = options.extraction.aggregetaion;
obslpc.parameters = {'Frame'};


%% Spectral
obsspec = Observation(4,cache);
obsspec.name = 'Spectral';
spectralfeatures = funvec(@mircentroid,@mirspread,...
    @mirskewness,@mirkurtosis);
obsspec.extractionfun = funchain({'Frame','max',4e3},@mirspectrum,spectralfeatures,getdata,hcat);
obsspec.varnames = {'centroid','spread','skewness','kurtosis'};
obsspec.stats = options.extraction.aggregetaion;
clear spectralfeatures;

%% Envelope
obsenv = Observation(7,cache);
obsenv.extractionfun = funvec(funchain(@specenveloppe,@temporal),funchain(@mirzerocross,@mirgetdata,1),'catresult');
obsenv.parameters = {};
obsenv.name = 'Envelope';
obsenv.stats = {};
obsenv.varnames = {'skewness','kurtosis','centroid','spread','slope','onset','zerocross'};

% Moving average of samples envelope
obsmaenv = Observation(6,cache);
obsmaenv.extractionfun = funchain(@maenveloppe,@temporal);
obsmaenv.parameters = {};
obsmaenv.name = 'Moving-average-envelope';
obsmaenv.varnames = {'skewness','kurtosis','centroid','spread','slope','onset'};

% IIR Low-pass filter envelope
obsfiltenv = Observation(6,cache);
obsfiltenv.extractionfun = funchain(@mirenvelope,1,@mirgetdata,@temporal);
obsfiltenv.parameters = {};
obsfiltenv.name = 'IIR-LP-filter-envelope';
obsfiltenv.varnames = {'skewness','kurtosis','centroid','spread','slope','onset'};

%% All features
observationvec = [obsspec, obsenv, obsmfcc, obslpc, obsmaenv, obsfiltenv];

if(~exist('map','var'))
	makeinstruments;
end
funkey = @(x) map(upper(x(end-8:end-7)));
[observationvec.namingconventionfun] = deal(funkey);

clear colvec rowvec hcat getdata obslpc obsspec obsenv obsmfcc cache funkey usedkeys unusedkeys keys instruments funkey map mapmany;
