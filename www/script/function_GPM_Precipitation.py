import geopandas as gpd
import pandas as pd
import os
import xarray as xr
import numpy as np
from geocube.api.core import make_geocube
import fiona
import rasterio as rio
from rasterio import mask
import matplotlib.pyplot as plt
import wget
import zipfile
import re
import datetime
import logging
import glob
import netCDF4


def download_IBTraACS(out_dir):
    output_directory = out_dir
    urls = ['https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.SI.list.v04r00.lines.zip',
            'https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.SI.list.v04r00.points.zip']



    for url in urls:
        filename = output_directory + '/' + os.path.basename(url) # get the full path of the file
        if os.path.exists(filename):
            os.remove(filename) # if exist, remove it directly
        wget.download(url, out=output_directory) # download it to the specific path.
        #Unzip folder
        with zipfile.ZipFile(filename, 'r') as zip_ref:
            zip_ref.extractall(output_directory)
        #Mada buffer
        mada = gpd.read_file("/home/florent/PycharmProjects/ShinyApp/data/cyclones/buffer_mada.shp")
        #Fix to shape file (replace zip character by shp)
        filename_shp = re.sub("zip", "", filename)+"shp"
        shapefile = gpd.read_file(filename_shp)
        shapefile["new_id"] = shapefile.SID


        if "lines" in filename_shp:
            shapefile_merge = shapefile.dissolve(by='new_id')
            shapefile_filter = shapefile_merge.loc[((shapefile_merge["year"] == 2015) & (shapefile_merge["month"] > 6)) | (shapefile_merge["year"] > 2015) ]
            intersect = gpd.overlay(shapefile_filter, mada, how = 'intersection')
            cycl_mada = shapefile_filter.loc[shapefile_filter["SID"].isin(intersect["SID"])]


        else :
            line = gpd.read_file(re.sub("points.zip", "", filename)+"lines_Mada_2015_present.shp")
            shapefile_filter = shapefile.loc[((shapefile["year"] == 2015) & (shapefile["month"] > 6)) | (shapefile["year"] > 2015)]
            cycl_mada = shapefile_filter.loc[shapefile_filter["SID"].isin(line["SID"])]


            #Convert wind to km/h
            cycl_mada.loc[np.isnan(cycl_mada["REU_WIND"]) == False , "wind_kmh"] = cycl_mada["REU_WIND"]*1.852
            cycl_mada.loc[np.isnan(cycl_mada["REU_WIND"]) == True, "wind_kmh"] = cycl_mada["USA_WIND"] * 1.852

            #Convert category
            cycl_mada.loc[cycl_mada["USA_SSHS"] == -5, "category_t"] = "Unknown"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == -4, "category_t"] = "Post-tropical"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == -3, "category_t"] = "Miscellaneous disturbance"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == -2, "category_t"] = "Subtropical"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == -1, "category_t"] = "Tropical Depression (TD)"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 0, "category_t"] = "Tropical Storm (TS)"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 1, "category_t"] = "Category 1"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 2, "category_t"] = "Category 2"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 3, "category_t"] = "Category 3"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 4, "category_t"] = "Category 4"
            cycl_mada.loc[cycl_mada["USA_SSHS"] == 5, "category_t"] = "Category 5"

            # make txt file with name of cyclone and start/end date
            groupby = cycl_mada.groupby(by="SID")
            dataframe = pd.DataFrame()
            for name, value in groupby:
                data = [[np.unique(value.NAME)[0], min(value.ISO_TIME)[:10], max(value.ISO_TIME)[:10]]]
                df1 = pd.DataFrame(data, columns=["name", "start", "end"])
                dataframe = pd.concat([dataframe, df1])

            dataframe.to_csv(output_directory + "/" + "name_date_cyclone.txt", header=True, index=None)

        #Export
        cycl_mada.to_file(re.sub(".zip", "", filename)+"_Mada_2015_present.shp")

