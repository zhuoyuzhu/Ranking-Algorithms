clear all
load tennis_data

%Probabilistic ranking based on the following algorithms
    %(1). Message passing on factor graphs
    %(2). Expectation propagation

M = size(W,1);            % number of players
N = size(G,1);            % number of games in 2011 season 

psi = inline('normpdf(x)./normcdf(x)');
lambda = inline('(normpdf(x)./normcdf(x)).*( (normpdf(x)./normcdf(x)) + x)');

pv = 0.5;            % prior skill variance (prior mean is always 0)

% initialize matrices of skill marginals - means and precisions
Ms = nan(M,1); 
Ps = nan(M,1);

% initialize matrices of game to skill messages - means and precisions
Mgs = zeros(N,2); 
Pgs = zeros(N,2);

% allocate matrices of skill to game messages - means and precisions
Msg = nan(N,2); 
Psg = nan(N,2);

NN = 0;


for iter=1:50
  % (1) compute marginal skills 
  for p=1:M
    % precision first because it is needed for the mean update
    Ps(p) = 1/pv + sum(Pgs(G==p)); 
    Ms(p) = sum(Pgs(G==p).*Mgs(G==p))./Ps(p);
  end

  % (2) compute skill to game messages
  % precision first because it is needed for the mean update
  Psg = Ps(G) - Pgs;
  Msg = (Ps(G).*Ms(G) - Pgs.*Mgs)./Psg;
    
  % (3) compute game to performance messages
  vgt = 1 + sum(1./Psg, 2);
  mgt = Msg(:,1) - Msg(:,2); % player 1 always wins the way we store data
   
  % (4) approximate the marginal on performance differences
  Mt = mgt + sqrt(vgt).*psi(mgt./sqrt(vgt));
  Pt = 1./( vgt.*( 1-lambda(mgt./sqrt(vgt)) ) );
    
  % (5) compute performance to game messages
  ptg = Pt - 1./vgt;
  mtg = (Mt.*Pt - mgt./vgt)./ptg;   
    
  % (6) compute game to skills messages
  Pgs = 1./(1 + repmat(1./ptg,1,2) + 1./Psg(:,[2 1]));
  Mgs = [mtg, -mtg] + Msg(:,[2 1]);
  
  V1(:,iter)=Ms; %Mean matrix per iternation
  V2(:,iter)=1./Ps; %Covariance matrix per iternation
  
  if iter > 5
      if (abs(V1(1,iter)-V1(1,iter-1))<0.001) && (abs(V1(1,iter)-V1(1,iter-1))<0.001)
          NN = iter;
          break;
      end
  end
end

%Examime the number of iterations necessary for approximate inference to
%converge by evaluating the mean and covariance of Player 2
subplot(2,1,1)
plot(V1(2,:),'r.');
title('Inference scheme to converge', 'FontSize', 13, 'FontWeight','bold');
ylabel('Mean of Player 2', 'FontSize', 12);
grid on;

subplot(2,1,2);
plot(V2(2,:),'b.');
ylabel('Covariance of Player 2', 'FontSize', 12);
grid on;

xlabel('Iterations', 'FontSize', 12);
figure;

%Visualise this ranking system according to the message passing and EP

pp = zeros(M,1);
pp = V1(:,NN);

[kk, ii] = sort(pp, 'descend');

np = 107;
barh(kk(np:-1:1))
set(gca,'YTickLabel',W(ii(np:-1:1)),'YTick',1:np,'FontSize',6)
axis([-1 2 0.5 np+0.5])

title('Ranking based on messaging passing and EP when it is converged (Iter=33)', 'FontSize', 13, 'FontWeight', 'bold')
xlabel('Player Skills', 'FontSize', 13);
ylabel('Names of players', 'FontSize', 13);
