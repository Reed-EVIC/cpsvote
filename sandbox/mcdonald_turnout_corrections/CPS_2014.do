* Replication code for Hur and Achen correction

* Hur and Achen correction:
* Step 1: Set PES1 codes to missing (-1, -2,-3,-9)
* Step 2: For repondents reporting voting (PES=1), compute correction = VEP/CPS state level turnout rate excluding missing data, using PWSSWGT, the CPS individual rate
* Step 3: For repondents reporting voting (PES=2), compute orrection = (1-VEP)/(1-CPS state level turnout rate)
* Step 4: multiply correction, multiplying by PWSSWGT to produce new weight

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


* No GESTCEN available in 2014 file from Dataferrett <http://dataferrett.census.gov/> at this time. Using GESTFIPS instead (available through "Select Geographies")

 replace  ME=1 if (GESTFIPS==23)
 replace  NH=1 if (GESTFIPS==33)
 replace  VT=1 if (GESTFIPS==50)
 replace  MA=1 if (GESTFIPS==25)
 replace  RI=1 if (GESTFIPS==44)
 replace  CT=1 if (GESTFIPS==9)
 replace  NY=1 if (GESTFIPS==36)
 replace  NJ=1 if (GESTFIPS==34)
 replace  PA=1 if (GESTFIPS==42)
 replace  OH=1 if (GESTFIPS==39)
 replace  IN=1 if (GESTFIPS==18)
 replace  IL=1 if (GESTFIPS==17)
 replace  MI=1 if (GESTFIPS==26)
 replace  WI=1 if (GESTFIPS==55)
 replace  MN=1 if (GESTFIPS==27)
 replace  IA=1 if (GESTFIPS==19)
 replace  MO=1 if (GESTFIPS==29)
 replace  ND=1 if (GESTFIPS==38)
 replace  SD=1 if (GESTFIPS==46)
 replace  NE=1 if (GESTFIPS==31)
 replace  KS=1 if (GESTFIPS==20)
 replace  DE=1 if (GESTFIPS==10)
 replace  MD=1 if (GESTFIPS==24)
 replace  DC=1 if (GESTFIPS==11)
 replace  VA=1 if (GESTFIPS==51)
 replace  WV=1 if (GESTFIPS==54)
 replace  NC=1 if (GESTFIPS==37)
 replace  SC=1 if (GESTFIPS==45)
 replace  GA=1 if (GESTFIPS==13)
 replace  FL=1 if (GESTFIPS==12)
 replace  KY=1 if (GESTFIPS==21)
 replace  TN=1 if (GESTFIPS==47)
 replace  AL=1 if (GESTFIPS==1)
 replace  MS=1 if (GESTFIPS==28)
 replace  AR=1 if (GESTFIPS==5)
 replace  LA=1 if (GESTFIPS==22)
 replace  OK=1 if (GESTFIPS==40)
 replace  TX=1 if (GESTFIPS==48)
 replace  MT=1 if (GESTFIPS==30)
 replace  ID=1 if (GESTFIPS==16)
 replace  WY=1 if (GESTFIPS==56)
 replace  CO=1 if (GESTFIPS==8)
 replace  NM=1 if (GESTFIPS==35)
 replace  AZ=1 if (GESTFIPS==4)
 replace  UT=1 if (GESTFIPS==49)
 replace  NV=1 if (GESTFIPS==32)
 replace  WA=1 if (GESTFIPS==53)
 replace  OR=1 if (GESTFIPS==41)
 replace  CA=1 if (GESTFIPS==6)
 replace  AK=1 if (GESTFIPS==2)
 replace  HI=1 if (GESTFIPS==15)

 * 2014 CPS Hur and Achen Weight Correction

gen correction = 0


