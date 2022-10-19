/*******************************************************************************
                          Semana 7: Diff-in-Diff

                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/

* 0) Set up environment
*==============================================================================*

global main "/Users/tomaspacheco/Desktop/week7"
global output "$main/output"
global input "$main/input"
cd "$output"

*1)
use "https://github.com/scunning1975/mixtape/raw/master/castle.dta", clear
*set scheme cleanplots
*ssc install bacondecomp

* define global macros
global crime1 jhcitizen_c jhpolice_c murder homicide  robbery assault burglary larceny motor robbery_gun_r 
global demo blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 //demographics
global lintrend trend_1-trend_51 //state linear trend
global region r20001-r20104  //region-quarter fixed effects
global exocrime l_larceny l_motor // exogenous crime rates
global spending l_exp_subsidy l_exp_pubwelfare
global xvar l_police unemployrt poverty l_income l_prisoner l_lagprisoner $demo $spending

label variable post "Year of treatment"
xi: xtreg l_homicide i.year $region $xvar $lintrend post [aweight=popwt], fe vce(cluster sid)


local y_vars l_burglary l_robbery l_assault


foreach y of local y_vars{

  xi: xtreg `y' cdl i.year [aweight=popwt], fe vce(cluster sid)
  est store `y'_1
  estadd local sy = "Yes"



  xi: xtreg `y' cdl i.year $region [aweight=popwt], fe vce(cluster sid)
  est store `y'_2
  estadd local sy = "Yes"
  estadd local ry = "Yes"



  xi: xtreg `y' cdl i.year $region $xvar [aweight=popwt], fe vce(cluster sid)
  est store `y'_3
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"


  xi: xtreg `y' cdl pre2_cdl i.year $region $xvar [aweight=popwt], fe vce(cluster sid)
  est store `y'_4
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"



  xi: xtreg `y' cdl pre2_cdl i.year $region $xvar $exocrime [aweight=popwt], fe vce(cluster sid)
  est store `y'_5
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"
  estadd local ccr = "Yes"


  xi: xtreg `y' cdl i.year $region $xvar $lintrend  [aweight=popwt], fe vce(cluster sid)
  est store `y'_6
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"
  estadd local ssltt = "Yes"



  xi: xtreg `y' cdl i.year , fe vce(cluster sid)
  est store `y'_1_no
  estadd local sy = "Yes"



  xi: xtreg `y' cdl i.year $region , fe vce(cluster sid)
  est store `y'_2_no
  estadd local sy = "Yes"
  estadd local ry = "Yes"



  xi: xtreg `y' cdl i.year $region $xvar , fe vce(cluster sid)
  est store `y'_3_no
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"


  xi: xtreg `y' cdl pre2_cdl i.year $region $xvar , fe vce(cluster sid)
  est store `y'_4_no
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"



  xi: xtreg `y' cdl pre2_cdl i.year $region $xvar $exocrime , fe vce(cluster sid)
  est store `y'_5_no
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"
  estadd local ccr = "Yes"


  xi: xtreg `y' cdl i.year $region $xvar $lintrend  , fe vce(cluster sid)
  est store `y'_6_no
  estadd local sy = "Yes"
  estadd local ry = "Yes"
  estadd local tv = "Yes"
  estadd local ssltt = "Yes"

}


*2)
*ssc install csdid
*ssc install drdid

replace effyear = 0 if effyear == .

csdid l_assault cdl [iw=popwt], ivar(sid) time(year) gvar(effyear) method(reg) notyet

* Pretrends test

estat pretrend // se rechaza

* Average ATT

estat simple // potencial problema de sesgo - no se rechaza la ho.

estat event
csdid_plot














* 3) Goodman-Bacon (2019)
*==============================================================================*

*ssc install bacondecomp

** Bacon Decomposition
xi: xtreg l_burglary cdl post i.year, fe vce(cluster sid)

*Request the detailed decomposition of the DD model.


bacondecomp l_burglary  post , stub(Bacon_) ddetail


drop Bacon_T
drop Bacon_*



































