function drawOverallAccuracy()

global outputFolder;
outputFolder = '../output';

snrValues = -5 : 5 : 40;
numOfSnr = length(snrValues);
xAxis = 1 : numOfSnr;

[awgnSnrHitRates, snrValueStr] = bindSnrHitRates(snrValues, 'awgn_snr');
[bgSnrHitRates, snrValueStr] = bindSnrHitRates(snrValues, 'background_noise');

figure
hold on
plot(xAxis, awgnSnrHitRates(1 : numOfSnr, :), 'xk-',...
	xAxis, awgnSnrHitRates(numOfSnr + 1 : 2 * numOfSnr, :), 'ob-')
plot(xAxis, bgSnrHitRates(1 : numOfSnr, :), 'sk-', ...
	xAxis, bgSnrHitRates(numOfSnr + 1 : 2 * numOfSnr, :), '.b-')
hold off

plotAttributes(numOfSnr, snrValueStr);
legend('MIR with AWGN', 'STFT with AWGN', ...
	'MIR with background noise', 'STFT with background noise')


function [allSnrHitRates, snrValueStr] = bindSnrHitRates(snrValues, typeStr)
global outputFolder;
	numOfSnr = length(snrValues);
	allSnrHitRates = zeros(numOfSnr * 2, 1);

	for ii = 1 : numOfSnr
		snrValueStr{ii} = num2str(snrValues(ii));
		formatName = ['-' typeStr '_' snrValueStr{ii} '.mat'];
		allSnrHitRates(ii, :) = getHitRates([outputFolder '/m' formatName]);
		allSnrHitRates(ii + numOfSnr, :) = getHitRates([outputFolder '/tf' formatName]);
	end


function plotAttributes(numOfXTicks, xTickLabel)
	set(gca, 'YLim', [0 110])
	set(gca, 'YTick', 0 : 20 : 100)
	set(gca, 'XTick', 1 : numOfXTicks)
	set(gca, 'XTickLabel', xTickLabel)
	xlabel('SNR (dB)')
	ylabel('Overall accuracy (%)')


function hitRates = getHitRates(mat)
	load(mat);
	hitRates = param.accuracy(1);
