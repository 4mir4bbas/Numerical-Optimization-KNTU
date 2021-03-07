
% Test for GSS and Fibonacci search algorithms implemented in Adhoc.m
% Coded by: Amir Abbas Bakhshipour
% Note:
%       Put your arbitrary test record in 'testCases' matrix to run algorithms on 
%       
%       'testCases' matrix format: 
%                          
%             [ 1, function #1, start point, end point, method, precision;
%               2, funciton #2, start point, end point, method, precision;
%                  .
%                  .
%                  .
%               n, function #n, start point, end point, method, precision]
%
%       Each line of the 'testCases' matrix is a test record
%
%       Select one of the {'gss', 'fibonacci', 'gss-fibonacci'} as method
%       argument. Otherwise you'll get an error.
%       
%       Note that the GSS algorithm that is used here is the iterative ...
%       version of GSS algorithm, because of it's efficiency (It ...
%       performs just one function evaluation in each iteration except ...
%       the first iteration)
%       
%       
%

clear all; clc;
syms x;
testCases = [ 1 , x^4 - 14*x^3 + 60*x^2 - 70*x , 0  , 2 , 'fibonacci-gss' , 0.3  ;  % Ex 7.2 Chong book page 98
              2 , 0.5*x^2 - sin(x)             , 0  , 2 , 'gss-fibonacci' , 1e-5 ;  % Ex 7.3 Chong book page 103        
              3 , (x-3)^2                      , 0  , 5 , 'fibonacci'     , 1e-3 ;  % Simple quadratic function
              4 , (x+1)^2                      , -3 , 1 , 'gss'           , 1e-3 ;  % Simple quadratic function
              5 , x                            , 2  , 4 , 'asd'           , 1   ];  % Error case
ctr = 1;
while ctr <= size(testCases, 1)
    func = testCases(ctr,2);
    period = [double(testCases(ctr, 3)), double(testCases(ctr, 4))];
    method = char(testCases(ctr, 5));
    precision = double(testCases(ctr, 6));
    if strcmp(method, 'gss')
        method = char('GSS');
        searchObject = Adhoc(func, period);
        [gssSt, gssEnd, gssFuncValue, gssIter] = searchObject.iterativeGss(precision);
        fprintf('\nTest case #%i\tMethod: %s\n', ctr, method);
        fprintf('\n\tNumber of Iterations: %d\n\tFinal Period: [%.4f, %.4f]\n\tFunction Value: %.4f\n\n', gssIter, gssSt, gssEnd, gssFuncValue);
    elseif strcmp(method, 'fibonacci')  
        method = char('Fibonacci');
        searchObject = Adhoc(func, period);
        [fibSt, fibEnd, fibFuncValue, fibIter] = searchObject.fibonacci(precision);
        fprintf('\nTest case #%i\tMethod: %s\n', ctr, method);
        fprintf('\n\tNumber of iterations: %d\n\tFinal Period: [%.4f, %.4f]\n\tFunction Value: %.4f\n\n', fibIter, fibSt, fibEnd, fibFuncValue);
    elseif strcmp(method, 'gss - fibonacci') || strcmp(method, 'fibonacci - gss')     
        method = char('GSS');
        searchObject1 = Adhoc(func, period);
        [gssSt, gssEnd, gssFuncValue, gssIter] = searchObject1.iterativeGss(precision);
        fprintf('\nTest case #%i\tMethod: %s\n', ctr, method);
        fprintf('\n\tNumber of iterations: %d\n\tFinal Period: [%.4f, %.4f]\n\tFunction Value: %.4f\n\n', gssIter, gssSt, gssEnd, gssFuncValue);
        
        method = char('Fibonacci');
        searchObject2 = Adhoc(func, period);
        [fibSt, fibEnd, fibFuncValue, fibIter] = searchObject2.fibonacci(precision);
        fprintf('\nTest case #%i\tMethod: %s\n', ctr, method);
        fprintf('\n\tNumber of iterations: %d\n\tFinal Period: [%.4f, %.4f]\n\tFunction Value: %.4f\n\n', fibIter, fibSt, fibEnd, fibFuncValue);  
    else
        fprintf('Error in test case #%d\n\tSearch method "%s" does not appear to be a valid search method\n\tChoose a valid search method\n',ctr, method);      
    end
    ctr = ctr + 1;
end
clear all;
