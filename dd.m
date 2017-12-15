f=imread('C:\Users\Özgür\Desktop\tire.tif');
h=imread('C:\Users\Özgür\Desktop\tire2.tif');	
g=double(f)-double(h);

N=size(g,1)
M=size(g,2)

mn=g(1,1)
for i=1:N
 for j=1:M
   if(mn>g(i,j))
    mn=g(i,j);
   end
 end
end

if (mn<0)
g=g-mn
end

mx=g(1,1);
for i=1:N
 for j=1:M
   if(mx<g(i,j))
    mx=g(i,j);
   end
 end
end

if (mx>255)
g=(g*255)/mx
end

figure,imshow(g);