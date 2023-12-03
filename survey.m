
function [Wtrue, W, V] = survey(X,N,S,K,niter,NN,SS)

Wtrue=zeros(niter,K);
W=zeros(niter,K); 
V=zeros(niter,K);
for k=1:niter 
ss=randsample(1:S,round(S*SS));  
for i=1:length(ss)
s=ss(i); 

pp=X(s,:); 
pp=pp/sum(pp); 
w=mnrnd(ceil(N*NN/length(ss)),pp); 
V(k,:)=V(k,:)+w; 
j=find(w==max(w)); 
if (length(j)>1) j=randsample(j,1);
end
W(k,j)=W(k,j)+1;
end
XX=X(ss,:);
for s=1:length(ss)
j=find(XX(s,:)==max(XX(s,:)));
Wtrue(k,j)=Wtrue(k,j)+1;
end
end
