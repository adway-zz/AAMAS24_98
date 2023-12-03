function [x conc p1] = dir_posterior_PCM(Y,N,S,K,alpha0, Nfr,Sfr,num_cands,num_samps)

%% Y: cell array of length L, each cell contains results of one survey. 1st row of each cell: projected %% vote shares of the K parties, 2nd row of each cell: their projected seat shares
% N: total number of voters
% S: total number of districts
% K: total number of parties
% alpha0: Dirichlet prior parameters
% Nfr: fraction of population surveyed uniformly at random in each district
% Sfr: fraction of districts surveyed uniformly at random
% num_cand: number of candidate solutions
% num_samps: number of samples per candidate
% x: list of candidate solutions (vote share)
% conc: list of candidate solutions (partywise concentrations)
% p1: list of posterior likelihood for each candidate solution
for i=1:num_cands
x(i,:)=dirichlet_sample(alpha0);
conc(i,:)=0.5*ones(1,3)+0.5*rand(1,3);
for j=1:num_samps
[CC{i}{j} V{i}(j,:)] = PCM_batch(N,S,100,x(i,:),conc(i,:));
[SV1true{i}{j}, SV1{i}{j}, SC1{i}{j}] = survey(CC{i}{j},N,S,K,100,Nfr,Sfr);
data=0.99*SC1{i}{j}./sum(SC1{i}{j},2)+0.01*1/3*ones(1,3);
alpha_est1{i}(j,:) = dirichlet_fit_newton(data) ;
data=0.99*SV1{i}{j}./sum(SV1{i}{j},2)+0.01*1/3*ones(1,3);
beta_est1{i}(j,:) = dirichlet_fit_newton(data);
for l=1:length(Y)
g1(l,j)=dirichlet_logProb(alpha_est1{i}(j,:),Y{l}(1,:));
h1(l,j)=dirichlet_logProb(beta_est1{i}(j,:),Y{l}(2,:));
end
end
p1(i)=log(mean(exp(sum(g1,1))))+ log(mean(exp(sum(h1,1))))+dirichlet_logProb(alpha0,x(i,:));
end