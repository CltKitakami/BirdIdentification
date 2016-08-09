function plotHitFigure(param)
	figure
	xAxis = [1 : length(param.testLabel)];
	plot(xAxis, param.testLabel, 'b.', xAxis, param.predictLabel, 'ro')
	legend('Ground truth', 'Prediction genre')
	featureTypeStr = { '32 Feature: ', 'TF: ' };
	title([featureTypeStr{param.featureType + 1} param.inputFolder])

	set(gca, 'XLim', [1 xAxis(end)])
	set(gca, 'YLim', [1 param.numberOfFolders])
	xlabel(['Number of samples (grouped by Genres)'])
	ylab = ylabel('Genres');
	set(ylab, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);

	set(gca, 'YTick', 1 : param.numberOfFolders, 'YTickLabel', [])
	yTicks = get(gca, 'YTick');
	horizontalOffset = 0.1;
	ax = axis;

	for ii = 1 : length(yTicks)
		text(ax(1) - horizontalOffset, yTicks(ii), ...
			['$BS_' num2str(yTicks(ii)) '$'], ...
			'HorizontalAlignment', 'Right', ...
			'FontSize', 12, ...
			'interpreter', 'latex');
	end

