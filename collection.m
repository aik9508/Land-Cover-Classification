function C=collection(nr,folder,beam)
C=struct('amp',[],'corr',[],'decayrate',[]);
C.amp=readslcs(nr,folder,beam);
C.corr=readcs2(nr/4,folder);
C.decayrate=-fitcurve(C.corr,[1,length(C.corr)],folder);
