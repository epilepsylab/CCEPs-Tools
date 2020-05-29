function viewContact(num,elecNum,fileName)
if~exist('num')
    num=15;%ccep#
end
if ~exist('elecNum')
    elecNum=3;
end
if ~exist('fileName')
    fileName='Pt1_ccep';
end 

global GLOBAL_F
GLOBAL_F=fileName;

load(GLOBAL_F,'chanInfo')

load(GLOBAL_F,'ccep','chanInfo')
global GLOBAL_DATA
GLOBAL_DATA=ccep;

figure
%peakTimes=plotIndex(indexNum,[],GLOBAL_DATA,GLOBAL_F);
plotMontage(num,elecNum,GLOBAL_F,GLOBAL_DATA)

set(gcf,'UserData',[num elecNum])

set(gcf,'KeyPressFcn','changeMontage')