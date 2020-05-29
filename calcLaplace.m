function [laplace bipolar]=calcLaplace(data,isBad)
if~exist('data')
    num=15;
    elecNum=3;
    fileName='Pt1_ccep';
    load(fileName,'ccep','chanInfo')
    indChan=find(chanInfo(:,1)==elecNum);
    data=ccep(num).mean(indChan,:);
end
if~exist('isBad')
    isBad=zeros(size(data,1),1);
end

%%
bipolar=zeros(size(data))+nan;
laplace=zeros(size(data))+nan;
numChan=size(data,1);

for i=1:numChan-1
    if sum(isBad(i:i+1))==0
        bipolar(i,:)=data(i,:)-data(i+1,:);
    end
end

for i=2:numChan-1
    if sum(isBad(i-1:i+1))==0
        laplace(i,:)=data(i,:)-0.5*data(i-1,:)-0.5*data(i+1,:); 
    %allow skipping bad electrdes
    elseif(i>=3 & isBad(i-1) & sum(isBad([i-2 i i+1]))==0)
        laplace(i,:)=data(i,:)-0.33*data(i-2,:)-0.67*data(i+1,:); 
    elseif(i<=numChan-2 & isBad(i+1) & sum(isBad([i-1 i i+2]))==0)
        laplace(i,:)=data(i,:)-0.33*data(i+2,:)-0.67*data(i-1,:); 
    end
end