function logLike = getLogLikelihood(inPatch,EP,EPVar);

%extract size of in patch
[P_Y P_X] = size(inPatch);
[E_Y E_X E_Z] = size(EP);
%define size of output patch
logLike = zeros(E_Y-P_Y+1,E_X-P_X+1,E_Z);


%flip incoming patch (used for
inPatchFlip = flipud(fliplr(inPatch));

%loop through layers
for (cZ = 1:E_Z)    
    thisEPVar = EPVar(:,:,cZ);
    thisEP = EP(:,:,cZ);
    
    %add constant term (ignore 2pi dependence as will normalize)
    logLike(:,:,cZ) = -0.5*conv2(ones(1,P_Y),ones(1,P_X),log(thisEPVar),'valid');
    %add xi squared term
    logLike(:,:,cZ) = logLike(:,:,cZ)-0.5*conv2(1./thisEPVar,inPatchFlip.^2,'valid');
    %add xi mu term
    logLike(:,:,cZ) = logLike(:,:,cZ)+conv2(thisEP./thisEPVar,inPatchFlip,'valid');
    %add mu sq term
    logLike(:,:,cZ) = logLike(:,:,cZ)-0.5*conv2(ones(1,P_Y),ones(1,P_X),thisEP.*thisEP./thisEPVar,'valid');    
end

