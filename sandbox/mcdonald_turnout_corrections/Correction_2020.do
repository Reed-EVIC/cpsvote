
* Get 2020 CPS Voting and Registration Supplement microdata at https://www2.census.gov/programs-surveys/cps/datasets/2020/supp/. I used R to read the csv file and covert to a .dta file.

use "D:\Pew\Vital Signs\CPS 2020\nov20pub.dta", clear

replace PWSSWGT = PWSSWGT/10000

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

 * No GESTCEN available in 2014 file from Dataferrett <http://dataferrett.census.gov/> at this time. Using gestfips instead (available through "Select Geographies")

 replace  ME=1 if (gestfips==23)
 replace  NH=1 if (gestfips==33)
 replace  VT=1 if (gestfips==50)
 replace  MA=1 if (gestfips==25)
 replace  RI=1 if (gestfips==44)
 replace  CT=1 if (gestfips==9)
 replace  NY=1 if (gestfips==36)
 replace  NJ=1 if (gestfips==34)
 replace  PA=1 if (gestfips==42)
 replace  OH=1 if (gestfips==39)
 replace  IN=1 if (gestfips==18)
 replace  IL=1 if (gestfips==17)
 replace  MI=1 if (gestfips==26)
 replace  WI=1 if (gestfips==55)
 replace  MN=1 if (gestfips==27)
 replace  IA=1 if (gestfips==19)
 replace  MO=1 if (gestfips==29)
 replace  ND=1 if (gestfips==38)
 replace  SD=1 if (gestfips==46)
 replace  NE=1 if (gestfips==31)
 replace  KS=1 if (gestfips==20)
 replace  DE=1 if (gestfips==10)
 replace  MD=1 if (gestfips==24)
 replace  DC=1 if (gestfips==11)
 replace  VA=1 if (gestfips==51)
 replace  WV=1 if (gestfips==54)
 replace  NC=1 if (gestfips==37)
 replace  SC=1 if (gestfips==45)
 replace  GA=1 if (gestfips==13)
 replace  FL=1 if (gestfips==12)
 replace  KY=1 if (gestfips==21)
 replace  TN=1 if (gestfips==47)
 replace  AL=1 if (gestfips==1)
 replace  MS=1 if (gestfips==28)
 replace  AR=1 if (gestfips==5)
 replace  LA=1 if (gestfips==22)
 replace  OK=1 if (gestfips==40)
 replace  TX=1 if (gestfips==48)
 replace  MT=1 if (gestfips==30)
 replace  ID=1 if (gestfips==16)
 replace  WY=1 if (gestfips==56)
 replace  CO=1 if (gestfips==8)
 replace  NM=1 if (gestfips==35)
 replace  AZ=1 if (gestfips==4)
 replace  UT=1 if (gestfips==49)
 replace  NV=1 if (gestfips==32)
 replace  WA=1 if (gestfips==53)
 replace  OR=1 if (gestfips==41)
 replace  CA=1 if (gestfips==6)
 replace  AK=1 if (gestfips==2)
 replace  HI=1 if (gestfips==15)

