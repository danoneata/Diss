function localopt=bolddriver(init,EGfn, maxit, P1, P2, P3, P4, P5, P6, P7)
% function localopt=bolddriver(init,EGfn, maxit, P1, P2, P3, P4, P5, P6, P7)
% 
% Minimizes an Energy function also using Gradient function. EGfn should be a
% string containing a function that returns energy and gradient as two args.
% Start at X=init and use "bold driver" algorithm.
% 
% Usage is compatible with Carl's minimize (which you should go use instead):
% 	http://www.gatsby.ucl.ac.uk/~edward/code/minimize/
% or if you want a gradient only algorithm see Macopt:
% 	http://www.inference.phy.cam.ac.uk/mackay/c/macopt.html
% 
% Iain Murray 5th July 2004 after talking to Sam Roweis at ICML

maxit=abs(maxit); % compatibility with Carl's minimize

% There's a better way to do callbacks, but grab Carl's code for now:
argstr = [EGfn, '(Xprop'];
for i = 1:(nargin - 3)
  argstr = [argstr, ',P', int2str(i)];
end
argstr = [argstr, ')'];

epsilon=0.1;
X=init;Xprop=X;
[E,G]=eval(argstr);
it=0;

while (epsilon>0)&&(it<maxit)
	fprintf('Iteration/fn eval %6i;  Value %4.6e\r', it, E);
	it=it+1;
	Xprop=X-epsilon*G;
	[Eprop,Gprop]=eval(argstr);
	if Eprop<E
		X=Xprop;
		E=Eprop;
		G=Gprop;
		epsilon=epsilon*1.1;
	else
		epsilon=epsilon/2;
	end
end

fprintf('\n');
localopt=X;
