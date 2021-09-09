function classifyResult = nn(features)

    %persistent histo;
   
    
    % usuwam wybrane kolumny - tu kolumne 22
    %features = [ features(1:21) features(23:end) ] ;

    % jesli wystepuja jakies NaNy to je zeruje
    features( isnan(features) ) = 0;

	load meanandst.mat;
	
	% normalizacja
	features = features - mi;
	features = features./st;

    
    

	load deepnet.mat;
	%net.inputs{1}.size

	% Test the sample
	output = deepnet(features')
	%view(net)

    %histo = [histo; output]
    %histogram(histo);

    	if output > 0.75
	    classifyResult = 1;
        else
	    classifyResult = -1;
        end
    
% 	if output > 0.55
% 	    classifyResult = 1;
%     elseif output<=0.55 && output>=0.5
%         classifyResult =0;
%     else
% 	    classifyResult = -1;
% 	end

end


