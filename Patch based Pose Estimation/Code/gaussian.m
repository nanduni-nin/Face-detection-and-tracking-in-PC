function im=gaussian(imX,imY)

im=zeros(imX,imY);

for i=1:imX
    for j=1:imY
        im(i,j)=exp(-0.5*(1/225)*(((i-imX/2)^2)+((j-imY/2)^2)));
    end
end

im=im/sum(sum(im));

%figure;imagesc(im);axis off square;colormap(gray);
