function [CC V MWM SWM] = SPM(N,S,VS,conc)

K=length(VS);
NS=floor(N*VS);
ZS=ones(1,K);
for s=1:S
C=ones(1,K);
for i=1:floor(N/S)
pp=NS/sum(NS);
cc=C/sum(C);
pr=conc*cc+(1-conc)*(pp)/(sum(pp));
pr=pr.*ZS;
pr=pr/sum(pr);
k=find(mnrnd(1,pr)==1);
C(k)=C(k)+1;
NS(k)=NS(k)-1;
if (NS(k)==0) ZS(k)=0;
end
end
[a W(s)]=max(C);
CC(s,:)=C;
%for k=1:K
%V(1,k)=length(find(W==k));
%end
end

%for s=1:S
%WVS(s)=CC(s,W(s))/sum(CC(s,:));
%end
%MWM=mean(WVS);
%SWM=std(WVS);

for s=1:S
theta(s,:)=CC(s,:)/sum(CC(s,:));
[m(s) w(s)]=max(theta(s,:));
end

for i=1:K
ind=find(w==i);
V(i)=length(ind);
MWM(i)=mean(m(ind));
SWM(i)=std(m(ind));
end