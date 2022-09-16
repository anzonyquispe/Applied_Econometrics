* 0) Set up environment
*==============================================================================*
*global main "C:/Users/geron/Desktop/Maestria/Economia Aplicada/STATA/Replicacion de Tutoriales/IV"
global main "C:/Users/Hp Support/Videos/03 - Cursos/06 - Economía Aplicada/03 - Trabajos prácticos/TP4"
global input "$main/input"
global output "$main/output"
cd "$main"


* 1) IV
*==============================================================================*

* Open the database
use "$input/poppy", clear
************************CONSIGNA 1
gen Chinesepresence =0 
replace Chinesepresence=1 if chinos1930hoy !=0

*variables: cartel2005 cartel2010 IM_2015 Impuestos_pc_mun dalemanes tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med growthperc pob1930cabec
**********************CONSIGNA 2
global control dalemanes tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med growthperc pob1930cabec capestado

tabstat $control, statistics(mean sd min max) columns(statistics)

* estpost summarize $control , listwise
esttab using "$output/Table 2.tex", cells("mean sd min max") nomtitle nonumber replace label 

global control2 dalemanes tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med pob1930cabec capestado


drop if estado=="Distrito Federal"

************CONSIGNA 3 COLUMNAS 3 A 6

eststo regr1: quietly reg cartel2010 Chinesepresence i.id_estado ,cluster(id_estado) 
eststo regr2: quietly reg cartel2010 Chinesepresence i.id_estado $control2 ,cluster(id_estado)

eststo regr3: quietly reg cartel2005 Chinesepresence i.id_estado ,cluster(id_estado)
eststo regr4: quietly reg cartel2005 Chinesepresence i.id_estado $control2 ,cluster(id_estado) 

esttab regr1 regr2 regr3 regr4 using "$output/regress1.tex", drop(*id_estado $control2 _cons) replace se label


********************************CONSIGNA 4 P1
*1
eststo ivregr1: quietly ivreg2  IM_2015 i.id_estado (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

est sto test
qui testparm*
estadd scalar p_value = r(p)

*2
eststo ivregr2: quietly ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst
est sto test
qui testparm*
estadd scalar p_value = r(p)


*3
eststo ivregr3: quietly ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence) if distancia_km<=100,cluster(id_estado) ffirst
est sto test
qui testparm*
estadd scalar p_value = r(p)

*4

eststo ivregr4: quietly ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence) if id_estado!=25,cluster(id_estado) ffirst
est sto test
qui testparm*
estadd scalar p_value = r(p)
*5

eststo ivregr5: quietly ivreg2  IM_2015 i.id_estado $control2 growthperc (cartel2010 = Chinesepresence),cluster(id_estado) ffirst
est sto test
qui testparm*
estadd scalar p_value = r(p)

esttab test ivregr1 ivregr2 ivregr3 ivregr4 ivregr5 using "$output/regress2.tex", star(* 0.1 ** 0.05 *** 0.01 **** 0.001) r2 ar2 p label scalar(F p_value) drop(*id_estado $control2 _cons) replace 

weakivtest
*******************************CONSIGNA 4 P2
eststo ivregr6: quietly ivreg2  ANALF_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr7: quietly ivreg2  SPRIM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr8: quietly ivreg2  OVSDE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr9: quietly ivreg2  OVSEE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr10: quietly ivreg2  OVSAE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr11: quietly ivreg2  VHAC_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr12: quietly ivreg2  OVPT_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr13: quietly ivreg2  PL5000_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

eststo ivregr14: quietly ivreg2  PO2SM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

esttab ivregr6 ivregr7 ivregr8 ivregr9 ivregr10 ivregr11 ivregr12 ivregr13 ivregr14 using "$output/regress3.tex", drop(*id_estado $control2 _cons) replace 

***************************CONSIGNA 6
global control3  tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med pob1930cabec capestado

eststo ivregr15: quietly ivreg2  IM_2015 i.id_estado $control3 (cartel2010 = Chinesepresence dalemanes),cluster(id_estado) ffirst
esttab ivregr15 using "$output/regress4.tex", drop(*id_estado $control3 _cons) replace se label

est store IV
predict resid, residual

reg resid $control3 Chinesepresence dalemanes
ereturn list
scalar sargan = chi2tail(1,e(N)*e(r2))
display sargan






