function value = P_ns(K,N,q)
Pns0 = (q^(N^2))/((q^N-1)^K);
for j=1:N
    Pns0 = Pns0 * (1-1/q^j);
end

if K < N
    value = 0;
end
if K >= N
    b = 0;
    for n=1:K-N
        b = b + (-1)^n * nchoosek(K,n) * m_n_q_binomial(K-n,K-N-n,q);
    end    
    value = Pns0 * (m_n_q_binomial(K,K-N,q) + b);
end
