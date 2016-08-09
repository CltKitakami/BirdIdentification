function drawWavesAndPatterns()

global row;
global col;
row = 2;
col = 3;

waves = { ...
	'../birdcall/chinese_bamboo_partridge/1.wav', ...
	'../birdcall/coal_tit/1.wav', ...
	'../birdcall/green_backed_tit/1.wav', ...
	'../birdcall/malaysian_night_heron/1.wav', ...
	'../birdcall/swinhoes_pheasant/1.wav', ...
	'../birdcall/taiwan_partridge/1.wav' ...
};

titleStr = { ...
	'Chinese bamboo partridge', ...
	'Coal tit', ...
	'Green backed tit', ...
	'Malaysian night heron', ...
	'Swinhoe''s pheasant', ...
	'Taiwan partridge' ...
};


figure
for ii = 1 : 6
	drawStft(waves{ii}, titleStr{ii}, ii)
end
drawColorbar()

figure
for ii = 1 : 6
	plotWav(waves{ii}, titleStr{ii}, ii)
end


function drawColorbar()
global row;
global col;
	pos = get(subplot(row, col, 6), 'Position');
	cbar = colorbar('Position', [pos(1)+pos(3)+0.02 pos(2) 0.02 pos(2)+pos(3)*3.3]);
	ytick = get(cbar, 'YTickLabel');
	ytick = num2str(str2num(ytick) ./ 255, '%.2f');
	ytick(1, 2) = ' ';
	ytick(1, 3) = ' ';
	ytick(1, 4) = ' ';
	set(cbar, 'YTickLabel', ytick)


function plotWav(filePath, titleStr, figureIndex)
global row;
global col;
	subplot(row, col, figureIndex)
	[x fs] = wavread(filePath);
	x = x(:, 1); % mono channel
	t = [1 : length(x)] / fs;
	plot(t, x)
	xlabel('Time(sec)')
	ylabel('Amplitude')
	set(gca, 'YLim', [-0.6 0.6])
    set(gca, 'YTick', [-0.6 -0.3 0 0.3 0.6])
	set(gca, 'XLim', [0 t(end)])
	title(titleStr)


function drawStft(filePath, titleStr, figureIndex)
global row;
global col;
	param.filePath = filePath;
	[featureVector] = extractStftFeature(param);
	im = reshape(featureVector, 64, 4);
	subplot(row, col, figureIndex)
	imagesc(1:4, 1:64, im)
	axis xy; axis tight; colormap(jet);
	set(gca,'YLim',[1 64])
	set(gca,'XLim',[.5 4.5])
	set(gca,'YTick', [1 10:10:60 64])
	set(gca,'XTickLabel',{'1';'2';'3';'4'})
	set(gca,'YTickLabel',{'0';'10';'20';'30';'40';'50';'60';'64'})
	title(titleStr)
