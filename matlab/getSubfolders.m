function subfolders = getSubfolders(rootFolderName)
	subfolders = dir(rootFolderName);

	if length(subfolders) > 2
		if strcmp(subfolders(1).name, '.') && strcmp(subfolders(2).name, '..')
			subfolders = subfolders(3 : end);
		end
	end
