function [Packet_Block,Decoded_Packet,Packet_Error_3] = Packet_enc_dec_3(K, N, i3)
% Considering size of Native Packet blocks, K=5, L=6.
K = K; %no of packets per Block
C = N; %K + m
L = 6; %no of bytes, each byte with 8 bits.
% Preallocating space.
Packet_Block = zeros(K,L);
Alpha = zeros(C,K); %Random Variable Matrix.
Packet = ones(L,8);
received_packet = zeros(C-1, L);
Random_Element_rec = zeros(C-1, K);
Received_Packet_N = zeros(C-2, L);
Random_Element_rec_N = zeros(C-2, K);
%Decoded_Packet = zeros(K,L);
global Packet_Error_3;
fprintf('\n')
fprintf('Block_seq_no:- %d',i3)
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
% Generating Random Element Matrix.
for ii = 1:1:C
    for jj = 1:1:K
        Alpha(ii, jj) = randi([1, 190]);
    end
end
Random_Packet = gf(Alpha, 8);
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
    RNN = randi(C,1,1);
    Received_Packet = gf(received_packet,8);
    Random_Element_rec = gf(Random_Element_rec, 8);
for iii1=1:1:RNN
    if iii1 == RNN
        if iii1 < C
            Received_Packet(iii1,:) = Coded_Packet(iii1+1,:);
            for iii1=RNN+1:1:C-1;
            Received_Packet(iii1,:) = Coded_Packet(iii1+1,:);
            end
        end
        elseif iii1 == C
            
    else 
                Received_Packet(iii1,:) = Coded_Packet(iii1,:);
    end
end
for iii1=1:1:RNN
    if iii1 == RNN
        if iii1 < C
            Random_Element_rec(iii1,:) = Random_Packet(iii1+1,:);
            for iii1=RNN+1:1:C-1;
            Random_Element_rec(iii1,:) = Random_Packet(iii1+1,:);
            end
        end
        elseif iii1 == C
            
    else 
                Random_Element_rec(iii1,:) = Random_Packet(iii1,:);
    end
end
%---------------------------------------------------------------------
PER = randi(10,1,1);
if PER < 2
    rnn = randi(C-1,1,1);
    Received_Packet_N = gf(Received_Packet_N, 8);
    Random_Element_rec_N = gf(Random_Element_rec_N, 8); 
    for iii2=1:1:rnn
        if iii2 == rnn
            if iii2 < C-1
                Received_Packet_N(iii2,:) = Received_Packet(iii2+1,:);
                for iii2=rnn+1:1:C-2;
                    Received_Packet_N(iii2,:) = Received_Packet(iii2+1,:);
                end
            end
        elseif iii2 == C-1
            
        else 
                Received_Packet_N(iii2,:) = Received_Packet(iii2,:);
        end
end
for iii2=1:1:rnn
    if iii2 == rnn
        if iii2 < C-1
            Random_Element_rec_N(iii2,:) = Random_Element_rec(iii2+1,:);
            for iii2=rnn+1:1:C-2;
                Random_Element_rec_N(iii2,:) = Random_Element_rec(iii2+1,:);
            end
        end
    elseif iii2 == C-1
        
    else 
                Random_Element_rec_N(iii2,:) = Random_Element_rec(iii2,:);
    end
end
    %--------------------------------
    %  Decoding the Packet Block.
    %--------------------------------
    %disp('The Coded Packet & Random Elements received at Receiver:');% Coded Block of Packet Received by Receiver.
    Received_Packet_N;
    Random_Element_rec_N;
    %Random_Element_rec_N = Random_Element_rec_N^-1;
    Decoded_Packet = Random_Element_rec_N \ Received_Packet_N; 
    %Decoded_Packet = Received_Packet_N * Random_Element_rec_N;
    Packet_Error_3 = isequal(Packet_Block, Decoded_Packet);
    Packet_Error_3 = ~Packet_Error_3;
else
    %--------------------------------
    %  Decoding the Packet Block.
    %--------------------------------
    %disp('Coded Packet & Random Elements received at Receiver:');% Coded Block of Packet Received by Receiver.
    Received_Packet;
    Random_Element_rec;
    %Random_Element_rec = Random_Element_rec^-1;
    % Decoding the source packets block from the received coded block.
    Decoded_Packet = Random_Element_rec \ Received_Packet;
    %Decoded_Packet = Received_Packet * Random_Element_rec;
    Packet_Error_3 = isequal(Packet_Block, Decoded_Packet);
    Packet_Error_3 = ~Packet_Error_3;
end
end