function [slope] = getSlope(sub_interval,p)
    slopeThis=(p*sub_interval'-sum(p)*(mean(sub_interval')) )/(p*p'-sum(p)*mean(p));    
    slope = atan(slopeThis)';
end
