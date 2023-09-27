library(osmdata)
library(sf)
#
q1 <- opq(c(43.0874,-23.5311, 44.1499,-21.7478)) %>%
    add_osm_feature(key = 'highway')
#
# q2 <-opq(c(43.6707,-23.3642, 43.69214,-23.37285)) %>%
#     add_osm_feature(key = 'water')
#
# q3 <-opq(c(43.6707,-23.3642, 43.69214,-23.37285)) %>%
#     add_osm_feature(key = 'building')
#
highway2 <- osmdata_sf(q1)
# water <- osmdata_sp(q2)
# building <- osmdata_sp(q3)
#
print(highway2$osm_lines)
st_write(highway2$osm_lines,"/home/florent/PycharmProjects/Cimopolee_BETA/data/OSm/freddy/test.shp")
# sp::plot(highway$osm_lines,col="red")
# sp::plot(water$osm_polygons, col="blue",add=TRUE)
# sp::plot(building$osm_polygons, col="black",add=TRUE,border="transparent")

####################################################################################
# library(sp)
# library(ncdf4)
# library(leaflet)
# library(raster)
#
# netCDF_file <- "/home/florent/PycharmProjects/ShinyApp/data/GPM_netcdf/3B-DAY-E.MS.MRG.3IMERG.20160207-S000000-E235959.V06.nc4.nc"
# # Load raster and set projection and lat/lon extent
# pr <- raster(netCDF_file, crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
# d <-  flip(t(pr), direction = "x")
#
# # underlay basic leaflet map, overlayed with JSON boundary and raster grid
# leaflet() %>% addTiles() %>%
#     addRasterImage(d, opacity = .7)
building
285
67864

road
258
22.3
