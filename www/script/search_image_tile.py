import datetime

from sen2chain import Tile
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib
import calendar
import seaborn as sns
import numpy as np
from eodag.api.core import EODataAccessGateway
from eodag import setup_logging
from shapely.geometry import Polygon
import july
from july.utils import date_range
import shapely
import logging


import os


def EO_product_count_image(start_date,
                           end_date,
                           cloud_max):

    mada_tiles= gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")
    df_EO_product = pd.DataFrame(columns=['tile', "title", "year", "month", "day", "cloudCover"])
    # list_mada_tile1 = mada_tiles[mada_tiles.Name == "38KLU"]
    # list_mada_tile = list(list_mada_tile1.Name)
    list_mada_tile = list(mada_tiles.Name)

    date = [["2015-07-01","2018-04-15"],["2018-04-18","2021-07-23"],["2021-07-27","2022-12-31"]]
    date = [["2022-01-01","2022-02-28"]]
    for tiles in list_mada_tile:

        for d in date:
            print(tiles)
            # EO_product = Tile(tiles).get_l1c(provider="peps",start= d[0],end=d[1], download = False,min_cloudcover=float(0),max_cloudcover=float(cloud_max))
            EO_product = Tile(tiles).get_l1c(provider="peps", start=str(d[0]), end=str(d[1]), download=False)

            for x in EO_product:
                dict_EO_product = x.as_dict()
                dict_properties = dict_EO_product['properties']
                title = dict_properties["title"]
                year = title[11:15]
                month = title[15:17]
                day = title[17:19]
                cloud_cover = dict_properties["cloudCover"]
                df_EO_product = df_EO_product.append({'tile': tiles, 'title': title,'year':year, 'month':month, 'day':day, 'cloudCover':cloud_cover}, ignore_index=True)

    df_EO_product.to_csv("/home/florent/PycharmProjects/Cyclone/output/test/EO_product_BATSIRAI_2015_07_01_2022_12_31_cloudmax_"+str(cloud_max-1)+".csv",index=False)

#EO_product_count_image( start_date="2022-01-01",end_date="2022-02-31",cloud_max=21)

