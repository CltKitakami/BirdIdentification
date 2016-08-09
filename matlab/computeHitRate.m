function param = computeHitRate(param)
	numberOfFolders = param.numberOfFolders;
	computionTable = [];
	computionTable{numberOfFolders}{numberOfFolders} = [];
	totalTestSetSize = 0;

	for ii = 1 : numberOfFolders
		inSubfolder = param.subfolderInfo{ii}.folderName;
		testSize = param.subfolderInfo{ii}.testSetSize;
		subLabel = param.predictLabel(totalTestSetSize + 1 : totalTestSetSize + testSize);
		hitCount = length(subLabel(subLabel == ii));
		param.subfolderInfo{ii}.predictLabel = subLabel;
		param.subfolderInfo{ii}.accuracy = hitCount * 100 / testSize;
		totalTestSetSize = totalTestSetSize + testSize;

		disp([inSubfolder ': ' num2str(param.subfolderInfo{ii}.accuracy) ...
			'% (' num2str(hitCount) '/' num2str(testSize) ')'])

		for jj = 1 : numberOfFolders
			count = length(subLabel(subLabel == jj));
			computionTable{ii}{jj} = sym(count / testSize);
		end
	end

	param.computionTable = computionTable;

	disp(['Total accuracy: ' num2str(param.accuracy(1)) '% (' ...
		num2str(sum(param.testLabel == param.predictLabel)) '/' ...
		num2str(length(param.testLabel)) ')'])

	for ii = 1 : numberOfFolders
		for jj = 1 : numberOfFolders
			count = computionTable{ii}{jj};
			fprintf('%5.1f%-9s ', double(count) * 100, ['(' char(count) ')']);
		end
		fprintf('\n');
	end
