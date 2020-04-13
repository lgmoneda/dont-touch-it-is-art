import numpy as np
import time

from PIL import Image
from numpy import asarray
from sklearn.cluster import KMeans


def get_closest_color(color, colors_from_color, colors, norm=True):
    true_colors = colors
    if norm:
        colors = colors - np.mean(colors, axis=0)
        color = color - np.mean(colors_from_color, axis=0)
    return true_colors[np.argmin(np.sum(np.power(np.subtract(color, colors), 2), axis=1))]

def replace_colors(image, color_remap, unique_colors):
    print("Color replacing")
    for i in range(len(unique_colors)):
        if i % 10000 == 0:
            print(float(i) / len(unique_colors))

        image = np.where(image == unique_colors[i],
                         color_remap[i],
                         image)

    return Image.fromarray(image)

def quantization(n_colors, image):
    model = KMeans(n_clusters=n_colors)
    print("Fit")
    model = model.fit(image.reshape(-1, 3))

    print("Predict")
    prediction = model.predict(image.reshape(-1, 3))

    flatten = image.reshape(-1, 3)
    unique_colors = np.unique(flatten, axis=0)
    centers = np.array([get_closest_color(model.cluster_centers_[i],
                                          unique_colors,
                                          unique_colors) for i in range(n_colors)])

    print("Replace")
    result = np.array([centers[i] for i in prediction])
    result = result.reshape(image.shape)
    result = result.astype("uint8")

    return result


first_painting = Image.open("bedroom.jpg")
second_painting = Image.open("the_scream.jpg")

first_painting = asarray(first_painting)
second_painting = asarray(second_painting)

N_COLORS = 32

print("Quantization")
first_painting = quantization(N_COLORS, first_painting)
second_painting = quantization(N_COLORS, second_painting)

unique_colors = []
for painting in [first_painting, second_painting]:
    flatten = painting.reshape(-1, 3)
    unique_colors.append(np.unique(flatten, axis=0))

print("Color remap")
color_remap_first = {i: get_closest_color(unique_colors[0][i],
                                          unique_colors[0],
                                          unique_colors[1]) for i in range(len(unique_colors[0]))}
color_remap_second = {i: get_closest_color(unique_colors[1][i],
                                           unique_colors[1],
                                           unique_colors[0]) for i in range(len(unique_colors[1]))}

timestamp = int(time.time())
second_painting = replace_colors(second_painting, color_remap_second, unique_colors[1])
second_painting.save(str(timestamp) + "_second.jpg")

first_painting = replace_colors(first_painting, color_remap_first, unique_colors[0])
first_painting.save(str(timestamp) + "_first.jpg")
