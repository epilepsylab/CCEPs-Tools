
useMedian=0;

if(useMedian)
    disp('Using MEDIAN Cceps amplitude')
else
    disp('Using MEAN Cceps amplitude')
end
tic
p=[];
for i=1:8
    fileName=['Pt' num2str(i) '_ccep'];
    load(fileName)
    for j=1:length(elecAnalyzed)
        elecNum=elecAnalyzed(j);
        numContacts=size(isGray,2);
        disp(['Pt' num2str(i) ' - ' num2str(elecNum) ', ' num2str(numContacts) ' contacts'] )
        
        indGray=find(isGray(j,:)==1);
        indWhite=find(isGray(j,:)==0);
        
        %remove contact 1 (no Laplacian)
        indGray=indGray(indGray>1);
        indWhite=indWhite(indWhite>1);
        
        %remove last contact - contact 10 for AdTech, 15 for Dixi
        indGray=indGray(indGray<numContacts);
        indWhite=indWhite(indWhite<numContacts);
        
        disp(indGray)
        disp(indWhite)
        p=[p; compareGrayWhite(elecNum,fileName,indGray,indWhite,0,useMedian)];
    end
end
toc


%%
ind=find(~isnan(p(:,1)));

pRank=ranksum(p(ind,1),p(ind,2))
[h pKS]=kstest2(p(ind,1),p(ind,2))

x(:,1)=sum(p<.05);
x(:,2)=sum(p>=.05);
x
[h pFisher]=fishertest(x)