def map_sen2_image(csv_file,
                   time = "total"):
    EO_product_list = pd.read_csv(csv_file)

    mada_tiles = gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")

    world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
    mada = world[world.name == 'Madagascar']
    base = mada.boundary
    cc = csv_file[-6:-4]
    if time == "total":
        date = '2015-07-01 / 2022-12-31'


        EO_product_group = EO_product_list.groupby(["tile", "month"]).count()
        EO_product_group2 = EO_product_group.reset_index()

        x = mada_tiles.merge(EO_product_group2, left_on='Name', right_on='tile')

        #plot
        fig, axs = plt.subplots(figsize=(10, 10),ncols=4, nrows=3)

        January = x[x["month"]==1]
        February = x[x["month"]==2]
        # March = x[x["month"] == 3]
        # April = x[x["month"] == 4]
        # May = x[x["month"] == 5]
        # June = x[x["month"] == 6]
        # July = x[x["month"] == 7]
        # August = x[x["month"] == 8]
        # September = x[x["month"] == 9]
        # October = x[x["month"] == 10]
        # November= x[x["month"] == 11]
        # December = x[x["month"] == 12]

        norm = matplotlib.colors.Normalize(vmin=x.day.min(), vmax=x.day.max())
        color = 'RdYlGn'

        January.plot(ax = axs[0,0],column="day",norm=norm,cmap=color).axis('off')
        February.plot(ax=axs[0,1],column="day",norm=norm,cmap=color).axis('off')
        # March.plot(ax=axs[0, 2], column="day", norm=norm,cmap=color).axis('off')
        # April.plot(ax=axs[0, 3], column="day", norm=norm,cmap=color).axis('off')
        # May.plot(ax=axs[1, 0], column="day", norm=norm,cmap=color).axis('off')
        # June.plot(ax=axs[1, 1], column="day", norm=norm,cmap=color).axis('off')
        # July.plot(ax=axs[1, 2], column="day", norm=norm,cmap=color).axis('off')
        # August.plot(ax=axs[1, 3], column="day", norm=norm,cmap=color).axis('off')
        # September.plot(ax=axs[2, 0], column="day", norm=norm,cmap=color).axis('off')
        # October.plot(ax=axs[2, 1], column="day", norm=norm,cmap=color).axis('off')
        # November.plot(ax=axs[2, 2], column="day", norm=norm,cmap=color).axis('off')
        # December.plot(ax=axs[2, 3], column="day", norm=norm,cmap=color).axis('off')

        axs[0, 0].set_title(calendar.month_name[1])
        axs[0, 1].set_title(calendar.month_name[2])
        # axs[0, 2].set_title(calendar.month_name[3])
        # axs[0, 3].set_title(calendar.month_name[4])
        # axs[1, 0].set_title(calendar.month_name[5])
        # axs[1, 1].set_title(calendar.month_name[6])
        # axs[1, 2].set_title(calendar.month_name[7])
        # axs[1, 3].set_title(calendar.month_name[8])
        # axs[2, 0].set_title(calendar.month_name[9])
        # axs[2, 1].set_title(calendar.month_name[10])
        # axs[2, 2].set_title(calendar.month_name[11])
        # axs[2, 3].set_title(calendar.month_name[12])

        color_base= "black"
        base.plot(ax=axs[0, 0], edgecolor=color_base)
        base.plot(ax=axs[0, 1], edgecolor=color_base)
        # base.plot(ax=axs[0, 2], edgecolor=color_base)
        # base.plot(ax=axs[0, 3], edgecolor=color_base)
        # base.plot(ax=axs[1, 0], edgecolor=color_base)
        # base.plot(ax=axs[1, 1], edgecolor=color_base)
        # base.plot(ax=axs[1, 2], edgecolor=color_base)
        # base.plot(ax=axs[1, 3], edgecolor=color_base)
        # base.plot(ax=axs[2, 0], edgecolor=color_base)
        # base.plot(ax=axs[2, 1], edgecolor=color_base)
        # base.plot(ax=axs[2, 2], edgecolor=color_base)
        # base.plot(ax=axs[2, 3], edgecolor=color_base)


        axs = axs.ravel()
        patch_col = axs[0].collections[0]
        fig.colorbar(patch_col, ax=axs, shrink=0.5).set_label('Number of images', rotation=270,labelpad=15)
        fig.suptitle("Number of images with cloud cover < "+cc+"%"+"\n"+str(date), fontsize=16)

        # fig.tight_layout()
        plt.show()

    if time == "year":
        EO_product_group = EO_product_list.groupby(["year","tile","month"]).count()
        EO_product_group2 = EO_product_group.reset_index()
        list_year = np.unique(list(EO_product_group2["year"]))


        fig = plt.figure(constrained_layout=True, figsize=(30, 30))
        subplots = fig.subfigures(2, 4)
        x = mada_tiles.merge(EO_product_group2, left_on='Name', right_on='tile')
        norm = matplotlib.colors.Normalize(vmin=EO_product_group2.day.min(), vmax=EO_product_group2.day.max())
        color = 'RdYlGn'




        ax0 = subplots[0][0].subplots(2, 4, gridspec_kw={'height_ratios': [2.7, 1.3]})
        ax1 = subplots[0][1].subplots(3, 4)
        ax2 = subplots[0][2].subplots(3, 4)
        ax3 = subplots[0][3].subplots(3, 4)
        ax4 = subplots[1][0].subplots(3, 4)
        ax5 = subplots[1][1].subplots(3, 4)
        ax6 = subplots[1][2].subplots(3, 4)
        ax7 = subplots[1][3].subplots(3, 4)

        list_ax = [ax0,ax1,ax2,ax3,ax4,ax5,ax6,ax7]

        x = mada_tiles.merge(EO_product_group2, left_on='Name', right_on='tile')
        norm = matplotlib.colors.Normalize(vmin=EO_product_group2.day.min(), vmax=EO_product_group2.day.max())
        color = 'RdYlGn'

        for l in range(len(list_year)):
            select = x[x["year"] == list_year[l]]
            January = select[select["month"] == 1]
            February = select[select["month"] == 2]
            March = select[select["month"] == 3]
            April = select[select["month"] == 4]
            May = select[select["month"] == 5]
            June = select[select["month"] == 6]
            July = select[select["month"] == 7]
            August = select[select["month"] == 8]
            September = select[select["month"] == 9]
            October = select[select["month"] == 10]
            November = select[select["month"] == 11]
            December= select[select["month"] == 12]

            if(list_year[l]==2015):
                list_ax[l][0, 0].axis('off')
                list_ax[l][0, 1].axis('off')
                list_ax[l][0, 2].axis('off')
                list_ax[l][0, 3].axis('off')
                September.plot(ax=list_ax[l][1, 0], column="day", norm=norm, cmap=color).axis('off')
                October.plot(ax=list_ax[l][1, 1], column="day", norm=norm, cmap=color).axis('off')
                November.plot(ax=list_ax[l][1, 2], column="day", norm=norm, cmap=color).axis('off')
                December.plot(ax=list_ax[l][1, 3], column="day", norm=norm, cmap=color).axis('off')

                color_base = "black"
                base.plot(ax=list_ax[l][1, 0], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 1], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 2], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 3], edgecolor=color_base)

                list_ax[l][1, 0].set_title(calendar.month_abbr[9], fontsize=9, x=0.1, y=0.8)
                list_ax[l][1, 1].set_title(calendar.month_abbr[10], fontsize=9, x=0.1, y=0.8)
                list_ax[l][1, 2].set_title(calendar.month_abbr[11], fontsize=9, x=0.1, y=0.8)
                list_ax[l][1, 3].set_title(calendar.month_abbr[12], fontsize=9, x=0.1, y=0.8)

                list_ax[l][0, 0].annotate("Number of Sentinel-1 images",
                                        xy=(0.4, 1))


            else:
                January.plot(ax = list_ax[l][0,0],column="day",norm=norm,cmap=color).axis('off')
                February.plot(ax=list_ax[l][0,1],column="day",norm=norm,cmap=color).axis('off')
                March.plot(ax=list_ax[l][0, 2], column="day", norm=norm,cmap=color).axis('off')
                April.plot(ax=list_ax[l][0, 3], column="day", norm=norm,cmap=color).axis('off')
                May.plot(ax=list_ax[l][1, 0], column="day", norm=norm,cmap=color).axis('off')
                June.plot(ax=list_ax[l][1, 1], column="day", norm=norm,cmap=color).axis('off')
                July.plot(ax=list_ax[l][1, 2], column="day", norm=norm,cmap=color).axis('off')
                August.plot(ax=list_ax[l][1, 3], column="day", norm=norm,cmap=color).axis('off')
                September.plot(ax=list_ax[l][2, 0], column="day", norm=norm,cmap=color).axis('off')
                October.plot(ax=list_ax[l][2, 1], column="day", norm=norm,cmap=color).axis('off')
                November.plot(ax=list_ax[l][2, 2], column="day", norm=norm,cmap=color).axis('off')
                December.plot(ax=list_ax[l][2, 3], column="day", norm=norm,cmap=color).axis('off')

                color_base = "black"
                base.plot(ax=list_ax[l][0, 0], edgecolor=color_base)
                base.plot(ax=list_ax[l][0, 1], edgecolor=color_base)
                base.plot(ax=list_ax[l][0, 2], edgecolor=color_base)
                base.plot(ax=list_ax[l][0, 3], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 0], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 1], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 2], edgecolor=color_base)
                base.plot(ax=list_ax[l][1, 3], edgecolor=color_base)
                base.plot(ax=list_ax[l][2, 0], edgecolor=color_base)
                base.plot(ax=list_ax[l][2, 1], edgecolor=color_base)
                base.plot(ax=list_ax[l][2, 2], edgecolor=color_base)
                base.plot(ax=list_ax[l][2, 3], edgecolor=color_base)

                list_ax[l][0, 0].set_title(calendar.month_abbr[1],fontsize=9,x=0.1, y=0.8)
                list_ax[l][0, 1].set_title(calendar.month_abbr[2],fontsize=9,x=0.1, y=0.8)
                list_ax[l][0, 2].set_title(calendar.month_abbr[3],fontsize=9,x=0.1, y=0.8)
                list_ax[l][0, 3].set_title(calendar.month_abbr[4],fontsize=9,x=0.1, y=0.8)
                list_ax[l][1, 0].set_title(calendar.month_abbr[5],fontsize=9,x=0.1, y=0.8)
                list_ax[l][1, 1].set_title(calendar.month_abbr[6],fontsize=9,x=0.1, y=0.8)
                list_ax[l][1, 2].set_title(calendar.month_abbr[7],fontsize=9,x=0.1, y=0.8)
                list_ax[l][1, 3].set_title(calendar.month_abbr[8],fontsize=9,x=0.1, y=0.8)
                list_ax[l][2, 0].set_title(calendar.month_abbr[9],fontsize=9,x=0.1, y=0.8)
                list_ax[l][2, 1].set_title(calendar.month_abbr[10],fontsize=9,x=0.1, y=0.8)
                list_ax[l][2, 2].set_title(calendar.month_abbr[11],fontsize=9,x=0.1, y=0.8)
                list_ax[l][2, 3].set_title(calendar.month_abbr[12],fontsize=9,x=0.1, y=0.8)


        subplots[0,0].suptitle('2015', fontsize='xx-large',y=0.48)
        subplots[0, 1].suptitle('2016', fontsize='xx-large')
        subplots[0, 2].suptitle('2017', fontsize='xx-large')
        subplots[0, 3].suptitle('2018', fontsize='xx-large')
        subplots[1, 0].suptitle('2019', fontsize='xx-large')
        subplots[1, 1].suptitle('2020', fontsize='xx-large')
        subplots[1, 2].suptitle('2021', fontsize='xx-large')
        subplots[1, 3].suptitle('2022', fontsize='xx-large')


        axs = ax0.ravel()
        patch_col = axs[5].collections[0]
        fig.colorbar(patch_col, ax=axs,shrink=0.8,anchor=(0.5,6),orientation="horizontal").set_label('Number of images',labelpad=-40)

        #fig.colorbar(patch_col, ax=axs, shrink=0.5, anchor=(0.5, 0.5), orientation="vertical")

        plt.subplots_adjust(wspace=0, hspace=0)
        plt.show()



        for y in list_year:
            EO_product_group3 = EO_product_group2[EO_product_group2["year"]==y]






