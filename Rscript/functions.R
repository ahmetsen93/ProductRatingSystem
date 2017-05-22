library("XML")
library("httr")
#install.packages('devtools')
require('devtools')
#install_github('mananshah99/sentR')
require('sentR')

setwd("C:/wamp/www/NLP/Rscript")
clean.text <- function(x, lowercase=TRUE, numbers=TRUE, punctuation=TRUE, spaces=TRUE){
  # x: character string
  
  # lower case
  if (lowercase)
    x = tolower(x)
  # remove numbers
  if (numbers)
    x = gsub("[[:digit:]]", "", x)
  # remove punctuation symbols
  if (punctuation)
    x = gsub("[[:punct:]]", "", x)
  # remove extra white spaces
  if (spaces) {
    x = gsub("[ \t]{2,}", " ", x)
    x = gsub("^\\s+|\\s+$", "", x)
  }
  # return
  x
}
positive <- readLines("positive.txt")
negative <- readLines("negative.txt" , encoding = "UTF-8")

get.urun.puani <- function(title.row.score,comment.row.score,yes.count,no.count,star.score){
  ## puanlama 
  ## yorum 50 puan
  ## baslik 10 puan
  ## yýldýz 20 puan
  ## yes no yorum onay 20 puan
  com.score <- 25
  tryCatch({
    if(title.row.score > 0){
      com.score=com.score +10
    }else if(title.row.score == 0){
      com.score=com.score +5
    }
  }, error=function(e){com.score=com.score +5})
  
  tryCatch({
    if(comment.row.score > 5){
      com.score=com.score +50
    }else if(comment.row.score > 0){
      com.score=com.score +(comment.row.score*10)
    }
  }, error=function(e){com.score=com.score +10})
  
  tryCatch({
    com.score=com.score +(as.numeric(star.score)/5)
  }, error=function(e){com.score=com.score +10})
  
  tryCatch({
    if(no.count < yes.count){
      com.score=com.score +20
    }else if(no.count == yes.count){
      com.score=com.score +10
    }
  }, error=function(e){com.score=com.score +10})
  return(com.score)
}

