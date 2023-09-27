import logging
from datetime import datetime

from sen2chain import Tile
from sen2change import CVAProduct
import fileinput
import os
from s1chain import DownloadProcess
from s1chain import MultiTempFiltering
from s1chain import NDRProcessing

def nearest(items, pivot):
     return min(items, key=lambda x: abs(x - pivot))


def run_sen2chain(tiles,
                  start,
                  end,
                  indices):

        #Sen2chain
        Tile(tiles).get_l1c(provider="peps", start= start, end= end, download=True)
        Tile(tiles).compute_l2a(nb_proc=7)
        Tile(tiles).compute_cloudmasks()
        Tile(tiles).compute_indices(indices)

        #Sen2Change
        list_date = Tile(tiles).l2a.dates
        start_date_format = datetime.strptime(start, '%Y-%m-%d')
        end_date_format = datetime.strptime(end, '%Y-%m-%d')
        start_near = str(nearest(list_date,start_date_format).date())
        end_near = str(nearest(list_date, end_date_format).date())
        identifier_before = Tile(tiles).l2a.filter_dates(date_min=start_near, date_max=start_near).products[0].replace(".SAFE", "")
        identifier_after = Tile(tiles).l2a.filter_dates(date_min=end_near, date_max=end_near).products[0].replace(".SAFE", "")

        identifier = identifier_before + "-" + identifier_after
        cva = CVAProduct(identifier)
        cva.initialize()
        cva.computeCVA()
        cva.computeClassif()
        cva.computeSeuillageMagnitude()
        cva.computeCloudMaskClassif()
        cva.computeReclassif()
        print("ok")

def run_s1chain(tiles,
                start,
                end):


            t = DownloadProcess(tile=tiles, first_date=start,last_date=end)
            t.update_config()
            t.s1tiling()
            logging.info("Download and Tiling OK")
            MultiTempFiltering(tile=tiles, first_date=start,last_date=end)
            logging.info("Filtering OK")
            NDRProcessing(tile=tiles,
                          filter_maj=3,
                          ref_date="2017-02-22",
                          first_date=start,
                          last_date=end)
            logging.info("NDR Processing OK")

# start = "2023-01-01"
# end = "2023-01-10"
# start_date_format = datetime.strptime(start, '%Y-%m-%d')
# end_date_format = datetime.strptime(end, '%Y-%m-%d')
#
# def nearest(items, pivot):
#     return min(items, key=lambda x: abs(x - pivot))
#
# list_date = Tile("38LRL").l2a.dates
#
# start_near = nearest(list_date,start_date_format)
# end_near = nearest(list_date, end_date_format)
# s_n = str(start_near.date())
# e_n = str(end_near.date())
#
# identifier_before = Tile("38LRL").l2a.filter_dates(date_min = s_n, date_max = s_n).products[0].replace(".SAFE","")
# identifier_after = Tile("38LRL").l2a.filter_dates(date_min = e_n, date_max = e_n).products[0].replace(".SAFE","")
#
# identifier = '"'+identifier_before+"-"+identifier_after+'"'
# print(identifier)

# list_tiles = "38KLA"
# start_date = "2023-03-08"
# end_date = "2023-03-10"
#
#
# run_s1chain(tiles= "38LRL",
#           start = start_date,
#           end =  end_date)
#
#
tiles = "38KQB"
start="2023-02-15"
end = "2023-02-28"
# start="2023-03-11"
#end2 = "2023-03-13"
t = DownloadProcess(tile=tiles, first_date=start,last_date=end)
#t.update_config()
NDRProcessing(tile=tiles,
                          filter_maj=3,
                          ref_date="2023-02-15",
                          first_date=start,
                          last_date=end,merge=True)

# # #
# # # #
# # #
#Tile(tiles).get_l1c(provider="peps", start= start, end= end, download=False)
# # Tile(tiles).compute_l2a(nb_proc=7)
# # Tile(tiles).compute_cloudmasks()
# # Tile(tiles).compute_indices(["NDVI","NDWIGAO","BIGR"])
#
# #sen2chain
# identifier = "S2B_MSIL2A_20171225T071209_N0206_R020_T38KND_20171225T102551-S2A_MSIL2A_20180129T071211_N0206_R020_T38KND_20180129T104706"
# cva = CVAProduct(identifier)
# cva.initialize()
# cva.computeCVA()
# cva.computeClassif()
# cva.computeSeuillageMagnitude()
# cva.computeCloudMaskClassif()
# cva.computeReclassif()

# t = DownloadProcess(tile=tiles, first_date=start,last_date=end)
# t.update_config()
# t.s1tiling()
# #logging.info("Download and Tiling OK")
# MultiTempFiltering(tile=tiles, first_date=start,last_date=end2,orbi="DES")
# # #logging.info("Filtering OK")
# NDRProcessing(tile=tiles,
#               filter_maj=3,
#               ref_date="2022-12-06",
#               first_date="2022-12-06",
#               last_date="2023-03-12",
#               merge=True)
# # # logging.info("NDR Processing OK")



# #Majoritary filter
# import rasterio
#
# import numpy as np
#
# from scipy import signal
#
#
# tci_38LPH = rasterio.open("/home/florent/sen2change_data/data/CVA/39LTF/S2B_MSIL2A_20221126T070159_N0400_R120_T39LTF_20221126T083240/S2B_MSIL2A_20230115T070159_N0509_R120_T39LTF_20230115T082617/CVA3D_S2B_MSIL2A_20221126T070159_N0400_R120_T39LTF_20221126T083240-S2B_MSIL2A_20230115T070159_N0509_R120_T39LTF_20230115T082617_classif_CM004_CSH1_CMP1_CHP1_TCI1_ITER5_SM_CM_RC.jp2")
# t = tci_38LPH.read(1)