#download_IBTraACS(out_dir="/home/florent/PycharmProjects/ShinyApp/data/cyclones")



def download_netcdf_GPM(IBTraACS_path_line="/home/florent/PycharmProjects/ShinyApp/data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp",
                        text_output_file="/home/florent/PycharmProjects/ShinyApp/data/GPM_netcdf/",
                        lon_extent="2186:2341",
                        lat_extent="621:832",
                        user_EarthData="veillon.florent@yahoo.com",
                        pwd_EarthData="Flodor42800"):
    """
    Construction d'un fichier texte avec les adresses de chaque raster de pluie pour les dates séléctionnées
    et téléchargement
    :param IBTraACS_path_line: path of line IBTraAcs .shp
    :param text_output_file: path of output text after generate
    :param lon_extent: longitude of rectangle extent
    :param lat_extent: latitude of rectangle extent
    :param user_EarthData: id of EarthData account (email)
    :param pwd_EarthData: password of EarthData account
    :return: txt file with web addresses of netcdf file
    """

    # Lecture du fihcier IBTraAcs
    shapefile = gpd.read_file(IBTraACS_path_line)
    #Création d'un df vide
    date = pd.DataFrame(columns=['time'])
    #Remplissage du nouveau df avec les dates de chaque cyclone
    date["time"] = shapefile.ISO_TIME.str.split(" ", expand=True).iloc[:, 0]
    #Liste de toutes les dates à télécharger
    list_date = pd.unique(date.time)

    #Création d'un fichier texte vide
    f = open(text_output_file + "netcdf_download_file.txt", "w+")
    #Remplissage du fihcier avec les adresses de chaque netcdf pour chaque date
    for i in range(len(list_date)):
        date_tiret = list_date[i]
        date_selected = date_tiret.replace("-", "")
        date_split = date_tiret.split("-")
        year_selected = date_split[0]
        month_selected = date_split[1]
        f.write(
            "https://gpm1.gesdisc.eosdis.nasa.gov:443/opendap/GPM_L3/GPM_3IMERGDE.06/" + year_selected + "/" + month_selected + "/3B-DAY-E.MS.MRG.3IMERG." + date_selected + "-S000000-E235959.V06.nc4.nc?precipitationCal[0:0][2186:2341][621:832],time,lon[" + lon_extent + "],lat[" + lat_extent + "] \n")
    #Fermeture du fichier txt
    f.close()
    #Wget du fichier texte : téléchargement de chaque netcdf
    os.chdir(text_output_file)
    os.system(
        "wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition -i " +
        text_output_file + "netcdf_download_file.txt --user " + user_EarthData + " --password " + pwd_EarthData)

#download_netcdf_GPM()

