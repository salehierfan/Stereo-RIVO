function IndexOut = removeSmallDIST(Start, Final, Index)
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
 subind = dist2>400;
% final index
IndexOut = Index;
IndexOut(ind(~subind)) = 0;


end