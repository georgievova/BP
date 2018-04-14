require(dplyr)
require(data.table)
require(ggplot2)
require(lattice)

#Labe od pramene po Svatopetrský potok včetně
UPOV_ID_orig <- readRDS(file.path(.datadir, "res/HSL_0010.rds"))
UPOV_ID <- UPOV_ID_orig %>% select(DTM, P)
UPOV_ID$year <- year(UPOV_ID$DTM)
UPOV_ID <- UPOV_ID[year == 2010, ]
#UPOV_ID <- UPOV_ID[year %in% seq(1995,2010,1), ]
length(unique(year(UPOV_ID$DTM)))

UPOV_ID.m <-
  UPOV_ID %>%  select(DTM, T, year) %>% melt(id.vars = c("DTM", "year")) %>% group_by(year) %>% mutate(dtm2 = 1:n())
UPOV_ID.m$year <- as.factor(UPOV_ID.m$year)


par(mfrow = c(3, 1))

my.settings <- list(par.main.text = list(
  font = 2,
  # make it bold
  just = "left",
  x = grid::unit(5, "mm")
))

# p2 = xyplot(P~DTM, data = UPOV_ID, par.settings=my.settings,
#             xlab = 'DTM', ylab = 'P', main="`lattice`" , type="l")

# ggplot(data=UPOV_ID.m, aes(dtm2, value, group=year, color =as.numeric(year)))+geom_line()+
#   theme_bw()+labs(title="`ggplot2`")


ggplot(data = UPOV_ID, aes(DTM, P)) +
  geom_line() +
  labs(title = "`ggplot2`")


plot(
  UPOV_ID$DTM,
  UPOV_ID$P,
  type = "l",
  xlab = "DTM",
  ylab = "P",
  main = "`base`"
)


xyplot(
  P ~ DTM,
  data = UPOV_ID,
  type = "l",
  xlab = 'DTM',
  ylab = 'P',
  main = "`lattice`"
)
#update(p2, col = "black")


## prostorova data

povodi <- readRDS(file.path(.datadir, "webapp_data/geo_rds/povodi.rds"))
BM_orig <- readRDS(file.path(.datadir, "webapp_data/mbilan/bilan_month_data_table.rds"))
BM <- BM_orig %>% filter(variable == "P", year(DTM) == 2010, month(DTM) == 8) %>% select(UPOV_ID, value)

povodi <- sp::merge(povodi, BM, by.x="UPOV_ID")
x <- data.frame(UPOV_ID=povodi$UPOV_ID,id= as.character(0:1111))
x$id <- as.character(x$id)

#base------------
library(RColorBrewer)
pal <- brewer.pal(c(6), "Blues")
pal <- c("#000511", "#011a56", "#022b8c", "#043fcc", "#024dff")
pal_cuts <- cut(povodi$value, c(0,100,200,300,400,500))
plot(povodi, col = pal[pal_cuts])

rbPal <- colorRampPalette(c('#00001a','#0053ff'))
povodi$col <- rbPal(10)[as.numeric(cut(povodi$value, breaks = 10))]
plot(povodi, col = povodi$col)
#----------------

#ggplot------------
install.packages("broom")
require(broom)

moje_barvicky <- unique(pal2(sort(povodi$value)))

povodi.gg <- tidy(povodi)
povodi.gg <- base::merge(povodi.gg, x, by="id")
povodi.gg <- base::merge(povodi.gg, BM, by="UPOV_ID")
povodi.gg$hodnota <- cut(povodi.gg$value, 10)
ggplot(data = povodi.gg) + 
  geom_polygon(aes(long, lat, group = group, fill=hodnota), color = "black", show.legend = F) + 
  theme_bw()+scale_fill_manual(values=moje_barvicky)
#------------------

#leaflet-----------
require(leaflet)

moje <- c("#000511", "#011a56", "#022b8c", "#043fcc", "#024dff")
pal <- colorBin(moje, domain = povodi$value, pretty = TRUE, na.color = "gray30")

leaflet() %>% addPolygons(data=povodi, color = "black",
                                          weight = 1, opacity = 1, smoothFactor = 0,
                                          fillColor = ~pal(value), fillOpacity = 1)
#------------------

#raster------------
require(raster)
povodi_0 <- readOGR(file.path('C:\\Users\\Irina\\ownCloud\\Shared\\BILAN_UPOV\\data/geo/E_HEIS$UPV_HLGP#P2$wm.shp'), 'E_HEIS$UPV_HLGP#P2$wm')
povodi_0 <- spTransform(povodi_0, CRS("+init=epsg:4326"))
povodi <- sp::merge(povodi_0, BM, by="UPOV_ID")

values(raster.povodi) <- 1:ncell(raster.povodi)
raster.povodi <- mask(raster.povodi, povodi_0)
plot(raster.povodi)
plot(povodi_0, add=TRUE)
#------------------
povodi <- readRDS(file.path(.datadir, "webapp_data/geo_rds/povodi.rds"))
BM_orig <- readRDS(file.path(.datadir, "webapp_data/mbilan/bilan_month_data_table.rds"))
BM <- BM_orig %>% filter(variable == "P", year(DTM) == 2010, month(DTM) == 8) %>% select(UPOV_ID, value)

povodi <- sp::merge(povodi, BM, by.x="UPOV_ID")



r.polys <- rasterize(povodi, r, field = povodi$value, fun = "mean", 
                    na.rm=TRUE)

pal1 <- brewer.pal(c(9), "Spectral")
pal2 <- colorBin(pal1, domain = povodi$value, pretty = TRUE, na.color = "gray30")

######konecna verze

r.polys <- rasterize(povodi, raster(povodi, res = 0.1), field = povodi$value, fun = "mean", update = TRUE, updateValue = "NA")

plot(r.polys, col=unique(pal2(sort(povodi$value))), xlab = "long", ylab = "lat")