def netcdf_cumul_precipitation_times_series(netcdf_output="/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/",
                               IBTraACS_path_line="/home/florent/PycharmProjects/ShinyApp/data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp",
                               area_boundaries="/home/florent/PycharmProjects/ShinyApp/data/mada_shp/mdg_admbnda_adm0_BNGRC_OCHA_20181031.shp",
                               area2_boundaries ="/home/florent/PycharmProjects/ShinyApp/data/mada_shp/mdg_admbnda_adm2_BNGRC_OCHA_20181031.shp",
                               name_hurricane="FREDDY"):

    """
    Construit un raster des cumuls de précipitations sur la durée du cyclone
    :param netcdf_output: path of netcdf
    :param IBTraACS_path_line: path of line IBTraAcs .shp
    :param area_boundaries: path of shape of global boudaries area
    :param area2_boundaries : path of shape of provinces boudaries area
    :param name_hurricane: name of hurricane choosen
    :return: cumul precipitation raster
    """
    print(name_hurricane)
    #Lecture du fihcier IBTraAcs
    shapefile = gpd.read_file(IBTraACS_path_line)
    #Création d'une liste contenant tout les noms des cyclones
    name = shapefile[shapefile.NAME == name_hurricane]
    list_date = pd.unique(name.ISO_TIME.str.split(" ", expand=True).iloc[:, 0]).tolist()
    date = [w.replace('-', '') for w in list_date]

    #Création d'une liste contenant les non des fichiers pour chaque date concernées par le cyclone
    liste_netcdf = []
    for d in date:
        dir_path = r''+netcdf_output+"*"+d+"*.nc"
        res = glob.glob(dir_path)
        for r in res :
            liste_netcdf.append(r)

    #ouverture des netcdf et transformation en df
    dataset = xr.open_mfdataset(liste_netcdf)
    df = dataset.to_dataframe()
    df_reformate = df.dropna().reset_index()
    crop_df_reformate = df_reformate[(df_reformate["lat"] > -25.67936494390249) & (df_reformate["lat"] < -11.497662454831802) & (df_reformate["lon"] > 41.83664491776657) & (df_reformate["lon"] < 51.51450171619917)]
    #Formation de groupe en fonction de la position de chaque pixel et calcul de la somme de chaque pixel
    df_groupby = crop_df_reformate.groupby(by=["lon", "lat"]).sum()
    final_df = df_groupby.dropna().reset_index()
    #Transformation en geodataframe
    gdf = gpd.GeoDataFrame(final_df, geometry=gpd.points_from_xy(final_df.lon, final_df.lat))

    #gdf.replace(0, np.nan, inplace=True)
    #Transformation en raster et exportation
    out_grid = make_geocube(vector_data=gdf, measurements=["precipitationCal"],
                            resolution=(-0.1, 0.1))  # for most crs negative comes first in resolution
    out_grid["precipitationCal"].rio.to_raster(netcdf_output + "cumul_precipitation_raster_nocrop_"+min(date)+"_"+max(date)+"_"+name_hurricane+".tif")

    #Subset du raster en fonction de la géometrie de Mada
    with fiona.open(area_boundaries, "r") as shapefile:
        shapes = [feature["geometry"] for feature in shapefile]
    #Ouverture du raster de précipitation non découpée
    with rio.open(netcdf_output + "cumul_precipitation_raster_nocrop_"+min(date)+"_"+max(date)+"_"+name_hurricane+".tif") as src:
        out_image, out_transform = rio.mask.mask(src, shapes, crop=True, all_touched=True)
        out_meta = src.meta
    #Découpage du raster
    out_meta.update({"driver": "GTiff",
                     "height": out_image.shape[1],
                     "width": out_image.shape[2],
                     "transform": out_transform})
    #export
    with rio.open(netcdf_output + "cumul_precipitation_raster_crop_"+min(date)+"_"+max(date)+"_"+name_hurricane+".tif", "w", **out_meta) as dest:
        dest.write(out_image)

    # #Times series
    # #Import des limites administratives de madagsacar (niv 2)
    mada2_shp = gpd.read_file(area2_boundaries)
    #Transformation en geodf de la couche des netcdf (df)
    gdf_ts = gpd.GeoDataFrame(crop_df_reformate, geometry=gpd.points_from_xy(crop_df_reformate.lon, crop_df_reformate.lat))
    print(gdf_ts)
    #Fixation du système de projection
    gdf_ts_reproject = gdf_ts.set_crs('epsg:4326')
    print("ok4")
    #Intersection entre les limites admin de mada et les netcdf
    subset_ts = gpd.overlay(gdf_ts_reproject, mada2_shp, how='intersection')
    # Calcul du cumul pour chaque date et pour chaque province de mada
    df_ts_groupby = subset_ts.groupby(by=["time", "ADM1_EN", "ADM2_EN"]).mean()
    final_ts_df = df_ts_groupby.dropna().reset_index()
    print("ok3")
    #format y/m/d hour
    final_ts_df["time"] = final_ts_df["time"].astype(str)
    # format y/m/d
    final_ts_df["time2"]= final_ts_df["time"].str.split(" ", n = 1, expand = True).iloc[:, 0]
    # format m/d
    final_ts_df["time3"] = final_ts_df["time2"].str.split("-", n=1, expand=True).iloc[:, 1]
    print("ok2")
    final_ts_df.to_csv(netcdf_output + "test/time_series_mean" +min(date)+"_"+max(date)+"_"+name_hurricane+".csv", index=False)


