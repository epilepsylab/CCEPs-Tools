function [medianLaplace medianRef medianBipolar ]=findPeaks(elec,fileName,timeWindow,wantPlot,ccep)
if~exist('elec')
    elec=3;%ccep#
end
if ~exist('fileName')
    fileName='Pt1_ccep';
end 
if~exist('timeWindow')
    %timeWindow=[0 0.05];
    timeWindow=[0 0.1];
end
if~exist('wantPlot')
    wantPlot=1;
end
if~exist('ccep')
    load(fileName,'ccep')
end

load(fileName,'chanLabel')
chanInfo=findChan(chanLabel);

hz=size(ccep(1).mean,2)-1;
t=[-0.5:1/hz:.5];

minTime=0.01;

%find noisy channels
load(fileName,'indNoise')

%%
indChan=find(chanInfo(:,1)==elec);
isBad=ismember(indChan,indNoise);

for i=1:length(ccep)
    elecStim=chanInfo(ccep(i).stimChan(1));
    %disp([i elecStim elec])
    if ~isempty(ccep(i).mean) & elecStim~=elec
        indSmall=find(t>max(timeWindow(1),minTime) & t<timeWindow(2));
        
        ref=ccep(i).mean(indChan,:);
        
        rmseRef(:,i)=sqrt(mean(ref(:,indSmall).^2,2));
        
        [laplace bipolar]=calcLaplace(ref,isBad);
        
        rmseLaplace(:,i)=sqrt(mean(laplace(:,indSmall).^2,2));
        rmseBipolar(:,i)=sqrt(mean(bipolar(:,indSmall).^2,2));
    else
        rmseRef(:,i)=nan;
        rmseLaplace(:,i)=nan;
        rmseBipolar(:,i)=nan;
    end
end

rmseRef(isBad,:)=nan;
rmseLaplace(isBad,:)=nan;
rmseBipolar(isBad,:)=nan;


indNotZero=find(rmseRef(2,:)>0);

medianRef=median(rmseRef(:,indNotZero),2)';
medianLaplace=median(rmseLaplace(:,indNotZero),2)';
medianBipolar=median(rmseBipolar(:,indNotZero),2)';

%maxEarly=max(rmseEarly(:,indNotZero),[],2);
%maxLate=max(rmseLate(:,indNotZero),[],2);

if(wantPlot)
    figure
    subplot(411)
    imagesc(rmseRef')
    ylabel('Ref')
    title([strtok(fileName,'_') ' - Elec #' num2str(elec)])
    
    subplot(412)
    imagesc(rmseBipolar')
     ylabel('Bipolar')
     
    subplot(413)
    imagesc(rmseLaplace')
     ylabel('Laplacian')
    
    %figure
    subplot(414)
    plot(medianRef,'.-')
    hold on
    %plot(medianBipolar,'g')
    x=[1:length(medianBipolar)-1]+.5;
    plot(x,medianBipolar(1:end-1),'g.-')
    plot(medianLaplace,'r.-')
    legend('Reference','Bipolar','Laplacian')
    xlabel('Contact')
    ylabel('Median RMSE')
    xlim([.5 length(indChan)+.5])

    set(gcf,'Color','w')
%     p=get(gcf,'Position');
%     p(3:4)=p(3:4)*.7;
%     set(gcf,'Position',p)
    
end
