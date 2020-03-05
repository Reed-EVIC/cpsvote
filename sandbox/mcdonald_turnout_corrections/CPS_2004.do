* Replication code for Hur and Achen correction

* apply Hur and Achen correction
* correction = VEP/CPS state level turnout rate, where PES1==1 set to missing
* correction = (1-VEP)/(1-CPS state level turnout rate), where PES1==0 set to missing

set mem 100m

use "<INSERT YOUR FILE PATH & NAME>", clear

gen vote = PES1
recode vote (-1 = .)
recode vote (-2 -3 -9 = 2)
recode vote (2=0)

gen vote_missing = PES1
recode vote_missing (-1 -2 -3 -9 = .)
recode vote_missing (2=0)

* add state dummies 

 gen  ME=0
 gen  NH=0
 gen  VT=0
 gen  MA=0
 gen  RI=0
 gen  CT=0
 gen  NY=0
 gen  NJ=0
 gen  PA=0
 gen  OH=0
 gen  IN=0
 gen  IL=0
 gen  MI=0
 gen  WI=0
 gen  MN=0
 gen  IA=0
 gen  MO=0
 gen  ND=0
 gen  SD=0
 gen  NE=0
 gen  KS=0
 gen  DE=0
 gen  MD=0
 gen  DC=0
 gen  VA=0
 gen  WV=0
 gen  NC=0
 gen  SC=0
 gen  GA=0
 gen  FL=0
 gen  KY=0
 gen  TN=0
 gen  AL=0
 gen  MS=0
 gen  AR=0
 gen  LA=0
 gen  OK=0
 gen  TX=0
 gen  MT=0
 gen  ID=0
 gen  WY=0
 gen  CO=0
 gen  NM=0
 gen  AZ=0
 gen  UT=0
 gen  NV=0
 gen  WA=0
 gen  OR=0
 gen  CA=0
 gen  AK=0
 gen  HI=0


 replace  ME=1 if (GESTCEN==11)
 replace  NH=1 if (GESTCEN==12)
 replace  VT=1 if (GESTCEN==13)
 replace  MA=1 if (GESTCEN==14)
 replace  RI=1 if (GESTCEN==15)
 replace  CT=1 if (GESTCEN==16)
 replace  NY=1 if (GESTCEN==21)
 replace  NJ=1 if (GESTCEN==22)
 replace  PA=1 if (GESTCEN==23)
 replace  OH=1 if (GESTCEN==31)
 replace  IN=1 if (GESTCEN==32)
 replace  IL=1 if (GESTCEN==33)
 replace  MI=1 if (GESTCEN==34)
 replace  WI=1 if (GESTCEN==35)
 replace  MN=1 if (GESTCEN==41)
 replace  IA=1 if (GESTCEN==42)
 replace  MO=1 if (GESTCEN==43)
 replace  ND=1 if (GESTCEN==44)
 replace  SD=1 if (GESTCEN==45)
 replace  NE=1 if (GESTCEN==46)
 replace  KS=1 if (GESTCEN==47)
 replace  DE=1 if (GESTCEN==51)
 replace  MD=1 if (GESTCEN==52)
 replace  DC=1 if (GESTCEN==53)
 replace  VA=1 if (GESTCEN==54)
 replace  WV=1 if (GESTCEN==55)
 replace  NC=1 if (GESTCEN==56)
 replace  SC=1 if (GESTCEN==57)
 replace  GA=1 if (GESTCEN==58)
 replace  FL=1 if (GESTCEN==59)
 replace  KY=1 if (GESTCEN==61)
 replace  TN=1 if (GESTCEN==62)
 replace  AL=1 if (GESTCEN==63)
 replace  MS=1 if (GESTCEN==64)
 replace  AR=1 if (GESTCEN==71)
 replace  LA=1 if (GESTCEN==72)
 replace  OK=1 if (GESTCEN==73)
 replace  TX=1 if (GESTCEN==74)
 replace  MT=1 if (GESTCEN==81)
 replace  ID=1 if (GESTCEN==82)
 replace  WY=1 if (GESTCEN==83)
 replace  CO=1 if (GESTCEN==84)
 replace  NM=1 if (GESTCEN==85)
 replace  AZ=1 if (GESTCEN==86)
 replace  UT=1 if (GESTCEN==87)
 replace  NV=1 if (GESTCEN==88)
 replace  WA=1 if (GESTCEN==91)
 replace  OR=1 if (GESTCEN==92)
 replace  CA=1 if (GESTCEN==93)
 replace  AK=1 if (GESTCEN==94)
 replace  HI=1 if (GESTCEN==95)

