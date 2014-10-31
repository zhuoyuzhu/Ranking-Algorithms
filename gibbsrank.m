clear all;
load tennis_data

%Probabilistic ranking system based on the following algorithms
    %(1). Bayes Decision Rule with generative model
    %(2). Gibbs sampling for the TrueSkill model
    %(3). Markov Chain Monte Carlo (MCMC)

randn('seed',27); % set the pseudo-random number generator seed

M = size(W,1);            % number of players
N = size(G,1);            % number of games in 2011 season 

pv = 0.5*ones(M,1);           % prior skill variance 

w = zeros(M,1);               % set skills to prior mean
r = zeros(M,100);
k = zeros(M,1);

for o = 1:991

  % First, sample performance differences given the skills and outcomes
  
  t = nan(N,1); % contains a t_g variable for each game
  for g = 1:N   % loop over games
    s = w(G(g,1))-w(G(g,2));  % difference in skills
    t(g) = randn()+s;         % performace difference sample
    while t(g) < 0  % rejection sampling: only positive perf diffs accepted
      t(g) = randn()+s; % if rejected, sample again
    end
  end 
 
  
  % Second, jointly sample skills given the performance differences
  
  m = nan(M,1);  % container for the mean of the conditional 
                 % skill distribution given the t_g samples
  for p = 1:M
    m(p) = t'*((p==G(:,1)) - (p==G(:,2)));% (***TO DO***) complete this line
  end
  
  iS = zeros(M,M); % container for the sum of precision matrices contributed
                   % by all the games (likelihood terms)
  
   %build the iS matrix             
    for i = 1:M
        for j = 1:i
            if i==j  
                iS(i,j) = sum(i==G(:,1)) + sum(i==G(:,2));
            else
                iS(i,j) = -sum((i==G(:,1)).*(j==G(:,2))+(i==G(:,2)).*(j==G(:,1)));
                iS(j,i) = iS(i,j);
            end
        end
    end
        

  iSS = diag(1./pv) + iS; % posterior precision matrix
  % prepare to sample from a multivariate Gaussian
  % Note: inv(M)*z = R\(R'\z) where R = chol(M);
  iR = chol(iSS);  % Cholesky decomposition of the posterior precision matrix
  mu = iR\(iR'\m); % equivalent to inv(iSS)*m but more efficient
    
  % sample from N(mu, inv(iSS))
  w = mu + iR\randn(M,1);
  V(o)=w(1);
  X(o)=w(5);
  Y(o)=w(10);
  Z(o)=w(15);
  
  if mod(o+9,10)==0     
    r(:,(o+9)/10)=w;
  end
  
end

k = mean(r,2);
pp = zeros(M,1);
Sum = 0;

%Calculate average probaility
for P1=1:M
   for P2=1:M
       pp(P1) = pp(P1) + normcdf(k(P1)-k(P2));
       
   end
end

pp=pp/107;

%Plot this ranking system 
[kk, ii] = sort(pp, 'descend');

np = 107;
barh(kk(np:-1:1))
set(gca,'YTickLabel',W(ii(np:-1:1)),'YTick',1:np,'FontSize',6)
axis([0 1 0.5 np+0.5])

title('Average winning probability of each player against other players', 'FontSize', 13, 'FontWeight', 'bold')
xlabel('Average probability that player will win against other players', 'FontSize', 12);
ylabel('Names of players', 'FontSize', 12);

