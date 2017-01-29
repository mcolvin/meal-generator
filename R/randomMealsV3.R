#===============================================================================
# RANDOM MEAL GENERATOR
# 8 SEPT 2007: BEGAN TO ADD BREAKFAST
# need to allow only dinners from previous week to be subset out, not breakfast
#===============================================================================
require(RODBC)
require(pander)
require(knitr)
library(markdown)
require(xtable)
setwd_fun("C:/Users/colvinm/Documents/mikesPersonal/recipes",
	"C:/Documents and Settings/mcolvin/My Documents/mikesPersonal/recipes")
channel2<-odbcConnectExcel2007("./Random Meals 3_0.xlsx")
meals<-sqlFetch(channel2, "Meals")
ingred<-sqlFetch(channel2, "Ingrdients")
directions<-sqlFetch(channel2, "Directions")
odbcClose(channel2)
# SUBSET OUT SEASONAL
xx<- subset(meals, Season %in% c("All", "Fall, Winter, Spring") & mealId != -99 & meal !="B" & mealType == "Main" & ingred==1 )

out<-data.frame(
	day=c("M","T","W","R","F"),#,"S","S"),
	ord=c(1:5),
	mealId=c(sample(xx[xx$Day=="MONDAY",]$mealId,1),sample(xx[xx$Day=="TUESDAY",]$mealId,1),
		sample(xx[xx$Day=="WEDNESDAY",]$mealId,1),sample(xx[xx$Day=="THURSDAY",]$mealId,1),
		sample(xx[xx$Day=="FRIDAY",]$mealId,1)#,sample(xx[xx$Day%in%c("SATURDAY","SUNDAY"),]$mealId,2)))
	))
out<- merge(out, meals[,c(1,3)], by="mealId", all.x=TRUE)
id<-c(201,2005,2007,2038,2040)

# DATASETS NEEDED FOR MARKDOWN FILE
shoppinglist<-aggregate(amount~summaryField + item + unit, ingred, sum, subset=MealId %in% c(out$mealId,0))
shoppinglist<- shoppinglist[order(shoppinglist$summaryField),]
mealName<- meals[meals$mealId %in% c(directions$mealId),c(1,3)]

knit2html("./OUTP.Rmd",fragment.only=TRUE)
