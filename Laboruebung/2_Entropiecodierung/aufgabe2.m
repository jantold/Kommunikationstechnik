%%Auftrittswahrscheinlichkeiten
%string = 'Hochschule';
string = fileread('rfc2795.txt');

lower_string = lower(string);
[y, x] = groupcounts(double(lower_string)');

disp(char(x)')
disp(y')
y_prob = y/sum(y);

y_tmp = log2(1./y_prob);



entropy = sum(y_prob .* y_tmp);
%% shannonfanodict
shannon = shannonfanodict(char(x), y_prob);
shannonenco_ret = huffmanenco(double(lower_string), shannon);
%% huffmandeco
huffman = huffmandict(x, y_prob);
huffmanenco_ret = huffmanenco(double(lower_string), huffman);
char(huffmandeco(huffmanenco_ret, huffman))
%% arithenco
input=double(lower_string);
[alphabet,~,seq]=unique(input);
counts = histc(input,alphabet);
code = arithenco(seq,counts);
dseq = arithdeco(code,counts,length(input));

%% bti_length
fprintf('shannon %d huffman %d arithm %d\n', length(shannonenco_ret), length(huffmanenco_ret), length(code))

%% 3.5
for i = {shannonenco_ret huffmanenco_ret code'}
    [y, x] = groupcounts(cell2mat(i.')');

    summe = sum(y);
    y_prob = y / summe;
    y_tmp = log2(1./y_prob);

    entropy = sum(y_prob .* y_tmp);

    % sum prob / len(ASCII-char)
    % gleicheviele Bits fuer jedes Char (128 -> 7)
    redundancy = sum(y_prob .* log2(128));
    length(i{:})
    fprintf("Entropie der Nachrichtenquelle: %s\n", num2str(entropy));
    fprintf("Redundanz der Nachrichtenquelle: %s\n", num2str( redundancy - entropy));
end
%% 4.2
threshold = 1000
names = ["shannonenco_ret" "huffmanenco_ret" "code"]
for ii = 0:20
    r  = randi([0, 128], 1, threshold);
    name_number = 1;
    lower_string = r;
    [y, x] = groupcounts(lower_string');

    y_prob = y/sum(y);

    y_tmp = log2(1./y_prob);
    
    % shannonfanodict
    shannon = shannonfanodict(char(x), y_prob);
    shannonenco_ret = huffmanenco(double(lower_string), shannon);
    % huffmandeco
    huffman = huffmandict(x, y_prob);
    huffmanenco_ret = huffmanenco(double(lower_string), huffman);
    % arithenco
    input=double(lower_string);
    [alphabet,~,seq]=unique(input);
    counts = histc(input,alphabet);
    code = arithenco(seq,counts);
    disp("--------------------------------------------------------------------")
    for i = {shannonenco_ret huffmanenco_ret code'}
        [y, x] = groupcounts(cell2mat(i.')');

        summe = sum(y);
        y_prob = y / summe;
        y_tmp = log2(1./y_prob);

        entropy = sum(y_prob .* y_tmp);

        % sum prob / len(ASCII-char)
        % gleicheviele Bits fuer jedes Char (128 -> 7)
        redundancy = sum(y_prob .* log2(128));
        fprintf("\n%s : %d\n",names(name_number), length(i{:}))
        
        fprintf("Entropie der Nachrichtenquelle: %s\n", num2str(entropy));
        fprintf("Redundanz der Nachrichtenquelle: %s\n", num2str( redundancy - entropy));
        name_number = name_number + 1;
    end
end