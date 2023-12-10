
%% module 
PAR.PHA=1;
PAR.soft=1;
PAR.Bucketing=1;
PAR.KFD=1;

PAR.phaseLR1 = 15.9263;
PAR.phaseLR = 1.42105;
PAR.tresh=  1.636327;                                                                            
PAR.maxRepError=  8.2300;
PAR.distt = 7.4947;  
PAR.nearF = 31.47;

PAR.pixelsamRate= 62;
PAR.pyramidLR= 10;
PAR.pyramid1to2= 15;
PAR.horANDvertRatio= 4.7;
PAR.horANDvertRatio1to2= PAR.horANDvertRatio;
PAR.LKhorizon1to2 = 5;
PAR.LKhorizon=PAR.LKhorizon1to2;
%% KFD module  
PAR.GFsigma=  6.68;
PAR.FLtresh1= 10.12;
PAR.RacklessKFD= 10;

%% Bucketing
vo_params.bucketing.max_features =1;  
vo_params.bucketing.bucket_width =70;

%             % width of bucket
vo_params.bucketing.bucket_height = 47;
%          % height of bucket

vo_params.bucketing.age_threshold =13;
PAR.A=  40;
PAR.B=200;

PAR.C= 100; 
PAR.D= 0.5;  
PAR.E=0.2; 