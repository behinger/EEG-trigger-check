function [  ] = be_figsSameAxes(a )
%BE_FIGSSAMEAXES Summary of this function goes here
%   Detailed explanation goes here
axes = findobj('Type','axes');
if nargin <1
a = axis;
end
axis(axes,a);

end