replace correction = 0.329095985736729/0.4958 if (AL==1 & vote_missing==1)
replace correction = 0.538008821315957/0.627 if (AK==1 & vote_missing==1)
replace correction = 0.334225464452868/0.4909 if (AZ==1 & vote_missing==1)
replace correction = 0.399521849851626/0.449 if (AR==1 & vote_missing==1)
replace correction = 0.29980056262325/0.4549 if (CA==1 & vote_missing==1)
replace correction = 0.534410767499032/0.7087 if (CO==1 & vote_missing==1)
replace correction = 0.422764126725281/0.5689 if (CT==1 & vote_missing==1)
replace correction = 0.343554121539695/0.5436 if (DE==1 & vote_missing==1)
replace correction = 0.353658782937531/0.5961 if (DC==1 & vote_missing==1)
replace correction = 0.427226178032796/0.5695 if (FL==1 & vote_missing==1)
replace correction = 0.380977851078989/0.5119 if (GA==1 & vote_missing==1)
replace correction = 0.361556730707511/0.5087 if (HI==1 & vote_missing==1)
replace correction = 0.391175233306148/0.4643 if (ID==1 & vote_missing==1)
replace correction = 0.403632199116718/0.5069 if (IL==1 & vote_missing==1)
replace correction = 0.278458132519619/0.396 if (IN==1 & vote_missing==1)
replace correction = 0.496793074712454/0.6241 if (IA==1 & vote_missing==1)
replace correction = 0.425429416064608/0.5246 if (KS==1 & vote_missing==1)
replace correction = 0.44035642708073/0.5232 if (KY==1 & vote_missing==1)
replace correction = 0.438489740743852/0.5625 if (LA==1 & vote_missing==1)
replace correction = 0.579755712621831/0.6721 if (ME==1 & vote_missing==1)
replace correction = 0.41518561788666/0.5683 if (MD==1 & vote_missing==1)
replace correction = 0.440459412632623/0.5477 if (MA==1 & vote_missing==1)
replace correction = 0.427171812052744/0.5689 if (MI==1 & vote_missing==1)
replace correction = 0.50226684200494/0.5909 if (MN==1 & vote_missing==1)
replace correction = 0.288863633038797/0.469 if (MS==1 & vote_missing==1)
replace correction = 0.31784980397112/0.4431 if (MO==1 & vote_missing==1)
replace correction = 0.467565995751998/0.568 if (MT==1 & vote_missing==1)
replace correction = 0.405764980072166/0.5009 if (NE==1 & vote_missing==1)
replace correction = 0.290086429855505/0.4228 if (NV==1 & vote_missing==1)
replace correction = 0.476402342979941/0.5614 if (NH==1 & vote_missing==1)
replace correction = 0.311175510687792/0.4395 if (NJ==1 & vote_missing==1)
replace correction = 0.356865984489564/0.5057 if (NM==1 & vote_missing==1)
replace correction = 0.281572039343009/0.4334 if (NY==1 & vote_missing==1)
replace correction = 0.408749881523033/0.5348 if (NC==1 & vote_missing==1)
replace correction = 0.43844538518909/0.5742 if (ND==1 & vote_missing==1)
replace correction = 0.35124750435911/0.4537 if (OH==1 & vote_missing==1)
replace correction = 0.297791415207009/0.4041 if (OK==1 & vote_missing==1)
replace correction = 0.509981425467825/0.6519 if (OR==1 & vote_missing==1)
replace correction = 0.360318246592873/0.4706 if (PA==1 & vote_missing==1)
replace correction = 0.415753084582412/0.5271 if (RI==1 & vote_missing==1)
replace correction = 0.347847480877893/0.4806 if (SC==1 & vote_missing==1)
replace correction = 0.444886020765763/0.5018 if (SD==1 & vote_missing==1)
replace correction = 0.285635203725804/0.4118 if (TN==1 & vote_missing==1)
replace correction = 0.283416069157912/0.4136 if (TX==1 & vote_missing==1)
replace correction = 0.29602149041645/0.4361 if (UT==1 & vote_missing==1)
replace correction = 0.388201967076005/0.4761 if (VT==1 & vote_missing==1)
replace correction = 0.364850492124176/0.5035 if (VA==1 & vote_missing==1)
replace correction = 0.411900397186022/0.5772 if (WA==1 & vote_missing==1)
replace correction = 0.311666813929601/0.406 if (WV==1 & vote_missing==1)
replace correction = 0.565113323284536/0.6264 if (WI==1 & vote_missing==1)
replace correction = 0.387011810996477/0.4664 if (WY==1 & vote_missing==1)

