<?php error_reporting(0); ?>
<!DOCTYPE html>
<html lang="en" class="no-js">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NLP Proje</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="assets/css/custom.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/preloading.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="assets/css/custom.css" />
    <style>
    </style>
    <script>
        $( document ).ready(function() {
            $("#loader-wrapper").fadeOut( "slow" );
        });
    </script>
</head>
<body>
<div id="loader-wrapper" style="background-color: rgba(119, 119, 119, 0.68); ">
    <p style="position: fixed; top: 60%; left: 40%; width: 20%; border: transparent; resize: none; background-color: transparent; text-align: center; font-size: 28px; color: white;">Ürün yorumları <br/><span> puanlandırılıyor...</span><br/><span style="font-size: 16px;">(Bu işlem ortalama 1 dakika sürmektedir.)</span></p>


    <div id="loader">  </div>
</div>
    <div class="col-md-12" style="background-color: #dedede; height: 22px; ">
        <span class="pull-right">Natural Language Processing - Ahmet ŞEN</span>
    </div>
    <?php
    $searchIsOpen=false;
    if($_GET['search'] && $_GET['search']!=""){
        $ilkZaman = time();
        $searchIsOpen=true;
        exec('"C:\Program Files\R\R-3.3.2\bin\Rscript.exe" "Rscript/cimri.r" "'.$_GET['search'].'"', $response);
    }
    if($searchIsOpen){ ?>
    <div class="col-md-12" style="background-color: rgba(222, 222, 222, 0.25); height: 70px; ">
        <div class="col-md-6" style="margin-top: 10px;">
            <div id="custom-search-input" >
                <form class="form-search" action="" method="post" style="height: 33px; ">
                    <div class="input-group col-md-12">
                        <input class="form-control input-lg" type="text" name="searchBox" value="<?=$_GET['search'] ?>" type="text" placeholder="Ne aramıştınız?">
                        <span class="input-group-btn">
                            <button class="btn btn-info btn-lg" name="submit" type="submit">
                                <i class="glyphicon glyphicon-search"></i>
                            </button>
                        </span>
                </form>
            </span>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="col-xs-12 col-md-12 col-lg-8 col-lg-offset-2">
            <?php
            $string = file_get_contents("Rscript/getData.json");
            $string = mb_convert_encoding($string, "UTF-8", "ISO-8859-9");
            $json_query = json_decode($string, true);
            $durum=array("yıl"=>31556926, "ay"=>2629743.83, "hafta"=>604800, "gün"=>86400, "saat"=>3600, "dakika"=>60, "saniye"=>1) ;
            $fark = time() - $ilkZaman;
            foreach ($durum as $isim => $saniye) {
                $gecen_zaman=floor($fark/$saniye);
                $gecen=$gecen_zaman . " ". $isim ;
                if($gecen_zaman > 0) break;
            }
            ?>
            <div style="margin: 10px;">
                <p>Arama süresi : <?php echo $gecen; ?></p>
            </div>
            <?php
            for ($i = 0; $i < count($json_query); $i++) {
            ?>
            <div class="col-md-12 urun_info" style="background-color: rgba(239, 239, 239, 0.06); border: 1px solid rgba(142, 146, 150, 0.14); min-height: 170px;  margin:5px; 0">
                <div class="col-md-2" style="height: 165px;">
                    <img width="165" height="165" style="left: -20px; position: relative;" src="<?php if(strcasecmp($json_query[$i]['imageSrc'],'//cdn02.cimri.com/img/lazy.png')){ echo $json_query[$i]['imageSrc'];}else{echo $json_query[$i]['imageLazySrc'];}?>">
                </div>
                <div class="col-md-5" style="background-color: ; height: 165px;">
                    <h4><b><?=$json_query[$i]['name']?></b></h4>
                    <?php
                    if($json_query[$i]['commentCount']>0) {
                        $oran =$json_query[$i]['commentCount'] * 20;
                        ?>
                        <span>Referans site puanı: </span>
                        <div class="star-ratings-css" style="display: inline-block;">
                            <div class="star-ratings-css-top" style="width:<?=$oran?>%">
                                <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
                            <div class="star-ratings-css-bottom">
                                <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
                        </div>
                        <span> &nbsp;&nbsp;&nbsp;(<?= $json_query[$i]['commentCount'] ?> yorum)</span>
                        <?php
                    }
                    ?>
                        <div>
                            <span class="glyphicon glyphicon-ok"
                                      style="color: #0564c5; display: block; margin: 3px;"> <span style="color: black;"><?= $json_query[$i]['aciklama1'] ?></span></span>
                            <span class="glyphicon glyphicon-ok"
                                  style="color: #0564c5; display: block; margin: 3px;"> <span style="color: black;"><?= $json_query[$i]['aciklama2'] ?></span></span>
                            <span class="glyphicon glyphicon-ok"
                                  style="color: #0564c5; display: block; margin: 3px;"> <span style="color: black;"><?= $json_query[$i]['aciklama3'] ?></span></span>
                            <span class="glyphicon glyphicon-ok"
                                  style="color: #0564c5; display: block; margin: 3px;"> <span style="color: black;"><?= $json_query[$i]['aciklama4'] ?></span></span>
                        </div>
                </div>
                <div class="col-md-5" style="height: 165px; color: white;">
                    <div style="height: 50px; margin-top: 15px; margin-bottom: 5px; background-color: #fd9530">
                        <p style="font-size: 20px; top:12px; left: 30px; position: relative;"><b><?=$json_query[$i]['fiyat']?></b></p>
                    </div>
                    <div style="height: 28px; margin-bottom: 5px; background-color: #ffc939">
                        <p style="font-size: 20px;left: 20px; position: relative;">Mağazalari Göster <i class="fa fa-angle-right" aria-hidden="true"></i></p>
                    </div>
                    <b><div class="urun_sub_info" style="display:none; border: 2px solid #ffc939; color: black; z-index: 999; font-size: 11px; margin-bottom: 15px;">
                    <?php
                    for($k = 1; $k < 4; $k++){
                        if(!strcasecmp($json_query[$i]['jump'.$k.'Site'],"n11.com") || !strcasecmp($json_query[$i]['jump'.$k.'Site'],"hepsiburada.com") ){
                            $urunOran = $json_query[$i]['score'.$k];
                        ?>
                            <a href="<?php echo "https://www.cimri.com".$json_query[$i]['jump'.$k] ;?>" target="_blank" ><span style=" position: relative; left: 5px;"><?php echo $json_query[$i]['jump'.$k.'Site'];?> (<span><?php echo $json_query[$i]['jump'.$k.'fiyat'];?>) </span></span> </a>
                        &nbsp;   <?php
                            if ($urunOran!=null){
                            ?>
                        <div class="star-ratings-css" style="display: inline-block;">
                            <div class="star-ratings-css-top" style="width:<?php echo $urunOran;?>%">
                                <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
                            <div class="star-ratings-css-bottom">
                                <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span></div>
                        </div>
                            <?php
                            }else{
                                echo " (Yorumsuz ürün!)";
                            }
                            ?>
                        <br/>
                        <?php
                        }
                    }?>
                    </div></b>
                </div>
            </div>
            <?php } ?>
        </div>
    </div>
    <?php } ?>
    <?php if(!$searchIsOpen){ ?>
            <div class="col-md-12">
                <div class="container" >
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2">
                            <div id="custom-search-input" style="margin-top: 45%; ">
                                <form class="form-search" action="" method="post" style="height: 35px; ">
                                    <div class="input-group col-md-12">
                                        <input class="form-control input-lg" type="text" name="searchBox" value="<?=$_GET['search'] ?>" type="text" placeholder="Ne aramıştınız?">
                                        <span class="input-group-btn">
                                    <button class="btn btn-info btn-lg" name="submit" type="submit">
                                        <i class="glyphicon glyphicon-search"></i>
                                    </button>
                                </span>
                                </form>
                            </div>
                        </div>
                    </div>
            </div>
        </div>
    </div>
    <?php } ?>
<script>
    $( document ).ready(function() {
        $(".urun_info").hover(function(){
            $(this).find( ".urun_sub_info" ).show();
        },function(){
            $(this).find( ".urun_sub_info" ).hide();
        });
        $(window).on("unload", function(e) {
            $("#loader-wrapper").fadeIn( "slow" );
        });
        $( ".form-search" ).submit(function( event ) {
            $("#loader-wrapper").fadeIn( "slow" );
            window.location.replace("index.php?search="+$("input[name=searchBox]").val());
            event.preventDefault();
        });
    });
</script>
</body>
</html>