map_sen2_image("/home/florent/PycharmProjects/Cyclone/output/test/EO_product_BATSIRAI_2015_07_01_2022_12_31_cloudmax_20.csv",
              time="total")

def heatmap_sen2_image(csv_file):

    EO_product_list = pd.read_csv(csv_file)
    EO_product_group = EO_product_list.groupby(["year", "month"]).count()
    EO_product_group2 = EO_product_group.reset_index()

    EO_product_group2['Month_text'] = EO_product_group2['month'].apply(lambda x: calendar.month_abbr[x])
    sns.set_theme()

    heatmap_pt = pd.pivot_table(EO_product_group2,values ='tile', index='year', columns="Month_text")
    column_order = [calendar.month_abbr[1],
                    calendar.month_abbr[2],
                    calendar.month_abbr[3],
                    calendar.month_abbr[4],
                    calendar.month_abbr[5],
                    calendar.month_abbr[6],
                    calendar.month_abbr[7],
                    calendar.month_abbr[8],
                    calendar.month_abbr[9],
                    calendar.month_abbr[10],
                    calendar.month_abbr[11],
                    calendar.month_abbr[12]
                    ]
    heatmap_pt_order = heatmap_pt.reindex(column_order, axis=1)

    sns.heatmap(heatmap_pt_order, cmap='RdYlGn',annot=True,fmt='g')


    plt.xlabel(" ")
    plt.ylabel(" ")
    plt.title("Count of Sentinel-1 images",fontsize=16)
    plt.show()