# #Exemple pour un calcul de tout les cyclones ayant touché Madagasacr depuis 2015
# shapefile = gpd.read_file("/home/florent/PycharmProjects/ShinyApp/data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp")
# list_name = pd.unique(shapefile["NAME"].tolist())
# for i in list_name:
#netcdf_cumul_precipitation_times_series()




def download_hourly_GPM(IBTraACS_path_line="/home/florent/PycharmProjects/ShinyApp/data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp",
                        text_output_file="/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/",
                        lon_extent="2070:2977",
                        lat_extent="566:847",
                        user_EarthData="veillon.florent@yahoo.com",
                        pwd_EarthData="Flodor42800"):
    """
    Construction d'un fichier texte avec les adresses de chaque raster de pluie pour les dates séléctionnées
    et téléchargement
    :param IBTraACS_path_line: path of line IBTraAcs .shp
    :param text_output_file: path of output text after generate
    :param lon_extent: longitude of rectangle extent
    :param lat_extent: latitude of rectangle extent
    :param user_EarthData: id of EarthData account (email)
    :param pwd_EarthData: password of EarthData account
    :return: txt file with web addresses of netcdf file
    """

    # Lecture du fihcier IBTraAcs
    shapefile = gpd.read_file(IBTraACS_path_line)
    name = shapefile[shapefile.NAME == "FREDDY"]
    #Liste de toutes les dates à télécharger
    list_date = pd.unique(name.ISO_TIME)

    # #Création d'un fichier texte vide
    if os.path.exists(text_output_file + "netcdf_download_file.txt"):
        os.remove(text_output_file + "netcdf_download_file.txt")

    f = open(text_output_file + "netcdf_download_file.txt", "w+")
    # #Remplissage du fihcier avec les adresses de chaque netcdf pour chaque date
    for i in range(len(list_date)):
         date_tiret = list_date[i]
         date_split = date_tiret.split(" ")

         #year an day
         date_iso = date_split[0]
         date_selected = date_iso.replace("-", "")
         date_split2 = date_iso.split("-")
         year_selected = date_split2[0]
         month_selected = date_split2[1]
         day_selected = date_split2[2]
         d = datetime.date(int(year_selected) , int(month_selected), int(day_selected))
         day_of_year = d.strftime('%j')
         # hour
         hour_iso = date_split[1]
         hour_split = hour_iso.split(":")
         hour = hour_split[0]

         if hour == "00" :
             h_index = "0000"
         elif hour == "03" :
             h_index = "0180"
         elif hour == "06":
             h_index = "0360"
         elif hour == "09":
             h_index = "0540"
         elif hour == "12":
             h_index = "0720"
         elif hour == "15":
             h_index = "0900"
         elif hour == "18":
             h_index = "1080"
         elif hour == "21":
             h_index = "1260"

         if int(year_selected) >= 2023:
            l = "C"
         else :
             l ="B"


         #Condition NE FONCTIONNE PAS
         if os.path.isfile(text_output_file+"3B-HHR-E.MS.MRG.3IMERG."+date_selected+"-S"+hour+"0000-E"+hour+"2959."+h_index+".V06"+l+".HDF5.nc") == False :
            f.write("https://gpm1.gesdisc.eosdis.nasa.gov:443/opendap/hyrax/GPM_L3/GPM_3IMERGHHE.06/"+year_selected+"/"+day_of_year+"/3B-HHR-E.MS.MRG.3IMERG."+date_selected+"-S"+hour+"0000-E"+hour+"2959."+h_index+".V06"+l+".HDF5.nc?precipitationCal[0:0]["+lon_extent+"]["+lat_extent+"],lat["+lat_extent+"],lon["+lon_extent+"],time[0:0],time_bnds[0:0][0:1] \n")
    #         #"https://gpm1.gesdisc.eosdis.nasa.gov:443/opendap/GPM_L3/GPM_3IMERGDE.06/" + year_selected + "/" + month_selected + "/3B-DAY-E.MS.MRG.3IMERG." + date_selected + "-S000000-E235959.V06.nc4.nc?precipitationCal[0:0][2186:2341][621:832],time,lon[" + lon_extent + "],lat[" + lat_extent + "] \n")

    #Fermeture du fichier txt
    f.close()
    # # #Wget du fichier texte : téléchargement de chaque netcdf
    os.chdir(text_output_file)
    os.system(
        "wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition -i " +
        text_output_file + "netcdf_download_file.txt --user " + user_EarthData + " --password " + pwd_EarthData)




