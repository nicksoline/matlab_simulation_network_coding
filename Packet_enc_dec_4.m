function [Packet_Block,Decoded_Packet,Packet_Error_4] = Packet_enc_dec_4(K, N, i4)
% Considering size of Native Packet blocks, K=5, L=6.
K = K; %no of packets per Block
C = N; %K + m
L = 6; %no of bytes, each byte with 8 bits.
PER = 0;
% Preallocating space.
Packet_Block = zeros(K,L);
Alpha = zeros(C,K); %Random Variable Matrix.
Packet = ones(L,8);
received_packet = zeros(C-1, L);
Random_Element_rec = zeros(C-1, K);
Received_Packet_N = zeros(C-2, L);
Random_Element_rec_N = zeros(C-2, K);
%Decoded_Packet = zeros(K,L);
global Packet_Error_4;
fprintf('\n')
fprintf('Block_seq_no:- %d',i4)
fprintf('\n')
%--------------------------------
%  Generating Data Packet Block
%--------------------------------
for y=1:1:K
    for i=1:1:8 % Size of byte, i.e i number of bits.
        for j=1:1:L
            % Creating a Random Variable.
            RN1 = randi([0.0,1.0],1,1);
            if RN1<0.9;
            Packet(j,i)=0;
            else Packet(j,i) = Packet(j,i);
            end
        end
    end
    %Packet;
    Decimal_Packet = bi2de(Packet);
    Packet_Block(y,:) = Decimal_Packet;
    % Reseting Packet
    Packet = ones(L,8);
    Decimal_Packet = bi2de(Packet);
end
Packet_Block = gf(Packet_Block, 8);
%-----------------------------------
% Generating Random Element Matrix.
%-----------------------------------
[Alpha] = Random_Coeff(C, K);
Random_Packet = Alpha;

% Generating Coded Packet by combining Source packet block and Random
% elements Matrix.
Coded_Packet = Random_Packet*Packet_Block;

% Coded Packets are Transmitted by Sender.
%---------------------------------------------------------------------
%---------------------ERASURE CHANNEL---------------------------------
%---------------------------------------------------------------------
% Coded_Packets are Received by the Receiver.

%--------------------------------
%  Creating ranndom losses.
%--------------------------------
% Considering Packet Erasure Rate(PER) as 0.2
    % Introduce Transmission Losses by flipping a random Element Block.
    %disp('Introduce Transmission Loss with Random Number RNN');
received_packet = [];
Received_Packet = gf(received_packet,8);
    
for iii1=1:1:C
    PER = randi(10,1,1);
    if PER < 2
        if iii1 >= C
        %-------SKIP------------------------------------    
        else
        Received_Packet(iii1,:) = Coded_Packet(iii1+1,:);
        Random_Element_rec(iii1,:) = Random_Packet(iii1+1,:);
        C = C-1;
        end
    else
        Received_Packet(iii1,:) = Coded_Packet(iii1,:);
        Random_Element_rec(iii1,:) = Random_Packet(iii1,:);
    end
    PER = 0;
end
%--------------------------------
%   Decoding the Packet Block
%--------------------------------
 try
    %for il = 1:1:C
        %Decoded_Packet(il,:) = gflineq(Received_Packet(il,:),Random_Element_rec(i1,:))
        Decoded_Packet =  Random_Element_rec \ Received_Packet ;
        Packet_Error_4 = isequal(Packet_Block, Decoded_Packet);
        Packet_Error_4 = ~Packet_Error_4;
    %end
    catch
        Decoded_Packet = 0;
        Packet_Error_4 = isequal(Packet_Block, Decoded_Packet);
        Packet_Error_4 = ~Packet_Error_4;
 end