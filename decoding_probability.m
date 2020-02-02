p = 0.1;
N = 5;
p_dec = [];
q = 2;
PNS = [];
q_initial = [2 4 16 32 256];
PNS_result = [];
p_dec_result = [];
p_fail = [];
p_fail_result = [];
for q = q_initial
    for K = 6:9 
    %for K = 5:25
       p_dec_temp = 0;
       p_fail_temp1 = 0;
       p_fail_temp2 = 0;
       for j = 0:N-1
           p_fail_temp1 = p_fail_temp1 + nchoosek(K,j)*p^(K-j)*((1-p)^j);
       end       
       for j=N:K
           p_dec_temp = p_dec_temp + nchoosek(K,j)*p^(K-j)*((1-p)^j)*(Pns(j,N,q));
           p_fail_temp2 = p_fail_temp2 + nchoosek(K,j)*p^(K-j)*((1-p)^j)*(1-Pns(j,N,q));
       end
       p_fail_temp = p_fail_temp1 + p_fail_temp2;
       p_dec = [p_dec p_dec_temp];
       p_fail = [p_fail p_fail_temp];
    end
    p_dec_result = [p_dec_result;p_dec];
    p_fail_result = [p_fail_result;p_fail];
    p_dec = [];
    p_fail = [];
    
    for K = 6:9
    % for K = 5:25
        PNS = [PNS Pns(K,N,q)];
    end
    PNS_result = [PNS_result;PNS];
    PNS = [];
end
simu256 = [0.686 0.337 0.154 0.0514 0.0225];
simu16  = [0.818 0.642 0.423 0.284 0.147];
simu256a = [0.667 0.352 0.154 0.0578 0.0209];
simu16a  = [0.835 0.629 0.348 0.218 0.128];
simu256b = [0.347 0.161 0.0681 0.0224];
simu16b  = [0.376 0.184 0.0809 0.0288];
simu2b   = [0.713 0.525 0.363 0.247];
theo256 = p_fail_result(5,:);
theo16  = p_fail_result(3,:);
theo2   = p_fail_result(1,:);
PRNC_q256_4bits = [0.623 0.303 0.199 0.0817];
PRNC_q256_8bits = [0.347 0.161 0.0625 0.0201];
K = 1:4;
% semilogy (K,simu256b,'--s',K,simu16b,'-o',K,simu2b,'-d',K,theo256,'--s',K,theo16,'-o',K,theo2,'-d');
% legend('Simulation, q = 256','Simulation, q = 16','Simulation, q = 2','Theoretical, q = 256','Theoretical, q = 16','Theoretical, q = 2')
% xlabel('Number of Redundancy')
% ylabel('Decoding failure')
% figure
semilogy (K,theo256,'--s',K,PRNC_q256_4bits,'-o',K,PRNC_q256_8bits,'-d');
legend('RLNC, q = 256','PRNC, q = 256, seed size = 4 bits','PRNC, q = 256, seed size = 8 bits')
xlabel('n-k')
ylabel('Decoding failure probability')
p_Raptor = [];
for R = 0:24
    p_Raptor_temp = 0.85 * 0.567^R;
    p_Raptor = [p_Raptor p_Raptor_temp];
end
R = 0:24;
p_RaptorQ = [];
for R = 0:24
    p_RaptorQ_temp = 1/255 * 255^(-R);
    p_RaptorQ = [p_RaptorQ p_RaptorQ_temp];
end
R = 0:24;
% semilogy(K,1-PNS_result(1,:),'--s',K,1-PNS_result(5,:),'--s',R,p_Raptor,'-o',R,p_RaptorQ,'-o')
% axis([0 24 10^-6 10^0])
% legend('RLNC, q =2','RLNC, q =256','Raptor','RaptorQ' )
% xlabel('n-k')
% ylabel('Decoding failure probability')
p_Raptor_rate = [];
for K = 6:9
    p_Raptor_rate_temp1 = 0;
    p_Raptor_rate_temp2 = 0;
    for j = 0:N-1
        p_Raptor_rate_temp1 = p_Raptor_rate_temp1 + nchoosek(K,j)*p^(K-j)*((1-p)^j);
    end
    for j = N:K
        p_Raptor_rate_temp2 = p_Raptor_rate_temp2 + nchoosek(K,j)*p^(K-j)*((1-p)^j)*0.85*0.567^(K-N);
    end
    p_Raptor_rate_temp = p_Raptor_rate_temp1 + p_Raptor_rate_temp2;
    p_Raptor_rate = [p_Raptor_rate p_Raptor_rate_temp];
end
p_RaptorQ_rate = [];
for K = 6:9
    p_RaptorQ_rate_temp1 = 0;
    p_RaptorQ_rate_temp2 = 0;
    for j = 0:N-1
        p_RaptorQ_rate_temp1 = p_RaptorQ_rate_temp1 + nchoosek(K,j)*p^(K-j)*((1-p)^j);
    end
    for j = N:K
        p_RaptorQ_rate_temp2 = p_RaptorQ_rate_temp2 + nchoosek(K,j)*p^(K-j)*((1-p)^j)*1/255 * 255^(N-K);
    end
    p_RaptorQ_rate_temp = p_RaptorQ_rate_temp1 + p_RaptorQ_rate_temp2;
    p_RaptorQ_rate = [p_RaptorQ_rate p_RaptorQ_rate_temp];
end
K = 1:4;
semilogy(K,theo2,'--s',K,theo256,'--s',K,p_Raptor_rate,'-o',K,p_RaptorQ_rate,'-o')
% axis([0 24 10^-6 10^0])
legend('RLNC, q =2','RLNC, q =256','Raptor','RaptorQ' )
xlabel('n-k')
ylabel('Decoding failure probability')
    