* 2004 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.691398876991858/0.7572 if (AK==1 & vote_missing==1)
replace correction = 0.572013045198996/0.7053 if (AL==1 & vote_missing==1)
replace correction = 0.535720439872649/0.6227 if (AR==1 & vote_missing==1)
replace correction = 0.541446092433204/0.7167 if (AZ==1 & vote_missing==1)
replace correction = 0.587807045175604/0.711 if (CA==1 & vote_missing==1)
replace correction = 0.667042025607206/0.7468 if (CO==1 & vote_missing==1)
replace correction = 0.649797019261162/0.7474 if (CT==1 & vote_missing==1)
replace correction = 0.542980548845294/0.7894 if (DC==1 & vote_missing==1)
replace correction = 0.641551212008165/0.7621 if (DE==1 & vote_missing==1)
replace correction = 0.644248287228993/0.7505 if (FL==1 & vote_missing==1)
replace correction = 0.561716686846007/0.645 if (GA==1 & vote_missing==1)
replace correction = 0.482286522452989/0.6029 if (HI==1 & vote_missing==1)
replace correction = 0.69881094414346/0.7512 if (IA==1 & vote_missing==1)
replace correction = 0.632425527862047/0.6579 if (ID==1 & vote_missing==1)
replace correction = 0.614959623228926/0.7413 if (IL==1 & vote_missing==1)
replace correction = 0.547926222090488/0.6469 if (IN==1 & vote_missing==1)
replace correction = 0.615812144486878/0.6832 if (KS==1 & vote_missing==1)
replace correction = 0.587315982770319/0.7007 if (KY==1 & vote_missing==1)
replace correction = 0.610509325062455/0.7166 if (LA==1 & vote_missing==1)
replace correction = 0.642364018668608/0.7522 if (MA==1 & vote_missing==1)
replace correction = 0.628532822036611/0.7344 if (MD==1 & vote_missing==1)
replace correction = 0.737953941632788/0.7842 if (ME==1 & vote_missing==1)
replace correction = 0.666286094040437/0.7814 if (MI==1 & vote_missing==1)
replace correction = 0.783663554624619/0.8507 if (MN==1 & vote_missing==1)
replace correction = 0.653286318795681/0.7335 if (MO==1 & vote_missing==1)
replace correction = 0.557030261644841/0.6882 if (MS==1 & vote_missing==1)
replace correction = 0.644308678261259/0.7321 if (MT==1 & vote_missing==1)
replace correction = 0.578127412520469/0.6638 if (NC==1 & vote_missing==1)
replace correction = 0.648059919748033/0.7442 if (ND==1 & vote_missing==1)
replace correction = 0.62933437154129/0.7069 if (NE==1 & vote_missing==1)
replace correction = 0.708618207367296/0.7873 if (NH==1 & vote_missing==1)
replace correction = 0.637747218760514/0.7479 if (NJ==1 & vote_missing==1)
replace correction = 0.589588033383326/0.6884 if (NM==1 & vote_missing==1)
replace correction = 0.552528802880586/0.6742 if (NV==1 & vote_missing==1)
replace correction = 0.580249359148818/0.708 if (NY==1 & vote_missing==1)
replace correction = 0.66778722674528/0.7334 if (OH==1 & vote_missing==1)
replace correction = 0.582979467403434/0.6647 if (OK==1 & vote_missing==1)
replace correction = 0.720056320859498/0.7996 if (OR==1 & vote_missing==1)
replace correction = 0.625635821812828/0.7184 if (PA==1 & vote_missing==1)
replace correction = 0.58515013229104/0.707 if (RI==1 & vote_missing==1)
replace correction = 0.529518257108761/0.6837 if (SC==1 & vote_missing==1)
replace correction = 0.682082733048074/0.7305 if (SD==1 & vote_missing==1)
replace correction = 0.563093300569935/0.618 if (TN==1 & vote_missing==1)
replace correction = 0.537157673208723/0.6437 if (TX==1 & vote_missing==1)
replace correction = 0.589308204421088/0.7365 if (UT==1 & vote_missing==1)
replace correction = 0.606077835250374/0.7287 if (VA==1 & vote_missing==1)
replace correction = 0.663422543337577/0.7418 if (VT==1 & vote_missing==1)
replace correction = 0.669118000933322/0.7511 if (WA==1 & vote_missing==1)
replace correction = 0.747952530234324/0.8254 if (WI==1 & vote_missing==1)
replace correction = 0.541255003763831/0.6245 if (WV==1 & vote_missing==1)
replace correction = 0.656519987863198/0.72 if (WY==1 & vote_missing==1)

