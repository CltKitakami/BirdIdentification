% function [featureVector] = extractFeature(param)
%   param.wavFile - WAV file path
%   featureVector - Feature vector
%
%   Flow chart:
%     wavread
%   ->STFT transform
%   ->threshold operation
%   ->stftNormalize to 0 ~ 1
%   ->return 1D featureVector

function [featureVector] = extractStftFeature(param)

if isfield(param, 'filePath') == 0
	error('Please set filePath.');
end

wavFile = param.filePath;

[x fs] = wavread(wavFile);
x = x(:, 1); % mono channel

[data, thresholdData] = stftTransform(x);

featureVector = getFeatureVector(thresholdData);


function [featureVector] = getFeatureVector(data)
	im = im2uint8(data);
	im = imresize(im, [64 4]);
	featureVector = reshape(im, numel(im), 1);


function [data, thresholdData] = stftTransform(signal)
	nConstant = 1;
	TFwindow = 512;
	TFoverlap = TFwindow / 2;
	nfft = pow2(nextpow2(length(signal)));
	dummyFs = 44100;
	data = abs(stft(signal, TFwindow, TFoverlap, nfft, dummyFs));
	thresholdData = stftNormalize(doThreshold(data, nConstant));


function [thresholdData] = doThreshold(data, nConstant)
	rowData = reshape(data, numel(data), 1);
	meanData = mean(rowData);
	stdData = std(rowData);
	threshold = meanData + stdData * nConstant;
	thresholdData = data;
	thresholdData(thresholdData < threshold) = 0;


function [normalizedData] = stftNormalize(data)
	rowData = reshape(data, numel(data), 1);
	minData = min(rowData);
	maxData = max(rowData);

	if minData ~= maxData
		normalizedData = (data - minData) / (maxData - minData);
	else
		normalizedData = data;
	end
