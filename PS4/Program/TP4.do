* 0) Set up environment
*==============================================================================*

global main "C:/Users/geron/Desktop/Maestria/Economia Aplicada/STATA/Replicacion de Tutoriales/IV"
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

estpost summarize $control , listwise
esttab using "$output/tables/Table 2.tex", cells("mean sd min max") 
nomtitle nonumber replace label 

global control2 dalemanes tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med pob1930cabec capestado




drop if estado=="Distrito Federal"

************CONSIGNA 3 COLUMNAS 3 A 6
reg cartel2010 Chinesepresence i.id_estado ,cluster(id_estado)
reg cartel2010 Chinesepresence i.id_estado $control2 ,cluster(id_estado)



reg cartel2005 Chinesepresence i.id_estado ,cluster(id_estado)
reg cartel2005 Chinesepresence i.id_estado $control2 ,cluster(id_estado)


********************************CONSIGNA 4 P1
*1
ivreg2  IM_2015 i.id_estado (cartel2010 = Chinesepresence),cluster(id_estado) ffirst
*2
ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

*3
ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence) if distancia_km<=100,cluster(id_estado) ffirst
*4

ivreg2  IM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence) if id_estado!=25,cluster(id_estado) ffirst

*5

ivreg2  IM_2015 i.id_estado $control2 growthperc (cartel2010 = Chinesepresence),cluster(id_estado) ffirst




global control3  tempopium distancia_km distkmDF mindistcosta POB_TOT_2015 superficie_km TempMed_Anual PrecipAnual_med pob1930cabec capestado



weakivtest
*******************************CONSIGNA 4 P2
ivreg2  ANALF_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  SPRIM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  OVSDE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  OVSEE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  OVSAE_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  VHAC_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  OVPT_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  PL5000_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst

ivreg2  PO2SM_2015 i.id_estado $control2 (cartel2010 = Chinesepresence),cluster(id_estado) ffirst





***************************CONSIGNA 6

ivreg2  IM_2015 i.id_estado $control3 (cartel2010 = Chinesepresence dalemanes),cluster(id_estado) ffirst 
est store IV
predict resid, residual

reg resid $control3 Chinesepresence dalemanes
ereturn list
scalar sargan = chi2tail(1,e(N)*e(r2))
display sargan






