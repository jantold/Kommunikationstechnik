
%1.
%G = [1 1 1 1 0 0 1 0; 0 0 1 1 1 1 0 1];
G = [1 1 0 1 0 0 0; 0 1 1 0 1 0 0; 1 1 1 0 0 1 0; 1 0 1 0 0 0 1];
nutzwort = [0 1 1 0];   
%codewort = mod(nutzwort * G, 2)
codewort = [1 1 0 0 1 1 0];
%2.
[r c] = size(G);
P = G(:,1:end - r);
Pt = P';
[r c] = size(Pt);

H = [eye(r) Pt];
% 3.
S = mod(codewort * H', 2);

%4.


fehlerSyndromKorrektur(H', codewort, [0 0 0]);

function [korrNachricht, anzFehler, resErr] = fehlerSyndromKorrektur(h ,nachricht, fehlersyndrom)
[r c] = size(h);
    for i = 1 : r
        if isequal(zeros(1, c), fehlersyndrom)
            break;
        end
        h(i, :)
        if isequal(h(i, :), fehlersyndrom)
            nachricht(i) = mod(nachricht (i) + 1, 2);
        end
        
    end
    
    korrNachricht = nachricht
    anzFehler = 1;
    resErr = 1;
    
end