get.urun.sistem.puani <- function(site,jump){
  Sys.sleep(0.01)
  ###############urun ana url#################
  ana.site <- "www.cimri.com"
  comment.data.url <- paste(ana.site,jump , sep="")
  comment.data.get <- GET(comment.data.url)
  comment.data.row<-rawToChar (comment.data.get$content)
  comment.data.parsed<- htmlParse(comment.data.row)
  
  comment.current.url <- xpathSApply(comment.data.parsed,"//script[14]",xmlValue)
  
  comment.current.url <- gsub(".*http://", "", comment.current.url)
  comment.current.url <- gsub("\".*", "", comment.current.url)
  comment.current.url <- gsub("\n", "", comment.current.url)
  comment.current.url <- gsub("  ", "", comment.current.url)
  comment.current.url
  
  comment.frame <- data.frame()
  comment.frame <- data.frame(title=NA,title.score=NA,comment=NA,comment.score=NA,yes=NA,no=NA,star=NA,total.score=NA)
  
  comment.frame.result <- data.frame()
  
  if ( site=="n11.com") {
    sub.data.get <- GET(comment.current.url)
    sub.data.row<-rawToChar (sub.data.get$content)
    sub.data.parsed<- htmlParse(sub.data.row)
  
  ############n11 verileri################
  n11.comment.count <- xpathSApply(sub.data.parsed,"//li[@class='comment']")
  for (i in 1:length(n11.comment.count)) {
    print(paste("site : " , site  , sep=""))
    tryCatch({
      comment.frame[i,"title"] <- xpathSApply(sub.data.parsed,paste("//li[@class='comment'][",i,"]
                                                                    //h5[@class='commentTitle']" , sep=""),xmlValue)[1]
      clean.title <- clean.text(comment.frame[i,"title"])
      comment.frame[i,"title.score"] <- classify.aggregate(clean.title, positive, negative)
    
    }, error=function(e){})
    tryCatch({
      comment.frame[i,"comment"] <- xpathSApply(sub.data.parsed,paste("//li[@class='comment'][",i,"]
                                                                      //p[@itemprop='description']" , sep=""),xmlValue)[1]
      clean.comment <- clean.text(comment.frame[i,"comment"])
      comment.frame[i,"comment.score"] <- classify.aggregate(clean.comment, positive, negative)
      
    }, error=function(e){})
    tryCatch({
      comment.frame[i,"yes"] <- xpathSApply(sub.data.parsed,paste("//li[@class='comment'][",i,"]
                                                                  //button[@class='btn btnGrey small btnComment yesBtn']
                                                                  //em" , sep=""),xmlValue)[1]
      comment.frame[i,"yes"] <- gsub(")", "", comment.frame[i,"yes"])
      comment.frame[i,"yes"] <- gsub("\\(", "", comment.frame[i,"yes"])
    }, error=function(e){})
    tryCatch({
      comment.frame[i,"no"] <- xpathSApply(sub.data.parsed,paste("//li[@class='comment'][",i,"]
                                                                 //button[@class='btn btnGrey small btnComment noBtn']
                                                                 //em" , sep=""),xmlValue)[1]
      comment.frame[i,"no"] <- gsub(")", "", comment.frame[i,"no"])
      comment.frame[i,"no"] <- gsub("\\(", "", comment.frame[i,"no"])
    }, error=function(e){})
    tryCatch({
      comment.frame[i,"star"] <- xpathSApply(sub.data.parsed,paste("//li[@class='comment'][",i,"]
                                                                   //div[@class='ratingCont']
                                                                   //span
                                                                   /@class" , sep=""))[1]
      comment.frame[i,"star"] <- gsub("rating", "", comment.frame[i,"star"])
      comment.frame[i,"star"] <- gsub("r", "", comment.frame[i,"star"])
    }, error=function(e){})
    
   # title.row.score,comment.row.score,yes.count,no.count,star.score
    comment.frame[i,"total.score"]<- get.urun.puani(comment.frame[i,"title.score"],comment.frame[i,"comment.score"],
                                                    comment.frame[i,"yes"],comment.frame[i,"no"],comment.frame[i,"star"])
  }
    comment.frame.result <- comment.frame
  } else if ( site=="hepsiburada.com") {
    print(paste("site : " , site  , sep=""))
    comment.current.url <- gsub("\\?.*", "", comment.current.url)
    
    sub.data.get <- GET(paste(comment.current.url, "-yorumlari", sep=""))
    sub.data.row<-rawToChar (sub.data.get$content)
    sub.data.parsed<- htmlParse(sub.data.row)
    hepsiburada.comment.page.count <- xpathSApply(sub.data.parsed,"//div[@id='pagination']
                                                  //ul
                                                  //li")
    comment.frame.result <- data.frame()
    for (k in 1:length(hepsiburada.comment.page.count)) {
      comment.frame <- data.frame()
      
      sub.data.get <- GET(paste(comment.current.url, "-yorumlari?sayfa=",k  , sep=""))
      sub.data.row<-rawToChar (sub.data.get$content)
      sub.data.parsed<- htmlParse(sub.data.row)
      
      
      hepsiburada.comment.count <- xpathSApply(sub.data.parsed,"//li[@class='review-item']")
      for (i in 1:length(hepsiburada.comment.count)) {
      tryCatch({
        comment.frame[i,"title"] <- xpathSApply(sub.data.parsed,paste("//li[@class='review-item'][",i,"]
                                                                      //strong[@class='subject']" , sep=""),xmlValue)[1]
        clean.title <- clean.text(comment.frame[i,"title"])
        comment.frame[i,"title.score"] <- classify.aggregate(clean.title, positive, negative)
      }, error=function(e){})
      tryCatch({
        comment.frame[i,"comment"] <- xpathSApply(sub.data.parsed,paste("//li[@class='review-item'][",i,"]
                                                                         //p[@class='review-text']" , sep=""),xmlValue)[1]
        clean.comment <- clean.text(comment.frame[i,"comment"])
        comment.frame[i,"comment.score"] <- classify.aggregate(clean.comment, positive, negative)
      }, error=function(e){})
      tryCatch({
        comment.frame[i,"yes"] <- xpathSApply(sub.data.parsed,paste("//li[@class='review-item'][",i,"]
                                                                     //a[@class='yes']
                                                                     //b" , sep=""),xmlValue)[1]
        comment.frame[i,"yes"] <- gsub(")", "", comment.frame[i,"yes"])
        comment.frame[i,"yes"] <- gsub("\\(", "", comment.frame[i,"yes"])
      }, error=function(e){})
      tryCatch({
        comment.frame[i,"no"] <- xpathSApply(sub.data.parsed,paste("//li[@class='review-item'][",i,"]
                                                                     //a[@class='yes'][2]
                                                                     //b" , sep=""),xmlValue)[1]
        comment.frame[i,"no"] <- gsub(")", "", comment.frame[i,"no"])
        comment.frame[i,"no"] <- gsub("\\(", "", comment.frame[i,"no"])
      }, error=function(e){})
      tryCatch({
        comment.frame[i,"star"] <- xpathSApply(sub.data.parsed,paste("//li[@class='review-item'][",i,"]
                                                                         //div[@class='ratings active']
                                                                     /@style" , sep=""))[1]
        comment.frame[i,"star"] <- gsub("width:", "", comment.frame[i,"star"])
        comment.frame[i,"star"] <- gsub("%", "", comment.frame[i,"star"])
      }, error=function(e){})
        comment.frame[i,"total.score"]<- get.urun.puani(comment.frame[i,"title.score"],comment.frame[i,"comment.score"],
                                                        comment.frame[i,"yes"],comment.frame[i,"no"],comment.frame[i,"star"])
      }
      comment.frame.result <- rbind(comment.frame.result, comment.frame)
    }
  } else {}
  ##################################
  return(comment.frame.result)
}

#site <- "hepsiburada.com"
#jump <-"/jump/144284418/?rank=18&catalogueid=33320754&urlpath=/bilgisayar_yazilimlar/bilgisayarlar/dizustu_bilgisayar/asus_x550vx_dm324d_laptop_notebook/id_33320754/normal_urun/fiyat_kiyaslama/marka_sayfasi/outgoing/ilk_3_magazaya_git_butonu/hepsiburada_com/merchant_title_asus_x550vx-dm324d_intel_core_i7_6700hq_2_6ghz___3_5ghz_8gb_1tb_15_6__fhd_tasinabilir_bilgisayar/sid_144284418/price_289900/sira_populer/gorunum_liste/brand_asus/pricerank_3/esas_teklif/fromurl_marka/asus_fromurl"

#site <- "n11.com"
#jump <-"/jump/128932259/?rank=17&catalogueid=762459&urlpath=/cep_telefonu/cep_telefonlari_x/cep_telefonlari/apple_iphone_6_16gb_uzay_grisi/id_762459/normal_urun/fiyat_kiyaslama/genel_arama_sayfasi/keyword_iphone/outgoing/ilk_3_magazaya_git_butonu/n11_com/merchant_title_apple_iphone_6_16_gb_cep_telefonu/sid_128932259/price_222900/sira_populer/gorunum_liste/brand_apple/pricerank_3/esas_teklif/fromurl_arama/?q=iphone_fromurl"

#yorum.frame<-get.urun.sistem.puani(site,jump)
#mean(yorum.frame[,"total.score"],na.rm = TRUE)