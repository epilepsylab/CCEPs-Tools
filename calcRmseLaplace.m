function [output peaks]=findPeaks(num,fileName,wantPlot,ccep)
if~exist('num')
    num=1;%ccep#
end
if ~exist('fileName')
    fileName='Pt1_ccep';
end 

if~exist('wantPlot')
    wantPlot=0;
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


eegRef=ccep(num).mean;

elecUnique=unique(chanInfo(:,1));

%for i=1:elecUnique

%%
indSmall=find(t>minTime & t<.05);
ref=ccep(num).mean;
laplace=zeros(size(ref))+nan;


%find noisy channels
load(fileName,'indNoise')



for i=1:length(elecUnique)
    indChan=find(chanInfo(:,1)==elecUnique(i));
    isBad=ismember(indChan,indNoise);
    refNow=ref(indChan,:);
    
    %Old
%     laplaceNow=zeros(length(indChan),length(t))+nan;
%     for j=2:length(indChan)-1
%         laplaceNow(j,:)=refNow(j,:)-0.5*refNow(j-1,:)-0.5*refNow(j+1,:);
%     end

    [laplaceNow bipolarNow]=calcLaplace(refNow,isBad);

    laplace(indChan,:)=laplaceNow;
end
%%

%change nan to zeros
indNan=find(isnan(laplace(:,1)));
laplace(indNan,:)=0;

%Reference montage
rmse(:,1)=sqrt(mean(ref(:,indSmall).^2,2));

indSmall=find(t>.05 & t<.1);
rmse(:,2)=sqrt(mean(ref(:,indSmall).^2,2));

indSmall=find(t>.1 & t<.2);
rmse(:,3)=sqrt(mean(ref(:,indSmall).^2,2));

rmse(:,4)=sum(rmse(:,1:2),2);
rmse(:,5)=sum(rmse(:,2:3),2);
rmse(:,6)=sum(rmse(:,1:3),2);

%Laplacian montage
rmseLaplace(:,1)=sqrt(mean(laplace(:,indSmall).^2,2));

indSmall=find(t>.05 & t<.1);
rmseLaplace(:,2)=sqrt(mean(laplace(:,indSmall).^2,2));

indSmall=find(t>.1 & t<.2);
rmseLaplace(:,3)=sqrt(mean(laplace(:,indSmall).^2,2));

rmseLaplace(:,4)=sum(rmseLaplace(:,1:2),2);
rmseLaplace(:,5)=sum(rmseLaplace(:,2:3),2);
rmseLaplace(:,6)=sum(rmseLaplace(:,1:3),2);






%%
peaks=rmseLaplace;

%10-30-19
%peaks=rmse.*rmseLaplace;


%zero out stimulation electrode
elecStim=chanInfo(ccep(num).stimChan(1:2));
indZero=find(chanInfo(:,1)==elecStim(1) | chanInfo(:,1)==elecStim(2));
peaks(indZero,:)=0;

%zero out noisy channels
load(fileName,'indNoise')

for i=1:length(indNoise)
        peaks(indNoise,:)=0;
end

temp=peaks(:,1);
temp(isnan(temp))=0;
[y ind]=sort(temp,'descend');
output=chanInfo(ind(1:10),1:2);

if(wantPlot)
    figure
    stem(chanInfo(:,1),peaks(:,1),'.')
    ylabel('Laplacian')
end



    