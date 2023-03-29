function phi = feature_gen(S,d1,d2)
    phi = @phi_gen;
    function phi_sa = phi_gen(s,a)
        is = mod(s,d1);
        ia = int16(mod(a * S, d2) + 1);
        phi_sa = zeros(d1*d2,1);
        phi_sa(is * d2 + ia) = 1;
    end
end