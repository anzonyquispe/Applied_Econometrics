/*******************************************************************************
                           Semana 6: Efectos fijos 

                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/

* 0) Set up environment
*==============================================================================*
clear all

// global main "C:\Users\geron\Desktop\Maestria\Economia Aplicada\STATA\Replicacion de Tutoriales\Efectos Fijos\Replication folder"
global main "G:\My Drive\Udesa\aplicada\tp\Replication folder6\Replication folder"
global output "$main/output"
global input "$main/input"

use "$input/microcredit.dta", clear
replace year = 1991 if year==0
replace year = 1998 if year==1
xtset nh year // set panel

* 1) Baseline specification
*==============================================================================*
gen l_exptot = log(exptot)
label var l_exptot "Log Expenditure"
label var dfmfd "Female participation"
reg l_exptot dfmfd
est store reg_1
local fe "No"
estadd local fe `fe'


*==============================================================================*

* 2) Village fixed effects
// ssc install reghdfe

*==============================================================================*
* 1: Household Fixed Effects
xtreg l_exptot dfmfd, fe i(nh)
est store reg_2
local fe "Household"
estadd local fe `fe'

* 2: Year Fixed Effects
xtreg l_exptot dfmfd, fe i(year)
est store reg_3
local fe "Year"
estadd local fe `fe'

* 3: Year Fixed Effects
xtreg l_exptot dfmfd, fe i(village) 
est store reg_4
local fe "Village"
estadd local fe `fe'


reghdfe l_exptot dfmfd, absorb(village nh)
est store reg_5
local fe "Village and Household"
estadd local fe `fe'


reghdfe l_exptot dfmfd, absorb(year nh) 
est store reg_6
local fe "Year and Household"
estadd local fe `fe'


reghdfe l_exptot dfmfd, absorb(village year) 
est store reg_7
local fe "Village and Year"
estadd local fe `fe'


gen village_year = village*year
reghdfe l_exptot dfmfd, absorb(village_year) 
est store reg_8
local fe "Village x Year"
estadd local fe `fe'


gen nh_year = nh*year
// reghdfe l_exptot dfmfd, absorb(nh_year) 
reg l_exptot dfmfd
est store reg_9
local fe "Household x Year"
estadd local fe `fe'


gen village_year2 = village*year
reghdfe l_exptot dfmfd, absorb(village_year2 nh) 
est store reg_10
local fe "Village x Year and Household"
estadd local fe `fe'

*--------------------------------------------------
* 3.4 Tablas
*--------------------------------------------------

esttab reg_1 reg_2 reg_3 reg_4 reg_5 ///
    using "${output}/table_1.tex" , replace ///
    eqlabels( none ) ///
    style(tab) order( ) mlabel(,none) ///
    cells(b(label(coef.) star fmt(%8.3f) ) se(label((z)) par fmt(%6.3f))) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    s( fe N r2 , label( "FE" "N" "R2" ) fmt( 0 0 3 ) ) /// 
    collabels(none) /// No column names within model
    delim("&")  /// Type of column delimiter 
    noobs /// Do not show number of observation used in model
    nomtitle ///
    nonumber ///
    keep( dfmfd ) ///
    width(1.5\hsize) ///
    nogaps /// No gaps between rows
    booktabs /// Style
    nonote /// No notes
    varlabels(dfmfd "Female Participation" ) ///
    mgroups( "\shortstack{(1)\\OLS\\Base\\}" "\shortstack{(2)\\FE\\Household\\}" ///
             "\shortstack{(3)\\FE\\Year\\}" "\shortstack{(4)\\FE\\Village\\}"  ///
             "\shortstack{(5)\\FE\\Village\\Household}" ///
             , pattern( 1 1 1 1 1 ) ) ///
    prehead("\begin{table}[H] \small \centering \protect \captionsetup{justification=centering} \caption{\label{tab:table3} All Regressions }" "\noindent\resizebox{\textwidth}{!}{ \begin{threeparttable}" "\begin{tabular}{l{5cm}c{3.5cm}c{3.5cm}c{3.5cm}c{3.5cm}c{3.5cm}}" \toprule) ///
    posthead(\hline) ///
    postfoot("")


esttab reg_6 reg_7 reg_8 reg_9 reg_10 ///
    using "${output}/table_1.tex" , append ///
    eqlabels( none ) ///
    style(tab) order( ) mlabel(,none) ///
    cells(b(label(coef.) star fmt(%8.3f) ) se(label((z)) par fmt(%6.3f))) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
    s( fe N r2 , label( "FE" "N" "R2" ) fmt( 0 0 3 ) ) /// 
    collabels(none) /// No column names within model
    delim("&")  /// Type of column delimiter 
    noobs /// Do not show number of observation used in model
    nomtitle ///
    keep( dfmfd ) ///
    width(1.5\hsize) ///
    nonumber ///
    nogaps /// No gaps between rows
    booktabs /// Style
    nonote /// No notes
    mgroups( "\shortstack{(6)\\FE\\Year and\\Household}" "\shortstack{(7)\\FE\\Village\\and Year}" ///
             "\shortstack{(8)\\FE\\Village\\x Year}" "\shortstack{(9)\\FE\\Household\\x Year}"  ///
             "\shortstack{(10)\\FE\\Household x Year\\and Household}"  ///
             , pattern( 1 1 1 1 1 ) ) ///
    varlabels(dfmfd "Female Participation" ) ///
    prehead(\hline) ///
    posthead(\hline) ///
    postfoot(\hline \hline \end{tabular} ///
      \begin{tablenotes} ///
      \begin{footnotesize} ///
      \end{footnotesize} ///
      "\end{tablenotes} \end{threeparttable} } \end{table}")


translate "TP6.do" "dofile.pdf", translator(txt2pdf)