#heatmap_sen2_image("/home/florent/PycharmProjects/Cyclone/output/test/test3.csv")


def stats_none_cloud_cover(txt_file):

    none_product = pd.read_csv(txt_file, sep=";", names=["name","year",'month',"day"])

    none_product["tile"]=none_product["name"].str[39:44]
    none_product_group = none_product.groupby(["tile","month"]).count()
    none_product_group2 = none_product_group.reset_index()


    mada_tiles = gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")
    x = mada_tiles.merge(none_product_group2, left_on='Name', right_on='tile')


    world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
    mada = world[world.name == 'Madagascar']
    base = mada.boundary


    # plot
    fig, axs = plt.subplots(figsize=(30, 30), ncols=3, nrows=1)
    July = x[x["month"] == 7]
    August = x[x["month"] == 8]
    September = x[x["month"] == 9]

    July['centroid'] = July.centroid
    August['centroid'] = August.centroid
    September['centroid'] = September.centroid

    norm = matplotlib.colors.Normalize(vmin=x.day.min(), vmax=x.day.max())
    color = 'RdYlGn_r'

    July.plot(ax=axs[0], column="day", norm=norm, cmap=color).axis('off')
    August.plot(ax=axs[1], column="day", norm=norm, cmap=color).axis('off')
    September.plot(ax=axs[2], column="day", norm=norm, cmap=color).axis('off')

    July.apply(lambda x: axs[0].annotate(text=x['Name'], xy=(x['centroid'].coords[0][0], x['centroid'].coords[0][1]), ha='center',fontsize=8,color="black"), axis=1)
    August.apply(lambda x: axs[1].annotate(text=x['Name'], xy=(x['centroid'].coords[0][0], x['centroid'].coords[0][1]), ha='center', fontsize=8, color="black"),axis=1)
    September.apply(lambda x: axs[2].annotate(text=x['Name'], xy=(x['centroid'].coords[0][0], x['centroid'].coords[0][1]), ha='center', fontsize=8, color="black"),axis=1)

    axs[0].set_title(calendar.month_name[7])
    axs[1].set_title(calendar.month_name[8])
    axs[2].set_title(calendar.month_name[9])

    color_base = "black"
    base.plot(ax=axs[0], edgecolor=color_base)
    base.plot(ax=axs[1], edgecolor=color_base)
    base.plot(ax=axs[2], edgecolor=color_base)

    axs = axs.ravel()
    patch_col = axs[0].collections[0]
    fig.colorbar(patch_col, ax=axs, shrink=0.5).set_label('Number of images', rotation=270, labelpad=15)
    fig.suptitle("Number of images with cloud cover = NaN for 2017", fontsize=16)

    plt.show()



#stats_none_cloud_cover("/home/florent/PycharmProjects/Cyclone/output/test/none/none_cloudcover20.txt")

