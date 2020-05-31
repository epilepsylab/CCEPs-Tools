%Comment this line out to run faster
calcRmseContactsAll

%dataMontage.mat is created by "calcRmseContactsAll.m"
load dataMontage class classBipolar rmseRefAll rmseBipolarAll rmseLaplaceAll
numNoise=sum(class>=0 & isnan(rmseRefAll))

%% Calculate mean amplitude
class3=[0 0.5 1];

%Ref
for i=1:3
    ind=find(class==class3(i) &~isnan(rmseRefAll));
    numRef(i)=length(ind);
    meanRef(i)=mean(rmseRefAll(ind));
    stdRef(i)=std(rmseRefAll(ind))/sqrt(numRef(i));
end

%Bipolar
for i=1:3
    ind=find(classBipolar==class3(i) &~isnan(rmseBipolarAll));
    numBipolar(i)=length(ind);
    meanBipolar(i)=mean(rmseBipolarAll(ind));
    stdBipolar(i)=std(rmseBipolarAll(ind))/sqrt(numBipolar(i));
end

%Laplacian
for i=1:3
    ind=find(class==class3(i) &~isnan(rmseLaplaceAll));
    numLaplace(i)=length(ind);
    meanLaplace(i)=mean(rmseLaplaceAll(ind));
    stdLaplace(i)=std(rmseLaplaceAll(ind))/sqrt(numLaplace(i));  
end



%%
close all

ind=find(~isnan(rmseRefAll) & class >=0);
[pRef,tbl,stats]=anova1(rmseRefAll(ind),class(ind));
close(gcf)
cRef=multcompare(stats);
title('Ref')

ind=find(~isnan(rmseBipolarAll) & classBipolar >=0);
[pBipolar,tbl,stats]=anova1(rmseBipolarAll(ind),classBipolar(ind));
close(gcf)
cBipolar=multcompare(stats);
title('Bipolar')

ind=find(~isnan(rmseLaplaceAll) & class >=0);
[pLaplace,tbl,stats]=anova1(rmseLaplaceAll(ind),class(ind));
close(gcf)
cLaplace=multcompare(stats);
title('Laplacian')

%% Table
disp('Table 1 - 3 means W, B, G')
disp(round(meanRef))
disp(round(meanBipolar))
disp(round(meanLaplace))
disp(' ')
disp('Table 1 -pVals - WB, WG, BG')

pairwiseRef=cRef(:,6)';
pairwiseBipolar=cBipolar(:,6)';
pairwiseLaplace=cLaplace(:,6)';

disp(pairwiseRef)
disp(pairwiseBipolar)
disp(pairwiseLaplace)



%% Plot mean, std by montage
f=20;
figure
subplot(311)
bar([0 0.5 1],meanRef,'FaceColor',[0 0.4 1])
%set(gca,'XTick',[0 0.5 1],'XTickLabel',[' White';'Border';' Gray '],'Fontsize',f)
set(gca,'XTick',[],'Fontsize',f)
ylabel('RMSD (uV)','Fontsize',f)
%title('Reference','Fontsize',f)

text(-.2,80,'Referential','Fontsize',f)
hold on
errorbar([0 0.5 1],meanRef,stdRef,-stdRef,'k.')
axis([-.25 1.25 0 100])




subplot(312)
bar([0 0.5 1],meanBipolar,'g')
%set(gca,'XTick',[0 0.5 1],'XTickLabel',[' White';'Border';' Gray '],'Fontsize',f)
set(gca,'XTick',[],'Fontsize',f)
ylabel('RMSD (uV)','Fontsize',f)
%title('Bipolar','Fontsize',f)
text(-.2,80,'Bipolar','Fontsize',f)

hold on
errorbar([0 0.5 1],meanBipolar,stdBipolar,-stdRef,'k.')
axis([-.25 1.25 0 100])

%stats
plot([0 0 0.45],[50 60 60],'k')
plot([1 1 0.55],[50 60 60],'k')

%make stats conditional
if(pairwiseBipolar(3)<.01)
    text(.72,25,'**','Fontsize',f)
elseif(pairwiseBipolar(3)<.05)
     text(.735,25,'*','Fontsize',f)
end
if(pairwiseBipolar(2)<.01)
    text(.47,55,'**','Fontsize',f)
elseif(pairwiseBipolar(2)<.05)
    text(.485,55,'*','Fontsize',f)
end

subplot(313)
bar([0 0.5 1],meanLaplace,'r')
hold on
errorbar([0 0.5 1],meanLaplace,stdLaplace,-stdLaplace,'k.')
set(gca,'XTick',[0 0.5 1],'XTickLabel',[' White';'Border';' Gray '],'Fontsize',f)
ylabel('RMSD (uV)','Fontsize',f)
%title('Laplacian','Fontsize',f)
text(-.2,80,'Laplacian','Fontsize',f)

%stats
plot([0 0 0.45],[50 60 60],'k')
plot([1 1 0.55],[50 60 60],'k')

%make stats conditional
if(pairwiseLaplace(3)<.01)
    text(.72,25,'**','Fontsize',f)
elseif(pairwiseLaplace(3)<.05)
     text(.735,25,'*','Fontsize',f)
end
if(pairwiseLaplace(2)<.01)
    text(.47,55,'**','Fontsize',f)
elseif(pairwiseLaplace(2)<.05)
    text(.485,55,'*','Fontsize',f)
end

axis([-.25 1.25 0 100])

set(gcf,'Color','w')