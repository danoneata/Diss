close all;

D = 2; N = 20;
Q = randn(D,N);
plot(Q(1,:),Q(2,:),'x'); hold on; axis equal;

idxs = ceil(rand(1,2)*N);
A = Q(:,idxs(1)); B = Q(:,idxs(2));
plot(Q(1,idxs),Q(2,idxs),'r-');
Q(:,idxs) = [];

BA = B-A;
PP = ones(D,N-2);
P = sum( bsxfun( @times, bsxfun(@minus, Q, A), BA ), 1 );
for i = 1:length(P),
  plot(Q(1,i),Q(2,i),'ro');
  PP(:,i) = A + P(i)*(BA)/(norm(BA)^2);
  P(i)
  plot(PP(1,i),PP(2,i),'g.');
  pause;
end