def compa_cloud_cover(file1,
                      file2):

    EO_product_list=pd.read_csv(file1)
    EO_product_list2=pd.read_csv(file2)
    EO_product_group = EO_product_list.groupby(["year","tile","month"]).count()
    EO_product_group2 = EO_product_list2.groupby(["year","tile","month"]).count()

    EO_product_g = EO_product_group.reset_index()
    EO_product_g2 = EO_product_group2.reset_index()


    merged_data= EO_product_g.merge(EO_product_g2, on=["year","tile","month"])
    merged_data["diff_image"]=merged_data["day_x"]-merged_data["day_y"]
    merged_data["diff_image"].replace(0, np.nan, inplace=True)


    mada_tiles = gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")
    x = mada_tiles.merge(merged_data, left_on='Name', right_on='tile')

    list_year = np.unique(list(EO_product_g2 ["year"]))


    fig = plt.figure(constrained_layout=True, figsize=(30, 30))
    subplots = fig.subfigures(2, 4)

    norm = matplotlib.colors.Normalize(vmin=merged_data.diff_image.min(), vmax=merged_data.diff_image.max())
    color = 'RdYlGn_r'

    world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
    mada = world[world.name == 'Madagascar']
    base = mada.boundary


    ax0 = subplots[0][0].subplots(2, 4, gridspec_kw={'height_ratios': [2.7, 1.3]})
    ax1 = subplots[0][1].subplots(3, 4)
    ax2 = subplots[0][2].subplots(3, 4)
    ax3 = subplots[0][3].subplots(3, 4)
    ax4 = subplots[1][0].subplots(3, 4)
    ax5 = subplots[1][1].subplots(3, 4)
    ax6 = subplots[1][2].subplots(3, 4)
    ax7 = subplots[1][3].subplots(3, 4)

    list_ax = [ax0,ax1,ax2,ax3,ax4,ax5,ax6,ax7]


    for l in range(len(list_year)):
        select = x[x["year"] == list_year[l]]
        January = select[select["month"] == 1]
        February = select[select["month"] == 2]
        March = select[select["month"] == 3]
        April = select[select["month"] == 4]
        May = select[select["month"] == 5]
        June = select[select["month"] == 6]
        July = select[select["month"] == 7]
        August = select[select["month"] == 8]
        September = select[select["month"] == 9]
        October = select[select["month"] == 10]
        November = select[select["month"] == 11]
        December= select[select["month"] == 12]

        if(list_year[l]==2015):
            list_ax[l][0, 0].axis('off')
            list_ax[l][0, 1].axis('off')
            list_ax[l][0, 2].axis('off')
            list_ax[l][0, 3].axis('off')
            September.plot(ax=list_ax[l][1, 0], column="diff_image", norm=norm, cmap=color).axis('off')
            October.plot(ax=list_ax[l][1, 1], column="diff_image", norm=norm, cmap=color).axis('off')
            November.plot(ax=list_ax[l][1, 2], column="diff_image", norm=norm, cmap=color).axis('off')
            December.plot(ax=list_ax[l][1, 3], column="diff_image", norm=norm, cmap=color).axis('off')

            color_base = "black"
            base.plot(ax=list_ax[l][1, 0], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 1], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 2], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 3], edgecolor=color_base)

            list_ax[l][1, 0].set_title(calendar.month_abbr[9], fontsize=9, x=0.1, y=0.8)
            list_ax[l][1, 1].set_title(calendar.month_abbr[10], fontsize=9, x=0.1, y=0.8)
            list_ax[l][1, 2].set_title(calendar.month_abbr[11], fontsize=9, x=0.1, y=0.8)
            list_ax[l][1, 3].set_title(calendar.month_abbr[12], fontsize=9, x=0.1, y=0.8)

            list_ax[l][0, 0].annotate("Difference of number of images [cc 20% - cc 10%] ",
                                    xy=(0.3, 1))


        else:
            January.plot(ax = list_ax[l][0,0],column="diff_image",norm=norm,cmap=color).axis('off')
            February.plot(ax=list_ax[l][0,1],column="diff_image",norm=norm,cmap=color).axis('off')
            March.plot(ax=list_ax[l][0, 2], column="diff_image", norm=norm,cmap=color).axis('off')
            April.plot(ax=list_ax[l][0, 3], column="diff_image", norm=norm,cmap=color).axis('off')
            May.plot(ax=list_ax[l][1, 0], column="diff_image", norm=norm,cmap=color).axis('off')
            June.plot(ax=list_ax[l][1, 1], column="diff_image", norm=norm,cmap=color).axis('off')
            July.plot(ax=list_ax[l][1, 2], column="diff_image", norm=norm,cmap=color).axis('off')
            August.plot(ax=list_ax[l][1, 3], column="diff_image", norm=norm,cmap=color).axis('off')
            September.plot(ax=list_ax[l][2, 0], column="diff_image", norm=norm,cmap=color).axis('off')
            October.plot(ax=list_ax[l][2, 1], column="diff_image", norm=norm,cmap=color).axis('off')
            November.plot(ax=list_ax[l][2, 2], column="diff_image", norm=norm,cmap=color).axis('off')
            December.plot(ax=list_ax[l][2, 3], column="diff_image", norm=norm,cmap=color).axis('off')

            color_base = "black"
            base.plot(ax=list_ax[l][0, 0], edgecolor=color_base)
            base.plot(ax=list_ax[l][0, 1], edgecolor=color_base)
            base.plot(ax=list_ax[l][0, 2], edgecolor=color_base)
            base.plot(ax=list_ax[l][0, 3], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 0], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 1], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 2], edgecolor=color_base)
            base.plot(ax=list_ax[l][1, 3], edgecolor=color_base)
            base.plot(ax=list_ax[l][2, 0], edgecolor=color_base)
            base.plot(ax=list_ax[l][2, 1], edgecolor=color_base)
            base.plot(ax=list_ax[l][2, 2], edgecolor=color_base)
            base.plot(ax=list_ax[l][2, 3], edgecolor=color_base)

            list_ax[l][0, 0].set_title(calendar.month_abbr[1],fontsize=9,x=0.1, y=0.8)
            list_ax[l][0, 1].set_title(calendar.month_abbr[2],fontsize=9,x=0.1, y=0.8)
            list_ax[l][0, 2].set_title(calendar.month_abbr[3],fontsize=9,x=0.1, y=0.8)
            list_ax[l][0, 3].set_title(calendar.month_abbr[4],fontsize=9,x=0.1, y=0.8)
            list_ax[l][1, 0].set_title(calendar.month_abbr[5],fontsize=9,x=0.1, y=0.8)
            list_ax[l][1, 1].set_title(calendar.month_abbr[6],fontsize=9,x=0.1, y=0.8)
            list_ax[l][1, 2].set_title(calendar.month_abbr[7],fontsize=9,x=0.1, y=0.8)
            list_ax[l][1, 3].set_title(calendar.month_abbr[8],fontsize=9,x=0.1, y=0.8)
            list_ax[l][2, 0].set_title(calendar.month_abbr[9],fontsize=9,x=0.1, y=0.8)
            list_ax[l][2, 1].set_title(calendar.month_abbr[10],fontsize=9,x=0.1, y=0.8)
            list_ax[l][2, 2].set_title(calendar.month_abbr[11],fontsize=9,x=0.1, y=0.8)
            list_ax[l][2, 3].set_title(calendar.month_abbr[12],fontsize=9,x=0.1, y=0.8)


    subplots[0,0].suptitle('2015', fontsize='xx-large',y=0.48)
    subplots[0, 1].suptitle('2016', fontsize='xx-large')
    subplots[0, 2].suptitle('2017', fontsize='xx-large')
    subplots[0, 3].suptitle('2018', fontsize='xx-large')
    subplots[1, 0].suptitle('2019', fontsize='xx-large')
    subplots[1, 1].suptitle('2020', fontsize='xx-large')
    subplots[1, 2].suptitle('2021', fontsize='xx-large')
    subplots[1, 3].suptitle('2022', fontsize='xx-large')


    axs = ax0.ravel()
    patch_col = axs[6].collections[0]
    fig.colorbar(patch_col, ax=axs,shrink=0.8,anchor=(0.5,6),orientation="horizontal").set_label('Number of images',labelpad=-40)

    #fig.colorbar(patch_col, ax=axs, shrink=0.5, anchor=(0.5, 0.5), orientation="vertical")

    plt.subplots_adjust(wspace=0, hspace=0)
    plt.show()

