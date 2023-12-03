function [Yf LR] = survey_evaluation_fake(Z0,X0, N,S,K,alpha0,thres,Nfr,Sfr)

% Z0: true complete results of election
% X0: true results of election
% N: total number of voters
% S: number of districts
% K: number of parties
% alpha0: Diricihlet prior parameters
% thres: threshold of K-L Divergence between true and candidate survey
% results (typical value 0.1)
% Nfr: fraction of people covered uniformly at random in each district
% Sfr: fraction of districts covered uniformly at random
% Yf: false candidate surveys
% LR: likelihood-ratio p(Y|X)/p(Y)

for i=1:10000
x(i,:)=dirichlet_sample(alpha0);
conc(i)=0.5*rand+0.5;
[Z{i} V{i}] = SPM_batch(N,S,100,x(i,:),conc(i));
[SV1true, SV1, SC1] = survey(Z{i},N,S,K,100,Nfr,Sfr);
YC{i}(1,:)=sum(SC1,1)/sum(sum(SC1));
YC{i}(2,:)=sum(SV1,1)/sum(sum(SV1));
end

for i=1:100
xf=dirichlet_sample(alpha0);
[Zf Vf]=SPM_batch(N,S,1,xf,0.95);
[SV1truef, SVf, SCf] = survey(Zf,N,S,K,100,Nfr,Sfr);
Yf{i}(1,:)=SCf/sum(SCf);
Yf{i}(2,:)=SVf/sum(SVf);
end

for j=1:100
for i=1:10000
y11=0.99*YC{i}(1,:)+0.01*(1/K)*ones(1,K);
y12=0.99*YC{i}(2,:)+0.01*(1/K)*ones(1,K);
y21=0.99*Yf{j}(1,:)+0.01*(1/K)*ones(1,K);
y22=0.99*Yf{j}(2,:)+0.01*(1/K)*ones(1,K);
kl1(i,j)=sum(y11.*log(y11./y21));
kl2(i,j)=sum(y12.*log(y12./y22));
end
PY(j)=length(find(kl1(:,j)<thres & kl2(:,j)<thres))/10000;
end

for i=1:10000
xc(i,:)=dirichlet_sample(alpha0);
concc(i)=0.92+0.08*rand;
[zc vc] = SPM_batch(N,S,100,xc(i,:),concc(i));
[SVctrue, SVc, SCc] = survey(zc,N,S,K,100,Nfr,Sfr);
y1=mean(SCc,1)/sum(mean(SCc,1));
y2=mean(SVc,1)/sum(mean(SVc,1));
xc2(i,:)=0.99*(vc/S)+0.01*(1/K)*ones(1,K);
klc1=sum(xc(i,:).*log(xc(i,:)./X0(1,:)));
klc2=sum(xc2(i,:).*log(xc2(i,:)./X0(2,:)));
if (klc1+klc2<thres) C1=[C1;y1];C2=[C2;y2];
end
end

for j=1:100
for i=1:size(C1,1)
y11=0.99*C1(i,:)+0.01*(1/K)*ones(1,K);
y12=0.99*C2(i,:)+0.01*(1/K)*ones(1,K);
y21=0.99*Yf{j}(1,:)+0.01*(1/K)*ones(1,K);
y22=0.99*Yf{j}(2,:)+0.01*(1/K)*ones(1,K);
klx1(i,j)=sum(y11.*log(y11./y21));
klx2(i,j)=sum(y12.*log(y12./y22));
end
PYX(j)=length(find(klx1(:,j)<0.1 & klx2(:,j)<0.1))/size(C1,1);
end
LR=PYX./PY;