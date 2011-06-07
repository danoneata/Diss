% X = [0 -1 1 .75 0 4  0 -4 -4;
%      0  0 1  -2 3 0 -5  0 -2];
% rand('seed',1);
% randn('seed',1);
% X = [X; rand(1,9)];
% c = [1 1 1 1 2 2 2 2 2];

% X = [1 1 10 9;1 2 10 11]; c = [1 1 2 2];

% close all;
% figure,
% plot3(X(1,1:4),X(2,1:4),X(3,1:4),'ro');
% hold on;
% plot3(X(1,5:9),X(2,5:9),X(3,5:9),'b*');

global X c;

N = 100;
r = rand(1,N);
r1 = 2;
theta = 2*pi*r(1:50);

r2 = 4;
theta2 = 2*pi*r(51:100);

classes = [zeros(1,50) ones(1,50)];

X = [r1*cos(theta) r2*cos(theta2); r1*sin(theta) r2*sin(theta2)];
X = [X; randn(1,N)*.9; randn(1,N)*.4; randn(1,N)*1.3; ; randn(1,N)*.7];
D = size(X,1);
Classes = repmat(classes,D,1);
c = classes;

class0 = reshape(X(Classes==0),D,[]);
class1 = reshape(X(Classes==1),D,[]);

figure,plot3(class0(1,:),class0(2,:),class0(3,:),'ro',...
             class1(1,:),class1(2,:),class0(3,:),'b*');
         
         title('Original data','interpreter','latex')

%          print -depsc2 orig_data.eps