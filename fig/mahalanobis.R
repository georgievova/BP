require(chemometrics)
data(glass)

z <- glass
x<- z[,c(2,4)]
require(robustbase)
x.mcd=covMcd(x)

drawMahal(x,center=x.mcd$center,covariance=x.mcd$cov, quantile = c(0.975, 0.75, 0.5, 0.25, 0.01), pch=1,frame.plot=T,cex=1)

png(filename = "C:/Users/Irina/Disk Google/1_ČZU/BP/!obsah/fig/mahalanobis.png")
drawMahal(x,center=x.mcd$center,covariance=x.mcd$cov, quantile = c(0.975, 0.75, 0.5, 0.25, 0.01), pch=1,frame.plot=TRUE,cex=1)
dev.off()
