clear all;

m = 15;
D = 2;   % in D dimensions, out of
N = 45; % a dataset of size N
global label;
label = 1;

alpha = 0.8;
% xx = [randn(D, ceil(N*alpha)),...
%       bsxfun(@plus, [4;4], 3*exp(randn(D, N-ceil(N*alpha))))];

xx = rand(D, N);

[yy, sort_idxs] = rpc(xx,1:N,m);
unsorted = 1:N;
new_idxs(sort_idxs) = unsorted;
yy = yy(new_idxs);
% xx = xx(:,sort_idxs);

style = ['.' 'o' 'x' '+' '*' 's' 'd' 'v' '^' '<' '>' 'p' 'h'];

figure; hold on;
for kk = 1:length(yy)
    color = rand(1,3);
    plot(xx(1,yy==kk), xx(2,yy==kk), style(ceil(rand*length(style))), 'Color', color);
end
axis equal
hold off;
    
% figure(ceil(rand*1000)), plot(xx(1,:),xx(2,:),'b*'), hold on; axis equal;
% plot(xx(1,ii),xx(2,ii),'r-');
% plot(pp(1,:),pp(2,:),'g.');
% 
% plot(xx(1,1:mm),xx(2,1:mm),'k^');
% plot(xx(1,mm+1:end),xx(2,mm+1:end),'c>');

% plot(xx(1,mm),xx(2,mm),'go');
% pp = bsxfun(@plus, A, BA*proj/(norm(BA)^2));