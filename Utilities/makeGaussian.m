function out = makeGaussian(mu,sigma,x)

out = 1/(sigma*sqrt(2*pi)).*exp(-(x - mu).^2/(2*sigma^2));
