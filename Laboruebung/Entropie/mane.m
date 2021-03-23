text = fileread('rfc2795.txt');

% nr 1
[y, x] = groupcounts(double(text)') ;

figure;

plot(x,y,'Color',[0,1.0,0]);

xlabel('Zeichen (sortiert)');
ylabel('Häufigkeit');


% nr 2
[v, i] = maxk(y, 10); % 14 = h

b = bar(v);
set(b,'FaceColor',[1.0,0.7,0]);
set(gca,'xticklabel',char(x(i)));
xlabel('Zeichen');
ylabel('Häufigkeit');