#compa_cloud_cover(file1="/home/florent/PycharmProjects/Cyclone/output/test/EO_product_2015_07_01_2022_12_31_cloudmax_20.csv",
#                  file2="/home/florent/PycharmProjects/Cyclone/output/test/EO_product_2015_07_01_2022_12_31_cloudmax_10.csv")

def heatmap_compa_cloud_cover(file1,
                              file2):

    EO_product_list = pd.read_csv(file1)
    EO_product_list2 = pd.read_csv(file2)

    EO_product_group = EO_product_list.groupby(["year", "month"]).count()
    EO_product_group2 = EO_product_list2.groupby(["year", "month"]).count()

    EO_product_group1 = EO_product_group.reset_index()
    EO_product_group21 = EO_product_group2.reset_index()

    EO_product_group1['Month_text'] = EO_product_group1['month'].apply(lambda x: calendar.month_abbr[x])

    x = EO_product_group1.merge(EO_product_group21, left_on=['year',"month"], right_on=['year',"month"])
    x["compa_produit"]= x["tile_x"]-x["tile_y"]


    sns.set_theme()

    heatmap_pt = pd.pivot_table(x, values='compa_produit', index='year', columns="Month_text")
    column_order = [calendar.month_abbr[1],
                    calendar.month_abbr[2],
                    calendar.month_abbr[3],
                    calendar.month_abbr[4],
                    calendar.month_abbr[5],
                    calendar.month_abbr[6],
                    calendar.month_abbr[7],
                    calendar.month_abbr[8],
                    calendar.month_abbr[9],
                    calendar.month_abbr[10],
                    calendar.month_abbr[11],
                    calendar.month_abbr[12]
                    ]
    heatmap_pt_order = heatmap_pt.reindex(column_order, axis=1)

    sns.heatmap(heatmap_pt_order, cmap='RdYlGn_r', annot=True, fmt='g')

    plt.xlabel(" ")
    plt.ylabel(" ")
    plt.title("Difference of number of images [cc 20% - cc 10%] ", fontsize=16)
    plt.show()


