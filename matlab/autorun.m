function autorun()

outputFolder = '../output';
folders = getSubfolders(outputFolder);

trainTwoFeatureExtrator('../birdcall')

for ii = 1 : length(folders)
	close all
	folderPath = [outputFolder '/' folders(ii).name];
	[dump, folderName, ext] = fileparts(folderPath);

	if strcmp(ext, '')
		disp(['# processing ' folderName])
		trainTwoFeatureExtrator(folderPath)
	end
end

function trainTwoFeatureExtrator(folderPath)
	trainBirdcall(folderPath, 0);
	trainBirdcall(folderPath, 1);
