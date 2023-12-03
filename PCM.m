function [NVS V MWS SWS] = PCM(N,S,VS,alpha)

K=length(VS);

NS=N*VS;
NVS=ones(S,K);
NVSS=ones(1,K);
ZS=ones(S,1);

for i=1:N
k=find(mnrnd(1,VS)==1);
pr=NVS(:,k).*ZS;
pr1=pr/sum(pr);
pr2=ZS/sum(ZS);
prr=alpha(k)*pr1+(1-alpha(k))*pr2;
s=find(mnrnd(1,prr));
NVS(s,k)=NVS(s,k)+1;
if (sum(NVS(s,:)>N/S)) ZS(s)=0;
end
end

%for s=1:S
%[WM(s) W(s)]=max(NVS(s,:)/(N/S));
%end
%for k=1:K
%V(k)=length(find(W==k));
%end
%MWS=mean(WM);
%SWS=std(WM);

for s=1:S
theta(s,:)=NVS(s,:)/sum(NVS(s,:));
[m(s) w(s)]=max(theta(s,:));
end

for i=1:K
ind=find(w==i);
V(i)=length(ind);
MWS(i)=mean(m(ind));
SWS(i)=std(m(ind));
end