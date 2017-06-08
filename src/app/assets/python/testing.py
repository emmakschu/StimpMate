import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

xVals = np.arange(0,10,0.2)
yVals = [np.cos(t) for t in xVals]

image = plt.plot(xVals, yVals, 'k--')

fileLoc = '/var/www/public_html/golf.mkschumacher.com/golfApp/app/assets/images/graph.png'
plt.savefig(fileLoc, dpi=150)
