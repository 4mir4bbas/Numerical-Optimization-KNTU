
% Test for GSS and Fibonacci search algorithms implemented in Adhoc.m
% Coded by: Amir Abbas Bakhshipour
% Example 7.2 Chong book page 98

clear all; clc;
syms x;
f = x^4 - 14*x^3 + 60*x^2 - 70*x;
gssAlgorithm = Adhoc(f,[0, 2]);
disp('gss:');
disp(gssAlgorithm.gss(0.3));
fibAlgorithm = Adhoc(f,[0,2]);
disp('fibonacci:');
disp(fibAlgorithm.fibonacci(0.3, 0.09));
