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

* 2006 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.510184621795667/0.6087 if (AK==1 & vote_missing==1)
replace correction = 0.374543472581839/0.5476 if (AL==1 & vote_missing==1)
replace correction = 0.38652956430719/0.4932 if (AR==1 & vote_missing==1)
replace correction = 0.389109377017092/0.5237 if (AZ==1 & vote_missing==1)
replace correction = 0.402155896191055/0.5566 if (CA==1 & vote_missing==1)
replace correction = 0.472629492858617/0.5928 if (CO==1 & vote_missing==1)
replace correction = 0.465539478194349/0.5765 if (CT==1 & vote_missing==1)
replace correction = 0.282739514092312/0.5755 if (DC==1 & vote_missing==1)
replace correction = 0.42255383636879/0.5306 if (DE==1 & vote_missing==1)
replace correction = 0.396236149369532/0.5294 if (FL==1 & vote_missing==1)
replace correction = 0.347038915592612/0.5092 if (GA==1 & vote_missing==1)
replace correction = 0.378815641487398/0.4971 if (HI==1 & vote_missing==1)
replace correction = 0.481119449336988/0.5836 if (IA==1 & vote_missing==1)
replace correction = 0.454005475260727/0.5512 if (ID==1 & vote_missing==1)
replace correction = 0.402271695745272/0.5506 if (IL==1 & vote_missing==1)
replace correction = 0.365609642364762/0.501 if (IN==1 & vote_missing==1)
replace correction = 0.436000752358083/0.4949 if (KS==1 & vote_missing==1)
replace correction = 0.404255274278287/0.5335 if (KY==1 & vote_missing==1)
replace correction = 0.296525784228224/0.4502 if (LA==1 & vote_missing==1)
replace correction = 0.487564098465763/0.6118 if (MA==1 & vote_missing==1)
replace correction = 0.46651536410944/0.6241 if (MD==1 & vote_missing==1)
replace correction = 0.542036848246897/0.6295 if (ME==1 & vote_missing==1)
replace correction = 0.52124666436797/0.668 if (MI==1 & vote_missing==1)
replace correction = 0.600644200753147/0.7047 if (MN==1 & vote_missing==1)
replace correction = 0.500396961204699/0.5981 if (MO==1 & vote_missing==1)
replace correction = 0.294076834183768/0.4821 if (MS==1 & vote_missing==1)
replace correction = 0.56423986058985/0.6354 if (MT==1 & vote_missing==1)
replace correction = 0.309804074712377/0.4506 if (NC==1 & vote_missing==1)
replace correction = 0.448741413978822/0.5768 if (ND==1 & vote_missing==1)
replace correction = 0.476478049850973/0.5584 if (NE==1 & vote_missing==1)
replace correction = 0.413758709241047/0.5273 if (NH==1 & vote_missing==1)
replace correction = 0.394677562234522/0.5157 if (NJ==1 & vote_missing==1)
replace correction = 0.424971720510486/0.5941 if (NM==1 & vote_missing==1)
replace correction = 0.368898136181131/0.4657 if (NV==1 & vote_missing==1)
replace correction = 0.348643616640855/0.5073 if (NY==1 & vote_missing==1)
replace correction = 0.475434798978532/0.5912 if (OH==1 & vote_missing==1)
replace correction = 0.363714348839149/0.4954 if (OK==1 & vote_missing==1)
replace correction = 0.524727242499249/0.6585 if (OR==1 & vote_missing==1)
replace correction = 0.441208760369426/0.5333 if (PA==1 & vote_missing==1)
replace correction = 0.510452871417328/0.6464 if (RI==1 & vote_missing==1)
replace correction = 0.346426423603447/0.4896 if (SC==1 & vote_missing==1)
replace correction = 0.577872499769703/0.6619 if (SD==1 & vote_missing==1)
replace correction = 0.41356058404871/0.5248 if (TN==1 & vote_missing==1)
replace correction = 0.308591473372779/0.4375 if (TX==1 & vote_missing==1)
replace correction = 0.343233867364029/0.4163 if (UT==1 & vote_missing==1)
replace correction = 0.440151386252745/0.5577 if (VA==1 & vote_missing==1)
replace correction = 0.549352016868346/0.6323 if (VT==1 & vote_missing==1)
replace correction = 0.473147825914197/0.5981 if (WA==1 & vote_missing==1)
replace correction = 0.531857810939724/0.6352 if (WI==1 & vote_missing==1)
replace correction = 0.3281393102795/0.4138 if (WV==1 & vote_missing==1)
replace correction = 0.511417521118561/0.5488 if (WY==1 & vote_missing==1)

