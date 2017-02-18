function im2=filterImage(im)

% convert to gray scale   
% if size(im,3)==3
%     im=rgb2gray(im);
% end
% im=double(im);

I=size(im,1);J=size(im,2);
padIm=zeros(2*I,2*J);
padIm(1:I,1:J)=im;padIm(I+1:2*I,1:J)=flipud(im);
padIm(1:I,J+1:2*J)=fliplr(im);padIm(I+1:2*I,J+1:2*J)=fliplr(flipud(im));
II=2*I;JJ=2*J;
%imshow(uint8(padIm));

% take the fft
F=fft2(padIm);

% construct the filters
D=zeros(II,JJ);
for i=1:I+1
    for j=1:J+1
        D(i,j)=sqrt((i-1)^2+(j-1)^2);
    end
end
D(I+2:II,1:J)=flipud(D(2:I,1:J));
D(1:I,J+2:JJ)=fliplr(D(1:I,2:J));
D(I+1:II,J+1:JJ)=flipud(D(1:I,J+1:JJ));

lpFilt=D<50;
hpFilt=D>5;
%figure;imshow(lpFilt);
%figure;imshow(lpFilt&hpFilt);

% apply the filters
F=F.*lpFilt;
F=F.*hpFilt;

% take the inverse fft
im2=real(ifft2(F));
im2=im2(1:I,1:J);

%m=min(im2(:));mm=max(im2(:));
%im2b=(im2-m)*(255/(mm-m));
%figure;imagesc(im2);colormap(gray);

