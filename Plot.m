function [] = Plot(R1,R2,R3,R4)
%--------------------------------------------------
%                     PLOT
%--------------------------------------------------
Rd_1 = R1;
Rd_2 = R2;
Rd_3 = R3;
Rd_4 = R4;
%R = 0:4;
figure
plot(R,Rd_1, R,Rd_2, R,Rd_3, R,Rd_4)
title('SIMULATION OF RLNC')
xlabel('Number of Redudancy')
ylabel('Decoding Failure')
end