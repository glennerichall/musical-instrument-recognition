% Specify the taxonomyy used
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0


if(~exist('mapmany','var'))
	makeinstruments;
end

taxonomy  = {'family',...
    'strings', mapmany({'AG','EG','EB','BJ','UK','MD','VC','VN','VL'}),...
    'flute/piccolo', mapmany({'PC','FL','PN','RC'}), ...
    'reeds', mapmany({'CL','OR','OB','FG','AC','HM'}), ...
    'brass', mapmany({'TR','CR','TB','TU','HR','EH','BA','TS','AS','SS'})};

taxonomy = NamedTree(taxonomy{:});

clear instruments keys map mapmany unusedkeys usedkeys;