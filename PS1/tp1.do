clear all

global main "C:\Users\Hp Support\Videos\03 - Cursos\06 - Economía Aplicada\03 - Trabajos prácticos\TP1\PS1"
global input "$main/input"
global output "$main/output"

use "$input/data_russia", clear

* Pregunta 1: Utilizando los comandos replace, split, destring y encode, emprolijen la base:


* Convirtiendo las variables en formato string a numérico 

tab econrk
tab powrnk
tab resprk
tab satlif
tab wtchng
tab evalhl
tab operat
tab hattac
tab geo

split hipsiz, parse("") g(hipsiz_n)
drop hipsiz hipsiz_n1 hipsiz_n2
rename hipsiz_n3 hipsiz

split totexpr,  g(totexpr_n)
drop totexpr_n1 totexpr_n2 totexpr
rename totexpr_n3 totexpr


foreach x of varlist econrk powrnk resprk satlif wtchng evalhl operat hattac smokes tincm_r hipsiz totexpr geo{
	replace `x' = "1" if (`x'== "one")
	replace `x' = "2" if (`x'== "two")
	replace `x' = "3" if (`x'== "three")
	replace `x' = "4" if (`x'== "four")
	replace `x' = "5" if (`x'== "five")
	replace `x' = "." if (`x'== ".b" ".c" ".d")
	replace `x' = "." if (`x'== ",")
	replace `x' = "1" if (`x'=="Smokes")
}


ds, has(type string)
foreach var in `r(varlist)' {
    destring `var', ignore("X") gen(`var'_n)
}

drop satecc highsc belief monage cmedin hprblm hosl3m alclmo waistc hhpres work0 work1 work2 ortho marsta1 marsta2 marsta3 marsta4 econrk powrnk resprk satlif wtchng evalhl operat hattac smokes geo // eliminamos las variables que ya fueron convertidas a formato numérico


label define sex_n 0 "male"
label define obese_n 0 "This person is not obese" 1 "This person is obese"
foreach var of varlist sex obese {
encode `var', generate (`var'_n)
}  

replace obese_n=. if obese_n==2  // se reemplaza ya que al utilizar encode, STATA le asigna un número a los valores perdidos lo que imposibilitaria contarlos más adelante. 

drop sex obese

destring tincm_r hipsiz totexpr, replace dpcomma 


*Ejercicio 2: 

// ssc install mdesc // instalamos 
mdesc // Chequeamos para todas las variables 

* Ejercicio 3: 


ds, has(type numeric)
foreach var in `r(varlist)' {
	summ `var' if `var'<0
} // observamos variables numéricas con valores negativos. 


ds, has(type numeric)
foreach var in `r(varlist)' {
	replace `var'=. if(`var'<0)
} // reemplazamos 


* Ejercicio 4: 

order id site sex_n
gsort -totexpr

* Ejercicio 5: 

foreach var of varlist sex_n monage_n satlif_n waistc_n hipsiz totexpr {
	summarize `var'
}

label variable sex_n "Sexo"
label variable monage_n "Edad en meses"
label variable satlif_n "Satisfacción con la vida"
label variable waistc_n "Circunferencia de la cintura"
label variable hipsiz "Circunferencia de la cadera"
label variable totexpr "Gasto real"

// exportando a word
estpost summarize sex_n monage_n satlif_n waistc_n hipsiz totexpr, listwise
esttab using "$output/Table 1.rtf", cells("mean sd min max") 
collabels("Mean" "SD" "Min" "Max") nomtitle nonumber replace label 

* Ejercicio 6: 

hist hipsiz, kdensity by(sex_n)
ttest hipsiz, by(sex_n)

* Ejercicio 7: 

reg satlif_n sex_n  monage_n height tincm_r


