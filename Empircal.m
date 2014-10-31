% make a bar plot from vector P and annotate with player names from W

clear all;
load('tennis_data.mat');

%Compute a probabilistic ranking system using empirical ratio of total
%number of wins to total number of games that each player played in 2011
parta;

[kk, ii] = sort(m(:,2), 'descend');

np = 107;
barh(kk(np:-1:1))
set(gca,'YTickLabel',W(ii(np:-1:1)),'YTick',1:np,'FontSize',6)
axis([0 1 0.5 np+0.5])

title('Ranking ratios based on the number of wins to total number of games played', 'FontSize', 13)
xlabel('Empirical ratio of winning', 'FontSize', 12);
ylabel('Names of players', 'FontSize', 12);

%%%