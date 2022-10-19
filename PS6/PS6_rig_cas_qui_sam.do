/*******************************************************************************
                          Diff-in-Diff

                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/



*******************************************************************************/


* 0) Set up environment
*==============================================================================*

global main "G:\My Drive\Udesa\aplicada\tp\week7"
global output "$main/output"
global input "$main/input"
cd "$output"


* 1) DiD
*==============================================================================*

*use http://pped.org/bacon_example.dta, clear
use "$input/castle", clear


// set scheme cleanplots
* ssc install bacondecomp

* define global macros
global crime1 jhcitizen_c jhpolice_c murder homicide  robbery assault burglary larceny motor robbery_gun_r 
global demo blackm_15_24 whitem_15_24 blackm_25_44 whitem_25_44 //demographics
global lintrend trend_1-trend_51 //state linear trend
global region r20001-r20104  //region-quarter fixed effects
global exocrime l_larceny l_motor // exogenous crime rates
global spending l_exp_subsidy l_exp_pubwelfare
global xvar l_police unemployrt poverty l_income l_prisoner l_lagprisoner $demo $spending


label variable post "Year of treatment"




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



  xi: xtreg `y' cdl i.year $region $xvar $exocrime [aweight=popwt], fe vce(cluster sid)
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



  xi: xtreg `y' cdl i.year $region $xvar $exocrime [aweight=popwt], fe vce(cluster sid)
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



#delimit ;

  global note_nv " \item Note: Each column in each panel represents a 
          separate regression. The unit of observation is state-year. 
          Robust standard errors are clustered at the state level. Time-varying controls include
          policing and incarceration rates, welfare and public assistance spending, 
          median income, poverty rate, unemployment rate, and demographics. 
          Contemporaneous crime rates include larceny and
          motor vehicle theft rates.";


  global pre_head_nv "\begin{sidewaystable}[htbp]\centering \fontsize{10}{4}\selectfont  
          \begin{threeparttable} \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
           \caption{The Deterrence Effects of Castle Doctrine Laws: 
            Burglary, Robbery, and Aggravated Assault}" ;


  esttab l_burglary_1 l_burglary_2 l_burglary_3 l_burglary_4 l_burglary_5 l_burglary_6
        l_burglary_1_no l_burglary_2_no l_burglary_3_no l_burglary_4_no l_burglary_5_no 
        l_burglary_6_no using "table_4.tex" , replace ///
        eqlabels( none )  nostar nobaselevels 
        cells(b(label(coef.) star fmt(%11.4f) ) se( par fmt(%11.4f) ) ) nonote 
        starlevels(\sym{*} 0.10 \sym{**} 0.05 \sym{***} 0.01)
        collabels(none)  
        delim("&")    
        noobs 
        keep( cdl pre2_cdl ) 
        nomtitles
        varlabels( cdl "Castle Doctrine Law"  pre2_cdl "0 to 2 years before adoption of castle doctrine law}" )
        mgroups( "OLS—Weighted by State Population" "OLS—Unweighted"
            , pattern( 1 0 0 0 0 0 1 0 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})  ) 
        refcat( cdl "\Gape[0.25cm][0.25cm]{ 
                  \underline{ Panel A.\textbf{ 
                  \textit{ Burglary } } } }" 
                  , nolabel)
        prehead( "${pre_head_nv}" "\label{PNDT Mortality Main Rest Female}" 
          "\begin{tabular}{p{5cm}p{1cm}p{1cm}p{1cm}p{1.2cm}p{1cm}p{1cm}p{1cm}p{1cm}p{1cm}p{1.2cm}p{1cm}p{1cm}}" \hline \hline ) 
        posthead(\hline) 
        postfoot( "" ) ;


  esttab l_robbery_1 l_robbery_2 l_robbery_3 l_robbery_4 l_robbery_5 l_robbery_6
        l_robbery_1_no l_robbery_2_no l_robbery_3_no l_robbery_4_no l_robbery_5_no 
        l_robbery_6_no using "table_4.tex" , append ///
        eqlabels( none )  nostar nobaselevels 
        cells(b(label(coef.) star fmt(%11.4f) ) se( par fmt(%11.4f) ) ) nonote 
        starlevels(\sym{*} 0.10 \sym{**} 0.05 \sym{***} 0.01)
        collabels(none)  
        delim("&")    
        noobs 
        nonumbers
        nomtitles
        keep( cdl pre2_cdl ) 
        varlabels( cdl "Castle Doctrine Law"  pre2_cdl "0 to 2 years before adoption of castle doctrine law}" )
        refcat( cdl "\Gape[0.25cm][0.25cm]{ 
                  \underline{ Panel B.\textbf{ 
                  \textit{ Robbery } } } }" 
                  , nolabel)
        prehead( \hline ) 
        posthead( "" ) 
        postfoot( "" ) ;


  esttab l_assault_1 l_assault_2 l_assault_3 l_assault_4 l_assault_5 l_assault_6
        l_assault_1_no l_assault_2_no l_assault_3_no l_assault_4_no l_assault_5_no 
        l_assault_6_no using "table_4.tex" , append 
        eqlabels( none )  nostar nobaselevels 
        cells(b(label(coef.) star fmt(%11.4f) ) se( par fmt(%11.4f) ) ) nonote 
        starlevels(\sym{*} 0.10 \sym{**} 0.05 \sym{***} 0.01) 
        stats( N sy ry tv ccr ssltt, 
        label( "Observations" "State and Year Fixed Effects" "Region-by-Year Fixed Effects" 
                "Time-Varying Controls" "Contemporaneous Crime Rates}" "State-Specific Linear Time Trends}" ) 
        fmt( 0 ) ) 
        collabels(none)
        delim("&")    
        noobs 
        nonumbers
        nomtitles
        keep( cdl pre2_cdl ) 
        varlabels( cdl "Castle Doctrine Law"  pre2_cdl "0 to 2 years before adoption of castle doctrine law}" )
        refcat( cdl " \Gape[0.25cm][0.25cm]{ \underline{ Panel C.\textbf{ 
                  \textit{ Aggravated }} \textbf{ 
                  \textit{ Assault }} }} " 
                  , nolabel)
        prehead( "" )
        postfoot(\hline \hline "\multicolumn{13}{l}{\footnotesize Standard errors in parentheses}\\" 
            "\multicolumn{13}{l}{\footnotesize \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}\\" \end{tabular}  
          \begin{tablenotes} 
          \begin{footnotesize} 
          ${note_nv} 
          \end{footnotesize} 
          "\end{tablenotes} \end{threeparttable} \end{sidewaystable}") ;


