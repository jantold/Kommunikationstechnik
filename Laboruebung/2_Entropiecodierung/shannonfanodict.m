% symb: Symbole
% p: auftrittswahrscheinlichkeiten
function [sfd,lc]=shannonfanodict(symb,p)
symb=symb(:)';
p=p(:)';
% Auftrittswahrscheinlichkeiten absteigend sortierten
[p_sorted,sort_index]=sort(p,'descend');
% Shannon Fano Codes
codes_sf=shannonfano(p_sorted);
% Codes in ursprüngliche Reihenfolge bringen
c_sf(sort_index)=codes_sf;
% Wörterbuch entsprechend Huffman-Codierung: Cell-Array mit
% - Symbolnummern in erster Spalte
% - binäre Codewörter (binäre Arrays) in zweiter Spalte
sfd=[num2cell(symb(1:end)') c_sf'];
lc=p_sorted*cellfun(@(x)(length(x)),codes_sf);

function code=shannonfano(p)
% p: Vektor mit absteigend sortierten Wahrscheinlichkeiten
if length(p)==1
    code={[]}; % nur ein Zeichen, keine Codierung notwendig
elseif length(p)==2
    code={1;0}; % zwei Zeichen, Codierung mit 0 und 1
else % mindestens drei Zeichen
    % Vektor normieren
    p=p/sum(p);
    % "0"-Hälfte bis zu dem Index, so dass die aufsummierten
    % Wahrscheinlichkeiten am nächsten bei 0.5 liegen
    [dev0,I]=min(abs(cumsum(p)-0.5));
    % Indizes der "0"-Hälfte
    Izero=1:I;
    %  Indizes der "1" Hälfte
    Ione=(I+1):length(p);
    % Rekursive Codierung der oberen und unteren Hälfte
    Czero=shannonfano(p(Izero));
    Cone=shannonfano(p(Ione));
    % "0" bzw. "1" vorne anfügen
    for i=1:length(Czero)
        Czero{i}=[0 Czero{i}];
    end
    for i=1:length(Cone)
        Cone{i}=[1 Cone{i}];
    end
    % Hälften zusammensetzen
    code=[Czero;Cone];
end
            
