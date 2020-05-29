%dataMontage.mat is created by "calcRmseContactsAll.m"
load dataMontage class classBipolar rmseRefAll rmseBipolarAll rmseLaplaceAll

%% ROC
indSmall=find(class==0 | class==1 &~isnan(rmseRefAll) &~isnan(rmseLaplaceAll));
classSmall=class(indSmall);
refSmall=rmseRefAll(indSmall);
laplaceSmall=rmseLaplaceAll(indSmall);

indSmall2=find(classBipolar==0 | classBipolar==1  &~isnan(rmseBipolarAll));
classBipolarSmall=classBipolar(indSmall2);
bipolarSmall=rmseBipolarAll(indSmall2);

figure
%[tp fp]=roc(classSmall,refSmall);
%[tp2 fp2]=roc(classSmall,laplaceSmall);
[fp tp t auc1]=perfcurve(classSmall,refSmall,1);
[fp2 tp2 t2 auc2]=perfcurve(classBipolarSmall,bipolarSmall,1);
[fp3 tp3 t3 auc3]=perfcurve(classSmall,laplaceSmall,1);

auc=[auc1 auc2 auc3]

%aucDiff=abs(auc3-auc1)
%aucDiff=abs(auc3-auc2)
aucDiff(1)=abs(auc2-auc1);
aucDiff(2)=abs(auc3-auc1);
aucDiff(3)=abs(auc3-auc2);
aucDiff




lw=2;
hold on
plot(fp,tp,'b:','LineWidth',lw)
plot(fp2,tp2,'g-.','LineWidth',lw)
plot(fp3,tp3,'r','LineWidth',lw)
plot([0 1],[0 1],'k')
f=20
xlabel('False Positive','Fontsize',f)
ylabel('True Positive','Fontsize',f)
leg=legend('Referential','Bipolar','Laplacian');
set(leg,'Location','SouthEast','Fontsize',f)
set(gca,'Fontsize',16)
set(gcf,'Color',[1 1 1])

%return
%%
%Bootstrap significance

wantCompute=0;
%wantCompute=1;

wantSave=1;
dataFile='dataAuc';

if(wantCompute)
    %numSim=10000
    numSim=100000
    %group=[classSmall classSmall];
    %data=[refSmall laplaceSmall];
    
    group=[classSmall classBipolarSmall];
    data=[refSmall bipolarSmall];
    
    %group=[classSmall classBipolarSmall];
    %data=[laplaceSmall bipolarSmall];
    
    
    
    n1=length(classSmall);

    tic
    aucPerm=[];
    for i=1:numSim
        if(mod(i,100)==0)
            disp(i)
        end
        %permute data
        x=randperm(2*n1);
        ind1=x(1:n1);
        ind2=x(n1+1:end);
        
        
        temp1=group(ind1);
        temp2=group(ind2);
        perm1=data(ind1);
        perm2=data(ind2);
        
        [a b c aucPerm(i,1)]=perfcurve(temp1,perm1,0);
        [a b c aucPerm(i,2)]=perfcurve(temp2,perm2,0);
    end
    toc
    
    %save dataRocMedian aucPerm
    if(wantSave)
        save(dataFile,'aucPerm')
    end
else
    %load dataRocBootstrap
    load(dataFile,'aucPerm')
    numSim=size(aucPerm,1)
end

%%
numSim=size(aucPerm,1)
diffPerm=diff(aucPerm,1,2);
for i=1:3
    pVal(i)=sum(abs(diffPerm)>abs(aucDiff(i)))/numSim;
end
pVal

figure
[n,x]=hist(diffPerm,100);
for i=1:3
    subplot(3,1,i)
    bar(x,n,'FaceColor','g','EdgeColor','g')
    hold on 
    ind1=find(x>aucDiff(i));
    bar(x(ind1),n(ind1),'FaceColor','r','EdgeColor','r')
    ind2=find(x<-aucDiff(i));
    bar(x(ind2),n(ind2),'FaceColor','r','EdgeColor','r')
    switch i
        case 1
            title('Bipolar vs Ref AUC Diff')
        case 2
            title('Laplace vs Ref AUC Diff')
        case 3
            title('Laplace vs Bipolar AUC Diff')
    end
end



