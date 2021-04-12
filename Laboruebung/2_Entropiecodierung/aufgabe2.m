%%Auftrittswahrscheinlichkeiten
%string = 'Hochschule';
string = fileread('rfc2795.txt');
%string = 'hochschule';
lower_string = lower(string);
[y, x] = groupcounts(double(lower_string)');

disp(char(x)')
disp(y')
y_prob = y/sum(y);

y_tmp = log2(1./y_prob);

entropy_total_text = sum(y_prob .* y_tmp);
%% shannonfanodict
shannon = shannonfanodict(char(x), y_prob);
shannonenco_ret = huffmanenco(double(lower_string), shannon);
%% huffmandeco
huffman = huffmandict(x, y_prob);
huffmanenco_ret = huffmanenco(double(lower_string), huffman);
%% arithenco
input=double(lower_string);
[alphabet,~,seq]=unique(input);
counts = histc(input,alphabet);
code = arithenco(seq,counts);
dseq = arithdeco(code,counts,length(input));

%% bit_length
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
names = ["shannon" "huffman" "arith"]
average_length = {[] [] []}

lower_string  = lower_string(randi(length(lower_string),[20,threshold]));

for ii = 1:20
    name_number = 1;
    
    % shannonfanodict
    shannonenco_ret = huffmanenco(double(lower_string(ii,:)), shannon);
    % huffmandeco
    huffmanenco_ret = huffmanenco(double(lower_string(ii,:)), huffman);
    % arithenco
    [alphabet,~,seq]=unique(double(lower_string(ii,:)));
    code = arithenco(seq,counts);
    
    for i = {shannonenco_ret huffmanenco_ret code' }
        average_length{name_number}(end + 1) = (length(i{:}) / threshold) / entropy_total_text;
        name_number = name_number + 1;
    end
end



figure;
hold on
xlabel('Wort');
ylabel('durchschnittliche laenge');

i = 1;
for p = average_length
    plot(1:20, cell2mat(p.'));
    i = i + 1;
end
legend(names)
hold off


%{ 
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
         %}