# heatmap_compa_cloud_cover(file1="/home/florent/PycharmProjects/Cyclone/output/test/EO_product_2015_07_01_2022_12_31_cloudmax_20.csv",
#                  file2="/home/florent/PycharmProjects/Cyclone/output/test/EO_product_2015_07_01_2022_12_31_cloudmax_10.csv")



########################################################################################
#SENTINEL1

def EO_images_S1():
    os.environ["EODAG__PEPS__AUTH__CREDENTIALS__USERNAME"] = "florent.veillon@ird.fr"
    os.environ["EODAG__PEPS__AUTH__CREDENTIALS__PASSWORD"] = "Meteocryo42800+"

    setup_logging(verbose=2)

    shape1 = gpd.GeoDataFrame.from_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada2.shp")
    df_EO_product = pd.DataFrame(columns=["tile","title", "year", "month", "day"])
    shape1 = pd.concat([shape1, shape1.bounds], axis=1)

    workspace = "/home/florent/PycharmProjects/Cyclone/ShinyApp/data/eodag_workspace_locations_tiles"
    os.chdir(workspace)

    for t in range(0,1):
        #len(shape1)
        shape = shape1.iloc[t]
        tile = shape["Name"]
        tile="38KPG"
        print(tile)

        df = pd.DataFrame({'longitude': [shape.minx,shape.minx,shape.maxx,shape.maxx],
                           'latitude': [shape.miny,shape.maxy,shape.miny,shape.maxy]})






        coords = list(map(tuple, np.asarray(df)))
        poly = Polygon(coords)

        #Save the PEPS configuration file.
        yaml_content = """
        peps:
            download:
                outputs_prefix: "{}"
                extract: true
        """.format(os.path.abspath(workspace))

        with open(os.path.join(workspace, 'eodag_conf.yml'), "w") as f_yml:
            f_yml.write(yaml_content.strip())

        dag = EODataAccessGateway(os.path.join(workspace, 'eodag_conf.yml'))

        page = 1
        searched_items_per_page = 100
        products= []

        while True:
            page_products, x = dag.search(
                page=page,
                items_per_page=searched_items_per_page,
                productType='S1_SAR_GRD',
                start='2015-07-01',
                end='2022-12-31',
                geom=poly,
                polarizationMode=["VV VH"],
                sensorMode="IW",
                orbitDirection=None,
                download=False)

            products+=page_products
            page+=1
            if len(page_products) < searched_items_per_page:
                break

        print(len(products))

        for x in products:
            dict_EO_product = x.as_dict()
            dict_properties = dict_EO_product['properties']
            title = dict_properties["title"]
            year = title[17:21]
            month = title[21:23]
            day = title[23:25]
            df_EO_product = df_EO_product.append({"tile":tile, 'title': title, 'year': year, 'month': month, 'day': day}, ignore_index=True)


    df_EO_product.to_csv("/home/florent/PycharmProjects/Cyclone/output/test/38KPG.csv",index=False)


#EO_images_S1()





