* Replication code for Hur and Achen correction

* Hur and Achen correction:
* Step 1: Set PES1 codes to missing (-1, -2,-3,-9)
* Step 2: For repondents reporting voting (PES=1), compute correction = VEP/CPS state level turnout rate excluding missing data, using PWSSWGT, the CPS individual rate
* Step 3: For repondents reporting voting (PES=2), compute orrection = (1-VEP)/(1-CPS state level turnout rate)
* Step 4: multiply correction, multiplying by PWSSWGT to produce new weight

use "D:\Pew\Vital Signs\CPS 2016\cps_2016.dta", clear

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

 * 2016 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.41039734700298/0.3029 if (AL==1 & vote_missing==0)
replace correction = 0.387114335124238/0.2638 if (AK==1 & vote_missing==0)
replace correction = 0.449834220931316/0.31 if (AZ==1 & vote_missing==0)
replace correction = 0.472299867775677/0.3056 if (AR==1 & vote_missing==0)
replace correction = 0.433130922276201/0.3029 if (CA==1 & vote_missing==0)
replace correction = 0.299032069459246/0.169 if (CO==1 & vote_missing==0)
replace correction = 0.357843185096553/0.2296 if (CT==1 & vote_missing==0)
replace correction = 0.355974605477961/0.2785 if (DE==1 & vote_missing==0)
replace correction = 0.391416387891206/0.1552 if (DC==1 & vote_missing==0)
replace correction = 0.353561402148336/0.2413 if (FL==1 & vote_missing==0)
replace correction = 0.408414943362285/0.2918 if (GA==1 & vote_missing==0)
replace correction = 0.578221011218609/0.4035 if (HI==1 & vote_missing==0)
replace correction = 0.408623200822481/0.3125 if (ID==1 & vote_missing==0)
replace correction = 0.38092405886362/0.2488 if (IL==1 & vote_missing==0)
replace correction = 0.436399893913788/0.3228 if (IN==1 & vote_missing==0)
replace correction = 0.31620786694699/0.2623 if (IA==1 & vote_missing==0)
replace correction = 0.422735713415377/0.3139 if (KS==1 & vote_missing==0)
replace correction = 0.41276962361875/0.3348 if (KY==1 & vote_missing==0)
replace correction = 0.399863529521723/0.2876 if (LA==1 & vote_missing==0)
replace correction = 0.295010392070921/0.2132 if (ME==1 & vote_missing==0)
replace correction = 0.334022110464209/0.2349 if (MD==1 & vote_missing==0)
replace correction = 0.327898923864837/0.2149 if (MA==1 & vote_missing==0)
replace correction = 0.353477925319062/0.2445 if (MI==1 & vote_missing==0)
replace correction = 0.257514393663384/0.2151 if (MN==1 & vote_missing==0)
replace correction = 0.444308996136583/0.2698 if (MS==1 & vote_missing==0)
replace correction = 0.377499550069905/0.2731 if (MO==1 & vote_missing==0)
replace correction = 0.381950841703123/0.2644 if (MT==1 & vote_missing==0)
replace correction = 0.374601730642868/0.2517 if (NE==1 & vote_missing==0)
replace correction = 0.427021679682826/0.3077 if (NV==1 & vote_missing==0)
replace correction = 0.285774329192344/0.2038 if (NH==1 & vote_missing==0)
replace correction = 0.358898006087252/0.2528 if (NJ==1 & vote_missing==0)
replace correction = 0.451911398914284/0.3832 if (NM==1 & vote_missing==0)
replace correction = 0.43188058493516/0.2991 if (NY==1 & vote_missing==0)
replace correction = 0.352107456751041/0.2154 if (NC==1 & vote_missing==0)
replace correction = 0.390546713366169/0.2923 if (ND==1 & vote_missing==0)
replace correction = 0.37090784399027/0.286 if (OH==1 & vote_missing==0)
replace correction = 0.476204861624315/0.3608 if (OK==1 & vote_missing==0)
replace correction = 0.335656540642961/0.2096 if (OR==1 & vote_missing==0)
replace correction = 0.364491420217027/0.2953 if (PA==1 & vote_missing==0)
replace correction = 0.409510796620498/0.2791 if (RI==1 & vote_missing==0)
replace correction = 0.43265226400674/0.2852 if (SC==1 & vote_missing==0)
replace correction = 0.415324752878802/0.3163 if (SD==1 & vote_missing==0)
replace correction = 0.488093401129611/0.382 if (TN==1 & vote_missing==0)
replace correction = 0.48441748749274/0.3562 if (TX==1 & vote_missing==0)
replace correction = 0.433147610680831/0.2939 if (UT==1 & vote_missing==0)
replace correction = 0.363345383416956/0.2489 if (VT==1 & vote_missing==0)
replace correction = 0.338898657466691/0.2383 if (VA==1 & vote_missing==0)
replace correction = 0.352370132114174/0.2536 if (WA==1 & vote_missing==0)
replace correction = 0.498988752855967/0.3966 if (WV==1 & vote_missing==0)
replace correction = 0.305986959928364/0.2276 if (WI==1 & vote_missing==0)
replace correction = 0.402616961214898/0.2902 if (WY==1 & vote_missing==0)

