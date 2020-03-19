drop _all

* The raw data can be obtained from https://thedataweb.rm.census.gov/ftp/cps_ftp.html#cpssupps
* I have not added value labels to these variables. Please refer to the online documentation.

infix ///
  GESTFIPS 93-94 ///
  PRTAGE 122-123 ///
  PEEDUCA 137-138 ///
  PTDTRACE 139-140 ///
  PEHSPNON 157-158 ///
  PWSSWGT 613-622 ///
  PES1 1001-1002 ///
  PES2 1003-1004 ///
  PES3 1005-1006 ///
  PES4 1007-1008 ///
  PES5 1009-1010 ///
  PES6 1011-1012 ///
  PES7 1013-1014 ///
  PES8 1015-1016 ///
  PUSCK4 1017-1018 ///
using "D:/Pew/Vital Signs/CPS 2018/nov18pub.dat"

replace PWSSWGT = PWSSWGT/4

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

* 2018 CPS Hur and Achen Weight Correction
 
gen correction = 0
 
replace correction = 0.527105969473326/0.366 if (AL==1 & vote_missing==0)
replace correction = 0.453772397020183/0.3274 if (AK==1 & vote_missing==0)
replace correction = 0.509245768104875/0.3249 if (AZ==1 & vote_missing==0)
replace correction = 0.586179636638213/0.4389 if (AR==1 & vote_missing==0)
replace correction = 0.504097013088168/0.335 if (CA==1 & vote_missing==0)
replace correction = 0.370457830021811/0.225 if (CO==1 & vote_missing==0)
replace correction = 0.456060724297063/0.3577 if (CT==1 & vote_missing==0)
replace correction = 0.485572199528739/0.3549 if (DE==1 & vote_missing==0)
replace correction = 0.562579601585796/0.2945 if (DC==1 & vote_missing==0)
replace correction = 0.450563760323695/0.3023 if (FL==1 & vote_missing==0)
replace correction = 0.449726423867123/0.312 if (GA==1 & vote_missing==0)
replace correction = 0.606987833743936/0.4352 if (HI==1 & vote_missing==0)
replace correction = 0.499674501235425/0.4428 if (ID==1 & vote_missing==0)
replace correction = 0.485959402740121/0.3364 if (IL==1 & vote_missing==0)
replace correction = 0.531134243930817/0.3943 if (IN==1 & vote_missing==0)
replace correction = 0.422940622886216/0.3178 if (IA==1 & vote_missing==0)
replace correction = 0.488489073933596/0.3575 if (KS==1 & vote_missing==0)
replace correction = 0.514337901633992/0.4239 if (KY==1 & vote_missing==0)
replace correction = 0.552360059948319/0.3924 if (LA==1 & vote_missing==0)
replace correction = 0.397940924841054/0.2757 if (ME==1 & vote_missing==0)
replace correction = 0.457764365437961/0.3338 if (MD==1 & vote_missing==0)
replace correction = 0.454096588471806/0.3129 if (MA==1 & vote_missing==0)
replace correction = 0.422218785588622/0.2833 if (MI==1 & vote_missing==0)
replace correction = 0.357501213589546/0.269 if (MN==1 & vote_missing==0)
replace correction = 0.572974947257863/0.3861 if (MS==1 & vote_missing==0)
replace correction = 0.465657479475132/0.3494 if (MO==1 & vote_missing==0)
replace correction = 0.380300836061384/0.2757 if (MT==1 & vote_missing==0)
replace correction = 0.482034912060163/0.4045 if (NE==1 & vote_missing==0)
replace correction = 0.524523588205605/0.3989 if (NV==1 & vote_missing==0)
replace correction = 0.453526997122528/0.3359 if (NH==1 & vote_missing==0)
replace correction = 0.468685111599871/0.3396 if (NJ==1 & vote_missing==0)
replace correction = 0.526627833706416/0.4368 if (NM==1 & vote_missing==0)
replace correction = 0.547565773848055/0.3511 if (NY==1 & vote_missing==0)
replace correction = 0.504319315360635/0.3627 if (NC==1 & vote_missing==0)
replace correction = 0.413951789886441/0.303 if (ND==1 & vote_missing==0)
replace correction = 0.491280748275924/0.4061 if (OH==1 & vote_missing==0)
replace correction = 0.574754724600082/0.4381 if (OK==1 & vote_missing==0)
replace correction = 0.384897683331952/0.2607 if (OR==1 & vote_missing==0)
replace correction = 0.485570667116468/0.3548 if (PA==1 & vote_missing==0)
replace correction = 0.519488064930809/0.3731 if (RI==1 & vote_missing==0)
replace correction = 0.547942483159059/0.3967 if (SC==1 & vote_missing==0)
replace correction = 0.467459483430327/0.4032 if (SD==1 & vote_missing==0)
replace correction = 0.549314150633435/0.43 if (TN==1 & vote_missing==0)
replace correction = 0.536579893211407/0.4288 if (TX==1 & vote_missing==0)
replace correction = 0.479977661990186/0.3613 if (UT==1 & vote_missing==0)
replace correction = 0.441024610748368/0.3292 if (VT==1 & vote_missing==0)
replace correction = 0.452296183974798/0.3221 if (VA==1 & vote_missing==0)
replace correction = 0.41058456084012/0.2949 if (WA==1 & vote_missing==0)
replace correction = 0.575062159227247/0.4778 if (WV==1 & vote_missing==0)
replace correction = 0.383221456238352/0.274 if (WI==1 & vote_missing==0)
replace correction = 0.513245692660094/0.4029 if (WY==1 & vote_missing==0)

