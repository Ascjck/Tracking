setup_paths();
%run external_libs/matconvnet/matlab/vl_setupnn 
net_name = 'imagenet-vgg-m-2048';
% load the pre-trained CNN
net = dagnn.DagNN.fromSimpleNN(load(['networks/', net_name])) ;
%gpuDevice(1);
net.move('gpu');

% modify network
net.removeLayer('fc8') ; 
net.removeLayer('prob') ;
fc8Block = dagnn.Conv('size',[1 1 2048 6],'hasBias',true,'stride',[1,1],'pad',[0,0,0,0]); 
net.addLayer('fc8',fc8Block,{'x19'},{'x20'},{'fc8f','fc8b'});
SoftMat_layer9 = dagnn.SoftMax();
net.addLayer('prob',SoftMat_layer9,{'x20'},{'x21'});

%initial new layer.
p = net.getParamIndex(net.layers(20).params) ;
params = net.layers(20).block.initParams();
params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
[net.params(p).value] = deal(params{:}) ;

% load image
im = imread('peppers.png');  
im_ = single(im);
im_ = imresize(im_,net.meta.normalization.imageSize(1:2));
im_ = gpuArray(im_);

% run the CNN
net.mode = 'test' ;
net.eval({'x0', im_}) ;

% obtain the CNN otuput
scores = net.vars(net.getVarIndex('x21')).value ;

% show the classification results
[bestScore, best] = max(scores) ;
disp([bestScore, best]);
% figure(1) ; clf ; imagesc(im) ;
% title(sprintf('%s (%d), score %.5f',...
% net.meta.classes.description{best}, best, bestScore)) ;