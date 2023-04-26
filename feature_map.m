function [dict_S, dict_A, feat_S, feat_A] = feature_map(S,d1,d2)
    dict_S = [1:S; mod(1:S,d1)];
    dict_A = [1:S; mod(1:S,d2)];
    feat_S = unique(dict_S(2,:));
    feat_A = unique(dict_A(2,:));
end