replace correction = 0.472894030526674/0.634 if (AL==1 & vote_missing== 1)
replace correction = 0.546227602979817/0.6726 if (AK==1 & vote_missing== 1)
replace correction = 0.490754231895125/0.6751 if (AZ==1 & vote_missing== 1)
replace correction = 0.413820363361787/0.5611 if (AR==1 & vote_missing== 1)
replace correction = 0.495902986911832/0.665 if (CA==1 & vote_missing== 1)
replace correction = 0.629542169978189/0.775 if (CO==1 & vote_missing== 1)
replace correction = 0.543939275702937/0.6423 if (CT==1 & vote_missing== 1)
replace correction = 0.514427800471261/0.6451 if (DE==1 & vote_missing== 1)
replace correction = 0.437420398414204/0.7055 if (DC==1 & vote_missing== 1)
replace correction = 0.549436239676305/0.6977 if (FL==1 & vote_missing== 1)
replace correction = 0.550273576132877/0.688 if (GA==1 & vote_missing== 1)
replace correction = 0.393012166256064/0.5648 if (HI==1 & vote_missing== 1)
replace correction = 0.500325498764575/0.5572 if (ID==1 & vote_missing== 1)
replace correction = 0.514040597259879/0.6636 if (IL==1 & vote_missing== 1)
replace correction = 0.468865756069183/0.6057 if (IN==1 & vote_missing== 1)
replace correction = 0.577059377113784/0.6822 if (IA==1 & vote_missing== 1)
replace correction = 0.511510926066404/0.6425 if (KS==1 & vote_missing== 1)
replace correction = 0.485662098366008/0.5761 if (KY==1 & vote_missing== 1)
replace correction = 0.447639940051681/0.6076 if (LA==1 & vote_missing== 1)
replace correction = 0.602059075158946/0.7243 if (ME==1 & vote_missing== 1)
replace correction = 0.542235634562039/0.6662 if (MD==1 & vote_missing== 1)
replace correction = 0.545903411528194/0.6871 if (MA==1 & vote_missing== 1)
replace correction = 0.577781214411378/0.7167 if (MI==1 & vote_missing== 1)
replace correction = 0.642498786410454/0.731 if (MN==1 & vote_missing== 1)
replace correction = 0.427025052742137/0.6139 if (MS==1 & vote_missing== 1)
replace correction = 0.534342520524868/0.6506 if (MO==1 & vote_missing== 1)
replace correction = 0.619699163938616/0.7243 if (MT==1 & vote_missing== 1)
replace correction = 0.517965087939837/0.5955 if (NE==1 & vote_missing== 1)
replace correction = 0.475476411794395/0.6011 if (NV==1 & vote_missing== 1)
replace correction = 0.546473002877472/0.6641 if (NH==1 & vote_missing== 1)
replace correction = 0.531314888400129/0.6604 if (NJ==1 & vote_missing== 1)
replace correction = 0.473372166293584/0.5632 if (NM==1 & vote_missing== 1)
replace correction = 0.452434226151945/0.6489 if (NY==1 & vote_missing== 1)
replace correction = 0.495680684639365/0.6373 if (NC==1 & vote_missing== 1)
replace correction = 0.586048210113559/0.697 if (ND==1 & vote_missing== 1)
replace correction = 0.508719251724076/0.5939 if (OH==1 & vote_missing== 1)
replace correction = 0.425245275399918/0.5619 if (OK==1 & vote_missing== 1)
replace correction = 0.615102316668048/0.7393 if (OR==1 & vote_missing== 1)
replace correction = 0.514429332883532/0.6452 if (PA==1 & vote_missing== 1)
replace correction = 0.480511935069191/0.6269 if (RI==1 & vote_missing== 1)
replace correction = 0.452057516840941/0.6033 if (SC==1 & vote_missing== 1)
replace correction = 0.532540516569673/0.5968 if (SD==1 & vote_missing== 1)
replace correction = 0.450685849366565/0.57 if (TN==1 & vote_missing== 1)
replace correction = 0.463420106788593/0.5712 if (TX==1 & vote_missing== 1)
replace correction = 0.520022338009814/0.6387 if (UT==1 & vote_missing== 1)
replace correction = 0.558975389251632/0.6708 if (VT==1 & vote_missing== 1)
replace correction = 0.547703816025202/0.6779 if (VA==1 & vote_missing== 1)
replace correction = 0.58941543915988/0.7051 if (WA==1 & vote_missing== 1)
replace correction = 0.424937840772753/0.5222 if (WV==1 & vote_missing== 1)
replace correction = 0.616778543761648/0.726 if (WI==1 & vote_missing== 1)
replace correction = 0.486754307339906/0.5971 if (WY==1 & vote_missing== 1)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
 
