clear; clc;
% syms x1 x2;
lsObj = LineSearch();
mini = lsObj.sd();
disp(mini);