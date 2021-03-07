classdef Adhoc
    % Object oriented implementation of ad-hoc optimization algorithms
    % (GSS and Fibonacci) 
    
    properties
        Function  % Objective funciton (single variable & unimodal)
        Period  % The period in which we want to find the minimum
        rhoGss = 0.382;  % Fixed rho for GSS algorithm
        rhoFibonacci = [];  % Variable rho for Fibonacci algorithm
        fib = [];  % Fibonacci sequence
        epsilon = 0.05;  % Epsilon in Fibonacci algorithm
        gssIter = -1;  % Number of iterations of GSS algorithm 
    end
    
    methods
        
        function obj = Adhoc(Function, Period)
            
            % Constructor for creating an Adhoc object.
            % It accepts the symbolic Function and the Period as input.
            %
            % Example: 
            %           syms x;
            %           f=x^2;
            %           p=[-1,1];
            %           object = Adhoc(f,p);
            
            obj.Function = Function;
            obj.Period = Period;
            % Generating Fibonacci sequence up to 100 instances
            obj.fib(1) = 1;
            obj.fib(2) = 2;
            for i=3:100
                obj.fib(i) = obj.fib(i - 1) + obj.fib(i - 2);
            end
            
        end
        
        
        function [periodStart, periodEnd, functionValue, gssIt] = recursiveGss(obj, precision)    
        
            % Recursive implementation of GSS algorithm
            % It performs GSS algorithm on an Adhoc object
            % It accepts percision as input
            % It returns the start and end of the final period and ...
            % value of the function in average point of the last period ...
            % and the number of iterations for convergence respectively
            %
            % Example:
            %           syms x;
            %           f=x^2;
            %           p=[-1,1];
            %           object = Adhoc(f,p);
            %           [s,e,f,i] = object.recursiveGss(0.1);
            
            obj.gssIter = obj.gssIter + 1;
            length = obj.Period(2) - obj.Period(1);
            if length < precision
                periodStart = obj.Period(1);
                periodEnd = obj.Period(2);
                functionValue = double(subs(obj.Function, (periodStart+periodEnd)/2));
                gssIt = obj.gssIter;
            else
                left = obj.Period(1) + obj.rhoGss * length;
                right = obj.Period(2) - obj.rhoGss * length;
                left_value = double(subs(obj.Function, left));
                right_value = double(subs(obj.Function, right));     
                if left_value < right_value
                    obj.Period = [obj.Period(1), right];
                    [periodStart, periodEnd, functionValue, gssIt] = recursiveGss(obj, precision);
                else
                    obj.Period = [left, obj.Period(2)];
                    [periodStart, periodEnd, functionValue, gssIt] = recursiveGss(obj, precision);
                end 
            end
        end
        
        
        function [periodStart, periodEnd, functionValue, gssIt] = iterativeGss(obj, precision)
           
            % Iterative implementation of GSS algorithm
            % It performs GSS algorithm on an Adhoc object
            % It accepts percision as input
            % It returns the start and end of the final period and ...
            % value of the function in average point of the last period ...
            % and the number of iterations for convergence respectively
            %
            % Example:
            %           syms x;
            %           f=x^2;
            %           p=[-1,1];
            %           object = Adhoc(f,p);
            %           [s,e,f,i] = object.iterativeGss(0.1);
            
            whichSide = 2;
            ctr = 0;
            while true
                length = obj.Period(2) - obj.Period(1);
                if length < precision
                    break;
                end
                if whichSide == 2
                    left = obj.Period(1) + obj.rhoGss * length;
                    right = obj.Period(2) - obj.rhoGss * length;
                    leftValue = double(subs(obj.Function, left));
                    rightValue = double(subs(obj.Function, right));
                else
                    if ~whichSide
                        left = obj.Period(1) + obj.rhoGss * length;
                        leftValue = double(subs(obj.Function, left));
                    else
                        right = obj.Period(2) - obj.rhoGss * length;
                        rightValue = double(subs(obj.Function, right));
                    end

                end
                if leftValue < rightValue
                    obj.Period = [obj.Period(1), right];
                    whichSide = false;
                    right = left;
                    rightValue = leftValue;
                else
                    obj.Period = [left, obj.Period(2)];
                    whichSide = true;
                    left = right;
                    leftValue = rightValue;
                end
                ctr = ctr + 1;
            end
            periodStart = obj.Period(1);
            periodEnd = obj.Period(2);
            functionValue = double(subs(obj.Function, (periodStart + periodEnd)/2));
            gssIt = ctr;
        end
        
        
        function [periodStart, periodEnd, functionValue, fibIter] = fibonacci(obj, precision)
            
            % Fibonacci algorithm
            % It performs Fibonacci algorithm on an Adhoc object.
            % It accepts percision as input.
            % It returns the start and end of the final period and ...
            % value of the function in average point of the last period ...
            % and the number of iterations for convergence respectively
            % Note that the fixed epsilon is equal to 0.05 in properties
            %
            % Example:
            %           syms x;
            %           f=x^2;
            %           p=[-1,1];
            %           object = Adhoc(f,p);
            %           [s,e,f,i] = object.fibonacci(0.3);
            
            length = obj.Period(2) - obj.Period(1);
            
            % finding N
            for i=1:100
                if length*(1+2*obj.epsilon)/obj.fib(i+1) < precision
                    N = i;
                    break;
                end
            end
            
            % Calculating rhos for each iteration
            for i=1:N
                if i~=N
                    obj.rhoFibonacci = [obj.rhoFibonacci 1-(obj.fib(N-i+1)/obj.fib(N-i+2))];
                else
                    obj.rhoFibonacci = [obj.rhoFibonacci 0.5 - obj.epsilon];
                end
            end
            
            % Main Fibonacci algorithm
            for i=1:N
                length = obj.Period(2) - obj.Period(1);
                if length < precision
                    break;
                end
                
                left = obj.Period(1) + obj.rhoFibonacci(i) * length;
                right = obj.Period(2) - obj.rhoFibonacci(i) * length;
                right_value = double(subs(obj.Function, right));
                left_value = double(subs(obj.Function, left));
                
                if left_value < right_value
                    obj.Period = [obj.Period(1), right];
                else
                    obj.Period = [left, obj.Period(2)];
                end        
            end
            
            % Results
            periodStart = obj.Period(1);
            periodEnd = obj.Period(2);
            functionValue = double(subs(obj.Function, (periodStart+periodEnd)/2));
            fibIter = N;
        end
    end
    
end
