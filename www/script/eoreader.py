import os
import matplotlib.pyplot as plt

# EOReader
import rasterio
from rasterio.enums import Resampling

post_b8 = rasterio.open('/home/florent/sen2chain_data/data/L2A/38KQE/S2B_MSIL2A_20221027T070159_N0400_R120_T38KQE_20221027T083155.SAFE/GRANULE/L2A_T38KQE_A029461_20221027T070201/IMG_DATA/R10m/T38KQE_20221027T070159_B08_10m.jp2')
post_b12 = rasterio.open('/home/florent/sen2chain_data/data/L2A/38KQE/S2B_MSIL2A_20221027T070159_N0400_R120_T38KQE_20221027T083155.SAFE/GRANULE/L2A_T38KQE_A029461_20221027T070201/IMG_DATA/R20m/T38KQE_20221027T070159_B12_20m.jp2')

pre_b8 = rasterio.open('/home/florent/sen2chain_data/data/L2A/38KQE/S2A_MSIL2A_20221002T070211_N0400_R120_T38KQE_20221002T121959.SAFE/GRANULE/L2A_T38KQE_A038012_20221002T070209/IMG_DATA/R10m/T38KQE_20221002T070211_B08_10m.jp2')
pre_b12 = rasterio.open('/home/florent/sen2chain_data/data/L2A/38KQE/S2A_MSIL2A_20221002T070211_N0400_R120_T38KQE_20221002T121959.SAFE/GRANULE/L2A_T38KQE_A038012_20221002T070209/IMG_DATA/R20m/T38KQE_20221002T070211_B12_20m.jp2')

# array_post_b8 = post_b8.read(1)
# array_post_b12= post_b12.read(1)
# array_pre_b8= pre_b8.read(1)
# array_pre_b12 = pre_b12.read(1)
#

upscale_factor = 2
with rasterio.open('/home/florent/sen2chain_data/data/L2A/38KQE/S2B_MSIL2A_20221027T070159_N0400_R120_T38KQE_20221027T083155.SAFE/GRANULE/L2A_T38KQE_A029461_20221027T070201/IMG_DATA/R20m/T38KQE_20221027T070159_B12_20m.jp2') as dataset:

    # resample data to target shape
    data = dataset.read(
        out_shape=(
            dataset.count,
            int(dataset.height * upscale_factor),
            int(dataset.width * upscale_factor)
        ),
        resampling=Resampling.bilinear
    )

    # scale image transform
    transform = dataset.transform * dataset.transform.scale(
        (dataset.width / data.shape[-1]),
        (dataset.height / data.shape[-2])
    )


    from matplotlib import pyplot

    pyplot.imshow(data, cmap='pink')
    pyplot.show()
