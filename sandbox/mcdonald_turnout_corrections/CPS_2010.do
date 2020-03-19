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

* 2010 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.518833095375518/0.6213 if (AK==1 & vote_missing==1)
replace correction = 0.43028410551956/0.5492 if (AL==1 & vote_missing==1)
replace correction = 0.375403891677994/0.4744 if (AR==1 & vote_missing==1)
replace correction = 0.409982331610472/0.5742 if (AZ==1 & vote_missing==1)
replace correction = 0.439608777000077/0.5748 if (CA==1 & vote_missing==1)
replace correction = 0.505821504055954/0.6416 if (CO==1 & vote_missing==1)
replace correction = 0.458723205857068/0.5908 if (CT==1 & vote_missing==1)
replace correction = 0.289250990473574/0.5609 if (DC==1 & vote_missing==1)
replace correction = 0.47492815869975/0.6087 if (DE==1 & vote_missing==1)
replace correction = 0.417280648165813/0.5568 if (FL==1 & vote_missing==1)
replace correction = 0.398381552375472/0.5356 if (GA==1 & vote_missing==1)
replace correction = 0.398656773964966/0.5251 if (HI==1 & vote_missing==1)
replace correction = 0.499425201201954/0.6019 if (IA==1 & vote_missing==1)
replace correction = 0.423084510321061/0.5211 if (ID==1 & vote_missing==1)
replace correction = 0.423817452081501/0.5446 if (IL==1 & vote_missing==1)
replace correction = 0.37135121373246/0.4668 if (IN==1 & vote_missing==1)
replace correction = 0.416933632301707/0.5178 if (KS==1 & vote_missing==1)
replace correction = 0.424127929881698/0.5188 if (KY==1 & vote_missing==1)
replace correction = 0.389272761178644/0.5622 if (LA==1 & vote_missing==1)
replace correction = 0.48929876816813/0.6143 if (MA==1 & vote_missing==1)
replace correction = 0.464274192359372/0.5746 if (MD==1 & vote_missing==1)
replace correction = 0.551690857550705/0.6585 if (ME==1 & vote_missing==1)
replace correction = 0.4452297473259/0.5681 if (MI==1 & vote_missing==1)
replace correction = 0.554013838901638/0.6459 if (MN==1 & vote_missing==1)
replace correction = 0.445145962334665/0.5338 if (MO==1 & vote_missing==1)
replace correction = 0.370326590379903/0.532 if (MS==1 & vote_missing==1)
replace correction = 0.474968464258834/0.5997 if (MT==1 & vote_missing==1)
replace correction = 0.391923636684024/0.5227 if (NC==1 & vote_missing==1)
replace correction = 0.461935738450736/0.6083 if (ND==1 & vote_missing==1)
replace correction = 0.374871902813606/0.4867 if (NE==1 & vote_missing==1)
replace correction = 0.456594848922734/0.5408 if (NH==1 & vote_missing==1)
replace correction = 0.363656246952153/0.5257 if (NJ==1 & vote_missing==1)
replace correction = 0.427843348781751/0.5601 if (NM==1 & vote_missing==1)
replace correction = 0.412870688747362/0.5044 if (NV==1 & vote_missing==1)
replace correction = 0.354506752740043/0.5226 if (NY==1 & vote_missing==1)
replace correction = 0.449394159122819/0.5325 if (OH==1 & vote_missing==1)
replace correction = 0.387970797030212/0.4584 if (OK==1 & vote_missing==1)
replace correction = 0.52619807925038/0.659 if (OR==1 & vote_missing==1)
replace correction = 0.416803961964969/0.5109 if (PA==1 & vote_missing==1)
replace correction = 0.4482969979071/0.5375 if (RI==1 & vote_missing==1)
replace correction = 0.396644831791594/0.5674 if (SC==1 & vote_missing==1)
replace correction = 0.528852440423772/0.6282 if (SD==1 & vote_missing==1)
replace correction = 0.346418908118413/0.4484 if (TN==1 & vote_missing==1)
replace correction = 0.320802821643985/0.4291 if (TX==1 & vote_missing==1)
replace correction = 0.362793360045793/0.4635 if (UT==1 & vote_missing==1)
replace correction = 0.386762472979854/0.5164 if (VA==1 & vote_missing==1)
replace correction = 0.494138364059541/0.6051 if (VT==1 & vote_missing==1)
replace correction = 0.531419898274252/0.6503 if (WA==1 & vote_missing==1)
replace correction = 0.520437042949285/0.6227 if (WI==1 & vote_missing==1)
replace correction = 0.367506211811144/0.4801 if (WV==1 & vote_missing==1)
replace correction = 0.454577907276845/0.5559 if (WY==1 & vote_missing==1)

