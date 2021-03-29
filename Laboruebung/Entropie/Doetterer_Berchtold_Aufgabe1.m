%% nr 1
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;

figure;
plot(x,y,'Color',[0,1.0,0]);
xlabel('Zeichen (sortiert)');
ylabel('Häufigkeit');

%% nr 2
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;
[v, i] = maxk(y, 10);  %14 = h

b = bar(v);
set(b,'FaceColor',[1.0,0.7,0]);
set(gca,'xticklabel',char(x(i)));
xlabel('Zeichen');
ylabel('Häufigkeit');

%% nr 3
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)') ;
[v, i] = maxk(y, 10);  %14 = h

summe = sum(y);
y_prob = y / summe;
y_tmp = log2(1./y_prob);

% Lineplot
figure(1);
plot(x, y_tmp,'Color',[0,1.0,0]);
xlabel('Zeichen (sortiert)');
ylabel('Häufigkeit');


% Barplot
figure(2);
b = bar(y_tmp);
set(b,'FaceColor',[1.0,0.7,0]);
set(gca,'xticklabel',char(x));
xlabel('Zeichen');
ylabel('Informationsgehalt');


%{
fprintf("Auftrittswahrscheinlichkeiten:")
for i = 1:length(tmp)
    fprintf('%s is %.2d\n', char(x(i)), tmp(i))
end
%}

%% nr 4 - benoetigt nr3-code
text = fileread('rfc2795.txt');
[y, x] = groupcounts(double(text)');

summe = sum(y);
y_prob = y / summe;
y_tmp = log2(1./y_prob);

entropy = sum(y_prob .* y_tmp);

% sum prob / len(ASCII-char)
% gleicheviele Bits fuer jedes Char (128 -> 7)
redundancy = sum(y_prob .* log2(128));
fprintf("Entropie der Nachrichtenquelle: %s\n", num2str(entropy));
fprintf("Redundanz der Nachrichtenquelle: %s\n", num2str( redundancy - entropy));