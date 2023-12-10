function IndexOut = testPHA(Start, Final, Index, PARAM)
% This function implement phase analyzer

% select inputs based on index
Index = logical(Index);
ind = find(Index);

% compute slope2 and magnitude
xdiff = Start(Index,1) - Final(Index,1);
ydiff = Start(Index,2) - Final(Index,2);
ydiff2 = ydiff.* ydiff;
xdiff2 = xdiff.* xdiff;
dist2 = xdiff2 + ydiff2;
slope2 = ydiff2./dist2;    


% index of points that should be kept
subind = (slope2 < sind(PARAM.phaseLR)^2 & xdiff > 0) | ...
    (slope2 < sind(PARAM.phaseLR1)^2 & xdiff > 0 & dist2 < PARAM.distt^2);
 
  subind = subind & dist2>PARAM.nearFF;
% final index
IndexOut = Index;
IndexOut(ind(~subind)) = 0;