* 2020 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.368730578283517/0.2261 if (AL==1 & vote_missing==0)
replace correction = 0.312363005358013/0.2338 if (AK==1 & vote_missing==0)
replace correction = 0.340800732318366/0.1852 if (AZ==1 & vote_missing==0)
replace correction = 0.439292055673292/0.2885 if (AR==1 & vote_missing==0)
replace correction = 0.314971608443022/0.2085 if (CA==1 & vote_missing==0)
replace correction = 0.235885755198057/0.1362 if (CO==1 & vote_missing==0)
replace correction = 0.285112473385018/0.205 if (CT==1 & vote_missing==0)
replace correction = 0.293242067308693/0.2064 if (DE==1 & vote_missing==0)
replace correction = 0.359162913711311/0.0751 if (DC==1 & vote_missing==0)
replace correction = 0.283369210350045/0.1934 if (FL==1 & vote_missing==0)
replace correction = 0.319683507770369/0.1892 if (GA==1 & vote_missing==0)
replace correction = 0.424771807286293/0.2463 if (HI==1 & vote_missing==0)
replace correction = 0.320394275242303/0.2681 if (ID==1 & vote_missing==0)
replace correction = 0.329794500592772/0.1919 if (IL==1 & vote_missing==0)
replace correction = 0.386292459190557/0.2858 if (IN==1 & vote_missing==0)
replace correction = 0.26754241789886/0.1568 if (IA==1 & vote_missing==0)
replace correction = 0.34139819707981/0.2346 if (KS==1 & vote_missing==0)
replace correction = 0.350606385387576/0.2151 if (KY==1 & vote_missing==0)
replace correction = 0.357011048236894/0.2267 if (LA==1 & vote_missing==0)
replace correction = 0.236785729094201/0.1959 if (ME==1 & vote_missing==0)
replace correction = 0.288975373578621/0.1406 if (MD==1 & vote_missing==0)
replace correction = 0.2789125985309/0.1694 if (MA==1 & vote_missing==0)
replace correction = 0.261032003747742/0.1872 if (MI==1 & vote_missing==0)
replace correction = 0.200430403388449/0.1449 if (MN==1 & vote_missing==0)
replace correction = 0.398260632621086/0.2234 if (MS==1 & vote_missing==0)
replace correction = 0.342605136583056/0.2223 if (MO==1 & vote_missing==0)
replace correction = 0.268987863341367/0.1655 if (MT==1 & vote_missing==0)
replace correction = 0.301131653260342/0.2015 if (NE==1 & vote_missing==0)
replace correction = 0.346420819763083/0.2303 if (NV==1 & vote_missing==0)
replace correction = 0.245438813304009/0.1811 if (NH==1 & vote_missing==0)
replace correction = 0.247347661527466/0.1383 if (NJ==1 & vote_missing==0)
replace correction = 0.387450465402496/0.2643 if (NM==1 & vote_missing==0)
replace correction = 0.364318936789588/0.216 if (NY==1 & vote_missing==0)
replace correction = 0.285241455430567/0.198 if (NC==1 & vote_missing==0)
replace correction = 0.355471093156953/0.232 if (ND==1 & vote_missing==0)
replace correction = 0.325656576967112/0.211 if (OH==1 & vote_missing==0)
replace correction = 0.45007352850745/0.3284 if (OK==1 & vote_missing==0)
replace correction = 0.2448156925315/0.158 if (OR==1 & vote_missing==0)
replace correction = 0.288635445435564/0.2011 if (PA==1 & vote_missing==0)
replace correction = 0.346597602427086/0.2283 if (RI==1 & vote_missing==0)
replace correction = 0.35486163199242/0.2205 if (SC==1 & vote_missing==0)
replace correction = 0.340338896226532/0.277 if (SD==1 & vote_missing==0)
replace correction = 0.401935699014238/0.26 if (TN==1 & vote_missing==0)
replace correction = 0.395771357752333/0.2747 if (TX==1 & vote_missing==0)
replace correction = 0.308302992443031/0.2273 if (UT==1 & vote_missing==0)
replace correction = 0.25789183090477/0.1725 if (VT==1 & vote_missing==0)
replace correction = 0.269998358637272/0.1694 if (VA==1 & vote_missing==0)
replace correction = 0.242917965281829/0.1607 if (WA==1 & vote_missing==0)
replace correction = 0.424167950715481/0.3147 if (WV==1 & vote_missing==0)
replace correction = 0.242308053281081/0.1685 if (WI==1 & vote_missing==0)
replace correction = 0.354366613811074/0.2266 if (WY==1 & vote_missing==0)

