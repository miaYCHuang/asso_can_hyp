libname TP  "E:\SAS\term paper";


data TP.opdteall;
set TP.H_nhi_opdte10301_10 TP.H_nhi_opdte10302_10 TP.H_nhi_opdte10303_10 TP.H_nhi_opdte10304_10 TP.H_nhi_opdte10305_10 TP.H_nhi_opdte10306_10 TP.H_nhi_opdte10307_10 TP.H_nhi_opdte10308_10 TP.H_nhi_opdte10309_10 TP.H_nhi_opdte10310_10 TP.H_nhi_opdte10311_10 TP.H_nhi_opdte10312_10;
run;
data TP.enrolall;
set TP.h_nhi_enrol10301 TP.h_nhi_enrol10302 TP.h_nhi_enrol10303 TP.h_nhi_enrol10304 TP.h_nhi_enrol10305 TP.h_nhi_enrol10306 TP.h_nhi_enrol10307 TP.h_nhi_enrol10308 TP.h_nhi_enrol10309 TP.h_nhi_enrol10310 TP.h_nhi_enrol10311 TP.h_nhi_enrol10312;
run;
/*�аO�����g�M�����������H*/
data TP.cancer_hyper;
set TP.opdteall;
cancer_flag=.;
hyper_flag=.;
if substr(CURE_ITEM_NO1,1,2) ='12' or substr(CURE_ITEM_NO2,1,2) ='12' or  substr(CURE_ITEM_NO3,1,2) ='12' or  substr(CURE_ITEM_NO4,1,2) ='12'  then cancer_flag=1;
else cancer_flag=0;
if substr(CURE_ITEM_NO1,1,2) ='02' or substr(CURE_ITEM_NO2,1,2) ='02' or  substr(CURE_ITEM_NO3,1,2) ='02' or  substr(CURE_ITEM_NO4,1,2) ='02'  then hyper_flag=1;
else hyper_flag=0;
run;
proc sort data= TP.cancer_hyper;
by id;
run;
data TP.cancer_hyper;
set  TP.cancer_hyper;
by id;
retain outpt_ca_count 0;
outpt_ca_count = outpt_ca_count+cancer_flag;
if first.id then outpt_ca_count=cancer_flag;

retain outpt_hy_count 0;
outpt_hy_count = outpt_hy_count+hyper_flag;
if first.id then outpt_hy_count=hyper_flag;
run;
data TP.cancer_hyper;
set  TP.cancer_hyper;
by id;
if last.id;
run;
data TP.cancer_hyper;
set TP.cancer_hyper;
if outpt_ca_count>0 then outpt_ca_count=1;
if outpt_hy_count>0 then outpt_hy_count=1;
run;

/*�B�z�~��*/
proc sort data=TP.cancer_hyper;
by id;
run;
proc sort data=TP.enrolall nodupkey;
by id;
run;
data TP.cancer_hyper2;
merge TP.cancer_hyper(in=a)TP.enrolall (in=b);
by id;
if a;
run;
data TP.cancer_hyper2;
set TP.cancer_hyper2;
if outpt_hy_count=. then delete;
if id_s=9 then delete;
age=2014-ID_BIRTH_Y;
run;
/*�~�֤��s*/
data TP.cancer_hyper2;
set TP.cancer_hyper2;
Agegroup=.;
if age=0 then Agegroup=1;
else if age>=1 and age<15 then Agegroup=2;
else if age>=15 and age<25 then Agegroup=3;
else if age>=25 and age<45 then Agegroup=4;
else if age>=45 and age<65then Agegroup=5;
else if age>=65 and age<75 then Agegroup=6;
else if age>=75 and age<85then Agegroup=7;
else if age>=85 and age<94 then Agegroup=8;
else Agegroup=9;
run;
data TP.cancer_hyper2;
set TP.cancer_hyper2;
if outpt_hy_count=1 and outpt_ca_count=1 then ca_hy_flag=1;
else ca_hy_flag=0;
run;

/*�y�z�ʲέp*/
title '�y�z�ʲέpoutpt_ca_count outpt_hy_count ca_hy_flag id_s';
proc freq data=TP.cancer_hyper2;
table outpt_ca_count outpt_hy_count ca_hy_flag id_s Agegroup;
run;


/*���g�P����������*/
title 'cancer hyper chisq';
proc freq data=TP.cancer_hyper2;
table  outpt_ca_count*outpt_hy_count /  chisq;
run;

/*�~�ֻP���g����*/
title 'cancer age ttest';
proc  ttest data=TP.cancer_hyper2;
class outpt_ca_count;
var Agegroup ;
run;
/*�~�ֻP����������*/
title 'hy age ttest';
proc  ttest data=TP.cancer_hyper2;
class outpt_hy_count;
var Agegroup ;
run;
/*�~�ֻP�P�ɦ����������g����*/
title 'cancer&hypertension  age ttest';
proc  ttest data=TP.cancer_hyper2;
class ca_hy_flag;
var Agegroup ;
run;



/*�ʧO�P���g����*/
title 'sex cancer  chisq';
proc freq data=TP.cancer_hyper2;
table  id_s*outpt_ca_count /  chisq;
run;
/*�ʧO�P����������*/
title 'sex hy  chisq';
proc freq data=TP.cancer_hyper2;
table  id_s*outpt_hy_count /  chisq;
run;
/*�ʧO�P�P�ɦ����������g����*/
title 'cancer&hypertension sex  chisq';
proc freq data=TP.cancer_hyper2;
table  id_s*ca_hy_flag /  chisq;
run;




