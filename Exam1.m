%% Q3:
clear all, close all, clc

A=imread('./flickr_dog.jpg');
X=double(rgb2gray(A));  % Convert RBG to gray, 256 bit to double.
nx = size(X,1); ny = size(X,2);

[U,S,V] = svd(X);

figure, subplot(2,2,1)
imagesc(X), axis off, colormap gray 
title('Original')

plotind = 2;
for r=[10 50 80];  % Truncation value
    Xapprox = U(:,1:r)*S(1:r,1:r)*V(:,1:r)'; % Approx. image
    subplot(2,2,plotind), plotind = plotind + 1;
    imagesc(Xapprox), axis off
    title(['r=',num2str(r,'%d'),', ',num2str(100*r*(nx+ny)/(nx*ny),'%2.2f'),'% storage']);
end
set(gcf,'Position',[100 100 550 400])

%% Q4:
A=imread('./flickr_dog.jpg');
X=double(rgb2gray(A));  % Convert RBG to gray, 256 bit to double.

[U,S,V] = svd(X);

N = size(X,1);
sigma = 1;
cutoff = (4/sqrt(3))*sqrt(N)*sigma; % Hard threshold
r = max(find(diag(S)>cutoff)); % Keep modes w/ sig > cutoff
Xr = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';
figure(2), imshow(Xr),title('Q4')

%% Q5:
n=size(double(rgb2gray(imread('./eigendog/flickr_dog_000002.jpg'))),1);
m=size(double(rgb2gray(imread('./eigendog/flickr_dog_000002.jpg'))),1);
allDogs = zeros(n*5,m*10);
count = 1;
ndog=512*ones(1,50);
for i=1:5
    for j=1:10
        if i*j+1 <10
            D = imread(['./eigendog/flickr_dog_00000',num2str(i*j+1),'.jpg']);
            D = double(rgb2gray(D));
        else
            D = imread(['./eigendog/flickr_dog_0000',num2str(i*j+1),'.jpg']);
            D = double(rgb2gray(D));
        end 
        figure(3), axes('position',[0  0  1  1])
        imagesc(D), axis off, colormap gray
        pause(0.1)
%         allDogs(1+(i-1)*n:i*n,1+(j-1)*m:j*m) ...
%             = reshape(D(:,1+sum(ndog(1:count-1))),n,m);
        count = count + 1;
    end
end


%% Q6:
G=imread('./flickr_dog.jpg');
GX=double(rgb2gray(G));

r = 50; % Target rank
q = 5;   % Power iterations
p = 5;   % Oversampling parameter
[rU,rS,rV] = rsvd(GX,r,q,p); % Randomized SVD

% Reconstruction
XrSVD = rU(:,1:r)*rS(1:r,1:r)*rV(:,1:r)'; % rSVD approx.
errrSVD = norm(GX-XrSVD,2)/norm(GX,2);
figure(4)
imagesc(XrSVD), axis off, colormap gray, title('Q6')