function [r,g,b] = xyz2rgb(x,y,z)

[n,m] = size(x);

Q = [0.03240479 -0.01537150 -0.00498535; -0.00969256 0.01875992 0.00041556; 0.00055648 -0.00204043 0.01057311];

rgb=min(1,max(0,Q*[x(:)';y(:)';z(:)']));
r=reshape(rgb(1,:),n,m);
g=reshape(rgb(2,:),n,m);
b=reshape(rgb(3,:),n,m);
