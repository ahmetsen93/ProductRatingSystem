args <- commandArgs(TRUE)
setwd("C:/wamp/www/NLP")
.libPaths("C:/Users/ahmet/Documents/R/win-library/3.3")
library("XML")
library("httr")
source("Rscript/functions.R")


#site <- "hepsiburada.com"
#jump <-"/jump/144284418/?rank=18&catalogueid=33320754&urlpath=/bilgisayar_yazilimlar/bilgisayarlar/dizustu_bilgisayar/asus_x550vx_dm324d_laptop_notebook/id_33320754/normal_urun/fiyat_kiyaslama/marka_sayfasi/outgoing/ilk_3_magazaya_git_butonu/hepsiburada_com/merchant_title_asus_x550vx-dm324d_intel_core_i7_6700hq_2_6ghz___3_5ghz_8gb_1tb_15_6__fhd_tasinabilir_bilgisayar/sid_144284418/price_289900/sira_populer/gorunum_liste/brand_asus/pricerank_3/esas_teklif/fromurl_marka/asus_fromurl"

#############veri cekme#############
result.frame <- data.frame()
tmp <- strsplit(args, " ")

input <- tmp
#input <- "6s"
page <- 1


data.url <- paste("https://www.cimri.com/arama/?q=",input,"&page=",page , sep="")
data.get <- GET(data.url ,encoding="UTF-8")
data.row<-rawToChar (data.get$content)
data.parsed<- htmlParse(data.row)


############sayfaki urun sayisi##############
product.count <- xpathSApply(data.parsed,"//li[@class='clx on spnrfix']")
result.frame <- data.frame(name=NA, commentCount=NA, 
                           jump1=NA, jump1Site=NA, jump1fiyat=NA, jump2=NA, jump2Site=NA, jump2fiyat=NA, jump3=NA, jump3Site=NA, jump3fiyat=NA,
                           
                           star=NA, fiyat=NA, fiyatSecenegi=NA, imageSrc=NA, imageLazySrc=NA, href=NA, 
                           aciklama1=NA, aciklama2=NA, aciklama3=NA, aciklama4=NA, aciklama5=NA,score1=NA,score2=NA,score3=NA)
