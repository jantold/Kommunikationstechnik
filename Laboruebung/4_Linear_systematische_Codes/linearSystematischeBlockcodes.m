%% Task 4
% 1. Source
n = 7;
k = 4;
M = 5;
msg = randsrc(M, k, [1 0])

%2. ChannelSource

encMsg = encode(msg, n, k)

%3. Transmit channel
p = 0.3;
errEncMsg = bsc(encMsg, p)

%4. channelEncoding
% does not return -1!!! but should!!
[decMsg, err] = decode(errEncMsg, n, k);

%5. statistic analysis

[num, ratio] = biterr(msg, decMsg);
disp("a.die Anzahl/den Anteil fehlerhafter Bits nach der Fehlerkorrektur");
disp([num, ratio])

[num_rowwise, ratio_rowwise] = biterr(msg, decMsg, 'row-wise');

disp("b.die Anzahl/den Anteil fehlerfrei übertragener Nutzworte");
correct_fixed = sum(num_rowwise == 0);
disp([correct_fixed, correct_fixed / M])

disp("c.die Anzahl/den Anteil richtig korrigierter Nutzworte");
sumErr = sum(err);
disp([sumErr sumErr / M])

disp("d.die Anzahl/den Anteil als fehlerhaft erkannter aber nicht korrigierter Nutzworte");
not_fixed = sum(err == -1);
disp([not_fixed not_fixed / M])

disp("e.die Anzahl/den Anteil falsch korrigierter Nutzworte");
not_correct_fixed = sum(num_rowwise > 0);
% how many are still wrong - not fixxed 
disp([not_correct_fixed - not_fixed, not_correct_fixed - not_fixed / M]);

disp("f.die Anzahl/den Anteil unerkannter fehlerhafter Nutzworte");
% undetected == failed correction  - can distinguish
 % disp([not_correct_fixed - ); 
disp([not_correct_fixed - not_fixed, not_correct_fixed - not_fixed / M]);
disp("----------------------");

%% 4.6
n = 7;
k = 4;
M = 1000;
msg = randsrc(M, k, [1 0]);

encMsg = encode(msg, n, k);

plot_y = [];
P = [1 2 5 10 25];
for p = P
    errEncMsg = bsc(encMsg, p / 100)
    [decMsg, err] = decode(errEncMsg, n, k);
    [num_rowwise, ratio_rowwise] = biterr(msg, decMsg, 'row-wise');
    
    num_incorrect_words = M - sum(num_rowwise == 0);
    not_fixed = sum(err == -1);
    
    tmp = [num_incorrect_words, not_fixed];
    plot_y = [plot_y; tmp];
end
plot_y
bar(P, plot_y)


%% Task 3
%1.
%G = [1 1 1 1 0 0 1 0; 0 0 1 1 1 1 0 1];
G = [1 1 0 1 0 0 0; 0 1 1 0 1 0 0; 1 1 1 0 0 1 0; 1 0 1 0 0 0 1];
nutzwort = [0 1 1 0];   
codewort = mod(nutzwort * G, 2);
disp("correct codewort:");
disp(codewort);
%codewort = [1 1 0 0 1 1 0];
e = [0 1 0 0 0 0 0];
codewort = xor(codewort, e);
%2.
[r c] = size(G);
P = G(:,1:end - r);
Pt = P';
[r c] = size(Pt);

H = [eye(r) Pt];
% 3.
S = mod(codewort * H', 2);

%4.


disp("codewort with error:");
disp(codewort);

disp("syndrom:");
disp(S);
disp("---------------"),
[korrNachricht, anzKorrFehler, uebrigErr] = fehlerSyndromKorrektur(H', codewort, S);

disp("korrNachricht:");
disp(korrNachricht);

disp("anzKorrFehler:");
disp(anzKorrFehler);

disp("uebrigErr:");
disp(uebrigErr);

% correct only one error
function [korrNachricht, anzKorrFehler, uebrigErr] = fehlerSyndromKorrektur(h ,nachricht, fehlersyndrom)
    [r c] = size(h);
    % if fehlersyndrom == 0 -> no error
    if isequal(zeros(1, c), fehlersyndrom)
            korrNachricht = nachricht;
            anzKorrFehler = 0;
            uebrigErr = false;
            return;
    end
    
    for i = 1 : r
        h(i, :);
        if isequal(h(i, :), fehlersyndrom)
            nachricht(i) = mod(nachricht (i) + 1, 2);
            korrNachricht = nachricht;
            anzKorrFehler = 1;
            uebrigErr = false;
            return;
        end
    end
    
    korrNachricht = nachricht;
    anzKorrFehler = 0;
    uebrigErr = true;    
end


