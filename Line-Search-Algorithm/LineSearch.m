classdef LineSearch
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods(Static)
        
        function y = rose()
            syms x1 x2;
            y = 100*(x2 - x1^2)^2 + (1-x1)^2;
        end
    end
    
    methods
        function obj = LineSearch()
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            
        end
        
        function y = rosenbrock(x)
            y = 100*(x(2) - x(1)^2)^2 + (1-x(1))^2;
        end
        
        function yPrime = rosenbrockGradient(x)
            yPrime = [-400*(x(2)-x(1)^2)*x(1)-2*(1-x(1));
                       200*(x(2)-x(1)^2)];
        end
        
        
        
        function minimizer = sd(obj)
            x0 = [1;
                  2];
            x = x0;
            syms x1 x2 a;
            while true
                dir = -subs(gradient(obj.rose()), [x1 x2], [x(1), x(2)]);
                func = subs(obj.rose(), [x1; x2], x+a.*dir);
                AdhocObj = Adhoc(func, [0 1]);
                [periodSt, periodNd, ~, ~] = AdhocObj.iterativeGss(0.1);
                alpha_k = (periodSt+periodNd)/2;
                tmp = x;
                x = x + alpha_k.*dir;
                if norm(x-tmp)<0.1
                    break;
                end
            end
            minimizer = x;
        end
        
    end
end