############for loop##############
for (i in 1:length(product.count)) {
  ###########urun ismi############
  tryCatch({
  result.frame[i,"name"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                     //strong[@class='flBs']
                                                     //b" , sep=""),xmlValue)
  }, error=function(e){})
  ###########urun resim############
  tryCatch({
    result.frame[i,"imageSrc"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //a[@class='flIm mblImgL image-wrapper']
                                                            //img
                                                            /@src" , sep=""))
  }, error=function(e){})
  tryCatch({
    result.frame[i,"imageLazySrc"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //a[@class='flIm mblImgL image-wrapper']
                                                            //img
                                                            /@data-src" , sep=""))
  }, error=function(e){})
  ###########urun href############
  tryCatch({
    result.frame[i,"href"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //a[@class='flIm mblImgL image-wrapper']
                                                            /@href" , sep=""))
  }, error=function(e){})
  ###########urun yorum sayisi############
  tryCatch({
    result.frame[i,"commentCount"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //li[@class='liT'][1]
                                                            //b" , sep=""),xmlValue)[1]
  }, error=function(e){})
  ###########urun jump 1 ############
  tryCatch({
    result.frame[i,"jump1"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //nav[@class='iium']
                                                            //a[@class='dMITop3'][1]
                                                            //strong[@class='mag1']
                                                            /@data-top3link" , sep=""))[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump1Site"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][1]
                                                             //strong[@class='mag1']" , sep=""),xmlValue)[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump1fiyat"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][1]
                                                             //i" , sep=""),xmlValue)[1]
  }, error=function(e){})
  ###########urun jump 2 ############
  tryCatch({
    result.frame[i,"jump2"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //nav[@class='iium']
                                                            //a[@class='dMITop3'][2]
                                                            //strong[@class='mag1']
                                                            /@data-top3link" , sep=""))[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump2Site"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][2]
                                                             //strong[@class='mag1']" , sep=""),xmlValue)[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump2fiyat"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][2]
                                                             //i" , sep=""),xmlValue)[1]
  }, error=function(e){})
  ###########urun jump 3 ############
  tryCatch({
    result.frame[i,"jump3"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //nav[@class='iium']
                                                            //a[@class='dMITop3'][3]
                                                            //strong[@class='mag1']
                                                            /@data-top3link" , sep=""))[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump3Site"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][3]
                                                             //strong[@class='mag1']" , sep=""),xmlValue)[1]
  }, error=function(e){})
  tryCatch({
    result.frame[i,"jump3fiyat"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                             //nav[@class='iium']
                                                             //a[@class='dMITop3'][3]
                                                             //i" , sep=""),xmlValue)[1]
  }, error=function(e){})
  ###########urun fiyat############
  tryCatch({
    result.frame[i,"fiyat"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                            //span[@class='ttF']
                                                            " , sep=""),xmlValue)[2]
  }, error=function(e){})
  ###########urun yildiz############
  tryCatch({
    result.frame[i,"star"] <- length(xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                      //div[@class='op']
                                                      //i[@class='st act']
                                                            " , sep="")))
  }, error=function(e){})
  ###########urun aciklama 1############
  tryCatch({
    result.frame[i,"aciklama1"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                     //ul[@class='urAc']
                                                            //li[1]
                                                            " , sep=""),xmlValue)
  }, error=function(e){})
  
  ###########urun aciklama 2############
  tryCatch({
    result.frame[i,"aciklama2"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                     //ul[@class='urAc']
                                                            //li[2]
                                                            " , sep=""),xmlValue)
  }, error=function(e){})
  ###########urun aciklama 3############
  tryCatch({
    result.frame[i,"aciklama3"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                     //ul[@class='urAc']
                                                            //li[3]
                                                            " , sep=""),xmlValue)
  }, error=function(e){})
  ###########urun aciklama 4############
  tryCatch({
    result.frame[i,"aciklama4"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                                 //ul[@class='urAc']
                                                                 //li[4]
                                                                 " , sep=""),xmlValue)
  }, error=function(e){})
  ###########urun aciklama 5############
  tryCatch({
    result.frame[i,"aciklama5"] <- xpathSApply(data.parsed,paste("//li[@class='clx on spnrfix'][",i,"]
                                                     //ul[@class='urAc']
                                                            //li[5]
                                                            " , sep=""),xmlValue)
  }, error=function(e){})
  
 
 
  tryCatch({
    if((result.frame[i,"jump1Site"]=="n11.com") || (result.frame[i,"jump1Site"]=="hepsiburada.com")){
      yorum.frame<-get.urun.sistem.puani(result.frame[i,"jump1Site"],result.frame[i,"jump1"])
      result.frame[i,"score1"]<-mean(yorum.frame[,"total.score"],na.rm = TRUE)
    }
   
  }, error=function(e){})
  tryCatch({
    if((result.frame[i,"jump2Site"]=="n11.com") || (result.frame[i,"jump2Site"]=="hepsiburada.com")){
      yorum.frame<-get.urun.sistem.puani(result.frame[i,"jump2Site"],result.frame[i,"jump2"])
      result.frame[i,"score2"]<-mean(yorum.frame[,"total.score"],na.rm = TRUE)
    }
  }, error=function(e){})
  tryCatch({
    if((result.frame[i,"jump3Site"]=="n11.com") || (result.frame[i,"jump3Site"]=="hepsiburada.com")){
      yorum.frame<-get.urun.sistem.puani(result.frame[i,"jump3Site"],result.frame[i,"jump3"])
      result.frame[i,"score3"]<-mean(yorum.frame[,"total.score"],na.rm = TRUE)
    }
  }, error=function(e){})
  
  
  print(i)
    if (i == 10){
      break
    }
    
  
  
  
  #######################
}




################fonksiyonlar#################
data.temizle <- function(veri,veri.col){
  veri[,veri.col] <- gsub("\t", "", veri[,veri.col])
  veri[,veri.col] <- gsub("\n", "", veri[,veri.col])
  veri[,veri.col] <- gsub("  ", "", veri[,veri.col])
  return(veri)
}
temizle <- c(1:22)
for(i in temizle){
  result.frame<-data.temizle(result.frame,i)
}

#######################

library(jsonlite)
exportJson<-toJSON(result.frame, pretty = TRUE)
write(exportJson, "getData.json")

