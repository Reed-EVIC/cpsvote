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

* 2002 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.541690213684064/0.6258 if (AK==1 & vote_missing==1)
replace correction = 0.415322726072602/0.5371 if (AL==1 & vote_missing==1)
replace correction = 0.412845571572595/0.4967 if (AR==1 & vote_missing==1)
replace correction = 0.358566454758259/0.4733 if (AZ==1 & vote_missing==1)
replace correction = 0.360598165492318/0.4879 if (CA==1 & vote_missing==1)
replace correction = 0.463310720063865/0.5566 if (CO==1 & vote_missing==1)
replace correction = 0.423046462895316/0.5336 if (CT==1 & vote_missing==1)
replace correction = 0.301478903660129/0.5947 if (DC==1 & vote_missing==1)
replace correction = 0.411220710255559/0.5053 if (DE==1 & vote_missing==1)
replace correction = 0.455637222946618/0.539 if (FL==1 & vote_missing==1)
replace correction = 0.354433043017839/0.4806 if (GA==1 & vote_missing==1)
replace correction = 0.437701605512994/0.5205 if (HI==1 & vote_missing==1)
replace correction = 0.478814592524956/0.5342 if (IA==1 & vote_missing==1)
replace correction = 0.446648079712957/0.4837 if (ID==1 & vote_missing==1)
replace correction = 0.414342290361803/0.547 if (IL==1 & vote_missing==1)
replace correction = 0.338515430252074/0.4558 if (IN==1 & vote_missing==1)
replace correction = 0.44047298723607/0.5221 if (KS==1 & vote_missing==1)
replace correction = 0.371620820381392/0.5036 if (KY==1 & vote_missing==1)
replace correction = 0.393952578696369/0.5597 if (LA==1 & vote_missing==1)
replace correction = 0.492100824881919/0.5817 if (MA==1 & vote_missing==1)
replace correction = 0.463403932093392/0.5805 if (MD==1 & vote_missing==1)
replace correction = 0.507700069141837/0.6096 if (ME==1 & vote_missing==1)
replace correction = 0.444545997363137/0.5679 if (MI==1 & vote_missing==1)
replace correction = 0.640853065104042/0.7223 if (MN==1 & vote_missing==1)
replace correction = 0.456077392419373/0.5875 if (MO==1 & vote_missing==1)
replace correction = 0.300674676563323/0.4818 if (MS==1 & vote_missing==1)
replace correction = 0.483982692835816/0.5789 if (MT==1 & vote_missing==1)
replace correction = 0.396681643880372/0.4914 if (NC==1 & vote_missing==1)
replace correction = 0.485101343619226/0.5978 if (ND==1 & vote_missing==1)
replace correction = 0.399324373688265/0.494 if (NE==1 & vote_missing==1)
replace correction = 0.480603249057894/0.5428 if (NH==1 & vote_missing==1)
replace correction = 0.380668162716502/0.4836 if (NJ==1 & vote_missing==1)
replace correction = 0.385813556128248/0.4917 if (NM==1 & vote_missing==1)
replace correction = 0.362360002875422/0.4714 if (NV==1 & vote_missing==1)
replace correction = 0.361129870073538/0.5001 if (NY==1 & vote_missing==1)
replace correction = 0.387982439455545/0.4822 if (OH==1 & vote_missing==1)
replace correction = 0.412081686573682/0.5213 if (OK==1 & vote_missing==1)
replace correction = 0.507753815603314/0.6068 if (OR==1 & vote_missing==1)
replace correction = 0.387775414221217/0.4796 if (PA==1 & vote_missing==1)
replace correction = 0.447350682685878/0.5649 if (RI==1 & vote_missing==1)
replace correction = 0.369453636000952/0.5008 if (SC==1 & vote_missing==1)
replace correction = 0.606840910970702/0.693 if (SD==1 & vote_missing==1)
replace correction = 0.396148063723164/0.5207 if (TN==1 & vote_missing==1)
replace correction = 0.342463130308013/0.4655 if (TX==1 & vote_missing==1)
replace correction = 0.370317222200436/0.4683 if (UT==1 & vote_missing==1)
replace correction = 0.289868408031147/0.4227 if (VA==1 & vote_missing==1)
replace correction = 0.488246786719643/0.5708 if (VT==1 & vote_missing==1)
replace correction = 0.417852676030924/0.5634 if (WA==1 & vote_missing==1)
replace correction = 0.454275594613018/0.5467 if (WI==1 & vote_missing==1)
replace correction = 0.311977335343646/0.4017 if (WV==1 & vote_missing==1)
replace correction = 0.500580315691736/0.5694 if (WY==1 & vote_missing==1)

