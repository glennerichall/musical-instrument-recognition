% Specify the taxonomyy used
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0


if(~exist('mapmany','var'))
	makeinstruments;
end

taxonomy  = {'martin',...
    'pizzicato', mapmany({'AG','EG','EB','BJ','UK','MD'}),...
	'sustained.strings', mapmany({'VC','VN','VL'}), ...
    'sustained.flute/piccolo', mapmany({'PC','FL','PN','RC'}), ...
    'sustained.reeds', mapmany({'CL','OR','OB','FG','AC','HM'}), ...
    'sustained.brass', mapmany({'TR','CR','TB','TU','HR','EH','BA','TS','AS','SS'})};

taxonomy = NamedTree(taxonomy{:});

clear instruments keys map mapmany unusedkeys usedkeys;