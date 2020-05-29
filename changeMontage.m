val=double(get(gcf,'CurrentCharacter'));
%disp(val)
data=get(gcf,'UserData');
global GLOBAL_F
global GLOBAL_DATA
indexNum=data(1);
elecNum=data(2);

%obj=datacursormode(gcf);

%left arrow
if(val==28 && indexNum~=1)
    indexNum=indexNum-1;
    
    plotMontage(indexNum,elecNum,GLOBAL_F,GLOBAL_DATA)
    set(gcf,'UserData',[indexNum elecNum])
end

%right arrow
if(val==29 & indexNum~=length(GLOBAL_DATA))
    indexNum=indexNum+1;
    
    plotMontage(indexNum,elecNum,GLOBAL_F,GLOBAL_DATA)
    set(gcf,'UserData',[indexNum elecNum])
end


