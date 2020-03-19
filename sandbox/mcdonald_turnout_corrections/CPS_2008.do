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

* 2008 CPS Hur and Achen Weight Correction

gen correction = 0

replace correction = 0.680386459726049/0.7549 if (AK==1 & vote_missing==1)
replace correction = 0.607848580551221/0.732 if (AL==1 & vote_missing==1)
replace correction = 0.524539683321241/0.5951 if (AR==1 & vote_missing==1)
replace correction = 0.566839467879365/0.6828 if (AZ==1 & vote_missing==1)
replace correction = 0.609208614116998/0.7517 if (CA==1 & vote_missing==1)
replace correction = 0.709840408943768/0.7858 if (CO==1 & vote_missing==1)
replace correction = 0.666425476774951/0.7677 if (CT==1 & vote_missing==1)
replace correction = 0.61459522939852/0.8498 if (DC==1 & vote_missing==1)
replace correction = 0.65647564469914/0.7677 if (DE==1 & vote_missing==1)
replace correction = 0.661344276257552/0.7791 if (FL==1 & vote_missing==1)
replace correction = 0.624724604385444/0.7533 if (GA==1 & vote_missing==1)
replace correction = 0.487672393494232/0.5943 if (HI==1 & vote_missing==1)
replace correction = 0.693618140746737/0.7708 if (IA==1 & vote_missing==1)
replace correction = 0.636314182021651/0.6639 if (ID==1 & vote_missing==1)
replace correction = 0.636212786848913/0.7412 if (IL==1 & vote_missing==1)
replace correction = 0.59124065472331/0.7146 if (IN==1 & vote_missing==1)
replace correction = 0.620492740336557/0.6911 if (KS==1 & vote_missing==1)
replace correction = 0.579360273600224/0.7016 if (KY==1 & vote_missing==1)
replace correction = 0.61163037924458/0.7832 if (LA==1 & vote_missing==1)
replace correction = 0.667956986916131/0.7903 if (MA==1 & vote_missing==1)
replace correction = 0.670450333072874/0.7936 if (MD==1 & vote_missing==1)
replace correction = 0.705590971993029/0.767 if (ME==1 & vote_missing==1)
replace correction = 0.691853889999768/0.786 if (MI==1 & vote_missing==1)
replace correction = 0.778143984907525/0.8507 if (MN==1 & vote_missing==1)
replace correction = 0.675946003902419/0.7425 if (MO==1 & vote_missing==1)
replace correction = 0.610338008855148/0.7857 if (MS==1 & vote_missing==1)
replace correction = 0.663150246746997/0.7217 if (MT==1 & vote_missing==1)
replace correction = 0.654707059305603/0.7413 if (NC==1 & vote_missing==1)
replace correction = 0.62726790051549/0.7167 if (ND==1 & vote_missing==1)
replace correction = 0.628594223511221/0.7383 if (NE==1 & vote_missing==1)
replace correction = 0.716540384952622/0.7857 if (NH==1 & vote_missing==1)
replace correction = 0.669647523503309/0.7575 if (NJ==1 & vote_missing==1)
replace correction = 0.609232593758096/0.7169 if (NM==1 & vote_missing==1)
replace correction = 0.570385618838883/0.6802 if (NV==1 & vote_missing==1)
replace correction = 0.59005778761228/0.7283 if (NY==1 & vote_missing==1)
replace correction = 0.669353591103759/0.7504 if (OH==1 & vote_missing==1)
replace correction = 0.558454916744969/0.6689 if (OK==1 & vote_missing==1)
replace correction = 0.67690468598803/0.779 if (OR==1 & vote_missing==1)
replace correction = 0.635729421897491/0.7205 if (PA==1 & vote_missing==1)
replace correction = 0.617811756817634/0.7427 if (RI==1 & vote_missing==1)
replace correction = 0.580170181972816/0.6959 if (SC==1 & vote_missing==1)
replace correction = 0.646626151137595/0.7275 if (SD==1 & vote_missing==1)
replace correction = 0.569721589624105/0.6787 if (TN==1 & vote_missing==1)
replace correction = 0.541051426642402/0.6426 if (TX==1 & vote_missing==1)
replace correction = 0.560123414531438/0.661 if (UT==1 & vote_missing==1)
replace correction = 0.670203756155031/0.7849 if (VA==1 & vote_missing==1)
replace correction = 0.673423428089592/0.7273 if (VT==1 & vote_missing==1)
replace correction = 0.665812206228982/0.7726 if (WA==1 & vote_missing==1)
replace correction = 0.724008383053922/0.7981 if (WI==1 & vote_missing==1)
replace correction = 0.498701447597556/0.6275 if (WV==1 & vote_missing==1)
replace correction = 0.627650764544083/0.7163 if (WY==1 & vote_missing==1)