replace correction = 0.489815378204333/0.3913 if (AK==1 & vote_missing== 0)
replace correction = 0.62545652741816/0.4524 if (AL==1 & vote_missing== 0)
replace correction = 0.61347043569281/0.5068 if (AR==1 & vote_missing== 0)
replace correction = 0.610890622982908/0.4763 if (AZ==1 & vote_missing== 0)
replace correction = 0.597844103808945/0.4434 if (CA==1 & vote_missing== 0)
replace correction = 0.527370507141383/0.4072 if (CO==1 & vote_missing== 0)
replace correction = 0.534460521805651/0.4235 if (CT==1 & vote_missing== 0)
replace correction = 0.717260485907688/0.4245 if (DC==1 & vote_missing== 0)
replace correction = 0.57744616363121/0.4694 if (DE==1 & vote_missing== 0)
replace correction = 0.603763850630468/0.4706 if (FL==1 & vote_missing== 0)
replace correction = 0.652961084407388/0.4908 if (GA==1 & vote_missing== 0)
replace correction = 0.621184358512602/0.5029 if (HI==1 & vote_missing== 0)
replace correction = 0.518880550663012/0.4164 if (IA==1 & vote_missing== 0)
replace correction = 0.545994524739273/0.4488 if (ID==1 & vote_missing== 0)
replace correction = 0.597728304254728/0.4494 if (IL==1 & vote_missing== 0)
replace correction = 0.634390357635238/0.499 if (IN==1 & vote_missing== 0)
replace correction = 0.563999247641917/0.5051 if (KS==1 & vote_missing== 0)
replace correction = 0.595744725721713/0.4665 if (KY==1 & vote_missing== 0)
replace correction = 0.703474215771776/0.5498 if (LA==1 & vote_missing== 0)
replace correction = 0.512435901534237/0.3882 if (MA==1 & vote_missing== 0)
replace correction = 0.53348463589056/0.3759 if (MD==1 & vote_missing== 0)
replace correction = 0.457963151753103/0.3705 if (ME==1 & vote_missing== 0)
replace correction = 0.47875333563203/0.332 if (MI==1 & vote_missing== 0)
replace correction = 0.399355799246853/0.2953 if (MN==1 & vote_missing== 0)
replace correction = 0.499603038795301/0.4019 if (MO==1 & vote_missing== 0)
replace correction = 0.705923165816232/0.5179 if (MS==1 & vote_missing== 0)
replace correction = 0.43576013941015/0.3646 if (MT==1 & vote_missing== 0)
replace correction = 0.690195925287623/0.5494 if (NC==1 & vote_missing== 0)
replace correction = 0.551258586021178/0.4232 if (ND==1 & vote_missing== 0)
replace correction = 0.523521950149027/0.4416 if (NE==1 & vote_missing== 0)
replace correction = 0.586241290758953/0.4727 if (NH==1 & vote_missing== 0)
replace correction = 0.605322437765478/0.4843 if (NJ==1 & vote_missing== 0)
replace correction = 0.575028279489514/0.4059 if (NM==1 & vote_missing== 0)
replace correction = 0.631101863818869/0.5343 if (NV==1 & vote_missing== 0)
replace correction = 0.651356383359145/0.4927 if (NY==1 & vote_missing== 0)
replace correction = 0.524565201021468/0.4088 if (OH==1 & vote_missing== 0)
replace correction = 0.636285651160851/0.5046 if (OK==1 & vote_missing== 0)
replace correction = 0.475272757500751/0.3415 if (OR==1 & vote_missing== 0)
replace correction = 0.558791239630574/0.4667 if (PA==1 & vote_missing== 0)
replace correction = 0.489547128582672/0.3536 if (RI==1 & vote_missing== 0)
replace correction = 0.653573576396553/0.5104 if (SC==1 & vote_missing== 0)
replace correction = 0.422127500230297/0.3381 if (SD==1 & vote_missing== 0)
replace correction = 0.58643941595129/0.4752 if (TN==1 & vote_missing== 0)
replace correction = 0.691408526627221/0.5625 if (TX==1 & vote_missing== 0)
replace correction = 0.656766132635971/0.5837 if (UT==1 & vote_missing== 0)
replace correction = 0.559848613747255/0.4423 if (VA==1 & vote_missing== 0)
replace correction = 0.450647983131654/0.3677 if (VT==1 & vote_missing== 0)
replace correction = 0.526852174085803/0.4019 if (WA==1 & vote_missing== 0)
replace correction = 0.468142189060276/0.3648 if (WI==1 & vote_missing== 0)
replace correction = 0.6718606897205/0.5862 if (WV==1 & vote_missing== 0)
replace correction = 0.488582478881439/0.4512 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
