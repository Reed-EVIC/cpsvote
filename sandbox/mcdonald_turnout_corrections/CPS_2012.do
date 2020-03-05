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

* 2012 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.587143256739521/0.6886 if (AK==1 & vote_missing==1)
replace correction = 0.586133862532235/0.7129 if (AL==1 & vote_missing==1)
replace correction = 0.506937608684387/0.5944 if (AR==1 & vote_missing==1)
replace correction = 0.526250192502025/0.647 if (AZ==1 & vote_missing==1)
replace correction = 0.550922398449985/0.6811 if (CA==1 & vote_missing==1)
replace correction = 0.699338851018642/0.814 if (CO==1 & vote_missing==1)
replace correction = 0.613134382441466/0.7404 if (CT==1 & vote_missing==1)
replace correction = 0.615107073677999/0.838 if (DC==1 & vote_missing==1)
replace correction = 0.623691978973139/0.7758 if (DE==1 & vote_missing==1)
replace correction = 0.628411417117396/0.7431 if (FL==1 & vote_missing==1)
replace correction = 0.590568894079476/0.7346 if (GA==1 & vote_missing==1)
replace correction = 0.442387919580835/0.6062 if (HI==1 & vote_missing==1)
replace correction = 0.702727313165514/0.7546 if (IA==1 & vote_missing==1)
replace correction = 0.597643481174303/0.6896 if (ID==1 & vote_missing==1)
replace correction = 0.589047053126571/0.71 if (IL==1 & vote_missing==1)
replace correction = 0.551984262989847/0.6679 if (IN==1 & vote_missing==1)
replace correction = 0.569485065457678/0.679 if (KS==1 & vote_missing==1)
replace correction = 0.556595390119345/0.6446 if (KY==1 & vote_missing==1)
replace correction = 0.602163513234478/0.7142 if (LA==1 & vote_missing==1)
replace correction = 0.658764265906635/0.7837 if (MA==1 & vote_missing==1)
replace correction = 0.666348210647238/0.7759 if (MD==1 & vote_missing==1)
replace correction = 0.681811277959294/0.7475 if (ME==1 & vote_missing==1)
replace correction = 0.64700369468325/0.7559 if (MI==1 & vote_missing==1)
replace correction = 0.760561644460514/0.8063 if (MN==1 & vote_missing==1)
replace correction = 0.622080215236995/0.7164 if (MO==1 & vote_missing==1)
replace correction = 0.593307046829416/0.7908 if (MS==1 & vote_missing==1)
replace correction = 0.625014574635201/0.7284 if (MT==1 & vote_missing==1)
replace correction = 0.648592344523677/0.7712 if (NC==1 & vote_missing==1)
replace correction = 0.598396839980231/0.7252 if (ND==1 & vote_missing==1)
replace correction = 0.60332146333098/0.7059 if (NE==1 & vote_missing==1)
replace correction = 0.701638877094667/0.7616 if (NH==1 & vote_missing==1)
replace correction = 0.615255496528336/0.7255 if (NJ==1 & vote_missing==1)
replace correction = 0.545720041071938/0.7234 if (NM==1 & vote_missing==1)
replace correction = 0.563540116175694/0.6835 if (NV==1 & vote_missing==1)
replace correction = 0.531143901819226/0.6998 if (NY==1 & vote_missing==1)
replace correction = 0.645261390864861/0.7445 if (OH==1 & vote_missing==1)
replace correction = 0.491979484149265/0.5958 if (OK==1 & vote_missing==1)
replace correction = 0.631165191216792/0.7703 if (OR==1 & vote_missing==1)
replace correction = 0.595007774457274/0.6866 if (PA==1 & vote_missing==1)
replace correction = 0.580151665542604/0.7045 if (RI==1 & vote_missing==1)
replace correction = 0.563374604399313/0.7226 if (SC==1 & vote_missing==1)
replace correction = 0.593389094825636/0.6632 if (SD==1 & vote_missing==1)
replace correction = 0.519146295527925/0.63 if (TN==1 & vote_missing==1)
replace correction = 0.496168398112339/0.6036 if (TX==1 & vote_missing==1)
replace correction = 0.555071922505644/0.6592 if (UT==1 & vote_missing==1)
replace correction = 0.660687631828897/0.7556 if (VA==1 & vote_missing==1)
replace correction = 0.606642830190768/0.7007 if (VT==1 & vote_missing==1)
replace correction = 0.648293414094098/0.7446 if (WA==1 & vote_missing==1)
replace correction = 0.729059403057491/0.816 if (WI==1 & vote_missing==1)
replace correction = 0.463314415238865/0.54 if (WV==1 & vote_missing==1)
replace correction = 0.585886805373283/0.6688 if (WY==1 & vote_missing==1)

