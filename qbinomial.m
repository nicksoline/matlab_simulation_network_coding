function value = qbinomial(m,n,q)
TS = 1;
MS = 1;
for j = m-n+1:m
    TS = TS * (q^j -1);
end
for j = 1:n
    MS = MS * (q^j -1);
end
value = TS/MS;
    