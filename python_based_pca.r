import numpy as np
from sklearn.decomposition import PCA
import pandas as pd
import os
import matplotlib.pyplot as plt
import numpy as np

#read in file

xx = pd.read_csv("Survey_new.csv")

#create pca f object
pca = PCA()

#determine shape
xnn.shape

##select columns of interest
xnn = xx.iloc[:, 2:874]


#drop a bad column
xnn = xnn.drop('s2', 1)

#fit PCA
fit = pca.fit(xnn)

#grab components into a separate object
PCs = pca.components_

#analyze explained var by component
print(pca.explained_variance_ratio_)


#create explained variance plot
fig = plt.figure(figsize=(20, 20))
y_pos = range(0,len(pca.explained_variance_ratio_-1))
plt.bar(left=y_pos, height = pca.explained_variance_ratio_, width = 0.8)



#generate my favorite first two dimension plots
fig = plt.figure(figsize=(15, 15))
plt.scatter(PCs[0, :], PCs[1, :])

#add labels if.. relevant
feature_names = np.arange(PCs.shape[1])
for i,j,z in zip(PCs[1,:]+0.01, PCs[0,:]+0.01, xnn.columns):
    plt.text(j, i, z, ha='center', va='center')


#circle, if you like it
circle = plt.Circle((0,0), 1, facecolor='none', edgecolor='b')
plt.gca().add_artist(circle)

#equal axis
plt.axis('equal')


# Label axes
plt.xlabel('PC 0')
plt.ylabel('PC 1')

# Done
plt.show()






import time as time
import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
from sklearn.cluster import AgglomerativeClustering
from sklearn.datasets.samples_generator import make_swiss_roll

from sklearn.cluster import SpectralClustering

X = PCs

# #############################################################################
# Compute clustering
print("Compute unstructured hierarchical clustering...")
st = time.time()
ward = SpectralClustering(n_clusters=8).fit(X)
elapsed_time = time.time() - st
label = ward.labels_
print("Elapsed time: %.2fs" % elapsed_time)
print("Number of points: %i" % label.size)

# #############################################################################
# Plot result
fig = plt.figure()
ax = p3.Axes3D(fig)
ax.view_init(7, -80)
for l in np.unique(label):
    ax.scatter(X[label == l, 0], X[label == l, 1], X[label == l, 2],
               color=plt.cm.jet(np.float(l) / np.max(label + 1)),
               s=20, edgecolor='k')
plt.title('Without connectivity constraints (time %.2fs)' % elapsed_time)


from sklearn.metrics import pairwise_distances
from sklearn import datasets
from sklearn import metrics
metrics.silhouette_score(X, label, metric='euclidean')

for i in range(2, 25):
    ward = KMeans(n_clusters=i).fit(X)
    elapsed_time = time.time() - st
    label = ward.labels_
    xx = metrics.silhouette_score(X, label, metric='euclidean')
    print(xx)