replace correction = 0.308601123008142/0.2428 if (AK==1 & vote_missing== 0)
replace correction = 0.427986954801004/0.2947 if (AL==1 & vote_missing== 0)
replace correction = 0.464279560127351/0.3773 if (AR==1 & vote_missing== 0)
replace correction = 0.458553907566796/0.2833 if (AZ==1 & vote_missing== 0)
replace correction = 0.412192954824396/0.289 if (CA==1 & vote_missing== 0)
replace correction = 0.332957974392794/0.2532 if (CO==1 & vote_missing== 0)
replace correction = 0.350202980738838/0.2526 if (CT==1 & vote_missing== 0)
replace correction = 0.457019451154706/0.2106 if (DC==1 & vote_missing== 0)
replace correction = 0.358448787991835/0.2379 if (DE==1 & vote_missing== 0)
replace correction = 0.355751712771007/0.2495 if (FL==1 & vote_missing== 0)
replace correction = 0.438283313153993/0.355 if (GA==1 & vote_missing== 0)
replace correction = 0.51771347754701/0.3971 if (HI==1 & vote_missing== 0)
replace correction = 0.30118905585654/0.2488 if (IA==1 & vote_missing== 0)
replace correction = 0.367574472137953/0.3421 if (ID==1 & vote_missing== 0)
replace correction = 0.385040376771074/0.2587 if (IL==1 & vote_missing== 0)
replace correction = 0.452073777909512/0.3531 if (IN==1 & vote_missing== 0)
replace correction = 0.384187855513122/0.3168 if (KS==1 & vote_missing== 0)
replace correction = 0.412684017229681/0.2993 if (KY==1 & vote_missing== 0)
replace correction = 0.389490674937545/0.2834 if (LA==1 & vote_missing== 0)
replace correction = 0.357635981331392/0.2478 if (MA==1 & vote_missing== 0)
replace correction = 0.371467177963389/0.2656 if (MD==1 & vote_missing== 0)
replace correction = 0.262046058367212/0.2158 if (ME==1 & vote_missing== 0)
replace correction = 0.333713905959563/0.2186 if (MI==1 & vote_missing== 0)
replace correction = 0.216336445375381/0.1493 if (MN==1 & vote_missing== 0)
replace correction = 0.346713681204319/0.2665 if (MO==1 & vote_missing== 0)
replace correction = 0.442969738355159/0.3118 if (MS==1 & vote_missing== 0)
replace correction = 0.355691321738741/0.2679 if (MT==1 & vote_missing== 0)
replace correction = 0.421872587479531/0.3362 if (NC==1 & vote_missing== 0)
replace correction = 0.351940080251967/0.2558 if (ND==1 & vote_missing== 0)
replace correction = 0.37066562845871/0.2931 if (NE==1 & vote_missing== 0)
replace correction = 0.291381792632704/0.2127 if (NH==1 & vote_missing== 0)
replace correction = 0.362252781239486/0.2521 if (NJ==1 & vote_missing== 0)
replace correction = 0.410411966616674/0.3116 if (NM==1 & vote_missing== 0)
replace correction = 0.447471197119414/0.3258 if (NV==1 & vote_missing== 0)
replace correction = 0.419750640851182/0.292 if (NY==1 & vote_missing== 0)
replace correction = 0.33221277325472/0.2666 if (OH==1 & vote_missing== 0)
replace correction = 0.417020532596566/0.3353 if (OK==1 & vote_missing== 0)
replace correction = 0.279943679140502/0.2004 if (OR==1 & vote_missing== 0)
replace correction = 0.374364178187172/0.2816 if (PA==1 & vote_missing== 0)
replace correction = 0.41484986770896/0.293 if (RI==1 & vote_missing== 0)
replace correction = 0.470481742891239/0.3163 if (SC==1 & vote_missing== 0)
replace correction = 0.317917266951926/0.2695 if (SD==1 & vote_missing== 0)
replace correction = 0.436906699430065/0.382 if (TN==1 & vote_missing== 0)
replace correction = 0.462842326791277/0.3563 if (TX==1 & vote_missing== 0)
replace correction = 0.410691795578912/0.2635 if (UT==1 & vote_missing== 0)
replace correction = 0.393922164749626/0.2713 if (VA==1 & vote_missing== 0)
replace correction = 0.336577456662423/0.2582 if (VT==1 & vote_missing== 0)
replace correction = 0.330881999066678/0.2489 if (WA==1 & vote_missing== 0)
replace correction = 0.252047469765676/0.1746 if (WI==1 & vote_missing== 0)
replace correction = 0.458744996236169/0.3755 if (WV==1 & vote_missing== 0)
replace correction = 0.343480012136802/0.28 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
