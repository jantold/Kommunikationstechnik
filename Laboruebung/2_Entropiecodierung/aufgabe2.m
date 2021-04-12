%%Auftrittswahrscheinlichkeiten
string = 'Hochschule';
lower_string = lower(string);
[y, x] = groupcounts(double(lower_string)');

disp(char(x)')
disp(y')
y_prob = y/sum(y);

y_tmp = log2(1./y_prob);

entropy = sum(y_prob .* y_tmp);
%% shannonfanodict
shannonfanodict(char(x), y_prob)
%% huffmandeco
huffman = huffmandict(x, y_prob);
huffmanenco_ret = huffmanenco(double(lower_string), huffman);
char(huffmandeco(huffmanenco_ret, huffman))
