test_taxonomy;

bm = Benchmark();
bm.taxonomy=tax;

obs = Observation(10);
obs.name = 'Test';
obs.extractionfunction = @(x) 1:10;
obs.varnames = 'observation';

bm.extractionfunction = @obs.extract;

bmgui = BenchmarkGUI(bm);
bmgui.display;