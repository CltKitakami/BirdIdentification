function createDirectoryIfNotExists(dirPath)
	if ~isdir(dirPath)
		mkdir(dirPath);
	end
