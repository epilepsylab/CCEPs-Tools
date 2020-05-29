function [pBino numBetter refDiff laplaceDiff]=compareGrayWhite(elecNum,fileName,contactGray,contactWhite,wantPlot,useMedian)
if~exist('elecNum')
    elecNum=1;
end
if ~exist('fileName')
   fileName='Pt6_ccep';
end
if ~exist('contactGray')
    contactGray=[2:5];
end
if ~exist('contactWhite')
    contactWhite=[6:8];
end
if ~exist('wantPlot')
    wantPlot=1;
end
if ~exist('useMedian')
    useMedian=0;
end

load(fileName)

%%
indChan=find(chanInfo(:,1)==elecNum);
indGray=indChan(contactGray);
indWhite=indChan(contactWhite);

%4-7-20
%Change to 10 to 100 ms, which is column 4 of calcRmse

for i=1:length(ccep)
    if ~isempty(ccep(i).mean)
        [temp peaks]=calcRmse(i,fileName,0,ccep);
        if(useMedian)
            %refGray(i)=median(peaks(indGray,1));
            %refWhite(i)=median(peaks(indWhite,1));
            refGray(i)=median(peaks(indGray,4));
            refWhite(i)=median(peaks(indWhite,4));
        else
            %refGray(i)=mean(peaks(indGray,1));
            %refWhite(i)=mean(peaks(indWhite,1));
            refGray(i)=mean(peaks(indGray,4));
            refWhite(i)=mean(peaks(indWhite,4));
        end
        
        
        
        
        [temp peaks2]=calcRmseLaplace(i,fileName,0,ccep);
        if(useMedian)
            %laplaceGray(i)=median(peaks2(indGray,1));
            %laplaceWhite(i)=median(peaks2(indWhite,1));
            laplaceGray(i)=median(peaks2(indGray,4));
            laplaceWhite(i)=median(peaks2(indWhite,4));
            
        else
            %laplaceGray(i)=mean(peaks2(indGray,1));
            %laplaceWhite(i)=mean(peaks2(indWhite,1));
            laplaceGray(i)=mean(peaks2(indGray,4));
            laplaceWhite(i)=mean(peaks2(indWhite,4));
            
        end
    else
        refGray(i)=nan;
        refWhite(i)=nan;
        laplaceGray(i)=nan;
        laplaceWhite(i)=nan;
    end
    
end
pRank(1)=ranksum(refGray,refWhite);
pRank(2)=ranksum(laplaceGray,laplaceWhite);

numCcep=sum(~isnan(refGray) &refGray>0);
refBetter=sum(refGray>refWhite);
laplaceBetter=sum(laplaceGray>laplaceWhite);
numBetter=[refBetter laplaceBetter numCcep];



pBino(1)=1-binocdf(refBetter-1,numCcep,.5);
pBino(2)=1-binocdf(laplaceBetter-1,numCcep,.5);

refDiff=refGray'-refWhite';
laplaceDiff=laplaceGray'-laplaceWhite';



%%
if(wantPlot)
    disp('Gray:')
    disp(chanInfo(indGray,1:2))
    disp(' ')
    disp('White:')
    disp(chanInfo(indWhite,1:2))
    
    figure
    subplot(1,2,1)
    
    indRef=find(refDiff>0);
    
    
    %stem()
    bar(refDiff,'b')
    hold on
    bar(indRef,refDiff(indRef),'g')
    
    xlim([-1 length(ccep)+2])
    %axis([1 length(ccep) -300 500])
    title('Ref')
    
    
    subplot(1,2,2)
    
    indLaplace=find(laplaceDiff>0);
    %stem(laplaceDiff)
    bar(laplaceDiff)
    hold on
    bar(indLaplace,laplaceDiff(indLaplace),'g')
    title('Laplace')
     xlim([-1 length(ccep)+2])
    %axis([1 length(ccep) -30 50])
end
