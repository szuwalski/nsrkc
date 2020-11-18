
library(miceadds)
library(ggplot2)
library(ggridges)
library(dplyr)
library(PBSmodelling)
library(reshape2)

#==uncommetn here if you do not have devtools and gmr installed
require(devtools)
install.packages("szuwalski/gmr")
library(gmr)

mod_names <- c("NSRKC_Hamachan_growth","NSRKC_const_est_molt_inc")
.MODELDIR = c("./1_nsrkc/","./1_nsrkc_estgrow/")
.THEME    = theme_bw(base_size = 12, base_family = "") +
  theme(strip.text.x = element_text(margin= margin(1,0,1,0)),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        strip.background = element_rect(color="white",fill="white"))

.OVERLAY  = TRUE
.SEX      = c("Aggregate","Male","Female")
.FLEET    = c("Winter_com","Summer_com","ADFG Trawl","NMFS_Trawl")
.TYPE     = c("Retained","Discarded","Total")
.SHELL    = c("New","Old")
.MATURITY = c("Aggregate","Mature","Immature")
.SEAS     = c("1","2","3","4","5","6","7")

fn       <- paste0(.MODELDIR, "gmacs")
M        <- lapply(fn, read_admb) #need .prj file to run gmacs and need .rep file here
names(M) <- mod_names


plot_catch(M,x_leg=0.85,y_leg=0.8)

plot_cpue(M, ShowEstErr = TRUE, "ADFG Trawl", ylab = "Survey biomass")
plot_cpue(M, ShowEstErr = TRUE, "NMFS_Trawl", ylab = "Survey biomass")



plot_F(M,in_leg_x=.8,in_leg_y=.9)

plot_growth_inc(M)

plot_molt_prob(M)

plot_selectivity(M)

plot_recruitment(M)

mdf <- .get_sizeComps_df(M)
for(x in 1:length(mdf))
{
png(paste("plots/size_comp_",x,".png",sep=""),height=8,width=8,res=500,units='in')
plot_size_comps(M,which=x)
dev.off()
}

for(x in 1:length(mdf))
{
  png(paste("plots/size_ridges_",x,".png",sep=""),height=8,width=8,res=500,units='in')
  plot_size_ridges(M,which=x)
  dev.off()
}

plot_natural_mortality(M, plt_knots = FALSE)

plot_ssb(M)

plot_recruitment_size(M)

plot_kobe(M,fleet_in="Summer_com")

