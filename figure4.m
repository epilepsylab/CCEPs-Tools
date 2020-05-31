%Run this code to determine 2x2 contigency table X
compareGrayWhiteAll

%Or just use this 2x2 table
%x=[9 13; 20 2];
[h pFisher]=fishertest(x)

frac=x(:,1)/sum(x(1,:));
perc=frac*100;
se=frac.*(1-frac)/sqrt(24)

f=20;
figure
hold on
bar([1 2],perc,'g')
axis([0 3 0 100])
errorbar([1 2],perc,-se*100,se*100,'k.')
text(1.4,100,'**','Fontsize',f+8)

ylabel('% Electrodes with Gray > White','FontSize',f)
set(gca,'XTick',[1 2],'XTickLabel',['Referential';' Laplacian '],'FontSize',f)
set(gcf,'Color',[1 1 1])

