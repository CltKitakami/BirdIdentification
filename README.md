# Bird Identification

This repository is the source code for my research in NTUST Interactive Multimedia Lab.

> C. S. Lin, W. W. Hsiung, and M.Y. Liu, "Avian Species Identification in Noisy Environment Using Scaled Time-Frequency Representation," *Int. Conf. on Telecommunications and Signal Processing*, pp. 319-322, Jun. 2016.

## How to use

Change directory to matlab folder and you need [LIBSVM](https://github.com/cjlin1/libsvm).

#### Generate birdcalls with noise
```
addBirdAllNoise()
```

#### Train all
```
autorun()
```

#### Train one
```
trainBirdcall('../output/awgn_snr_-5', featureType)
```

#### Draw waves and patterns figure
```
drawWavesAndPatterns()
```

#### Draw overall accuracy (after training all)
```
drawOverallAccuracy()
```

#### Plot one hitting rate
```
load('../output/tf-original.mat');
disp(param.logText);
plotHitFigure(param)
```


#### Get one compution table
```
load('../output/tf-original.mat');

disp(['Total accuracy: ' num2str(param.accuracy(1)) '% (' ...
	num2str(sum(param.testLabel == param.predictLabel)) '/' ...
	num2str(length(param.testLabel)) ')'])

for ii = 1 : param.numberOfFolders
	for jj = 1 : param.numberOfFolders
		count = param.computionTable{ii}{jj};
		fprintf('%5.1f%-9s ', double(count) * 100, ['(' char(count) ')']);
	end
	fprintf('\n');
end
```
