function [CC V] = SPM_batch(N,S,batchsize,VS,conc)

K=length(VS);
NS=floor(N*VS);
ZS=ones(1,K);
for s=1:S
C=ones(1,K);
for i=1:floor(N/(S*batchsize))
pp=NS/sum(NS);
cc=C/sum(C);
pr=conc*cc+(1-conc)*(pp)/(sum(pp));
pr=pr.*ZS;
if (sum(pr)~=0)
pr=pr/sum(pr);
c=mnrnd(batchsize,pr);
C=C+c;
NS=NS-c;
ZS(find((NS<=batchsize)))=0;
end
end
[a W(s)]=max(C);
CC(s,:)=C;
end

for s=1:S
theta(s,:)=CC(s,:)/sum(CC(s,:));
[m(s) w(s)]=max(theta(s,:));
end

for i=1:K
ind=find(w==i);
V(i)=length(ind);
end