replace correction = 0.412856743260479/0.3114 if (AK==1 & vote_missing== 0)
replace correction = 0.413866137467765/0.2871 if (AL==1 & vote_missing== 0)
replace correction = 0.493062391315613/0.4056 if (AR==1 & vote_missing== 0)
replace correction = 0.473749807497975/0.353 if (AZ==1 & vote_missing== 0)
replace correction = 0.449077601550015/0.3189 if (CA==1 & vote_missing== 0)
replace correction = 0.300661148981358/0.186 if (CO==1 & vote_missing== 0)
replace correction = 0.386865617558534/0.2596 if (CT==1 & vote_missing== 0)
replace correction = 0.384892926322001/0.162 if (DC==1 & vote_missing== 0)
replace correction = 0.376308021026861/0.2242 if (DE==1 & vote_missing== 0)
replace correction = 0.371588582882604/0.2569 if (FL==1 & vote_missing== 0)
replace correction = 0.409431105920524/0.2654 if (GA==1 & vote_missing== 0)
replace correction = 0.557612080419165/0.3938 if (HI==1 & vote_missing== 0)
replace correction = 0.297272686834486/0.2454 if (IA==1 & vote_missing== 0)
replace correction = 0.402356518825697/0.3104 if (ID==1 & vote_missing== 0)
replace correction = 0.410952946873429/0.29 if (IL==1 & vote_missing== 0)
replace correction = 0.448015737010153/0.3321 if (IN==1 & vote_missing== 0)
replace correction = 0.430514934542322/0.321 if (KS==1 & vote_missing== 0)
replace correction = 0.443404609880655/0.3554 if (KY==1 & vote_missing== 0)
replace correction = 0.397836486765522/0.2858 if (LA==1 & vote_missing== 0)
replace correction = 0.341235734093365/0.2163 if (MA==1 & vote_missing== 0)
replace correction = 0.333651789352762/0.2241 if (MD==1 & vote_missing== 0)
replace correction = 0.318188722040706/0.2525 if (ME==1 & vote_missing== 0)
replace correction = 0.35299630531675/0.2441 if (MI==1 & vote_missing== 0)
replace correction = 0.239438355539486/0.1937 if (MN==1 & vote_missing== 0)
replace correction = 0.377919784763005/0.2836 if (MO==1 & vote_missing== 0)
replace correction = 0.406692953170584/0.2092 if (MS==1 & vote_missing== 0)
replace correction = 0.374985425364799/0.2716 if (MT==1 & vote_missing== 0)
replace correction = 0.351407655476323/0.2288 if (NC==1 & vote_missing== 0)
replace correction = 0.401603160019769/0.2748 if (ND==1 & vote_missing== 0)
replace correction = 0.39667853666902/0.2941 if (NE==1 & vote_missing== 0)
replace correction = 0.298361122905333/0.2384 if (NH==1 & vote_missing== 0)
replace correction = 0.384744503471664/0.2745 if (NJ==1 & vote_missing== 0)
replace correction = 0.454279958928062/0.2766 if (NM==1 & vote_missing== 0)
replace correction = 0.436459883824306/0.3165 if (NV==1 & vote_missing== 0)
replace correction = 0.468856098180774/0.3002 if (NY==1 & vote_missing== 0)
replace correction = 0.354738609135139/0.2555 if (OH==1 & vote_missing== 0)
replace correction = 0.508020515850735/0.4042 if (OK==1 & vote_missing== 0)
replace correction = 0.368834808783208/0.2297 if (OR==1 & vote_missing== 0)
replace correction = 0.404992225542726/0.3134 if (PA==1 & vote_missing== 0)
replace correction = 0.419848334457396/0.2955 if (RI==1 & vote_missing== 0)
replace correction = 0.436625395600687/0.2774 if (SC==1 & vote_missing== 0)
replace correction = 0.406610905174364/0.3368 if (SD==1 & vote_missing== 0)
replace correction = 0.480853704472075/0.37 if (TN==1 & vote_missing== 0)
replace correction = 0.503831601887661/0.3964 if (TX==1 & vote_missing== 0)
replace correction = 0.444928077494356/0.3408 if (UT==1 & vote_missing== 0)
replace correction = 0.339312368171103/0.2444 if (VA==1 & vote_missing== 0)
replace correction = 0.393357169809232/0.2993 if (VT==1 & vote_missing== 0)
replace correction = 0.351706585905902/0.2554 if (WA==1 & vote_missing== 0)
replace correction = 0.270940596942509/0.184 if (WI==1 & vote_missing== 0)
replace correction = 0.536685584761135/0.46 if (WV==1 & vote_missing== 0)
replace correction = 0.414113194626717/0.3312 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