replace correction = 0.458309786315936/0.3742 if (AK==1 & vote_missing== 0)
replace correction = 0.584677273927398/0.4629 if (AL==1 & vote_missing== 0)
replace correction = 0.587154428427405/0.5033 if (AR==1 & vote_missing== 0)
replace correction = 0.641433545241741/0.5267 if (AZ==1 & vote_missing== 0)
replace correction = 0.639401834507682/0.5121 if (CA==1 & vote_missing== 0)
replace correction = 0.536689279936135/0.4434 if (CO==1 & vote_missing== 0)
replace correction = 0.576953537104685/0.4664 if (CT==1 & vote_missing== 0)
replace correction = 0.698521096339871/0.4053 if (DC==1 & vote_missing== 0)
replace correction = 0.588779289744441/0.4947 if (DE==1 & vote_missing== 0)
replace correction = 0.544362777053382/0.461 if (FL==1 & vote_missing== 0)
replace correction = 0.645566956982161/0.5194 if (GA==1 & vote_missing== 0)
replace correction = 0.562298394487006/0.4795 if (HI==1 & vote_missing== 0)
replace correction = 0.521185407475044/0.4658 if (IA==1 & vote_missing== 0)
replace correction = 0.553351920287043/0.5163 if (ID==1 & vote_missing== 0)
replace correction = 0.585657709638197/0.453 if (IL==1 & vote_missing== 0)
replace correction = 0.661484569747926/0.5442 if (IN==1 & vote_missing== 0)
replace correction = 0.55952701276393/0.4779 if (KS==1 & vote_missing== 0)
replace correction = 0.628379179618608/0.4964 if (KY==1 & vote_missing== 0)
replace correction = 0.606047421303632/0.4403 if (LA==1 & vote_missing== 0)
replace correction = 0.507899175118081/0.4183 if (MA==1 & vote_missing== 0)
replace correction = 0.536596067906608/0.4195 if (MD==1 & vote_missing== 0)
replace correction = 0.492299930858163/0.3904 if (ME==1 & vote_missing== 0)
replace correction = 0.555454002636863/0.4321 if (MI==1 & vote_missing== 0)
replace correction = 0.359146934895958/0.2777 if (MN==1 & vote_missing== 0)
replace correction = 0.543922607580627/0.4125 if (MO==1 & vote_missing== 0)
replace correction = 0.699325323436677/0.5182 if (MS==1 & vote_missing== 0)
replace correction = 0.516017307164184/0.4211 if (MT==1 & vote_missing== 0)
replace correction = 0.603318356119628/0.5086 if (NC==1 & vote_missing== 0)
replace correction = 0.514898656380774/0.4022 if (ND==1 & vote_missing== 0)
replace correction = 0.600675626311735/0.506 if (NE==1 & vote_missing== 0)
replace correction = 0.519396750942106/0.4572 if (NH==1 & vote_missing== 0)
replace correction = 0.619331837283498/0.5164 if (NJ==1 & vote_missing== 0)
replace correction = 0.614186443871752/0.5083 if (NM==1 & vote_missing== 0)
replace correction = 0.637639997124578/0.5286 if (NV==1 & vote_missing== 0)
replace correction = 0.638870129926462/0.4999 if (NY==1 & vote_missing== 0)
replace correction = 0.612017560544455/0.5178 if (OH==1 & vote_missing== 0)
replace correction = 0.587918313426318/0.4787 if (OK==1 & vote_missing== 0)
replace correction = 0.492246184396686/0.3932 if (OR==1 & vote_missing== 0)
replace correction = 0.612224585778783/0.5204 if (PA==1 & vote_missing== 0)
replace correction = 0.552649317314122/0.4351 if (RI==1 & vote_missing== 0)
replace correction = 0.630546363999048/0.4992 if (SC==1 & vote_missing== 0)
replace correction = 0.393159089029298/0.307 if (SD==1 & vote_missing== 0)
replace correction = 0.603851936276836/0.4793 if (TN==1 & vote_missing== 0)
replace correction = 0.657536869691987/0.5345 if (TX==1 & vote_missing== 0)
replace correction = 0.629682777799564/0.5317 if (UT==1 & vote_missing== 0)
replace correction = 0.710131591968853/0.5773 if (VA==1 & vote_missing== 0)
replace correction = 0.511753213280357/0.4292 if (VT==1 & vote_missing== 0)
replace correction = 0.582147323969076/0.4366 if (WA==1 & vote_missing== 0)
replace correction = 0.545724405386982/0.4533 if (WI==1 & vote_missing== 0)
replace correction = 0.688022664656354/0.5983 if (WV==1 & vote_missing== 0)
replace correction = 0.499419684308264/0.4306 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
