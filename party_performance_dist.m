function [pp qq] = party_performance_dist(Y,N,S,K,alpha0,thres,Nfr,Sfr)

% Y: survey results (cell array, each cell contains vote shares (1st row) and seat shares (2nd row))
% thres: threshold of KL-divergence between simulated and actual surveys (typical value 0.25)
% K: number of parties
% alpha0: prior Dirichlet parameters
% pp: pdf of vote share of different parties
% qq: pdf of seat shares of different parties

C=[];
for i=1:1000
xc(i,:)=dirichlet_sample(alpha0);
concc(i)=0.92+0.08*rand;
[zc vc] = SPM_batch(N,S,500,xc(i,:),concc(i));
[SVctrue, SVc, SCc] = survey(zc, N,S,K,100,Nfr,Sfr);
y1=mean(SCc,1)/sum(mean(SCc,1));
y2=mean(SVc,1)/sum(mean(SVc,1));
y2=0.99*y2+0.01*(1/3)*ones(1,3);
y1=0.99*y1+0.01*(1/3)*ones(1,3);
for l=1:length(Y)
klc(l,1)=sum(y1.*log(y1./Y{l}(1,:)));
klc(l,2)=sum(y2.*log(y2./Y{l}(2,:)));
end
if (mean(sum(klc,1))<thres) C=[C;[xc(i,:) concc(i)]];
end
end

for i=1:size(C,1)
[zz x2c(i,:)]=SPM_batch(N,S,100,C(i,1:K),C(i,K+1));
end
gamma1 = dirichlet_fit_newton(C(:,1:K));
gamma2 = dirichlet_fit_newton(x2c/S);

jj=0;
for ii=0:0.01:1
jj=jj+1;
for k=1:K
pp{k}(jj)=betapdf(ii,gamma1(1),sum(gamma1)-gamma1(k));
qq{k}(jj)=betapdf(ii,gamma2(1),sum(gamma2)-gamma2(k));
end
end