replace correction = 0.670904014263271/0.5042 if (AL==1 & vote_missing== 0)
replace correction = 0.461991178684043/0.373 if (AK==1 & vote_missing== 0)
replace correction = 0.665774535547132/0.5091 if (AZ==1 & vote_missing== 0)
replace correction = 0.600478150148374/0.551 if (AR==1 & vote_missing== 0)
replace correction = 0.70019943737675/0.5451 if (CA==1 & vote_missing== 0)
replace correction = 0.465589232500968/0.2913 if (CO==1 & vote_missing== 0)
replace correction = 0.577235873274719/0.4311 if (CT==1 & vote_missing== 0)
replace correction = 0.656445878460305/0.4564 if (DE==1 & vote_missing== 0)
replace correction = 0.646341217062469/0.4039 if (DC==1 & vote_missing== 0)
replace correction = 0.572773821967204/0.4305 if (FL==1 & vote_missing== 0)
replace correction = 0.619022148921011/0.4881 if (GA==1 & vote_missing== 0)
replace correction = 0.638443269292489/0.4913 if (HI==1 & vote_missing== 0)
replace correction = 0.608824766693852/0.5357 if (ID==1 & vote_missing== 0)
replace correction = 0.596367800883282/0.4931 if (IL==1 & vote_missing== 0)
replace correction = 0.721541867480381/0.604 if (IN==1 & vote_missing== 0)
replace correction = 0.503206925287546/0.3759 if (IA==1 & vote_missing== 0)
replace correction = 0.574570583935392/0.4754 if (KS==1 & vote_missing== 0)
replace correction = 0.55964357291927/0.4768 if (KY==1 & vote_missing== 0)
replace correction = 0.561510259256148/0.4375 if (LA==1 & vote_missing== 0)
replace correction = 0.420244287378169/0.3279 if (ME==1 & vote_missing== 0)
replace correction = 0.58481438211334/0.4317 if (MD==1 & vote_missing== 0)
replace correction = 0.559540587367377/0.4523 if (MA==1 & vote_missing== 0)
replace correction = 0.572828187947256/0.4311 if (MI==1 & vote_missing== 0)
replace correction = 0.49773315799506/0.4091 if (MN==1 & vote_missing== 0)
replace correction = 0.711136366961203/0.531 if (MS==1 & vote_missing== 0)
replace correction = 0.68215019602888/0.5569 if (MO==1 & vote_missing== 0)
replace correction = 0.532434004248002/0.432 if (MT==1 & vote_missing== 0)
replace correction = 0.594235019927834/0.4991 if (NE==1 & vote_missing== 0)
replace correction = 0.709913570144495/0.5772 if (NV==1 & vote_missing== 0)
replace correction = 0.523597657020059/0.4386 if (NH==1 & vote_missing== 0)
replace correction = 0.688824489312208/0.5605 if (NJ==1 & vote_missing== 0)
replace correction = 0.643134015510436/0.4943 if (NM==1 & vote_missing== 0)
replace correction = 0.718427960656991/0.5666 if (NY==1 & vote_missing== 0)
replace correction = 0.591250118476967/0.4652 if (NC==1 & vote_missing== 0)
replace correction = 0.56155461481091/0.4258 if (ND==1 & vote_missing== 0)
replace correction = 0.64875249564089/0.5463 if (OH==1 & vote_missing== 0)
replace correction = 0.702208584792991/0.5959 if (OK==1 & vote_missing== 0)
replace correction = 0.490018574532175/0.3481 if (OR==1 & vote_missing== 0)
replace correction = 0.639681753407127/0.5294 if (PA==1 & vote_missing== 0)
replace correction = 0.584246915417588/0.4729 if (RI==1 & vote_missing== 0)
replace correction = 0.652152519122107/0.5194 if (SC==1 & vote_missing== 0)
replace correction = 0.555113979234237/0.4982 if (SD==1 & vote_missing== 0)
replace correction = 0.714364796274196/0.5882 if (TN==1 & vote_missing== 0)
replace correction = 0.716583930842088/0.5864 if (TX==1 & vote_missing== 0)
replace correction = 0.70397850958355/0.5639 if (UT==1 & vote_missing== 0)
replace correction = 0.611798032923995/0.5239 if (VT==1 & vote_missing== 0)
replace correction = 0.635149507875824/0.4965 if (VA==1 & vote_missing== 0)
replace correction = 0.588099602813978/0.4228 if (WA==1 & vote_missing== 0)
replace correction = 0.688333186070399/0.594 if (WV==1 & vote_missing== 0)
replace correction = 0.434886676715464/0.3736 if (WI==1 & vote_missing== 0)
replace correction = 0.612988189003523/0.5336 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