#delimit cr






*2)
// ssc install csdid
// ssc install drdid

replace effyear = 0 if effyear == .

csdid l_assault ${xvar} [iw=popwt], ivar(sid) time(year) gvar(effyear) method(reg) notyet
estat simple

* Pretrends test

estat pretrend // se rechaza

* Average ATT

estat simple                              // potencial problema de sesgo - no se rechaza la ho.
esttab r(table, transpose)

estat event
csdid_plot


csdid l_assault cdl [iw=popwt], ivar(sid) time(year) gvar(effyear) method(reg) notyet
csdid_plot, group(2005) name(m1,replace) title("Group 2005")
csdid_plot, group(2006) name(m2,replace) title("Group 2006")
csdid_plot, group(2007) name(m3,replace) title("Group 2007")
csdid_plot, group(2008) name(m4,replace) title("Group 2008")
graph combine m1 m2 m3 m4, xcommon scale(0.8)



* 3) Goodman-Bacon (2019)
*==============================================================================*

ssc install bacondecomp

** Bacon Decomposition
xi: xtreg l_burglary cdl post i.year, fe vce(cluster sid)

*Request the detailed decomposition of the DD model.


bacondecomp l_burglary  post , stub(Bacon_) ddetail


translate "G:\My Drive\Udesa\aplicada\tp\week7\programs\week7 - Copy.do" "C:\Users\Anzony\Documents\GitHub\Applied_Econometrics\PS6/tp6_do.pdf", translator(txt2pdf)