def calendar_product(tiles):
    list_year = [2015,2016,2017,2018,2019,2020,2021,2022]
    tile = tiles

    mada_tiles = gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")

    tile_mada = mada_tiles[mada_tiles["Name"]==tile]

    world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
    mada = world[world.name == 'Madagascar']
    base = mada.boundary

    liste_s1=[]
    liste_s2= []

    fig, axs = plt.subplots(figsize=(20, 10),ncols=9, nrows=1)

    for l in range(len(list_year)):
        year = list_year[l]
        dates = date_range(str(year)+"-01-01", str(year)+'-12-31')

        x = pd.DataFrame({"date":pd.to_datetime(dates)})

        #Sentinel2
        EO_product_list = pd.read_csv("/home/florent/PycharmProjects/Cyclone/output/test/EO_product_2015_07_01_2022_12_31_cloudmax_20.csv")

        product_2020 = EO_product_list[(EO_product_list ["tile"]== tile) & (EO_product_list ["year"]== year )]

        test = product_2020.sort_values(by=['month',"day"])

        test.loc[test['day'] <10 , 'day'] = test["day"].astype(str).str.zfill(2)
        test.loc[test['month'] <10 , 'month'] = test["month"].astype(str).str.zfill(2)

        test["date"] = test["year"].astype(str)+test["month"].astype(str)+test["day"].astype(str)
        test["date_time"]= pd.to_datetime(test["date"], format='%Y%m%d')
        test = test.drop_duplicates(subset=["date_time"])

        #Sentinel1
        EO_productS1_list = pd.read_csv("/home/florent/PycharmProjects/Cyclone/output/test/test3.csv")
        product_2020_S1 = EO_productS1_list [(EO_productS1_list  ["tile"]== tile) & (EO_productS1_list  ["year"]== year )]
        product_2020_S1 = product_2020_S1.drop_duplicates()


        product_2020_S1.loc[product_2020_S1['day'] <10 , 'day'] = product_2020_S1["day"].astype(str).str.zfill(2)
        product_2020_S1.loc[product_2020_S1['month'] <10 , 'month'] = product_2020_S1["month"].astype(str).str.zfill(2)

        product_2020_S1["date"] = product_2020_S1["year"].astype(str)+product_2020_S1["month"].astype(str)+product_2020_S1["day"].astype(str)
        product_2020_S1["date_time"]= pd.to_datetime(product_2020_S1["date"], format='%Y%m%d')
        product_2020_S1 = product_2020_S1.drop_duplicates(subset=["date_time"])


        y = x.merge(test, left_on='date', right_on='date_time',how="outer")
        y.replace({np.nan: 0}, inplace = True)
        y.loc[y['date_time'] !=0 , 'date_time'] = 1

        z = y.merge(product_2020_S1, left_on='date_x', right_on='date_time',how="outer")
        #z.to_csv("/home/florent/PycharmProjects/Cyclone/output/test/calendar_tile/test.csv")
        z.replace({np.nan: 0}, inplace = True)
        #z.loc[z['date_time_x'] == 1 , 'date_time2'] = 0
        z.loc[z['date_time_y'] != 0 , 'date_time2'] = 9
        z.replace({np.nan: 6}, inplace=True)
        z['date_time3']= (z['date_time2']+z['date_time_x'])*2

        #z.to_csv("/home/florent/PycharmProjects/Cyclone/output/test/calendar_tile/test.csv")
        ok = list(z['date_time3'])



        july.heatmap(ax=axs[l], dates=dates, data=ok, cmap="perso", cmin=0, cmax=21, date_label=True, month_grid=True, horizontal=False, fontsize=8)


        groupby_z1= z.groupby(['date_time3']).count()
        groupby_z = groupby_z1.reset_index()

        if 14 not in groupby_z.values:
            s2_count = 0
        else :
            s2_count= list(groupby_z[groupby_z["date_time3"]==14]['date_time2'])[0]


        if 18 not in groupby_z.values:
            s1_count = 0
        else :
            s1_count = list(groupby_z[groupby_z["date_time3"] == 18]['date_time2'])[0]


        if 20 not in groupby_z.values:
            s1_count = s1_count +0
            s2_count = s2_count + 0
        else :
            s2_count = list(s2_count+groupby_z[groupby_z["date_time3"] == 20]['date_time2'])[0]
            s1_count = list(s1_count + groupby_z[groupby_z["date_time3"] == 20]['date_time2'])[0]


        # print(s1_count)
        liste_s1.append(s1_count)
        liste_s2.append(s2_count)

        axs[l].annotate("S1 : " + str(s1_count), xy=(1, 55), annotation_clip=False, size=11, color="#93C6E7", weight='bold')
        axs[l].annotate("S2 : " + str(s2_count), xy=(1, 57), annotation_clip=False, size=11, color="#F49D1A", weight='bold')



    axs[0].annotate("Sentinel-2",xy=(1, -4.3), annotation_clip=False,size=11,color= "#F49D1A",weight='bold')
    axs[0].annotate("Sentinel-1",xy=(1, -5.7), annotation_clip=False,size=11,color="#93C6E7",weight='bold')
    axs[0].annotate("Sentinel-1 + Sentinel-2",xy=(1, -2.9), annotation_clip=False,size=11,color="#EB455F",weight='bold')
    tile_mada.plot(ax = axs[8],color="green").axis('off')
    color_base = "black"

    base.plot(ax=axs[8], edgecolor=color_base)
    axs[7].annotate("Sum : " + str(sum(liste_s1)), xy=(1, -5.7), annotation_clip=False, size=11, color="#93C6E7", weight='bold')
    axs[7].annotate("Sum : " + str(sum(liste_s2)), xy=(1, -4.3), annotation_clip=False, size=11, color="#F49D1A", weight='bold')

    fig.suptitle(tile+"  cc <20%", fontsize=16)
    plt.savefig("/home/florent/PycharmProjects/Cyclone/output/test/calendar_tile/"+tile+"_cc20.pdf", format="pdf")
    #plt.show()

# mada_tiles= gpd.read_file("/home/florent/PycharmProjects/Cyclone/ShinyApp/data/mada_Sentinel_tiles/Tile_mada.shp")
# liste_tile = list(mada_tiles["Name"])
#
#
# for l in liste_tile:
#     print(l)
#     calendar_product(l)
