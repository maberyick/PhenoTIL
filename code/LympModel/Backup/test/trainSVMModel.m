function model = trainSVMModel( data,labels,kernel )
%TRAINSVMMODEL Summary of this function goes here
%   Detailed explanation goes here

%kernel types:
% 0 -- linear: u'*v
% 1 -- polynomial: (gamma*u'*v + coef0)^degree
% 2 -- radial basis function: exp(-gamma*|u-v|^2)
% 3 -- sigmoid: tanh(gamma*u'*v + coef0)
params=sprintf('-t %d',kernel);
model = svmtrain(labels, data, params);

end

