clear all, close all, clc
%% Q1
% Define domain
dx = 0.001;
L = pi;
x = (-1+dx:dx:1)*L;
n = length(x);
%nquart = floor(n/6);

% Define hat function
f = 0*x;
f(1:floor(n/6)-1) = sin(x(1:floor(n/6)-1));
f(floor(n/6):floor(2*n/6)-1) = 1;
f(floor(2*n/6):floor(3*n/6)-1) = exp(x(floor(2*n/6):floor(3*n/6)-1));
f(floor(3*n/6):floor(4*n/6)-1) = -1;
f(floor(4*n/6):floor(5*n/6)-1) = cos(x(floor(4*n/6):floor(5*n/6)-1));
figure(1)
%plot(x,f,'-k','LineWidth',1.5), hold on

% Compute Fourier series
CC = jet(150);
A0 = sum(f.*ones(size(x)))*dx;
fFS = A0/2;
for k=1:150
    A(k) = sum(f.*cos(pi*k*x/L))*dx; % Inner product
    B(k) = sum(f.*sin(pi*k*x/L))*dx;
    fFS = fFS + A(k)*cos(k*pi*x/L) + B(k)*sin(k*pi*x/L);
    plot(x,fFS,'-','Color',CC(k,:),'LineWidth',1.2)
    hold on
end

%% Q2
A = imread('dog.jpg'); % Load image
B = rgb2gray(A);
Bnoise = B + uint8(200*randn(size(B)));  % Add some noise
Btshift=fftshift(fft2(Bnoise));
F = log(abs(Btshift)+1);       % Put FFT on log-scale

figure(2)
subplot(2,2,1), imagesc(Bnoise) % Plot image
subplot(2,2,2), imagesc(F)      % Plot FFT

[nx,ny] = size(B);
[X,Y] = meshgrid(-ny/2+1:ny/2,-nx/2+1:nx/2);
R2 = X.^2+Y.^2;
ind = R2<150^2;
Btshiftfilt = Btshift.*ind;
Ffilt = log(abs(Btshiftfilt)+1);  % Put FFT on log-scale
subplot(2,2,3), imagesc(Ffilt)    % Plot filtered FFT

Btfilt = ifftshift(Btshiftfilt);
Bfilt = ifft2(Btfilt);
subplot(2,2,4), imagesc(uint8(real(Bfilt))) % Filtered image
colormap gray

%% Q3
A = imread('dog.jpg');
B = rgb2gray(A);

[C,S] = wavedec2(B,4,'db1');
Csort = sort(abs(C(:))); % Sort by magnitude
figure(3)
subplot(2,2,1)
imagesc(B)
colormap gray
counter = 2;
for keep =  [.1 .03 .001]
    subplot(2,2,counter)
    thresh = Csort(floor((1-keep)*length(Csort)));
    ind = abs(C)>thresh;
    Cfilt = C.*ind;      % Threshold small indices
    
    % Plot Reconstruction
    Arecon=uint8(waverec2(Cfilt,S,'db1'));
    imshow(uint8(Arecon))
    title(['',num2str(keep*100),'%'],'FontSize',12)
    counter = counter + 1;
end

%% Q4
load 'data.csv'
figure(4)
scatter(data(:,1),data(:,2),'bo') % Data
hold on
x = data(:,1)
b = data(:,2)
xgrid = sort(x)
cvx_begin;       % L1 optimization to reject outlier
    variable aL1;     % aL1 is slope to be optimized 
    minimize( norm(aL1*x-b,1) );     % aL1 is robust
cvx_end;

plot(xgrid,xgrid*aL1,'b')         % L1 fit

x_without = data(1:end-1,1)
b_without = data(1:end-1,2)

atrue = x\b;
awithout = x_without\b_without;
plot(xgrid,xgrid*awithout,'k--')       % L2 fit (no outlier)
plot(xgrid,xgrid*atrue,'r--')    % L2 fit (outlier)
legend('Data','L1','L2 (no outlier)','L2 (outlier)')