replace correction = 0.631269421716483/0.7739 if (AL==1 & vote_missing== 1)
replace correction = 0.687636994641987/0.7662 if (AK==1 & vote_missing== 1)
replace correction = 0.659199267681634/0.8148 if (AZ==1 & vote_missing== 1)
replace correction = 0.560707944326708/0.7115 if (AR==1 & vote_missing== 1)
replace correction = 0.685028391556978/0.7915 if (CA==1 & vote_missing== 1)
replace correction = 0.764114244801943/0.8638 if (CO==1 & vote_missing== 1)
replace correction = 0.714887526614982/0.795 if (CT==1 & vote_missing== 1)
replace correction = 0.706757932691307/0.7936 if (DE==1 & vote_missing== 1)
replace correction = 0.640837086288689/0.9249 if (DC==1 & vote_missing== 1)
replace correction = 0.716630789649955/0.8066 if (FL==1 & vote_missing== 1)
replace correction = 0.680316492229631/0.8108 if (GA==1 & vote_missing== 1)
replace correction = 0.575228192713707/0.7537 if (HI==1 & vote_missing== 1)
replace correction = 0.679605724757697/0.7319 if (ID==1 & vote_missing== 1)
replace correction = 0.670205499407228/0.8081 if (IL==1 & vote_missing== 1)
replace correction = 0.613707540809443/0.7142 if (IN==1 & vote_missing== 1)
replace correction = 0.73245758210114/0.8432 if (IA==1 & vote_missing== 1)
replace correction = 0.65860180292019/0.7654 if (KS==1 & vote_missing== 1)
replace correction = 0.649393614612424/0.7849 if (KY==1 & vote_missing== 1)
replace correction = 0.642988951763106/0.7733 if (LA==1 & vote_missing== 1)
replace correction = 0.763214270905799/0.8041 if (ME==1 & vote_missing== 1)
replace correction = 0.711024626421379/0.8594 if (MD==1 & vote_missing== 1)
replace correction = 0.7210874014691/0.8306 if (MA==1 & vote_missing== 1)
replace correction = 0.738967996252258/0.8128 if (MI==1 & vote_missing== 1)
replace correction = 0.799569596611551/0.8551 if (MN==1 & vote_missing== 1)
replace correction = 0.601739367378914/0.7766 if (MS==1 & vote_missing== 1)
replace correction = 0.657394863416944/0.7777 if (MO==1 & vote_missing== 1)
replace correction = 0.731012136658633/0.8345 if (MT==1 & vote_missing== 1)
replace correction = 0.698868346739658/0.7985 if (NE==1 & vote_missing== 1)
replace correction = 0.653579180236917/0.7697 if (NV==1 & vote_missing== 1)
replace correction = 0.754561186695991/0.8189 if (NH==1 & vote_missing== 1)
replace correction = 0.752652338472534/0.8617 if (NJ==1 & vote_missing== 1)
replace correction = 0.612549534597504/0.7357 if (NM==1 & vote_missing== 1)
replace correction = 0.635681063210412/0.784 if (NY==1 & vote_missing== 1)
replace correction = 0.714758544569433/0.802 if (NC==1 & vote_missing== 1)
replace correction = 0.644528906843047/0.768 if (ND==1 & vote_missing== 1)
replace correction = 0.674343423032888/0.789 if (OH==1 & vote_missing== 1)
replace correction = 0.54992647149255/0.6716 if (OK==1 & vote_missing== 1)
replace correction = 0.7551843074685/0.842 if (OR==1 & vote_missing== 1)
replace correction = 0.711364554564436/0.7989 if (PA==1 & vote_missing== 1)
replace correction = 0.653402397572914/0.7717 if (RI==1 & vote_missing== 1)
replace correction = 0.64513836800758/0.7795 if (SC==1 & vote_missing== 1)
replace correction = 0.659661103773468/0.723 if (SD==1 & vote_missing== 1)
replace correction = 0.598064300985762/0.74 if (TN==1 & vote_missing== 1)
replace correction = 0.604228642247667/0.7253 if (TX==1 & vote_missing== 1)
replace correction = 0.691697007556969/0.7727 if (UT==1 & vote_missing== 1)
replace correction = 0.74210816909523/0.8275 if (VT==1 & vote_missing== 1)
replace correction = 0.730001641362728/0.8306 if (VA==1 & vote_missing== 1)
replace correction = 0.757082034718171/0.8393 if (WA==1 & vote_missing== 1)
replace correction = 0.575832049284519/0.6853 if (WV==1 & vote_missing== 1)
replace correction = 0.757691946718919/0.8315 if (WI==1 & vote_missing== 1)
replace correction = 0.645633386188926/0.7734 if (WY==1 & vote_missing== 1)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
 

svyset [pw =  PWSSWGT]

* state level rates for Hur and Achen correction
* svy: tab gestfips vote, row
svy: tab gestfips vote_missing, row

svyset [pw =  FINALWEIGHT]

svy: tab gestfips vote_missing, row
 
