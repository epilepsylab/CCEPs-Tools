function [output peaks]=findPeaks(num,fileName,wantPlot,ccep)
if~exist('num')
    num=1;%ccep#
end
if ~exist('fileName')
    fileName='Pt1_ccep';
end 

if~exist('wantPlot')
    wantPlot=1;
end
if~exist('ccep')
    load(fileName,'ccep')
end

load(fileName,'chanLabel')
chanInfo=findChan(chanLabel);

hz=size(ccep(num).mean,2)-1;
t=[-0.5:1/hz:.5];


minTime=0.01;


numChan=length(chanInfo);
for i=1:numChan
    indSmall=find(t>minTime & t<.05);
    x=ccep(num).mean(i,:);
    rmse(i,1)=sqrt(mean(x(indSmall).^2));
    
    indSmall=find(t>.05 & t<.1);
    rmse(i,2)=sqrt(mean(x(indSmall).^2));
    
    indSmall=find(t>.1 & t<.2);
    rmse(i,3)=sqrt(mean(x(indSmall).^2));
  
end

rmse(:,4)=sum(rmse(:,1:2),2);
rmse(:,5)=sum(rmse(:,2:3),2);
rmse(:,6)=sum(rmse(:,1:3),2);

%peaks=[n1peak' p2peak'];
%peakTimes=[n1time' p2time'];
%peaks=[n1peak' p2peak' n2peak'];
%peakTimes=[n1time' p2time' n2time'];
peaks=rmse;


%zero out stimulation electrode
elecStim=chanInfo(ccep(num).stimChan(1:2));
indZero=find(chanInfo(:,1)==elecStim(1) | chanInfo(:,1)==elecStim(2));
peaks(indZero,:)=0;

%zero out noisy channels
load(fileName,'indNoise')

for i=1:length(indNoise)
        peaks(indNoise,:)=0;
end

[y ind]=sort(peaks(:,1),'descend');
output=chanInfo(ind(1:10),1:2);

if(wantPlot)
    figure
    stem(chanInfo(:,1),peaks(:,1),'.')
    ylabel('Reference')
end



    