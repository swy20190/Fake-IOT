
y = [0 1 1 0 1 0 1];  %eg
FSK = 0;
t_begin=0;
t_end=1;
for i=1:length(y)
    t=t_begin:0.01:t_end;
    if(y(i)==1)
        FSK=[FSK,sin(40000*pi*t).*(t>=t_begin & t<t_end)]
    elseif (y(i)==0)
        FSK=[FSK,sin(20000*pi*t).*(t>=t_begin & t<t_end)]
    end
    t_begin=t_begin+1;
    t_end=t_end+1;
end
plot(FSK);
ylim([-1.5,1.5]);
title('2FSK信号')