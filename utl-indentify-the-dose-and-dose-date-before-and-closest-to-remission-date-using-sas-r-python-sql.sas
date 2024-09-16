%let pgm=utl-indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql;

Indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql

  SOLUTIONS

      1 sql sas
      2 sql r
      3 sql python
      4 related repos

 github
https://tinyurl.com/mpw8bsx4
https://github.com/rogerjdeangelis/utl-indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql


related problem (maybe this is closser to what the op was asking
https://tinyurl.com/5a8p4bbb
https://stackoverflow.com/questions/78990103/identify-value-in-one-dataset-whose-date-is-closest-to-a-date-in-another-dataset

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/***************************************************************************************************************************/
/*                             |                                           |                                               */
/*        INPUTS               |        PROCESS                            |                      OUTPUTS                  */
/*        =====                |                                           |                                               */
/*                             |                                           |                                               */
/*                             |                                           |                                               */
/* SD1.MASTER total obs=1      | Identify the dose_date                    | WANT total obs=2                              */
/*                             | and dose for each mouse in the master     |                   DOSE_                       */
/* Obs   MOUSE  DOSE_DATE DOSE | table whose master dose_date              | Obs    MOUSE      DATE      REMISSION    DOSE */
/*                             | occurs before and is closest              |                                               */
/*   1     1    20220101   16  | to the mouse disease remission date       |  1       1      20220104     20220105     18  */
/*   2     1    20220102   25  | in the trans table                        |  2       2      20220103     20220104     19  */
/*   3     1    20220103   21  |                                           |                                               */
/*   4     1    20220104   18  | SELF EXPLANATORY                          |                                               */
/*   5     1    20220105   18  | ================                          |                                               */
/*   6     2    20220101   18  |                                           |                                               */
/*   7     2    20220102   22  | create                                    |                                               */
/*   8     2    20220103   19  |    table want as                          |                                               */
/*   9     2    20220104   16  | select                                    |                                               */
/*  10     2    20220105   18  |    l.mouse     as mouse                   |                                               */
/*                             |   ,l.dose_date as dose_date               |                                               */
/* SD1.TRANS total obs=8       |   ,r.remission as remission               |                                               */
/*                             |   ,l.dose                                 |                                               */
/* Obs   MOUSE  REMISSION      | from                                      |                                               */
/*                             |   sd1.master as l left join sd1.trans as r|                                               */
/*  1      1    20220105       | on                                        |                                               */
/*  2      2    20220104       |            l.mouse     = r.mouse          |                                               */
/*  3      3    20220103       |       and  l.dose_date < r.remission      |                                               */
/*  4      4    20220102       | having                                    |                                               */
/*  5      5    20220101       |   (r.remission-l.dose_date)               |                                               */
/*  6      6    20220105       |      = min(r.remission-l.dose_date)       |                                               */
/*  7      7    20220104       |                                           |                                               */
/*  8      8    20220103       |                                           |                                               */
/*                             |                                           |                                               */
/***************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
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

/***************************************************************************************************************************/
/*                                                                                                                         */
/*        INPUTS                                                                                                           */
/*        =====                                                                                                            */
/*                                                                                                                         */
/*                                                                                                                         */
/* SD1.MASTER total obs=1                                                                                                  */
/*                                                                                                                         */
/* Obs   MOUSE  DOSE_DATE DOSE                                                                                             */
/*                                                                                                                         */
/*   1     1    20220101   16                                                                                              */
/*   2     1    20220102   25                                                                                              */
/*   3     1    20220103   21                                                                                              */
/*   4     1    20220104   18                                                                                              */
/*   5     1    20220105   18                                                                                              */
/*   6     2    20220101   18                                                                                              */
/*   7     2    20220102   22                                                                                              */
/*   8     2    20220103   19                                                                                              */
/*   9     2    20220104   16                                                                                              */
/*  10     2    20220105   18                                                                                              */
/*                                                                                                                         */
/* SD1.TRANS total obs=8                                                                                                   */
/*                                                                                                                         */
/* Obs   MOUSE  REMISSION                                                                                                  */
/*                                                                                                                         */
/*  1      1    20220105                                                                                                   */
/*  2      2    20220104                                                                                                   */
/*  3      3    20220103                                                                                                   */
/*  4      4    20220102                                                                                                   */
/*  5      5    20220101                                                                                                   */
/*  6      6    20220105                                                                                                   */
/*  7      7    20220104                                                                                                   */
/*  8      8    20220103                                                                                                   */
/*                                                                                                                         */
/***************************************************************************************************************************/

/*             _
/ |  ___  __ _| |  ___  __ _ ___
| | / __|/ _` | | / __|/ _` / __|
| | \__ \ (_| | | \__ \ (_| \__ \
|_| |___/\__, |_| |___/\__,_|___/
            |_|
*/

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

/*___              _
|___ \   ___  __ _| |  _ __
  __) | / __|/ _` | | | `__|
 / __/  \__ \ (_| | | | |
|_____| |___/\__, |_| |_|
                |_|
*/

proc datasets lib=sd1 nodetails nolist;
 delete rwant;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
master<-read_sas("d:/sd1/master.sas7bdat")
trans<-read_sas("d:/sd1/trans.sas7bdat")
want<-sqldf('
  select
     l.mouse        as mouse
    ,l.dose_date    as dose_date
    ,r.remission    as remission
    ,l.dose
  from
    master as l left join trans as r
  on
             l.mouse     = r.mouse
        and  l.dose_date < r.remission
  group
    by r.mouse
  having
    (r.remission-l.dose_date)
       = min(r.remission-l.dose_date)
  ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

libname sd1 "d:/sd1";
proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/* ==                                                                                                                     */
/*  > want                                                                                                                */
/*    mouse dose_date remission DOSE                                                                                      */
/*  1     1  20220104  20220105   18                                                                                      */
/*  2     2  20220103  20220104   19                                                                                      */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*  ===                                                                                                                   */
/*                         DOSE_                                                                                          */
/*  ROWNAMES    MOUSE      DATE      REMISSION    DOSE                                                                    */
/*                                                                                                                        */
/*      1         1      20220104     20220105     18                                                                     */
/*      2         2      20220103     20220104     19                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/


  %utl_rbeginx;
 parmcards4;
 library(feather)
 data <- read_feather("d:/rds/have.feather")
 data;
 ;;;;
 %utl_rendx;


%utl_pybeginx;
parmcards4;
import pyarrow.feather as feather
import tempfile
import pyperclip
import os
import sys
import subprocess
import time
import pandas as pd
import pyreadstat as ps
import numpy as np
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
exec(open('c:/oto/fn_tosas9x.py').read())
master, meta = ps.read_sas7bdat("d:/sd1/master.sas7bdat")
trans, meta = ps.read_sas7bdat("d:/sd1/trans.sas7bdat")
want=pdsql("""
  select
     l.mouse        as mouse
    ,l.dose_date    as dose_date
    ,r.remission    as remission
    ,l.dose
  from
    master as l left join trans as r
  on
             l.mouse     = r.mouse
        and  l.dose_date < r.remission
  group
    by r.mouse
  having
    (r.remission-l.dose_date)
       = min(r.remission-l.dose_date)
   """)
print(want)
fn_tosas9x(want,outlib="d:/sd1/",outdsn="rwant",timeest=3)
;;;;
%utl_pyendx;

libname sd1 "d:/sd1";
proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* PYTHON                                                                                                                 */
/*                                                                                                                        */
/*    mouse   dose_date   remission  DOSE                                                                                 */
/* 0    1.0  20220104.0  20220105.0  18.0                                                                                 */
/* 1    2.0  20220103.0  20220104.0  19.0                                                                                 */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/*             DOSE_                                                                                                      */
/*  MOUSE      DATE      REMISSION    DOSE                                                                                */
/*                                                                                                                        */
/*    1      20220104     20220105     18                                                                                 */
/*    2      20220103     20220104     19                                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*  _
| || |    _ __ ___ _ __   ___  ___
| || |_  | `__/ _ \ `_ \ / _ \/ __|
|__   _| | | |  __/ |_) | (_) \__ \
   |_|   |_|  \___| .__/ \___/|___/
                  |_|
*/
https://github.com/rogerjdeangelis/utl-add-zero-counts-for-missing-category-combinations-sas-sparse-completetypes-sql-r-python
https://github.com/rogerjdeangelis/utl-analyzing-mean-and-median-by-groups-in-sas-wps-r-python
https://github.com/rogerjdeangelis/utl-bigint-longint-in-sas-r-and-python
https://github.com/rogerjdeangelis/utl-calculate-regression-coeficients-in-base-sas-fcmp-proc-reg-r-and-python
https://github.com/rogerjdeangelis/utl-change-from-baseline-using-sql-in-sas-r-and-python
https://github.com/rogerjdeangelis/utl-chiSquare-anaysis-in-sas-r-python-using-matrix-algebra-procs-and-sql
https://github.com/rogerjdeangelis/utl-classic-transpose-by-index-variableid-and-value-in-sas-r-and-python
https://github.com/rogerjdeangelis/utl-compute-the-mean-by-group-using-sas-wps-python-r-native-code-and-sql
https://github.com/rogerjdeangelis/utl-converting-sas-proc-rank-to-wps-python-r-sql
https://github.com/rogerjdeangelis/utl-converting-sas-proc-sql-code-to-r-and-python
https://github.com/rogerjdeangelis/utl-create-a-simple-n-percent-clinical-table-in-r-sas-wps-python-output-pdf-rtf-xlsx-html-list
https://github.com/rogerjdeangelis/utl-create-tables-from-xml-files-using-sas-wps-r-and-python
https://github.com/rogerjdeangelis/utl-creating-spss-tables-from-a-sas-datasets-using-sas-r-and-python
https://github.com/rogerjdeangelis/utl-determinating-gender-from-firstname-AI-sas-r-and-python
https://github.com/rogerjdeangelis/utl-drop-down-using-dosubl-from-sas-datastep-to-wps-r-perl-powershell-python-msr-vb
https://github.com/rogerjdeangelis/utl-examples-of-drop-downs-from-sas-to-wps-r-microsoftR-python-perl-powershell
https://github.com/rogerjdeangelis/utl-how-to-sum-a-variable-by-group-in-sas-r-and-python-using-sql
https://github.com/rogerjdeangelis/utl-importing-sas-tables-sas7bdats-and-sas7bcats-into-python-and-r-with-associared-format-catalogs
https://github.com/rogerjdeangelis/utl-last-value-carried-backwards-using-mutate-dow-sql-in-wps-sas-r-python
https://github.com/rogerjdeangelis/utl-left-join-two-datasets-to-a-master-dataset-native-and-sql-using-wps-sas-r-and-python
https://github.com/rogerjdeangelis/utl-leveraging-your-knowledge-of-perl-regex-to-sas-wps-r-python-and-perl
https://github.com/rogerjdeangelis/utl-merging-two-tables-without-any-common-column-data-in-r-python-and-sas
https://github.com/rogerjdeangelis/utl-minimmum-code-to-transpose-and-summarize-a-skinny-to-fat-with-sas-wps-r-and-python
https://github.com/rogerjdeangelis/utl-monty-hall-problem-r-sas-python
https://github.com/rogerjdeangelis/utl-mysql-queries-without-sas-using-r-python-and-wps
https://github.com/rogerjdeangelis/utl-native-r-and-r-python-sas-sql-calculate-the-standard-deviation-of-all-columns
https://github.com/rogerjdeangelis/utl-overall-frequency-of-values-over-all-columns-and-rows-simutaneously-sas-r-python
https://github.com/rogerjdeangelis/utl-partial-key-matching-and-luminosity-in-gene-analysis-sas-r-python-postgresql
https://github.com/rogerjdeangelis/utl-partial-sql-join-based-on-a-column-value-in-wps-sas-r-and-python
https://github.com/rogerjdeangelis/utl-passing-r-python-and-sas-macro-vars-to-sqllite-interface-arguments
https://github.com/rogerjdeangelis/utl-pivot-long-transpose-three-arrays-of-size-three-sas-r-python-sql
https://github.com/rogerjdeangelis/utl-python-r-and-sas-sql-solutions-to-add-missing-rows-to-a-data-table
https://github.com/rogerjdeangelis/utl-python-r-import-a-subset-of-SAS-columns-from-sas7bdat-and-v5-export-files
https://github.com/rogerjdeangelis/utl-r-python-sas-sqlite-subtracting-the-means-of-a-specific-column-from-other-columns
https://github.com/rogerjdeangelis/utl-read-print-file-backwards-in-perl-powershell-sas-r-and-python
https://github.com/rogerjdeangelis/utl-sas-fcmp-hash-stored-programs-python-r-functions-to-find-common-words
https://github.com/rogerjdeangelis/utl-sas-proc-transpose-in-sas-r-wps-python-native-and-sql-code
https://github.com/rogerjdeangelis/utl-sas-proc-transpose-wide-to-long-in-sas-wps-r-python-native-and-sql
https://github.com/rogerjdeangelis/utl-transpose-fat-to-skinny-pivot-longer-in-sas-wps-r-pythonv
https://github.com/rogerjdeangelis/utl-update-master-using-transaction-data-using-sql-in-sas-r-and-python
https://github.com/rogerjdeangelis/utl-using-column-position-instead-of-excel-column-names-due-to-misspellings-sas-r-python
https://github.com/rogerjdeangelis/utl-very-simple-sql-join-and-summary-in-python-r-wps-and-sas
https://github.com/rogerjdeangelis/utl-append-rows-and-merge-with-reference-table-in-sql-wps-r-and-python
https://github.com/rogerjdeangelis/utl-calculate-percentage-by-group-in-wps-r-python-excel-sql-no-sql
https://github.com/rogerjdeangelis/utl-calculating-median-values-by-group-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-calculations-involving-a-sql-self-join-in-wps-r-and-python
https://github.com/rogerjdeangelis/utl-cartesian-join-with-condition-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-change-from-baseline-to-week1-to-week8-using-wps-r-python-base-and-sql
https://github.com/rogerjdeangelis/utl-common-products-sold-by-two-stores-split-string-pivot-long-sql-wps-r-and-python
https://github.com/rogerjdeangelis/utl-compute-the-mean-by-group-using-sas-wps-python-r-native-code-and-sql
https://github.com/rogerjdeangelis/utl-converting-multiple-columns-from-numeric-to-character-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-converting-sas-proc-rank-to-wps-python-r-sql
https://github.com/rogerjdeangelis/utl-create-equally-spaced-values-using-partitioning-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-create-new-column-based-on-complex-logic-involving-four-other-columns-in-wps-r-python-sql-nosql
https://github.com/rogerjdeangelis/utl-create-summary-statistics-datasets-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-distance-between-a-point-and-curve-in-sql-and-wps-pythony-r-sympy
https://github.com/rogerjdeangelis/utl-doblebook-hotel-and-same-guest-booked--hotel-same-day-in-different-years-sql-wps-r-py
https://github.com/rogerjdeangelis/utl-efficiently-swap-values-between-related-columns-in-wps-r-python-sql-nosql
https://github.com/rogerjdeangelis/utl-exporting-python-panda-dataframes-to-wps-r-using-a-shared-sqllite-database
https://github.com/rogerjdeangelis/utl-frequency-of-duplicated-digits-in-social-security-numbers-in-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-group-by-id-an-subtract-fist.date-from-last.date-using-wps-r-and-python-native-and-sql
https://github.com/rogerjdeangelis/utl-how-to-compare-one-set-of-columns-with-another-set-of-columns-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-last-value-carried-backwards-using-mutate-dow-sql-in-wps-sas-r-python
https://github.com/rogerjdeangelis/utl-left-join-two-datasets-to-a-master-dataset-native-and-sql-using-wps-sas-r-and-python
https://github.com/rogerjdeangelis/utl-manipulate-excel-directly-using-passthru-microsoft-sql-wps-r-rodbc
https://github.com/rogerjdeangelis/utl-merging-inner-join-dataframes-based-on-single-primary-key-in-wps-r-python-sql-nosql
https://github.com/rogerjdeangelis/utl-mysql-queries-without-sas-using-r-python-and-wps
https://github.com/rogerjdeangelis/utl-nearest-sales-date-on-or-before-a-commercial-date-using-r-roll-join-and-wps-r-and-python-sql
https://github.com/rogerjdeangelis/utl-partial-sql-join-based-on-a-column-value-in-wps-sas-r-and-python
https://github.com/rogerjdeangelis/utl-passing-arguments-to-sqldf-wps-r-sql-functional-sql
https://github.com/rogerjdeangelis/utl-pivot-long-pivot-wide-transpose-partitioning-sql-arrays-wps-r-python
https://github.com/rogerjdeangelis/utl-pivot-transpose-by-id-using-wps-r-python-sql-using-partitioning
https://github.com/rogerjdeangelis/utl-rename-and-cast-char-to-numeric-using-do-over-arrays-in-natve-and-mysql-wps-r-python
https://github.com/rogerjdeangelis/utl-sas-proc-transpose-in-sas-r-wps-python-native-and-sql-code
https://github.com/rogerjdeangelis/utl-sas-proc-transpose-wide-to-long-in-sas-wps-r-python-native-and-sql
https://github.com/rogerjdeangelis/utl-select-all-unique-pairs-of-ingredients-in-salads-r-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-select-groups-of-rows-having-a-compound-condition-and-further-subset-using-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-select-students-that-have-not-transfered-schools-over-the-last-three-years-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-select-the-first-two-observations-from-each-group-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-self-join-get-all-combinations-where-left-col-less-then-right-col-sql-wps-r-and-python
https://github.com/rogerjdeangelis/utl-set-type-for-subject-based-on-baseline-dose-wps-r-python-sql
https://github.com/rogerjdeangelis/utl-simple-classic-transpose-pivot-wider-in-native-and-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-simple-conditional-summarization-in-sql-wps-r-and-python-multi-language
https://github.com/rogerjdeangelis/utl-simple-left-join-in-native-r-and-sql-wps-r-and-python
https://github.com/rogerjdeangelis/utl-top-four-seasonal-precipitation-totals--european-cities-sql-partitions-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transpose-pivot-wide-using-sql-partitioning-in-wps-r-python
https://github.com/rogerjdeangelis/utl-using-sql-in-wps-r-python-select-the-four-youngest-male-and-female-students-partitioning
https://github.com/rogerjdeangelis/utl-very-simple-sql-join-and-summary-in-python-r-wps-and-sas

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

