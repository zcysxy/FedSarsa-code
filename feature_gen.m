function phi = feature_gen(S,d1,d2)
    phi = @phi_gen;
    function phi_sa = phi_gen(s,a)
        siz = [d1*d2, length(a)];
        phi_sa = zeros(siz);
        is = mod(s,d1);
        ia = floor(mod(a * S, d2) + 1)';
        phi_sa(sub2ind(siz, is * d2 + ia, 1:length(a))) = 1;
    end
end