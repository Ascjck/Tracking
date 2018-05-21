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

% first weight branch
fc8Block = dagnn.Conv('size',[1 1 2048 6],'hasBias',true,'stride',[1,1],'pad',[0,0,0,0]); 
net.addLayer('fc8_1',fc8Block,{'x19'},{'x20_1'},{'fc8_1f','fc8_1b'});
SoftMat_layer9 = dagnn.SoftMax();
net.addLayer('prob_1',SoftMat_layer9,{'x20_1'},{'x21_1'});

% second weight branch
net.addLayer('fc8_2',fc8Block,{'x19'},{'x20_2'},{'fc8_2f','fc8_2b'});
net.addLayer('prob_2',SoftMat_layer9,{'x20_2'},{'x21_2'});

% third weight branch
net.addLayer('fc8_3',fc8Block,{'x19'},{'x20_3'},{'fc8_3f','fc8_3b'});
net.addLayer('prob_3',SoftMat_layer9,{'x20_3'},{'x21_3'});

%fourth weight branch
net.addLayer('fc8_4',fc8Block,{'x19'},{'x20_4'},{'fc8_4f','fc8_4b'});
net.addLayer('prob_4',SoftMat_layer9,{'x20_4'},{'x21_4'});

%fourth weight branch
net.addLayer('fc8_5',fc8Block,{'x19'},{'x20_5'},{'fc8_5f','fc8_5b'});
net.addLayer('prob_5',SoftMat_layer9,{'x20_5'},{'x21_5'});

%initial new layer.
fc8_list = {'fc8_1','fc8_2','fc8_3','fc8_4','fc8_5'};
for i = 1:length(fc8_list)
    layerid = net.getLayerIndex(fc8_list(i));
    p = net.getParamIndex(net.layers(layerid).params) ;
    params = net.layers(layerid).block.initParams();
    params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
    [net.params(p).value] = deal(params{:}) ;
end


% load image
im = imread('peppers.png');  
im_ = single(im);
im_ = imresize(im_,net.meta.normalization.imageSize(1:2));
im_ = gpuArray(im_);

% run the CNN
net.mode = 'test' ;
net.eval({'x0', im_}) ;

% obtain the CNN otuput
prob1 = net.vars(net.getVarIndex('x21_1')).value ;
prob2 = net.vars(net.getVarIndex('x21_2')).value ;
prob3 = net.vars(net.getVarIndex('x21_3')).value ;
prob4 = net.vars(net.getVarIndex('x21_4')).value ;
prob5 = net.vars(net.getVarIndex('x21_5')).value ;

% show the classification results
[bestScore1, weight1] = max(prob1) ;
[bestScore2, weight2] = max(prob2) ;
[bestScore3, weight3] = max(prob3) ;
[bestScore4, weight4] = max(prob4) ;
[bestScore5, weight5] = max(prob5) ;

weight1 = weight1 - 1;
weight2 = weight2 - 1;
weight3 = weight3 - 1;
weight4 = weight4 - 1;
weight5 = weight5 - 1;

disp([bestScore1, weight1]);
disp([bestScore2, weight2]);
disp([bestScore3, weight3]);
disp([bestScore4, weight4]);
disp([bestScore5, weight5]);
