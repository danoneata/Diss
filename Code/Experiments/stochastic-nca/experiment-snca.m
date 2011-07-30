close all;
d = 2;

% [X,c] = load_data_set('mnist-train-256');
% [Xt,ct] = load_data_set('mnist-test-256');

[X,c] = load_data_set('usps');
[X,c,Xt,ct]=split_data(X,c);

[mapping] = run_sNCA('nca_obj_simple', X, c, d, [1 30 0.05]);
AX = transform(double(X), mapping);
AXt = transform(double(Xt), mapping);

plot3_data(AX,c);
plot3_data(AXt,ct);

score_nn  = NN_score(AX,c,AXt,ct);
% score_nca = nca_cls('nca_obj_simple', AX, c, AXt, ct);