function [Xt] = transform(X, t)
%TRANSFORM Apply linear transformation to data.
%
%     transform(X, t)
%
% Inputs:
%      X DxN data.
%      t structure that contains a mean to substract and a projection
%        matrix.

% Dan Oneata, June 2011

    Xt = bsxfun(@minus, X, t.mean);
    Xt = t.A * Xt;

end