


# Koláčové grafy se mnohdy používají nekorektně, vnímání takových grafu je obtížné. Následující graf je takovým příkladem.
# ```{r pie_3D, echo=FALSE, fig.align = 'center', out.width='75%'}
# slices <- c(2,2,3,3)
# lbls <- c("Zavádějící (20%)", "Matoucí (20%)", "Dobré (30%)", "Nečitelné (30%)")
# lp <- pie3D(slices, radius=1.19, height = 0.16, theta=pi/20, start=0.8, shade=0.5, main="Vnimání 3D koláčových grafů", border=NA)
# 
# pie3D.labels(lp, labels = lbls, labelcex = 1.2, labelrad = 1.8)
# ```
# Jednotlivé kategorie tohoto grafu mají podobné procentuální zastoupení, ale protože modrá výseč se nachází nejblíž, vnímá se jako dominantní. Přestože tento příklad se považuje za extrémní, 3D koláčové grafy i s malým počtem kategorii se těžce rozlišují.
# 
# ```{r, echo=FALSE, fig.align = 'center', out.width = '65%', eval=FALSE}
# knitr::include_graphics("3Dpie.png")
# ```
# Další častou chybou je nekorektní vyznačení procentuálního zastoupení jednotlivých kategorii. ??

x <- rnorm(300, 4, 2.5)
boxplot(x)
