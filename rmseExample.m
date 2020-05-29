load Pt6_ccep
plotMontage(102,1,'Pt6_ccep',ccep) 

[output peaks]=calcRmse(102,'Pt6_ccep',1,ccep);
[output2 peaks2]=calcRmseLaplace(102,'Pt6_ccep',1,ccep);

rmse1=peaks(1:10,1)
rmse2=peaks2(1:10,1);

figure
plot(rmse1)
hold on
plot(rmse2,'r')

medianRef(1)=median(rmse1(2:5));
medianRef(2)=median(rmse1(6:8));

medianLaplace(1)=median(rmse2(2:5));
medianLaplace(2)=median(rmse2(6:8));

meanRef(1)=mean(rmse1(2:5));
meanRef(2)=mean(rmse1(6:8));

meanLaplace(1)=mean(rmse2(2:5));
meanLaplace(2)=mean(rmse2(6:8));

[p n]=compareGrayWhite(1,'Pt6_ccep',[2:5],[6:8])