svyset [pw =  PWSSWGT]

* state level rates for Hur and Achen correction
* svy: tab GESTFIPS vote, row
svy: tab GESTFIPS vote_missing, row
 
svyset [pw =  FINALWEIGHT]
 
svy: tab GESTFIPS vote_missing, row
 
* race

gen race_cat4 = 0
replace race_cat4 = 1 if(PTDTRACE==1&PEHSPNON==2)
replace race_cat4 = 2 if((PTDTRACE==2|PTDTRACE==6|PTDTRACE==10|PTDTRACE==11|PTDTRACE==12|PTDTRACE==15|PTDTRACE==16|PTDTRACE==19)&PEHSPNON==2)
replace race_cat4 = 3 if(PEHSPNON==1)
replace race_cat4 = 4 if(race_cat4 ==0)

svyset [pw =  PWSSWGT]

svy: tab race_cat4 vote, row
svy: tab race_cat4 vote, column

svyset [pw =  FINALWEIGHT]

svy: tab race_cat4 vote_missing, row
svy: tab race_cat4 vote_missing, column

* age

gen age4 = 0
replace age4 = 1 if(PRTAGE>29)
replace age4 = 2 if(PRTAGE>44)
replace age4 = 3 if(PRTAGE>59)

gen age7 = 0
replace age7 = 1 if(PRTAGE>24)
replace age7 = 2 if(PRTAGE>34)
replace age7 = 3 if(PRTAGE>44)
replace age7 = 4 if(PRTAGE>54)
replace age7 = 5 if(PRTAGE>64)
replace age7 = 6 if(PRTAGE>74)

gen age5 = 0
replace age5 = 1 if(PRTAGE>24)
replace age5 = 2 if(PRTAGE>44)
replace age5 = 3 if(PRTAGE>64)
replace age5 = 4 if(PRTAGE>74)

svyset [pw =  PWSSWGT]

svy: tab age4 vote, row
svy: tab age4 vote, column

svy: tab age5 vote, row
svy: tab age5 vote, column



svyset [pw =  FINALWEIGHT]

svy: tab age4 vote_missing, row
svy: tab age4 vote_missing, column

svyset [pw =  FINALWEIGHT]

svy: tab GESTFIPS vote_missing if(age7==1), row

svy: tab GESTFIPS PES1 if(age5==0 & PRTAGE>17), row

* education

gen educ = 0
replace educ = 1 if(PEEDUCA>38)
replace educ = 2 if(PEEDUCA>39)
replace educ = 3 if(PEEDUCA>43)

gen w_college = 0
replace w_college = 1 if(PEEDUCA<43 & race_cat4==1)
replace w_college = 2 if(PEEDUCA>42 & race_cat4==1)

svyset [pw =  PWSSWGT]

svy: tab educ vote, row
svy: tab educ vote, column

svyset [pw =  FINALWEIGHT]

svy: tab educ vote_missing, row
svy: tab educ vote_missing, column

* nhwhite with college education

svyset [pw =  FINALWEIGHT]

svy: tab w_college vote_missing, row
svy: tab w_college vote_missing, column


* early vote

svy: tab PES6 if(vote==1)
