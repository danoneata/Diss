function [f, df] = nca_obj(A),
    
    f  = 0;
    temp_df = 0;
    
    load_data;
    [D N] = size(X);
    A = reshape(A,D,[]);
    C = repmat(c,[D 1]);
    
    for i=1:N,
        % Eliminate current point:
        X2 = X; X2(:,i) = []; c2 = c; c2(i) = [];
        % Compute denominator:
        temp_k = exp(-sum(abs(repmat(A*X(:,i),[1 N-1])-A*X2).^2));
        sum_k = sum(temp_k);
        % Compute numerator:
        temp_p = temp_k(c2==c(i));
        sum_j = sum(temp_p);
        f = f + sum_j/sum_k;
    end
    
    if nargout > 1,
        for i = 1:N,
            X2 = X; X2(:,i) = []; c2 = c; c2(i) = [];
            % Compute denominator:
            temp_k = exp(-sum(abs(repmat(A*X(:,i),[1 N-1])-A*X2).^2));
            sum_k = sum(temp_k);
            % Compute numerator:
            temp_j = temp_k(c2==c(i));
            sum_j = sum(temp_j);

            p_i = sum_j/sum_k;
            x_ik = sum((repmat(X(:,i),[1 N-1])-X2).^2); 
            x_ij = x_ik(c2==c(i));
            temp_df = temp_df + p_i * sum((temp_k.*x_ik)/sum_k) - sum((temp_j.*x_ij)/sum_k);
        end
        df = 2*A*temp_df;
        df = df(:);
    end
    
end