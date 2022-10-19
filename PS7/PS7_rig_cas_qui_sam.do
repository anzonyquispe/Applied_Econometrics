/*******************************************************************************
                      TP 7: Cluster robust inference

                          Universidad de San Andrés
                              Economía Aplicada
							       2022							           
*******************************************************************************/

* 0) Set up environment
*==============================================================================*
clear all

global main "G:\My Drive\Udesa\aplicada\tp\Replication folder 7\Replication folder"
global output "$main/output"
global input "$main/input"

/* Ref: The Effects of High Stakes High School Achievement Awards:
Evidence from a Randomized Trial (Angrist y Lavy 2009).*/

use "$input/base01.dta"


global X semrel semarab


// Generating groups
gen group = 1
replace group = 2 if pair == 2 | pair == 4
replace group = 3 if pair == 5 | pair == 8
replace group = 4 if pair == 7
replace group = 5 if pair == 9 | pair == 10
replace group = 6 if pair == 11
replace group = 7 if pair == 12 | pair == 13
replace group = 8 if pair == 14 | pair == 15
replace group = 9 if pair == 16 | pair == 17
replace group = 10 if pair == 18 | pair == 20
replace group = 11 if pair == 19


// Using dummies variables
tabulate group, generate(dum_g)

* 1) Robust Standard Errors
*==============================================================================*
eststo reg_re: reg zakaibag treated $X dum_g*, vce( r )

* 2) Cluster Standard Errors
*==============================================================================*
eststo reg_cl: reg zakaibag treated $X dum_g*, cluster( group )


* 3) Bootstrap Cluster Standard Errors
*==============================================================================*
eststo reg_boot: reg zakaibag treated $X dum_g*, cluster( group)
boottest {treated}, boottype(wild) cluster( group ) robust seed(123) nograph
mat p2 = (r(p) )
mat colnames p2= treated
est restore reg_boot
estadd matrix p2


* 3) ARTs
*==============================================================================*
do "$main/programs/art.ado"
art zakaibag treated $X dum_g*, cluster( group) m(regress) report( treated )
scalar p_1 = r(pvalue_joint)
mat p3 = (p_1 )
mat colnames p3 = treated
reg zakaibag treated $X dum_g*, cluster( group )
estadd matrix p3
est store reg_art



#delimit ;

  global note_nv " \item Note: All regressions are clustered at group level. Clustered standard errors in parenthesis, 
  clustered p-value in braces, ART-based p-values in brackets";


  global pre_head_nv "\begin{table}[H]\centering \fontsize{10}{4}\selectfont  
          \begin{threeparttable} \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
           \caption{The Effects of High Stakes High School Achievement 
            Awards: Evidence from a Randomized Trial}" ;


  esttab reg_re reg_cl reg_boot reg_art using "$main/output/table_1.tex" , replace ///
        eqlabels( none )  nostar nobaselevels 
        cells(b(label(coef.) star fmt(%11.4f) ) se( par fmt(%11.4f) ) p2(par({ })) p3(par([ ] )) ) nonote 
        starlevels(\sym{*} 0.10 \sym{**} 0.05 \sym{***} 0.01)
        collabels(none)  
        delim("&")    
        noobs 
        keep( treated ) 
        varlabels( treated "Bagrut" )
        mtitles( "Robust Standard Errors" "Cluster Standard Errors" "Wild Bootstrap" "ARTs" ) 
        prehead( "${pre_head_nv}" "\label{PNDT Mortality Main Rest Female}" 
          "\begin{tabular}{l*{4}c}" \hline \hline ) 
        postfoot(\hline \hline "\multicolumn{5}{l}{\footnotesize Standard errors in parentheses}\\" 
            "\multicolumn{5}{l}{\footnotesize \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)}\\" \end{tabular}  
          \begin{tablenotes} 
          \begin{footnotesize} 
          ${note_nv} 
          \end{footnotesize} 
          "\end{tablenotes} \end{threeparttable} \end{table}") ;


#delimit cr

*==============================================================================*