replace correction = 0.319613540273951/0.2451 if (AK==1 & vote_missing== 0)
replace correction = 0.392151419448779/0.268 if (AL==1 & vote_missing== 0)
replace correction = 0.475460316678759/0.4049 if (AR==1 & vote_missing== 0)
replace correction = 0.433160532120635/0.3172 if (AZ==1 & vote_missing== 0)
replace correction = 0.390791385883002/0.2483 if (CA==1 & vote_missing== 0)
replace correction = 0.290159591056232/0.2142 if (CO==1 & vote_missing== 0)
replace correction = 0.333574523225049/0.2323 if (CT==1 & vote_missing== 0)
replace correction = 0.38540477060148/0.1502 if (DC==1 & vote_missing== 0)
replace correction = 0.34352435530086/0.2323 if (DE==1 & vote_missing== 0)
replace correction = 0.338655723742448/0.2209 if (FL==1 & vote_missing== 0)
replace correction = 0.375275395614556/0.2467 if (GA==1 & vote_missing== 0)
replace correction = 0.512327606505768/0.4057 if (HI==1 & vote_missing== 0)
replace correction = 0.306381859253263/0.2292 if (IA==1 & vote_missing== 0)
replace correction = 0.363685817978349/0.3361 if (ID==1 & vote_missing== 0)
replace correction = 0.363787213151087/0.2588 if (IL==1 & vote_missing== 0)
replace correction = 0.40875934527669/0.2854 if (IN==1 & vote_missing== 0)
replace correction = 0.379507259663443/0.3089 if (KS==1 & vote_missing== 0)
replace correction = 0.420639726399776/0.2984 if (KY==1 & vote_missing== 0)
replace correction = 0.38836962075542/0.2168 if (LA==1 & vote_missing== 0)
replace correction = 0.332043013083869/0.2097 if (MA==1 & vote_missing== 0)
replace correction = 0.329549666927126/0.2064 if (MD==1 & vote_missing== 0)
replace correction = 0.294409028006971/0.233 if (ME==1 & vote_missing== 0)
replace correction = 0.308146110000232/0.214 if (MI==1 & vote_missing== 0)
replace correction = 0.221856015092475/0.1493 if (MN==1 & vote_missing== 0)
replace correction = 0.324053996097581/0.2575 if (MO==1 & vote_missing== 0)
replace correction = 0.389661991144852/0.2143 if (MS==1 & vote_missing== 0)
replace correction = 0.336849753253003/0.2783 if (MT==1 & vote_missing== 0)
replace correction = 0.345292940694397/0.2587 if (NC==1 & vote_missing== 0)
replace correction = 0.37273209948451/0.2833 if (ND==1 & vote_missing== 0)
replace correction = 0.371405776488779/0.2617 if (NE==1 & vote_missing== 0)
replace correction = 0.283459615047378/0.2143 if (NH==1 & vote_missing== 0)
replace correction = 0.330352476496691/0.2425 if (NJ==1 & vote_missing== 0)
replace correction = 0.390767406241904/0.2831 if (NM==1 & vote_missing== 0)
replace correction = 0.429614381161117/0.3198 if (NV==1 & vote_missing== 0)
replace correction = 0.40994221238772/0.2717 if (NY==1 & vote_missing== 0)
replace correction = 0.330646408896241/0.2496 if (OH==1 & vote_missing== 0)
replace correction = 0.441545083255031/0.3311 if (OK==1 & vote_missing== 0)
replace correction = 0.32309531401197/0.221 if (OR==1 & vote_missing== 0)
replace correction = 0.364270578102509/0.2795 if (PA==1 & vote_missing== 0)
replace correction = 0.382188243182366/0.2573 if (RI==1 & vote_missing== 0)
replace correction = 0.419829818027184/0.3041 if (SC==1 & vote_missing== 0)
replace correction = 0.353373848862405/0.2725 if (SD==1 & vote_missing== 0)
replace correction = 0.430278410375895/0.3213 if (TN==1 & vote_missing== 0)
replace correction = 0.458948573357598/0.3574 if (TX==1 & vote_missing== 0)
replace correction = 0.439876585468562/0.339 if (UT==1 & vote_missing== 0)
replace correction = 0.329796243844969/0.2151 if (VA==1 & vote_missing== 0)
replace correction = 0.326576571910408/0.2727 if (VT==1 & vote_missing== 0)
replace correction = 0.334187793771018/0.2274 if (WA==1 & vote_missing== 0)
replace correction = 0.275991616946078/0.2019 if (WI==1 & vote_missing== 0)
replace correction = 0.501298552402444/0.3725 if (WV==1 & vote_missing== 0)
replace correction = 0.372349235455917/0.2837 if (WY==1 & vote_missing== 0)

gen FINALWEIGHT = 0
replace FINALWEIGHT = correction *  PWSSWGT
