import numpy as np
import cmath
import matplotlib.pyplot as plt

f = open('ersdata');
rawdata = np.fromfile(f,dtype=np.uint8)
rawdata = np.reshape(rawdata,(1024,10218))
print(np.shape(rawdata))
rawdata = rawdata[:,412::]
print(np.shape(rawdata))
sigt=(rawdata[:,0::2]-15.5)+1j*(rawdata[:,1::2]-15.5)
sigf=np.fft.fft(sigt,axis=1)
print(sigt[100,100])
print(sigf[100,100])
meansigf=np.mean(sigf,0)
meansigf=20*np.log10(np.abs(meansigf))
x=range(len(meansigf))
plt.plot(x,meansigf)
plt.show()