replace correction = 0.58960265299702/0.6971 if (AL==1 & vote_missing== 1)
replace correction = 0.612885664875762/0.7362 if (AK==1 & vote_missing== 1)
replace correction = 0.550165779068684/0.69 if (AZ==1 & vote_missing== 1)
replace correction = 0.527700132224323/0.6944 if (AR==1 & vote_missing== 1)
replace correction = 0.566869077723799/0.6971 if (CA==1 & vote_missing== 1)
replace correction = 0.700967930540754/0.831 if (CO==1 & vote_missing== 1)
replace correction = 0.642156814903447/0.7704 if (CT==1 & vote_missing== 1)
replace correction = 0.644025394522039/0.7215 if (DE==1 & vote_missing== 1)
replace correction = 0.608583612108794/0.8448 if (DC==1 & vote_missing== 1)
replace correction = 0.646438597851664/0.7587 if (FL==1 & vote_missing== 1)
replace correction = 0.591585056637715/0.7082 if (GA==1 & vote_missing== 1)
replace correction = 0.421778988781391/0.5965 if (HI==1 & vote_missing== 1)
replace correction = 0.591376799177519/0.6875 if (ID==1 & vote_missing== 1)
replace correction = 0.61907594113638/0.7512 if (IL==1 & vote_missing== 1)
replace correction = 0.563600106086212/0.6772 if (IN==1 & vote_missing== 1)
replace correction = 0.68379213305301/0.7377 if (IA==1 & vote_missing== 1)
replace correction = 0.577264286584623/0.6861 if (KS==1 & vote_missing== 1)
replace correction = 0.58723037638125/0.6652 if (KY==1 & vote_missing== 1)
replace correction = 0.600136470478277/0.7124 if (LA==1 & vote_missing== 1)
replace correction = 0.704989607929079/0.7868 if (ME==1 & vote_missing== 1)
replace correction = 0.665977889535791/0.7651 if (MD==1 & vote_missing== 1)
replace correction = 0.672101076135163/0.7851 if (MA==1 & vote_missing== 1)
replace correction = 0.646522074680938/0.7555 if (MI==1 & vote_missing== 1)
replace correction = 0.742485606336616/0.7849 if (MN==1 & vote_missing== 1)
replace correction = 0.555691003863417/0.7302 if (MS==1 & vote_missing== 1)
replace correction = 0.622500449930095/0.7269 if (MO==1 & vote_missing== 1)
replace correction = 0.618049158296877/0.7356 if (MT==1 & vote_missing== 1)
replace correction = 0.625398269357132/0.7483 if (NE==1 & vote_missing== 1)
replace correction = 0.572978320317174/0.6923 if (NV==1 & vote_missing== 1)
replace correction = 0.714225670807656/0.7962 if (NH==1 & vote_missing== 1)
replace correction = 0.641101993912748/0.7472 if (NJ==1 & vote_missing== 1)
replace correction = 0.548088601085716/0.6168 if (NM==1 & vote_missing== 1)
replace correction = 0.56811941506484/0.7009 if (NY==1 & vote_missing== 1)
replace correction = 0.647892543248959/0.7846 if (NC==1 & vote_missing== 1)
replace correction = 0.609453286633831/0.7077 if (ND==1 & vote_missing== 1)
replace correction = 0.62909215600973/0.714 if (OH==1 & vote_missing== 1)
replace correction = 0.523795138375685/0.6392 if (OK==1 & vote_missing== 1)
replace correction = 0.664343459357039/0.7904 if (OR==1 & vote_missing== 1)
replace correction = 0.635508579782973/0.7047 if (PA==1 & vote_missing== 1)
replace correction = 0.590489203379502/0.7209 if (RI==1 & vote_missing== 1)
replace correction = 0.56734773599326/0.7148 if (SC==1 & vote_missing== 1)
replace correction = 0.584675247121198/0.6837 if (SD==1 & vote_missing== 1)
replace correction = 0.511906598870389/0.618 if (TN==1 & vote_missing== 1)
replace correction = 0.51558251250726/0.6438 if (TX==1 & vote_missing== 1)
replace correction = 0.566852389319169/0.7061 if (UT==1 & vote_missing== 1)
replace correction = 0.636654616583044/0.7511 if (VT==1 & vote_missing== 1)
replace correction = 0.661101342533309/0.7617 if (VA==1 & vote_missing== 1)
replace correction = 0.647629867885826/0.7464 if (WA==1 & vote_missing== 1)
replace correction = 0.501011247144033/0.6034 if (WV==1 & vote_missing== 1)
replace correction = 0.694013040071636/0.7724 if (WI==1 & vote_missing== 1)
replace correction = 0.597383038785102/0.7098 if (WY==1 & vote_missing== 1)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT

