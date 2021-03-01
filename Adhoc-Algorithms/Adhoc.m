classdef Adhoc
    % Object oriented implementation of ad-hoc optimization algorithms
    % (GSS and Fibonacci) 
    
    properties
        Function  % Objective funciton (single variable & unimodal)
        Period  % The period in which we want to find the minimum
        rho_gss = 0.382;  % Fixed rho for GSS algorithm
        rho_fibonacci = [];  % Variable rho for Fibonacci algorithm
        fib = [];  % Fibonacci Sequence
        
    end
    
    methods
        
        function obj = Adhoc(Function, Period)
            
            % Constructor for creating an Adhoc object.
            % It accepts the symbolic Function and the Period as input.
            %
            % Example: 
            %           syms x;
            %           f=x^2;
            %           period=[-1,1];
            %           object = Adhoc(f,period);
            
            obj.Function = Function;
            obj.Period = Period;
            obj.fib(1) = 1;
            obj.fib(2) = 2;
            for i=3:100
                obj.fib(i) = obj.fib(i - 1) + obj.fib(i - 2);
            end
            
        end
        
        
        function lastPeriod = gss(obj, precision)    
        
            % GSS algorithm.
            % This is a recursive implementation of GSS algorithm.
            % It performs GSS algorithm on an Adhoc object.
            % It accepts percision as input.
            %
            % Example:
            %           syms x;
            %           f=x^2;
            %           period=[-1,1];
            %           object = Adhoc(f,period);
            %           finalPeriod = object.gss(0.1);
        
            length = obj.Period(2) - obj.Period(1);
            if length < precision
                lastPeriod = obj.Period;
            else
                left = obj.Period(1) + obj.rho_gss * length;
                right = obj.Period(2) - obj.rho_gss * length;
                left_value = double(subs(obj.Function, left));
                right_value = double(subs(obj.Function, right));
                if left_value < right_value
                    obj.Period = [obj.Period(1), right];
                    lastPeriod = gss(obj, precision);
                else
                    obj.Period = [left, obj.Period(2)];
                    lastPeriod = gss(obj, precision);
                end 
            end
        end
        
        
        
        function lastPeriod = fibonacci(obj, precision, epsilon)
            
            % Fibonacci algorithm
            % It performs Fibonacci algorithm on an Adhoc object.
            % It accepts percision and epsilon as input.
            %
            % Example:
            %           syms x;
            %           f=x^2;
            %           period=[-1,1];
            %           object = Adhoc(f,period);
            %           finalPeriod = object.fibonacci(0.5, 0.1);
            
            length = obj.Period(2) - obj.Period(1);
            
            % finding N
            for i=1:100
                if length*(1+2*epsilon)/obj.fib(i+1) <= precision
                    N = i;
                    break;
                end
            end
            % Calculating rhos for each iteration
            for i=1:N
                if i~=N
                    obj.rho_fibonacci = [obj.rho_fibonacci 1-(obj.fib(N-i+1)/obj.fib(N-i+2))];
                else
                    obj.rho_fibonacci = [obj.rho_fibonacci 0.5 - epsilon];
                end
            end
            
            % Main Fibonacci algorithm
            for i=1:N
                length = obj.Period(2) - obj.Period(1);
                if length < precision
                    break;
                end
                left = obj.Period(1) + obj.rho_fibonacci(i) * length;
                right = obj.Period(2) - obj.rho_fibonacci(i) * length;
                left_value = double(subs(obj.Function, left));
                right_value = double(subs(obj.Function, right));
                if left_value < right_value
                    obj.Period = [obj.Period(1), right];
                else
                    obj.Period = [left, obj.Period(2)];
                end        
            end
            % Final Period
            lastPeriod = obj.Period;   
        end
    end
    
end

