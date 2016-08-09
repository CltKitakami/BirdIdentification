function trainBirdcall(inputFolder, featureType)

%% Constant
param.MUSIC_FEATURE = 0;
param.TF_FEATURE = 1;

%% User define parameters
param.defaultInputFolder = '../birdcall';
param.defaultFeatureType = param.TF_FEATURE;
param.outputFolder = '../output';
param.fileFilter = '*.wav';
param.traningPercentage = 0.50;
param.libsvmCmd = '-s 0 -t 0 -q';


param.inputFolder = param.defaultInputFolder;
param.featureType = param.defaultFeatureType;


if nargin > 0
	param.inputFolder = inputFolder;
end

if nargin > 1
	param.featureType = featureType;
end

param = initializeParam(param);

for ii = 1 : param.numberOfFolders
	param = doEnterFolder(param, ii);

	for jj = 1 : param.subfolderInfo{ii}.dataSetSize
		param = doEachFile(param, ii, jj);
	end

	param = doLeaveFolder(param, ii);
end

finalize(param);


function param = initializeParam(param)
	mirverbose(0);
	mirwaitbar(0);

	param.traningLabel = [];
	param.traningVector = [];

	param.testLabel = [];
	param.testVector = [];

	createDirectoryIfNotExists(param.outputFolder);
	param.subfolders = getSubfolders(param.inputFolder);

	param.numberOfFolders = length(param.subfolders);
	param.subfolderInfo = [];
	param.subfolderInfo{param.numberOfFolders} = SubfolderInfo();


function param = doEnterFolder(param, folderIndex)
	param.traningFolder = fullfile(param.defaultInputFolder, param.subfolders(folderIndex).name);
	param.folderFullPath = fullfile(param.inputFolder, param.subfolders(folderIndex).name);
	param.files = dir(fullfile(param.folderFullPath, param.fileFilter));
	param.subfolderInfo{folderIndex} = SubfolderInfo();
	param.subfolderInfo{folderIndex}.folderName = param.subfolders(folderIndex).name;
	param.subfolderInfo{folderIndex}.files = param.files;
	param.subfolderInfo{folderIndex}.dataSetSize = length(param.files);
	param.classVector = [];


function param = doEachFile(param, folderIndex, fileIndex)
	dataSetSize = param.subfolderInfo{folderIndex}.dataSetSize;
	disp(['- File[' num2str(fileIndex) '/' num2str(dataSetSize)...
		 '] Folder[' num2str(folderIndex) '/' num2str(param.numberOfFolders) ']'])

	if fileIndex <= fix(dataSetSize * param.traningPercentage)
		param.filePath = fullfile(param.traningFolder, param.files(fileIndex).name);
	else
		param.filePath = fullfile(param.folderFullPath, param.files(fileIndex).name);
	end

	if param.featureType == param.MUSIC_FEATURE
		param.classVector(fileIndex, :) = extractMirFeature(param);
	elseif param.featureType == param.TF_FEATURE
		param.classVector(fileIndex, :) = extractStftFeature(param);
	else
		error(['Unknow featureType = ' num2str(param.featureType)])
	end


function param = doLeaveFolder(param, folderIndex)
	dataSetSize = length(param.files);
	traningSize = fix(dataSetSize * param.traningPercentage);
	testSize = dataSetSize - traningSize;
	param.subfolderInfo{folderIndex}.testSetSize = testSize;
	disp(['#Train / #Test: ' num2str(traningSize) ' / ' num2str(testSize)])

	param.traningLabel = [param.traningLabel; repmat(folderIndex, traningSize, 1)];
	param.traningVector = [param.traningVector; param.classVector(1 : traningSize, :)];

	param.testLabel = [param.testLabel; repmat(folderIndex, testSize, 1)];
	param.testVector = [param.testVector; param.classVector(end - testSize + 1 : end, :)];


function param = dataSetZscore(param)
	[param.traningVector means stds] = zscore(param.traningVector);
	testSize = length(param.testLabel);
	means = repmat(means, testSize, 1);
	stds = repmat(stds, testSize, 1);
	param.testVector = (param.testVector - means) ./ (stds + eps);


function param = tryBestSvmModel(param)
	best = 0;
	bestCost = 1;

	for log2c = -1.1 : 3.1,
		crossValidationAccuracy = svmtrain(param.traningLabel, param.traningVector, ...
			[param.libsvmCmd ' -v 2 -c ' num2str(2 ^ log2c)]);

		if (crossValidationAccuracy >= best)
			best = crossValidationAccuracy;
			bestCost = 2 ^ log2c;
		end
	end

	param.libsvmCmd = [param.libsvmCmd ' -c ' num2str(bestCost)];
	param.model = svmtrain(param.traningLabel, param.traningVector, param.libsvmCmd);
	[param.predictLabel, param.accuracy, param.estimates] = ...
		svmpredict(param.testLabel, param.testVector, param.model);
	% accuracy: a vector with accuracy, mean squared error, squared correlation coefficient.


function saveResults(param)
	[dump, folderName] = fileparts(param.inputFolder);
	featureTypeStr = { 'm-', 'tf-' };
	saveResultPath = fullfile(param.outputFolder, ...
		[featureTypeStr{param.featureType + 1} folderName '.mat']);
	save(saveResultPath, 'param');
	disp(['Save ' saveResultPath])


function finalize(param)
	if param.featureType == param.MUSIC_FEATURE
		param = dataSetZscore(param);
	end

	param = tryBestSvmModel(param);
	[logText param] = evalc('computeHitRate(param)');
	param.logText = logText;
	saveResults(param);
	plotHitFigure(param)
