% 		function varargout = subsref(o,s)
% 			
% 			if(length(o)>1)
% 				for i=1:length(o)
% 					varargout{i} = subsref(o(i),s);
% 				end	
% 				return;
% 			end
% 			
% 			switch s(1).type
% 			case '()'
% 				varargout{1} = o(s(1).subs{:});
% 			case '{}'
% 			case '.'
% 				varargout{1} = o.(s(1).subs);
% 			end
% 			
% 			if(length(s)>1)
% 				varargout = [varargout{:}];
% 				[out{1:length(varargout)}] = subsref(varargout,s(2:end));
% 				varargout = out;				
% 			end
% 		end