args <- commandArgs(TRUE)
setwd("C:/wamp/www/NLP")
.libPaths("C:/Users/ahmet/Documents/R/win-library/3.3")
library("XML")
library("httr")

#############veri cekme#############
result.frame <- data.frame()
tmp <- strsplit(args, " ")

#input <- tmp
input <- "6s"
page <- 1


data.url <- paste("https://www.cimri.com/arama/?q=",input,"&page=",page , sep="")
data.get <- GET(data.url ,encoding="UTF-8")
data.row<-rawToChar (data.get$content)
data.parsed<- htmlParse(data.row)


################fonksiyonlar#################
data.temizle <- function(veri,veri.col){
  veri[,veri.col] <- gsub("\t", "", veri[,veri.col])
  veri[,veri.col] <- gsub("\n", "", veri[,veri.col])
  veri[,veri.col] <- gsub("  ", "", veri[,veri.col])
  veri[,veri.col] <- gsub("devamý \\+", "", veri[,veri.col])
  
  
  return(veri)
}
temizle <- c(1:22)
for(i in temizle){
  result.frame<-data.temizle(result.frame,i)
}

getCurrentComment <- function(path , site){
  
  commentUrl <- paste("www.cimri.com",path , sep="")
  #print(paste(site , path  ,"   ---   ", sep=""))

  if ( site=="n11.com") {
    print(paste("site : " , site  , sep=""))
    n11.data.url <- paste("www.cimri.com", path , sep="")
    n11.data.get <- GET(n11.data.url ,encoding="UTF-8")
    n11.data.row<-rawToChar (n11.data.get$content)
    n11.data.parsed<- htmlParse(n11.data.row)
    n11.commentCount <- xpathSApply(n11.data.parsed,"//li[@class='comment']")
    print(paste("site : " , site ," yorum sayisi : " , length(n11.commentCount) , sep=""))
  } else if ( site=="hepsiburada.com") {
    print(paste("site : " , site  , sep=""))
  } else {}
  #print(paste("site : " , site , "yorum : ", commentUrl , sep=""))
}
############sayfaki urun sayisi##############
product.count <- xpathSApply(data.parsed,"//li[@class='clx on spnrfix']")
result.frame <- data.frame(name=NA, commentCount=NA, 
                           jump1=NA, jump1Site=NA, jump1fiyat=NA, jump2=NA, jump2Site=NA, jump2fiyat=NA, jump3=NA, jump3Site=NA, jump3fiyat=NA,
                           
                           star=NA, fiyat=NA, fiyatSecenegi=NA, imageSrc=NA, imageLazySrc=NA, href=NA, 
                           aciklama1=NA, aciklama2=NA, aciklama3=NA, aciklama4=NA, aciklama5=NA)
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
  
  tryCatch({
    getCurrentComment(result.frame[i,"jump1"] , result.frame[i,"jump1Site"]) 
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
  #######################
}

#######################

library(jsonlite)
exportJson<-toJSON(result.frame, pretty = TRUE)
write(exportJson, "getData.json")

