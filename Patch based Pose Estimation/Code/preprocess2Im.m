function im2=preprocess2Im(im1)

[imX imY imZ]=size(im1);
if imZ>1
im1=rgb2gray(im1);
end
im1=double(im1);

im1=filterImage(im1);



mu=mean(im1(:));

im1=im1-mu;
gauss=gaussian(imX,imY);
im1=im1.*gauss;
im1=im1-mean(im1(:));
im2=im1./std(im1(:));

