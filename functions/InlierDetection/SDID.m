function  [Index,InNUM,matches]=SDID(I1_l, I2_l, I1_r, I2_r,M1L_1R,PAR,x,Index)
% Get the parameters 
PARAM.phaseLR = PAR.phaseLR(1,x);
PARAM.phaseLR1 = PAR.phaseLR1(1,x);
PARAM.nearFF =PAR.nearF(1,x);  
% % 
%  PARAM.phaseLRC = PAR.phaseLRC(1,x);
%  PARAM.phaseLRC1 = PAR.phaseLRC1(1,x);
PARAM.distt = PAR.distt(1,x);
% PARAM.nearFEA = PAR.nearF(1,x);
if PAR.PHA
% Left to Right phase analysis
%    Index = PHA(M1L_1R(:,1:2),M1L_1R(:,3:4),Index, PARAM);
%  Index = newPHA(M1L_1R(:,1:2),M1L_1R(:,3:4),Index, PARAM);
   Index = testPHA(M1L_1R(:,1:2),M1L_1R(:,3:4),Index, PARAM);

end

% showMatchedFeaturesNew(I1_l, I1_r, M1L_1R(Index,1:2),M1L_1R(Index,3:4))

% first right to second right LKT
 block12= Block12(PAR,x);
[M1R_2R,Index] = tracking(M1L_1R(:,3:4),Index,I1_r,I2_r,block12,PAR.pyramid1to2(1,x));
% length(Index(Index>0))
% Spatial correlation (SCRR)
%  Index=SCRR(M1R_2R(:,1:2),M1R_2R(:,3:4),I1_r,PAR,x,Index,I2_r);

% showMatchedFeaturesNew(I1_r, I2_r, M1R_2R(Index,1:2),M1R_2R(Index,3:4))
% second right to second left LKT
 blockLR= BlockLR(PAR,x);
[M2R_2L, Index] = tracking(M1R_2R(:,3:4),Index,I2_r,I2_l, blockLR,PAR.pyramidLR(1,x));
% showMatchedFeaturesNew(I2_r, I2_l, M2R_2L(Index,1:2),M2R_2L(Index,3:4))

if PAR.PHA
% Right to Left phase analysis
%Index = newPHA(M2R_2L(:,3:4),M2R_2L(:,1:2),Index, PARAM);
%    Index = PHA(M1L_1R(:,1:2),M1L_1R(:,3:4),Index, PARAM);
    Index = testPHA(M2R_2L(:,3:4),M2R_2L(:,1:2),Index, PARAM);

end
% showMatchedFeaturesNew(I2_r, I2_l, M1L_1R(Index,1:2),M1L_1R(Index,3:4))
% second left to first left LKT
[M2L_1L,Index] = tracking(M2R_2L(:,3:4),Index,I2_l,I1_l,block12,PAR.pyramid1to2(1,x));

% Spatial correlation (SCRR)
%  Index=SCRR(M2L_1L(:,1:2),M2L_1L(:,3:4),I1_l,PAR,x,Index,I2_l);
% showMatchedFeaturesNew(I2_l, I1_l, M2L_1L(Index,1:2),M2L_1L(Index,3:4))

% Fine Decision
matches(:,1:4) = M1L_1R(Index==1,:);
matches(:,5:6) = M1R_2R(Index==1,3:4);
matches(:,7:8) = M2R_2L(Index==1,3:4);
matches(:,9:10) = M2L_1L(Index==1,3:4);
if PAR.soft
dist = distance(matches(:,9),matches(:,10),matches(:,1),matches(:,2));
y1= [matches(:,1:2) matches(:,3:4)];y2= [matches(:,3:4) matches(:,5:6)];
y3= [matches(:,5:6) matches(:,7:8)];y4 = [matches(:,7:8) matches(:,9:10)];
threshold = PAR.tresh(x)*(distance(y1(:,1),y1(:,2),y1(:,3),y1(:,4))+ ...
    distance(y2(:,1),y2(:,2),y2(:,3),y2(:,4))+ ...
    distance(y3(:,1),y3(:,2),y3(:,3),y3(:,4))+...
    distance(y4(:,1),y4(:,2),y4(:,3),y4(:,4)));
matches1 = matches(dist < threshold,:);
% showMatchedFeaturesNew(I2_l, I1_l, matches1(:,9:10),matches1(:,7:8))
InNUM = size(matches1,1);
% if InNUM>20
   matches = matches1;
% end
end

InNUM = size(matches,1);
end