%% Get the data
[bigT,smoothT] = BigDataSmoother('2014-8-01','00:00','2014-10-31','00:00',3,99.9);
%% Best R2 Aug 1st - Oct 31st 2014 with dependent Phyco
% 3rd Degree 3 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .9011 --> pH x Turbidity x Nitrate
% R2 .9041 --> Temp x Turbidity x Nitrate
% R2 .9275 --> Temp x DissOxygen x pH
% R2 .9304 --> Temp x DissOxygen x Nitrate
% R2 .9394 --> Temp x pH x Nitrate
% 2nd Degree 3 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .8248 --> Temp x Turbidity x Elevation
% R2 .8410 --> Temp x DissOxygen x pH
% R2 .8527 --> Temp x DissOxygen x Nitrate
% R2 .8628 --> Temp x pH x Nitrate
% R2 .8901 --> Temp x DissOxygen x Elevation
% 1st Degree 3 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .6545 --> Temp x Turbidity x Elevation
% 3rd Degree 2 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .7096 --> Temp x Elevation
% R2 .7327 --> Temp x Nitrate
% R2 .7344 --> pH x Nitrate
% R2 .7675 --> Temp x DissOxygen
% 2nd Degree 2 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .6054 --> Temp x Turbidity
% R2 .6100 --> Temp x Nitrate
% R2 .6811 --> Temp x Elevation
% R2 .7351 --> Temp x DissOxygen
% 1st Degree 2 var %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R2 .2458 --> Temp x Salinity
%% create models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyPxTxN33 = polyfitn([smoothT.pH,smoothT.turbidity,smoothT.nitrate],smoothT.Phyco,2);
polyTxTxN33 = polyfitn([smoothT.temp03at240,smoothT.turbidity,smoothT.nitrate],smoothT.Phyco,3);
polyTxDxP33 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen,smoothT.pH],smoothT.Phyco,3);
polyTxDxN33 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen,smoothT.nitrate],smoothT.Phyco,3);
polyTxPxN33 = polyfitn([smoothT.temp03at240,smoothT.pH,smoothT.nitrate],smoothT.Phyco,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyTxTxE23 = polyfitn([smoothT.temp03at240,smoothT.turbidity,smoothT.elev],smoothT.Phyco,2);
polyTxDxP23 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen,smoothT.pH],smoothT.Phyco,2);
polyTxDxN23 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen,smoothT.nitrate],smoothT.Phyco,2);
polyTxPxN23 = polyfitn([smoothT.temp03at240,smoothT.pH,smoothT.nitrate],smoothT.Phyco,2);
polyTxDxE23 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen,smoothT.elev],smoothT.Phyco,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyTxTxE13 = polyfitn([smoothT.temp03at240,smoothT.turbidity,smoothT.elev],smoothT.Phyco,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyTxE32 = polyfitn([smoothT.temp03at240,smoothT.elev],smoothT.Phyco,2);
polyTxN32 = polyfitn([smoothT.temp03at240,smoothT.nitrate],smoothT.Phyco,2);
polyPxE32 = polyfitn([smoothT.pH,smoothT.elev],smoothT.Phyco,2);
polyTxD32 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen],smoothT.Phyco,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyTxT22 = polyfitn([smoothT.temp03at240,smoothT.turbidity],smoothT.Phyco,2);
polyTxN22 = polyfitn([smoothT.temp03at240,smoothT.nitrate],smoothT.Phyco,2);
polyTxE22 = polyfitn([smoothT.temp03at240,smoothT.elev],smoothT.Phyco,2);
polyTxD22 = polyfitn([smoothT.temp03at240,smoothT.DissOxygen],smoothT.Phyco,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
polyTxS12 = polyfitn([smoothT.temp03at240,smoothT.salt03at240],smoothT.Phyco,2);
%% Surface Plots
% Temp vs DissOxygen
[Xtemp,Ydo] = meshgrid(14:1/4:19,4:0.1:6);
Zpoly22 = polyvaln(polyTxD22,[Xtemp(:),Ydo(:)]);
figure(1)
surf(Xtemp,Ydo,reshape(Zpoly22,size(Xtemp)))
xlabel('Temperature')
ylabel('Dissolved Oxygen')
zlabel('Phyco')
colorbar
hold on
scatter3(smoothT.temp03at240,smoothT.DissOxygen,smoothT.Phyco)
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temp vs Nitrate
[Xtemp,Ynitrate] = meshgrid(14:1/4:19,14:.5:24);
Zpoly22 = polyvaln(polyTxN22,[Xtemp(:),Ynitrate(:)]);
figure(2)
surf(Xtemp,Ynitrate,reshape(Zpoly22,size(Xtemp)))
xlabel('Temperature')
ylabel('Nitrate')
zlabel('Phyco')
colorbar
hold on
scatter3(smoothT.temp03at240,smoothT.nitrate,smoothT.Phyco)
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temp vs Turbidity
[Xtemp,Yturbidity] = meshgrid(14:1/4:19,1:3/20:4);
Zpoly22 = polyvaln(polyTxT22,[Xtemp(:),Yturbidity(:)]);
figure(3)
surf(Xtemp,Yturbidity,reshape(Zpoly22,size(Xtemp)))
xlabel('Temperature')
ylabel('Turbidity')
zlabel('Phyco')
colorbar
hold on
scatter3(smoothT.temp03at240,smoothT.turbidity,smoothT.Phyco)
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temp vs Salinity 1st degree polyfit
[Xtemp,Ysalt] = meshgrid(14:1/4:19,7:11/20:18);
Zpoly22 = polyvaln(polyTxS12,[Xtemp(:),Ysalt(:)]);
figure(3)
surf(Xtemp,Ysalt,reshape(Zpoly22,size(Xtemp)))
xlabel('Temperature')
ylabel('Salinity')
zlabel('Phyco')
colorbar
hold on
scatter3(smoothT.temp03at240,smoothT.salt03at240,smoothT.Phyco)
hold off
%% Sliceomatic??
%polyTxPxN23 = polyfitn([smoothT.temp03at240,smoothT.pH,smoothT.nitrate],smoothT.Phyco,2);
[Xtemp,YpH,Znitrate] = meshgrid(14:1/4:19,7:0.1:9,14:0.5:24);
ChopFun = polyvaln(polyTxPxN23,[Xtemp(:),YpH(:),Znitrate(:)]);
sliceomatic(reshape(ChopFun,size(Xtemp)))