replace correction = 0.481166904624482/0.3787 if (AK==1 & vote_missing== 0)
replace correction = 0.56971589448044/0.4508 if (AL==1 & vote_missing== 0)
replace correction = 0.624596108322006/0.5256 if (AR==1 & vote_missing== 0)
replace correction = 0.590017668389528/0.4258 if (AZ==1 & vote_missing== 0)
replace correction = 0.560391222999923/0.4252 if (CA==1 & vote_missing== 0)
replace correction = 0.494178495944046/0.3584 if (CO==1 & vote_missing== 0)
replace correction = 0.541276794142932/0.4092 if (CT==1 & vote_missing== 0)
replace correction = 0.710749009526426/0.4391 if (DC==1 & vote_missing== 0)
replace correction = 0.52507184130025/0.3913 if (DE==1 & vote_missing== 0)
replace correction = 0.582719351834187/0.4432 if (FL==1 & vote_missing== 0)
replace correction = 0.601618447624528/0.4644 if (GA==1 & vote_missing== 0)
replace correction = 0.601343226035034/0.4749 if (HI==1 & vote_missing== 0)
replace correction = 0.500574798798046/0.3981 if (IA==1 & vote_missing== 0)
replace correction = 0.576915489678939/0.4789 if (ID==1 & vote_missing== 0)
replace correction = 0.576182547918499/0.4554 if (IL==1 & vote_missing== 0)
replace correction = 0.62864878626754/0.5332 if (IN==1 & vote_missing== 0)
replace correction = 0.583066367698293/0.4822 if (KS==1 & vote_missing== 0)
replace correction = 0.575872070118302/0.4812 if (KY==1 & vote_missing== 0)
replace correction = 0.610727238821356/0.4378 if (LA==1 & vote_missing== 0)
replace correction = 0.51070123183187/0.3857 if (MA==1 & vote_missing== 0)
replace correction = 0.535725807640627/0.4254 if (MD==1 & vote_missing== 0)
replace correction = 0.448309142449295/0.3415 if (ME==1 & vote_missing== 0)
replace correction = 0.5547702526741/0.4319 if (MI==1 & vote_missing== 0)
replace correction = 0.445986161098362/0.3541 if (MN==1 & vote_missing== 0)
replace correction = 0.554854037665335/0.4662 if (MO==1 & vote_missing== 0)
replace correction = 0.629673409620097/0.468 if (MS==1 & vote_missing== 0)
replace correction = 0.525031535741166/0.4003 if (MT==1 & vote_missing== 0)
replace correction = 0.608076363315976/0.4773 if (NC==1 & vote_missing== 0)
replace correction = 0.538064261549264/0.3917 if (ND==1 & vote_missing== 0)
replace correction = 0.625128097186394/0.5133 if (NE==1 & vote_missing== 0)
replace correction = 0.543405151077266/0.4592 if (NH==1 & vote_missing== 0)
replace correction = 0.636343753047847/0.4743 if (NJ==1 & vote_missing== 0)
replace correction = 0.572156651218249/0.4399 if (NM==1 & vote_missing== 0)
replace correction = 0.587129311252638/0.4956 if (NV==1 & vote_missing== 0)
replace correction = 0.645493247259957/0.4774 if (NY==1 & vote_missing== 0)
replace correction = 0.550605840877181/0.4675 if (OH==1 & vote_missing== 0)
replace correction = 0.612029202969788/0.5416 if (OK==1 & vote_missing== 0)
replace correction = 0.47380192074962/0.341 if (OR==1 & vote_missing== 0)
replace correction = 0.583196038035031/0.4891 if (PA==1 & vote_missing== 0)
replace correction = 0.5517030020929/0.4625 if (RI==1 & vote_missing== 0)
replace correction = 0.603355168208406/0.4326 if (SC==1 & vote_missing== 0)
replace correction = 0.471147559576228/0.3718 if (SD==1 & vote_missing== 0)
replace correction = 0.653581091881587/0.5516 if (TN==1 & vote_missing== 0)
replace correction = 0.679197178356015/0.5709 if (TX==1 & vote_missing== 0)
replace correction = 0.637206639954207/0.5365 if (UT==1 & vote_missing== 0)
replace correction = 0.613237527020146/0.4836 if (VA==1 & vote_missing== 0)
replace correction = 0.505861635940459/0.3949 if (VT==1 & vote_missing== 0)
replace correction = 0.468580101725748/0.3497 if (WA==1 & vote_missing== 0)
replace correction = 0.479562957050715/0.3773 if (WI==1 & vote_missing== 0)
replace correction = 0.632493788188856/0.5199 if (WV==1 & vote_missing== 0)
replace correction = 0.545422092723155/0.4441 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
