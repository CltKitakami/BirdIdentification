function addBirdAllNoise()

snrValues = -5 : 5 : 40;
for ii = 1 : length(snrValues)
	addBirdNoise(0, snrValues(ii));
	addBirdNoise(1, snrValues(ii));
end