svyset [pw =  FINALWEIGHT]
svy: tab GESTFIPS vote_missing, row


* state level rates for Hur and Achen correction
* svy: tab GESTCEN vote, row
* svy: tab GESTCEN vote_missing, row

* race

gen race_cat4 = 0
replace race_cat4 = 1 if(PTDTRACE==1&PEHSPNON==2)
replace race_cat4 = 2 if((PTDTRACE==2|PTDTRACE==6|PTDTRACE==10|PTDTRACE==11|PTDTRACE==12|PTDTRACE==15|PTDTRACE==16|PTDTRACE==19)&PEHSPNON==2)
replace race_cat4 = 3 if(PEHSPNON==1)
replace race_cat4 = 4 if(race_cat4 ==0)

svyset [pw =  PWSSWGT]

svy: tab race_cat4 vote, row
svy: tab race_cat4 vote, column

* svy: tab race_cat4 vote_missing, row
* svy: tab race_cat4 vote_missing, column

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

svyset [pw =  PWSSWGT]

svy: tab age4 vote, row
svy: tab age4 vote, column

* svy: tab age4 vote_missing, row
* svy: tab age4 vote_missing, column

svyset [pw =  FINALWEIGHT]

svy: tab age4 vote_missing, row
svy: tab age4 vote_missing, column

* svyset [pw =  PWSSWGT]

* svy: tab age7 vote, row
* svy: tab age7 vote, column

* svy: tab age7 vote_missing, row
* svy: tab age7 vote_missing, column

* svyset [pw =  FINALWEIGHT]

* svy: tab age7 vote_missing, row
* svy: tab age7 vote_missing, column

* education

gen educ = 0
replace educ = 1 if(PEEDUCA>38)
replace educ = 2 if(PEEDUCA>39)
replace educ = 3 if(PEEDUCA>43)

svyset [pw =  PWSSWGT]

svy: tab educ vote, row
svy: tab educ vote, column

* svy: tab educ vote_missing, row
* svy: tab educ vote_missing, column

svyset [pw =  FINALWEIGHT]

svy: tab educ vote_missing, row
svy: tab educ vote_missing, column

* tenure (hard to interpret since question on voting and registration supplement)

* gen tenure = .
* replace tenure = 1 if(PES8>0)
* replace tenure = 2 if(PES8>5)

* svyset [pw =  PWSSWGT]

* svy: tab tenure vote, row
* svy: tab tenure vote, column

* svy: tab tenure vote_missing, row
* svy: tab tenure vote_missing, column

* svyset [pw =  FINALWEIGHT]

* svy: tab tenure vote_missing, row
* svy: tab tenure vote_missing, column
