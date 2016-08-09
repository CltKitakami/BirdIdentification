function [featureVector] = extractMirFeature(param)

wavFile = param.filePath;
featureVector = zeros(32, 1);
a = miraudio(wavFile);

ed = mireventdensity(a);
zc = mirzerocross(a);
c = mirchromagram(a, 'wrap', 'yes');
mfcc = mirmfcc(a);
rms = mirrms(a);
low = mirlowenergy(a);
roll = mirrolloff(a, 'Threshold');
b = mirbrightness(a);
m = mirmode(a);

featureVector(1) = mirgetdata(ed);
featureVector(2) = mirgetdata(zc);
featureVector(3:15) = mirgetdata(mfcc);
featureVector(16) = mirgetdata(roll);
featureVector(17) = mirgetdata(b);
featureVector(18:29) = mirgetdata(c);
featureVector(30) = mirgetdata(m);
featureVector(31) = mirgetdata(rms);
featureVector(32) = mirgetdata(low);
