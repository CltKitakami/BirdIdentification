function addBirdNoise(nioseType, snr)

%% Constant
param.AWGN_TYPE = 0;
param.BACKGROUND_NOISE_TYPE = 1;

%% User define parameters
param.inputFolder = '../birdcall';
param.outputFolder = '../output';
param.noiseWav = '../noise/Malaysian_Night_Heron.wav';
param.fileFilter = '*.wav';

param.nioseType = nioseType;
param.snr = snr;

if nargin ~= 2 || ...
	(nioseType ~= param.AWGN_TYPE && nioseType ~= param.BACKGROUND_NOISE_TYPE)
	error(['addBirdNoise(nioseType, snr): ' ...
		'nioseType ' num2str(param.AWGN_TYPE) ' = AWGN, ' ...
		num2str(param.BACKGROUND_NOISE_TYPE) ' = background noise'])
end

param = initializeParam(param);

for ii = 1 : param.numberOfFolders
	param = doEnterFolder(param, ii);

	for jj = 1 : param.numberOfFiles
		param = doEachFile(param, ii, jj);
	end
end

disp(['Output directory is ' param.outputFolder])


function param = initializeParam(param)
	if param.nioseType == param.AWGN_TYPE
		param.outputFolder = fullfile(param.outputFolder, ['awgn_snr_' num2str(param.snr)]);
	elseif param.nioseType == param.BACKGROUND_NOISE_TYPE
		noise = wavread(param.noiseWav);
		noise = noise(:, 1);
		param.noise = repmat(noise, 1000, 1);	% length must big than your signal
		param.outputFolder = fullfile(param.outputFolder, ['background_noise_' num2str(param.snr)]);
	end

	if param.snr == 0
		param.snr = 0.01;
	end

	createDirectoryIfNotExists(param.outputFolder);
	param.subfolders = getSubfolders(param.inputFolder);
	createOutputSubfolders(param.outputFolder, param.subfolders);
	param.numberOfFolders = length(param.subfolders);



function param = doEnterFolder(param, folderIndex)
	param.folderFullPath = fullfile(param.inputFolder, param.subfolders(folderIndex).name);
	param.outSubfolder = fullfile(param.outputFolder, param.subfolders(folderIndex).name);
	param.files = dir(fullfile(param.folderFullPath, param.fileFilter));
	param.numberOfFiles = length(param.files);


function param = doEachFile(param, folderIndex, fileIndex)
	inName = fullfile(param.folderFullPath, param.files(fileIndex).name);
	outName = fullfile(param.outSubfolder, param.files(fileIndex).name);

	[x, fs] = wavread(inName);
	x = x(:, 1);

	if param.nioseType == param.AWGN_TYPE
		x = awgn(x, param.snr);
	elseif param.nioseType == param.BACKGROUND_NOISE_TYPE
		x = addnoise(x, param.noise, param.snr);
	end

	wavwrite(x, fs, outName);

	disp(['- File[' num2str(fileIndex) '/' num2str(param.numberOfFiles)...
		 '] Folder[' num2str(folderIndex) '/' num2str(param.numberOfFolders) ']'])