# out_grid = make_geocube(vector_data=gdf, measurements=["freq_front"], resolution=(-0.1, 0.1))  # for most crs negative comes first in resolution
# out_grid["freq_front"].rio.to_raster("/home/florent/Downloads/BOA_SWIO_2003-2020_analysis_freq.tif")






#download_hourly_GPM()
#
# import glob
# dir_path = r'/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/*2023*.nc'
# res = glob.glob(dir_path)
#
# for i in range(len(res)):
#     xds = xr.open_dataset(res[i])
#     bT = xds["precipitationCal"]
#     bT = bT.rio.set_spatial_dims(x_dim='lon', y_dim='lat')
#     bT.rio.write_crs("epsg:4326", inplace=True)
#     bT= bT.transpose('time', 'lat', 'lon')
#     bT = bT.where(bT != 0)
#     bT = bT[:, ::2, ::2]
#     output_path = res[i].replace("nc", "tif")
#     bT.rio.to_raster(output_path)
# #
# def download_hourly_GPM(IBTraACS_path_line="/home/florent/PycharmProjects/ShinyApp/data/cyclones/IBTrACS.SI.list.v04r00.points_Mada_2015_present.shp",
#                         text_output_file="/home/florent/PycharmProjects/ShinyApp/data/GPM_hourly/",
#                         lon_extent="2186:2341",
#                         lat_extent="621:832",
#                         user_EarthData="veillon.florent@yahoo.com",
#                         pwd_EarthData="Flodor42800"):
#     """
#     Construction d'un fichier texte avec les adresses de chaque raster de pluie pour les dates séléctionnées
#     et téléchargement
#     :param IBTraACS_path_line: path of line IBTraAcs .shp
#     :param text_output_file: path of output text after generate
#     :param lon_extent: longitude of rectangle extent
#     :param lat_extent: latitude of rectangle extent
#     :param user_EarthData: id of EarthData account (email)
#     :param pwd_EarthData: password of EarthData account
#     :return: txt file with web addresses of netcdf file
#     """
#
#     # Lecture du fihcier IBTraAcs
#     shapefile = gpd.read_file(IBTraACS_path_line)
#     # Création d'une liste contenant tout les noms des cyclones
#     name = shapefile[shapefile.NAME == "FREDDY"]
#     #Liste de toutes les dates à télécharger
#     list_date = pd.unique(name.ISO_TIME)
#
#     # #Création d'un fichier texte vide
#     if os.path.exists(text_output_file + "netcdf_download_file.txt"):
#         os.remove(text_output_file + "netcdf_download_file.txt")
#
#     list = []
#     for i in range(0, 24, 1):
#         if i < 10:
#             list.append(["0" + str(i) + "0000", "0" + str(i) + "2", i * 60])
#             list.append(["0" + str(i) + "3000", "0" + str(i) + "5", (i * 60) + 30])
#         else:
#             list.append([str(i) + "0000", str(i) + "2", i * 60])
#             list.append([str(i) + "3000", str(i) + "5", (i * 60) + 30])
#
#     f = open(text_output_file + "netcdf_download_file.txt", "w+")
#     # #Remplissage du fihcier avec les adresses de chaque netcdf pour chaque date
#     for i in range(len(list_date[0])):
#         date_tiret = list_date[i]
#         date_split = date_tiret.split(" ")
#
#         #year an day
#         date_iso = date_split[0]
#         date_selected = date_iso.replace("-", "")
#         date_split2 = date_iso.split("-")
#         year_selected = date_split2[0]
#         month_selected = date_split2[1]
#         day_selected = date_split2[2]
#         d = datetime.date(int(year_selected) , int(month_selected), int(day_selected))
#         day_of_year = d.strftime('%j')
#
#
#         if int(year_selected) >= 2023:
#             l = "C"
#         else :
#             l ="B"
#
#         for hr in list:
#             if len(str(hr[2]))==1:
#                 new_hr = "0000"
#             elif len(str(hr[2]))==2:
#                 new_hr = "00"+str(hr[2])
#             elif len(str(hr[2]))==3:
#                 new_hr = "0"+str(hr[2])
#             else :
#                 new_hr = str(hr[2])
#
#
#             #Condition NE FONCTIONNE PAS
#             #if os.path.isfile(text_output_file+"3B-HHR-E.MS.MRG.3IMERG."+date_selected+"-S"+str(hr[0])+"-E"+str(hr[1])+"959."+new_hr+".V06"+l+".HDF5.nc") == False :
#             f.write("https://gpm1.gesdisc.eosdis.nasa.gov:443/opendap/hyrax/GPM_L3/GPM_3IMERGHHE.06/"+year_selected+"/"+day_of_year+"/3B-HHR-E.MS.MRG.3IMERG."+date_selected+"-S"+str(hr[0])+"-E"+str(hr[1])+"959."+new_hr+".V06"+l+".HDF5.nc?precipitationCal[0:0]["+lon_extent+"]["+lat_extent+"],lat["+lat_extent+"],lon["+lon_extent+"],time[0:0],time_bnds[0:0][0:1] \n")
#         #         #"https://gpm1.gesdisc.eosdis.nasa.gov:443/opendap/GPM_L3/GPM_3IMERGDE.06/" + year_selected + "/" + month_selected + "/3B-DAY-E.MS.MRG.3IMERG." + date_selected + "-S000000-E235959.V06.nc4.nc?precipitationCal[0:0][2186:2341][621:832],time,lon[" + lon_extent + "],lat[" + lat_extent + "] \n")
#
#     #Fermeture du fichier txt
#     f.close()
#     # #Wget du fichier texte : téléchargement de chaque netcdf
#     # os.chdir(text_output_file)
#     # os.system(
#     #     "wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition -i " +
#     #     text_output_file + "netcdf_download_file.txt --user " + user_EarthData + " --password " + pwd_EarthData)
#
#     list_date2 = pd.unique(name.ISO_TIME.str.split(" ", expand=True).iloc[:, 0]).tolist()
#     date2 = [w.replace('-', '') for w in list_date2]
#
#     # Création d'une liste contenant les non des fichiers pour chaque date concernées par le cyclone
#     liste_netcdf = []
#     for d in date2:
#         dir_path = r'' + text_output_file + "*" + d + "*.nc"
#         res = glob.glob(dir_path)
#         for r in res:
#             liste_netcdf.append(r)
#
#
#     dataset = xr.open_mfdataset(liste_netcdf)
#     df = dataset.to_dataframe()
#     # df_reformate = df.dropna().reset_index()
#     print(df)
# download_hourly_GPM()

#
# list = []
# for i in range(0,24,1):
#     if i < 10 :
#         list.append(["0"+str(i) + "0000","0"+str(i)+"2",i*60])
#         list.append(["0"+str(i) + "3000","0"+str(i)+"5",(i*60)+30])
#     else :
#         list.append([str(i)+"0000",str(i)+"2",i*60])
#         list.append([str(i) + "3000",str(i)+"5",(i*60)+30])
#
# print(list)
