timeWindow=[0 0.1]

class=[];
classBipolar=[];
rmseRefAll=[];
rmseLaplaceAll=[];
rmseBipolarAll=[];
elecAll=[];
ptAll=[];

for i=1:8
    fileName=['Pt' num2str(i) '_ccep'];
    load(fileName)
    for j=1:length(elecAnalyzed)
        elecNum=elecAnalyzed(j);
        disp(['Pt #' num2str(i) ' - ' num2str(elecNum)] )
        
        %%Same code as identified version
        [rmseLaplace rmseRef rmseBipolar]=calcRmseMontageElec(elecNum,fileName,timeWindow,0,ccep);
    
        ind=1:min(length(isGray(j,:)),length(rmseRef));
        
        rmseLaplaceAll=[rmseLaplaceAll rmseLaplace(ind)];
        rmseRefAll=[rmseRefAll rmseRef(ind)];
        rmseBipolarAll=[rmseBipolarAll rmseBipolar(ind)];
        
        class=[class isGray(j,:)];
        
        temp=isGray(j,:);
        classMean=[mean([temp(1:end-1); temp(2:end)]) nan];
        %classMean=[temp(1:end-1) nan]; %class to the left this performs slightly worse
        
        classMean(classMean>.5)=1;
        classMean(classMean<.5 & classMean>=0)=0;
        classBipolar=[classBipolar classMean];
    end
end

save dataMontage class classBipolar rmseRefAll rmseBipolarAll rmseLaplaceAll
