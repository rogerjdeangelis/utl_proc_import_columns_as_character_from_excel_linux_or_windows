Proc Import Columns as Character from Excel Linux SAS and Windows workstation

WPS/PROC R or IML/R  (works in any unix or windows)

see
https://goo.gl/NXv8wU
https://stackoverflow.com/questions/47836256/proc-import-as-character-from-excel-linux-sas

INPUT (import column A as character)
====================================

   d:/xls/messy.xlsx

      +----------+
      |    A     |
      +----------+
      |          |
    1 |   VAR2   |
      +----------+
    2 |   1111111|  NUMERIC  note the right justification
      +----------+
    3 |   2222222|
      +----------+
    4 |   3333333|
      +----------+
    5 |   4444444|
      +----------+
    6 |Multipl   |  TEXT  note the left justification
      +----------+
    7 |   5555555|
      +----------+
    8 |H6666-0   |  TEXT  note the left justification
      -----------+

PROCESS
=======


  WPS/Proc R  (working code)

      want <- readWorksheet(wb, sheet = "messy", colTypes=c("character"));

 *                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|
;

You need to copy this to an excel sheet

d:/xls/messy.xlsx

Var2
1111111
2222222
3333333
4444444
Multipl
5555555
H6666-0

You can use this code to show that var2 has mixed type

proc sql dquote=ansi;
   connect to excel (Path="d:\xls\messy.xlsx");
     select * from connection to Excel
         (
          Select
               count(*) + sum(isnumeric(var2)) as var2_character
              ,-1*sum(isnumeric(var2)) as var2_numeric
          from
               [messy$]
         );
     disconnect from Excel;
quit;

Column two has 2 character values and 5 numeric values

   var2_
  character  var2_numeric
 ------------------------
          2             5

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
library(XLConnect);
wb <- loadWorkbook("d:/xls/messy.xlsx");
want <- readWorksheet(wb, sheet = "messy", colTypes=c("character"));
want;
endsubmit;
import r=have  data=wrk.have;
run;quit;
');

proc print data=have;
run;quit;


