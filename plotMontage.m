function plotArray(num,elecNum,fileName,ccep)

if~exist('num')
    num=15;%ccep#
end
if ~exist('elecNum')
    elecNum=3;
end
if ~exist('fileName')
    fileName='Pt1_ccep';
end 
if~exist('ccep')
    load(fileName,'ccep')
end
load(fileName,'chanInfo')

%%
indChan=find(chanInfo(:,1)==elecNum);
numChan=length(indChan);
contactNum=chanInfo(indChan,2);

if(isnan(ccep(num).time(1)))
    clf
    subplot(131)
    xlabel(['#' num2str(num) ' ' ccep(num).label])
    
    subplot(132)
    xlabel('Time (s)')
    
    subplot(133)
    xlabel(['Record Elec #' num2str(elecNum)])
    return
end
    
data=ccep(num).mean(indChan,:);



%find noisy channels
load(fileName,'indNoise')
isBad=ismember(indChan,indNoise);

%calculate Laplacian in centralized place
[laplace bipolar]=calcLaplace(data,isBad);

%%

hz=size(data,2)-1;
if(hz<2100)
    minTime=0.02; %1024
else
    minTime=0.01; %4096
    
end
%minTime=0
    
t=[-0.5:1/hz:.5];

indPlot=find(t>minTime & t<.5);

yRange=max(range(data(:,indPlot)'));
yRange=max(1000,yRange);



lw=2;
%figure
clf
subplot(1,3,1)
hold on
for i=1:size(data,1)
    if(~isBad(i))
        plot(t(indPlot),data(i,indPlot)-i*yRange,'LineWidth',lw)
    else
        plot(t(indPlot),data(i,indPlot)-i*yRange,'LineWidth',lw,'Color','k')
    end
    text(-0.05,-i*yRange,num2str(i))
end
axis([-.1 .55 -(numChan+1)*yRange 0])
plot(-[.075 .075],[-1000 -2000],'k','LineWidth',2)
title('Reference')
set(gca,'YTickLabel',[])
xlabel(['#' num2str(num) ' ' ccep(num).label])

subplot(1,3,2)
hold on
for i=1:size(data,1)-1
    %original   
    %plot(t(indPlot),data(i,indPlot)-data(i+1,indPlot)-(i+.5)*yRange,'LineWidth',lw)
    
    %function
    plot(t(indPlot),bipolar(i,indPlot)-(i+.5)*yRange,'LineWidth',lw)
    
    text(-0.13,-(i+.5)*yRange,[num2str(i) '-' num2str(i+1)])
end
%plot(-[.075 .075],[-1000 -2000],'k','LineWidth',2)
axis([-.145 .505 -(numChan+1)*yRange 0])
%plot(-[.09 .09],[-1500 -2000],'k','LineWidth',2)
set(gca,'YTickLabel',[])
title('Bipolar')
xlabel('Time (s)')



subplot(1,3,3)
hold on
for i=1:size(data,1)-1

    %original    
    %plot(t(indPlot),data(i,indPlot)-0.5*data(i-1,indPlot)-0.5*data(i+1,indPlot)-i*yRange,'LineWidth',lw) %Laplacian
      
    %I think this is the polarity of the 2nd derivative
    %plot(t(indPlot),data(i-1,indPlot)+data(i+1,indPlot)-2*data(i,indPlot)-i*yRange,'LineWidth',lw) %Laplacian
    
    %function
    if(i>1)
        plot(t(indPlot),laplace(i,indPlot)-i*yRange,'LineWidth',lw)
        text(-0.05,-i*yRange,num2str(i))
    else
        plot(-1,0,'.') %not visible, makes colors match up
    end
        
end
%plot(-[.075 .075],[-1000 -2000],'k','LineWidth',2)
axis([-.1 .55 -(numChan+1)*yRange 0])
%plot(-[.09 .09],[-1500 -2000],'k','LineWidth',2)
set(gca,'YTickLabel',[])
%title('Bipolar')
title('Laplacian')
xlabel(['Record Elec #' num2str(elecNum)])

set(gcf,'Color','w')
% p=get(gcf,'Position');
% p(3:4)=p(3:4)*.7;
% set(gcf,'Position',p)