/* Source: utl-indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql.sas
   The SAS/SQL solution from the repo, extracted to run standalone.
   Only change from the original: the sd1 libname points at WORK instead of the
   author's Windows path "d:/sd1" so the run needs no external directory.
   All DATA steps (inline cards4) and the PROC SQL logic are unchanged. */

%let pgm=utl-indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql;

options validvarname=upcase;
libname sd1 (work);

data sd1.master;
 input mouse dose_date dose ;
cards4;
1 20220101 16
1 20220102 25
1 20220103 21
1 20220104 18
1 20220105 18
2 20220101 18
2 20220102 22
2 20220103 19
2 20220104 16
2 20220105 18
;;;;
run;quit;

data sd1.trans;
 input mouse remission;
cards4;
1 20220105
2 20220104
3 20220103
4 20220102
5 20220101
6 20220105
7 20220104
8 20220103
;;;;
run;quit;

proc sql;
  create
     table want as
  select
     l.mouse   as mouse
    ,l.dose_date    as dose_date
    ,r.remission    as remission
    ,l.dose
  from
    sd1.master as l left join sd1.trans as r
  on
             l.mouse     = r.mouse
        and  l.dose_date < r.remission
  having
    (r.remission-l.dose_date)
       = min(r.remission-l.dose_date)
;quit;

proc print data=want;
run;quit;
