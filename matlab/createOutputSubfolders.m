function createOutputSubfolders(outputFolder, subfolders)
	for ii = 1 : length(subfolders)
		subname = subfolders(ii).name;
		outputSubfolder = fullfile(outputFolder, subname);
		createDirectoryIfNotExists(outputSubfolder);
	end
