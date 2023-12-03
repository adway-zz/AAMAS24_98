function [NVS V] = PCM_batch(N,S,batchsize,VS,alpha)

K=length(VS);

NS=N*VS;
NVS=ones(S,K);
NVSS=ones(1,K);
ZS=ones(S,1);

for i=1:batchsize:N
k=find(mnrnd(1,VS)==1);
pr=NVS(:,k).*ZS;
pr1=pr/sum(pr);
pr2=ZS/sum(ZS);
prr=alpha(k)*pr1+(1-alpha(k))*pr2;
s=mnrnd(batchsize,prr);
NVS(:,k)=NVS(:,k)+s';
for j=1:S
if (sum(NVS(j,:)>N/S)) ZS(j)=0;
end
end
end


for s=1:S
theta(s,:)=NVS(s,:)/sum(NVS(s,:));
[m(s) w(s)]=max(theta(s,:));
end

for i=1:K
ind=find(w==i);
V(i)=length(ind);
end