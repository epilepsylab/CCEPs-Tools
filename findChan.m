function elecInfo=findChan(chanLabel)

numChan=length(chanLabel);
elecInfo=[];
elecNum=0;
for i=1:numChan
    name=chanLabel{i};
    temp=strfind(name,'Rd');
    if ~isempty(temp) && temp
        %numRight=numRight+1;
        elecNum=elecNum+1;
        elec=str2num(name(1:temp-1));
        contact=str2num(name(temp+2:end));
        %elecInfo(elecNum,:)=[elec contact i-1];
        elecInfo(elecNum,:)=[elec contact elecNum i];
    end
    
    temp=strfind(name,'Ld');
    if ~isempty(temp)
        %numLeft=numLeft+1;
        elecNum=elecNum+1;
        elec=str2num(name(1:temp-1));
        contact=str2num(name(temp+2:end));
        %elecInfo(elecNum,:)=[elec contact i-1];
        elecInfo(elecNum,:)=[elec contact elecNum i];
    end
end
%numElec=[size(elecLeft,1) size(elecRight,1)];
elecTotal=size(elecInfo,1);
    