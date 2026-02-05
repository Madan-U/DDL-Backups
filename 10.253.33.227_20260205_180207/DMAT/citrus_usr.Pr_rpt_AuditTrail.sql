-- Object: PROCEDURE citrus_usr.Pr_rpt_AuditTrail
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--Pr_rpt_AuditTrail 3,'Mar  19 2009', 'Mar  19 2010','',''
--Pr_rpt_AuditTrail_vishal 3,'jan  5 2008', 'nov 10 2008'
--SELECT * FROM ACCP_HST WHERE ACCP_ACCPM_PROP_CD LIKE '%BILL_%'
--SELECT * FROM ACCOUNT_PROPERTIES WHERE ACCP_CLISBA_ID = 101 AND ACCP_ACCPM_PROP_CD LIKE '%BILL_%'
--
CREATE proc [citrus_usr].[Pr_rpt_AuditTrail]
@pa_excsm_id int,
@pa_from_dt datetime,
@pa_to_dt datetime,
@pa_fromaccid varchar(16),
@pa_toaccid varchar(16)
as
begin

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @@l_dpm_id int

select @@l_dpm_id= dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind =1            

IF @pa_fromaccid = ''                      
 BEGIN                      
  SET @pa_fromaccid = '0'                      
  SET @pa_toaccid = '99999999999999999'                      
 END                      
 IF @pa_toaccid = ''                      
 BEGIN                  
   SET @pa_toaccid = @pa_fromaccid                      
 END   

create table #Climdates (cl_code bigint,lst_dt datetime)
create table #dpamdates (cl_code bigint,dpam_code bigint,lst_dt datetime)
create table #hldrdates (hldr_code bigint,lst_dt datetime)
create table #bankdates (bank_code bigint,lst_dt datetime)
create table #Clientpropdates (cl_code bigint,prop_desc varchar(20),lst_dt datetime)
create table #Accountpropdates (dpam_code bigint,prop_desc varchar(20),lst_dt datetime)

CREATE TABLE #TMPDATAACCTPROP(cl_code bigint,dpam_code bigint,Prop_desc varchar(100),Prop_value varchar(150),lst_upd_by varchar(30),lst_dt datetime,O_Prop_value varchar(150))
CREATE TABLE #TMPDATACLIENTPROP(cl_code bigint,dpam_code bigint,Prop_desc varchar(100),Prop_value varchar(150),lst_upd_by varchar(30),lst_dt datetime,O_Prop_value varchar(150))


CREATE TABLE #TMPDATA
(T_CLIM_CRN_NO BIGINT
,CLIM_NAME1 VARCHAR(100)
,CLIM_NAME2 VARCHAR(100),CLIM_NAME3 VARCHAR(100),CLIM_SHORT_NAME VARCHAR(50),CLIM_GENDER VARCHAR(2),CLIM_DOB DATETIME,T_CLIM_LST_UPD_DT DATETIME,CLIM_LST_UPD_BY VARCHAR(30),
T_DPAM_ID BIGINT,DPAM_ACCT_NO VARCHAR(20),DPAM_SBA_NAME VARCHAR(200),DPAM_SBA_NO VARCHAR(20),ENTTM_DESC VARCHAR(200),CLICM_DESC VARCHAR(200),subcm_desc VARCHAR(200),STAM_DESC VARCHAR(50),DPAM_LST_UPD_BY VARCHAR(30),T_DPAM_LST_UPD_DT DATETIME,
DPHD_FH_FTHNAME VARCHAR(100),DPHD_SH_FNAME VARCHAR(100),DPHD_SH_MNAME VARCHAR(100),DPHD_SH_LNAME VARCHAR(100),DPHD_SH_FTHNAME VARCHAR(100),DPHD_SH_DOB DATETIME,DPHD_SH_PAN_NO VARCHAR(50),DPHD_SH_GENDER VARCHAR(2),DPHD_TH_FNAME VARCHAR(100),DPHD_TH_MNAME VARCHAR(100),DPHD_TH_LNAME VARCHAR(100),DPHD_TH_FTHNAME VARCHAR(100),DPHD_TH_DOB DATETIME,DPHD_TH_PAN_NO VARCHAR(50),DPHD_TH_GENDER VARCHAR(2),DPHD_NOM_FNAME VARCHAR(100),DPHD_NOM_MNAME VARCHAR(100),DPHD_NOM_LNAME VARCHAR(100),DPHD_NOM_FTHNAME VARCHAR(100),DPHD_NOM_DOB DATETIME,DPHD_NOM_PAN_NO VARCHAR(50),DPHD_NOM_GENDER VARCHAR(1),DPHD_GAU_FNAME VARCHAR(100),DPHD_GAU_MNAME VARCHAR(100),DPHD_GAU_LNAME VARCHAR(100),DPHD_GAU_FTHNAME VARCHAR(100),DPHD_GAU_DOB DATETIME,DPHD_GAU_PAN_NO VARCHAR(50),DPHD_GAU_GENDER VARCHAR(2),DPHD_LST_UPD_BY VARCHAR(30),T_DPHD_LST_UPD_DT DATETIME,
dphd_nomgau_fname VARCHAR(100),dphd_nomgau_mname VARCHAR(100),dphd_nomgau_lname VARCHAR(100),dphd_nomgau_fthname VARCHAR(100),dphd_nomgau_dob DATETIME,dphd_nomgau_pan_no VARCHAR(50),dphd_nomgau_gender VARCHAR(2),NOM_NRN_NO VARCHAR(20),
BANM_NAME VARCHAR(200),BANM_BRANCH VARCHAR(200),BANM_MICR VARCHAR(20),CLIBA_AC_NO VARCHAR(20),CLIBA_AC_TYPE VARCHAR(20),CLIBA_AC_NAME VARCHAR(200),CLIBA_LST_UPD_BY VARCHAR(30),T_CLIBA_LST_UPD_DT DATETIME,

O_CLIM_NAME1 VARCHAR(100),O_CLIM_NAME2 VARCHAR(100),O_CLIM_NAME3 VARCHAR(100),O_CLIM_SHORT_NAME VARCHAR(50),O_CLIM_GENDER VARCHAR(2),O_CLIM_DOB DATETIME,
O_DPAM_ACCT_NO VARCHAR(20),O_DPAM_SBA_NAME VARCHAR(200),O_DPAM_SBA_NO VARCHAR(20),O_ENTTM_DESC VARCHAR(200),O_CLICM_DESC VARCHAR(200),O_subcm_desc VARCHAR(200),O_STAM_DESC VARCHAR(50),
O_DPHD_FH_FTHNAME VARCHAR(100),O_DPHD_SH_FNAME VARCHAR(100),O_DPHD_SH_MNAME VARCHAR(100),O_DPHD_SH_LNAME VARCHAR(100),O_DPHD_SH_FTHNAME VARCHAR(100),O_DPHD_SH_DOB DATETIME,O_DPHD_SH_PAN_NO VARCHAR(50),O_DPHD_SH_GENDER VARCHAR(2),O_DPHD_TH_FNAME VARCHAR(100),O_DPHD_TH_MNAME VARCHAR(100),O_DPHD_TH_LNAME VARCHAR(100),O_DPHD_TH_FTHNAME VARCHAR(100),O_DPHD_TH_DOB DATETIME,O_DPHD_TH_PAN_NO VARCHAR(50),O_DPHD_TH_GENDER VARCHAR(2),O_DPHD_NOM_FNAME VARCHAR(100),O_DPHD_NOM_MNAME VARCHAR(100),O_DPHD_NOM_LNAME VARCHAR(100),O_DPHD_NOM_FTHNAME VARCHAR(100),O_DPHD_NOM_DOB DATETIME,O_DPHD_NOM_PAN_NO VARCHAR(50),O_DPHD_NOM_GENDER VARCHAR(1),O_DPHD_GAU_FNAME VARCHAR(100),O_DPHD_GAU_MNAME VARCHAR(100),O_DPHD_GAU_LNAME VARCHAR(100),O_DPHD_GAU_FTHNAME VARCHAR(100),O_DPHD_GAU_DOB DATETIME,O_DPHD_GAU_PAN_NO VARCHAR(50),O_DPHD_GAU_GENDER VARCHAR(2),
O_dphd_nomgau_fname VARCHAR(100),O_dphd_nomgau_mname VARCHAR(100),O_dphd_nomgau_lname VARCHAR(100),O_dphd_nomgau_fthname VARCHAR(100),O_dphd_nomgau_dob DATETIME,O_dphd_nomgau_pan_no VARCHAR(50),O_dphd_nomgau_gender VARCHAR(2),O_NOM_NRN_NO VARCHAR(20),
O_BANM_NAME VARCHAR(200),O_BANM_BRANCH VARCHAR(200),O_BANM_MICR VARCHAR(20),O_CLIBA_AC_NO VARCHAR(20),O_CLIBA_AC_TYPE VARCHAR(20),O_CLIBA_AC_NAME VARCHAR(200),
Record_type char(1),
Prop_DESC varchar(200),Prop_value varchar(200), O_Prop_value varchar(200),Prop_lst_upd_by varchar(30),Prop_lst_dt datetime 

)                    
--
INSERT INTO #TMPDATA(T_CLIM_CRN_NO,CLIM_NAME1,CLIM_NAME2,CLIM_NAME3,CLIM_SHORT_NAME,CLIM_GENDER,CLIM_DOB,T_CLIM_LST_UPD_DT,CLIM_LST_UPD_BY,
T_DPAM_ID,DPAM_ACCT_NO,DPAM_SBA_NAME,DPAM_SBA_NO,ENTTM_DESC,CLICM_DESC,subcm_desc,STAM_DESC,DPAM_LST_UPD_BY,T_DPAM_LST_UPD_DT,
DPHD_FH_FTHNAME,DPHD_SH_FNAME,DPHD_SH_MNAME,DPHD_SH_LNAME,DPHD_SH_FTHNAME,DPHD_SH_DOB,DPHD_SH_PAN_NO,DPHD_SH_GENDER,DPHD_TH_FNAME,DPHD_TH_MNAME,DPHD_TH_LNAME,DPHD_TH_FTHNAME,DPHD_TH_DOB,DPHD_TH_PAN_NO,DPHD_TH_GENDER,DPHD_NOM_FNAME,DPHD_NOM_MNAME,DPHD_NOM_LNAME,DPHD_NOM_FTHNAME,DPHD_NOM_DOB,DPHD_NOM_PAN_NO,DPHD_NOM_GENDER,DPHD_GAU_FNAME,DPHD_GAU_MNAME,DPHD_GAU_LNAME,DPHD_GAU_FTHNAME,DPHD_GAU_DOB,DPHD_GAU_PAN_NO,DPHD_GAU_GENDER,DPHD_LST_UPD_BY,T_DPHD_LST_UPD_DT,
dphd_nomgau_fname,dphd_nomgau_mname,dphd_nomgau_lname,dphd_nomgau_fthname,dphd_nomgau_dob,dphd_nomgau_pan_no,dphd_nomgau_gender,NOM_NRN_NO,
BANM_NAME,BANM_BRANCH,BANM_MICR,CLIBA_AC_NO,CLIBA_AC_TYPE,CLIBA_AC_NAME,CLIBA_LST_UPD_BY,T_CLIBA_LST_UPD_DT,Record_type)
SELECT CLIM_CRN_NO,CLIM_NAME1,CLIM_NAME2,CLIM_NAME3,CLIM_SHORT_NAME,CLIM_GENDER,CLIM_DOB,CLIM_LST_UPD_DT,CLIM_LST_UPD_BY,
DPAM_ID,DPAM_ACCT_NO,DPAM_SBA_NAME,DPAM_SBA_NO,ENTTM_DESC,CLICM_DESC,subcm_desc,STAM_DESC,DPAM_LST_UPD_BY,DPAM_LST_UPD_DT,
DPHD_FH_FTHNAME,DPHD_SH_FNAME,DPHD_SH_MNAME,DPHD_SH_LNAME,DPHD_SH_FTHNAME,DPHD_SH_DOB,DPHD_SH_PAN_NO,DPHD_SH_GENDER,DPHD_TH_FNAME,DPHD_TH_MNAME,DPHD_TH_LNAME,DPHD_TH_FTHNAME,DPHD_TH_DOB,DPHD_TH_PAN_NO,DPHD_TH_GENDER,DPHD_NOM_FNAME,DPHD_NOM_MNAME,DPHD_NOM_LNAME,DPHD_NOM_FTHNAME,DPHD_NOM_DOB,DPHD_NOM_PAN_NO,DPHD_NOM_GENDER,DPHD_GAU_FNAME,DPHD_GAU_MNAME,DPHD_GAU_LNAME,DPHD_GAU_FTHNAME,DPHD_GAU_DOB,DPHD_GAU_PAN_NO,DPHD_GAU_GENDER,DPHD_LST_UPD_BY,DPHD_LST_UPD_DT,
dphd_nomgau_fname,dphd_nomgau_mname,dphd_nomgau_lname,dphd_nomgau_fthname,dphd_nomgau_dob,dphd_nomgau_pan_no,dphd_nomgau_gender,NOM_NRN_NO,
BANM_NAME,BANM_BRANCH,BANM_MICR,CLIBA_AC_NO,CLIBA_AC_TYPE,CLIBA_AC_NAME,CLIBA_LST_UPD_BY,CLIBA_LST_UPD_DT,
Record_type = 'M'
FROM client_mstr,dp_acct_mstr 
left outer join dp_holder_dtls on dphd_dpam_id =dpam_id and dphd_deleted_ind = 1
left outer join client_bank_accts on dpam_id = cliba_clisba_id  and CLIBA_FLG in (1,3) and cliba_deleted_ind = 1 
LEFT OUTER JOIN bank_mstr on cliba_banm_id = banm_id and banm_deleted_ind = 1
,entity_type_mstr 
,client_ctgry_mstr 
,SUB_CTGRY_MSTR
,STATUS_MSTR
WHERE clim_crn_no = dpam_crn_no
AND dpam_enttm_cd = enttm_cd                  
AND dpam_clicm_cd = clicm_cd 
and dpam_subcm_cd = subcm_cd
and dpam_stam_cd  = stam_cd
and clim_lst_upd_dt between @pa_from_dt and @pa_to_dt
--and clim_lst_upd_dt between 'jan  1 2008' and 'dec  1 2008'
--and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid) 
and DPAM_SBA_NO between convert(varchar,@pa_fromaccid) and convert(varchar,@pa_toaccid) 
and dpam_dpm_id = @@l_dpm_id --2 
and clim_deleted_ind = 1
and dpam_deleted_ind = 1
and enttm_deleted_ind =1
and clicm_deleted_ind = 1
and subcm_deleted_ind = 1
AND stam_deleted_ind = 1
--AND CLIM_SHORT_NAME = 'SITA THIRUGNANA SAMBANDAM TEST AUDIT'



INSERT INTO #Climdates
select CLIM_CRN_NO,MAX(CLIM_LST_UPD_DT)
FROM CLIM_HST,#TMPDATA
WHERE CLIM_CRN_NO = T_CLIM_CRN_NO AND CLIM_LST_UPD_DT < T_CLIM_LST_UPD_DT 
AND   Clim_action IN ('I','E')
GROUP BY CLIM_CRN_NO

INSERT INTO #dpamdates
SELECT DPAM_CRN_NO,DPAM_ID,MAX(DPAM_LST_UPD_DT)
FROM DP_ACCT_MSTR_HST,#TMPDATA
WHERE DPAM_CRN_NO = T_CLIM_CRN_NO AND DPAM_ID = T_DPAM_ID AND DPAM_LST_UPD_DT < T_DPAM_LST_UPD_DT
AND   DPAM_ACTION  IN ('I','E')
GROUP BY DPAM_CRN_NO,DPAM_ID

INSERT INTO #hldrdates
SELECT DPHD_DPAM_ID,MAX(DPHD_LST_UPD_DT)
FROM dp_holder_dtls_hst,#TMPDATA
WHERE DPHD_DPAM_ID = T_DPAM_ID AND DPHD_LST_UPD_DT < T_DPHD_LST_UPD_DT
AND   DPHD_ACTION IN ('I','E')
GROUP BY DPHD_DPAM_ID

INSERT INTO #bankdates
SELECT cliba_clisba_id,MAX(CLIBA_LST_UPD_DT)
FROM CLIBA_HST,#TMPDATA
WHERE cliba_clisba_id = T_DPAM_ID AND CLIBA_LST_UPD_DT < T_DPHD_LST_UPD_DT
AND    CLIBA_ACTION IN ('I','E')
GROUP BY cliba_clisba_id 

INSERT INTO #Clientpropdates
SELECT ENTP_ENT_ID,ENTP_ENTPM_CD,MAX(ENTP_LST_UPD_DT)
FROM ENTP_HST,#TMPDATA
WHERE ENTP_ENT_ID = T_CLIM_CRN_NO AND ENTP_LST_UPD_DT < T_CLIM_LST_UPD_DT
AND   ENTP_ACTION IN ('I','E')
GROUP BY ENTP_ENT_ID,ENTP_ENTPM_CD 

INSERT INTO #Accountpropdates
SELECT ACCP_CLISBA_ID,ACCP_ACCPM_PROP_CD,MAX(ACCP_LST_UPD_DT)
FROM ACCP_HST,DP_ACCT_MSTR,#TMPDATA
WHERE T_CLIM_CRN_NO = DPAM_CRN_NO
AND DPAM_ID = ACCP_CLISBA_ID
AND ACCP_LST_UPD_DT < T_CLIM_LST_UPD_DT
AND ACCP_ACTION IN ('I','E')
GROUP BY ACCP_CLISBA_ID,ACCP_ACCPM_PROP_CD




INSERT INTO #TMPDATACLIENTPROP(cl_code,dpam_code,Prop_desc,Prop_value,lst_upd_by,lst_dt)
SELECT ENTP_ENT_ID,DPAM_ID,ENTP_ENTPM_CD,ENTP_VALUE,ENTP_LST_UPD_BY,ENTP_LST_UPD_DT
FROM ENTITY_PROPERTIES,#Climdates,dp_acct_mstr 
WHERE ENTP_ENT_ID = DPAM_CRN_NO 
AND ENTP_LST_UPD_DT BETWEEN  @pa_from_dt and @pa_to_dt
AND ENTP_ENT_ID = cl_code 
AND ENTP_DELETED_IND = 1
AND DPAM_DELETED_IND = 1

UPDATE #TMPDATACLIENTPROP 
SET O_Prop_value = ENTP_VALUE
FROM #TMPDATACLIENTPROP T,ENTP_HST,#Clientpropdates p
WHERE T.CL_CODE = ENTP_ENT_ID
AND T.Prop_desc = ENTP_ENTPM_CD 
and P.CL_CODE = T.CL_CODE
AND P.PROP_DESC = T.PROP_DESC
AND ENTP_LST_UPD_DT = p.LST_DT


INSERT INTO #TMPDATAACCTPROP(cl_code,dpam_code,Prop_desc,Prop_value,lst_upd_by,lst_dt)
SELECT DPAM_CRN_NO,ACCP_CLISBA_ID,ACCP_ACCPM_PROP_CD,ACCP_VALUE,ACCP_LST_UPD_BY,ACCP_LST_UPD_DT 
FROM ACCOUNT_PROPERTIES,DP_ACCT_MSTR,#Climdates
WHERE ACCP_CLISBA_ID = DPAM_ID AND DPAM_CRN_NO = CL_CODE
AND ACCP_LST_UPD_DT BETWEEN  @pa_from_dt and @pa_to_dt
AND ACCP_ACCT_TYPE = 'D'
AND DPAM_DELETED_IND = 1 AND ACCP_DELETED_IND = 1


UPDATE #TMPDATAACCTPROP 
SET O_Prop_value = ACCP_VALUE
FROM #TMPDATAACCTPROP T,ACCP_HST,#Accountpropdates p
WHERE T.DPAM_CODE = ACCP_CLISBA_ID
AND T.Prop_desc = ACCP_ACCPM_PROP_CD 
AND P.PROP_DESC = T.PROP_DESC
AND ACCP_LST_UPD_DT = p.LST_DT
AND ACCP_ACCT_TYPE = 'D'


update #TMPDATA
set O_CLIM_NAME1= H.CLIM_NAME1,O_CLIM_NAME2= H.CLIM_NAME2,O_CLIM_NAME3 = H.CLIM_NAME3,O_CLIM_SHORT_NAME = H.CLIM_SHORT_NAME,O_CLIM_GENDER =H.CLIM_GENDER,O_CLIM_DOB = H.CLIM_DOB
FROM #Climdates,#TMPDATA,clim_hst H
WHERE CL_CODE = T_CLIM_CRN_NO 
AND T_CLIM_CRN_NO = CLIM_CRN_NO
AND CLIM_LST_UPD_DT = LST_DT



update #TMPDATA
set O_DPAM_ACCT_NO = H.DPAM_ACCT_NO,DPAM_SBA_NAME= H.DPAM_SBA_NAME,O_DPAM_SBA_NO = H.DPAM_SBA_NO,O_ENTTM_DESC=E.ENTTM_DESC,O_CLICM_DESC= C.CLICM_DESC,O_subcm_desc =S.SUBCM_DESC,O_STAM_DESC =ST.STAM_DESC
FROM #dpamdates,#TMPDATA,DP_ACCT_MSTR_HST H
,entity_type_mstr E
,client_ctgry_mstr C
,SUB_CTGRY_MSTR S
,STATUS_MSTR ST
WHERE CL_CODE = T_CLIM_CRN_NO 
AND T_DPAM_ID = DPAM_CODE
AND T_CLIM_CRN_NO = DPAM_CRN_NO
AND T_DPAM_ID = DPAM_ID
AND DPAM_LST_UPD_DT = LST_DT
AND H.dpam_enttm_cd = enttm_cd                  
AND H.dpam_clicm_cd = clicm_cd 
and H.dpam_subcm_cd = subcm_cd
and H.dpam_stam_cd  = stam_cd
and enttm_deleted_ind =1
and clicm_deleted_ind = 1
and subcm_deleted_ind = 1
AND stam_deleted_ind = 1




update #TMPDATA
set O_DPHD_FH_FTHNAME =H.DPHD_FH_FTHNAME,O_DPHD_SH_FNAME =H.DPHD_SH_FNAME ,O_DPHD_SH_MNAME= H.DPHD_SH_MNAME,O_DPHD_SH_LNAME=H.DPHD_SH_LNAME,O_DPHD_SH_FTHNAME=H.DPHD_SH_FTHNAME,O_DPHD_SH_DOB=H.DPHD_SH_DOB,O_DPHD_SH_PAN_NO=H.DPHD_SH_PAN_NO,O_DPHD_SH_GENDER=H.DPHD_SH_GENDER,O_DPHD_TH_FNAME=H.DPHD_TH_FNAME,O_DPHD_TH_MNAME=H.DPHD_TH_MNAME,O_DPHD_TH_LNAME=H.DPHD_TH_LNAME,O_DPHD_TH_FTHNAME=H.DPHD_TH_FTHNAME,O_DPHD_TH_DOB=H.DPHD_TH_DOB,O_DPHD_TH_PAN_NO=H.DPHD_TH_PAN_NO,O_DPHD_TH_GENDER=H.DPHD_TH_GENDER,O_DPHD_NOM_FNAME=H.DPHD_NOM_FNAME,O_DPHD_NOM_MNAME=H.DPHD_NOM_MNAME,O_DPHD_NOM_LNAME=H.DPHD_NOM_LNAME,O_DPHD_NOM_FTHNAME=H.DPHD_NOM_FTHNAME,O_DPHD_NOM_DOB=H.DPHD_NOM_DOB,O_DPHD_NOM_PAN_NO=H.DPHD_NOM_PAN_NO,O_DPHD_NOM_GENDER=H.DPHD_NOM_GENDER,O_DPHD_GAU_FNAME=H.DPHD_GAU_FNAME,O_DPHD_GAU_MNAME=H.DPHD_GAU_MNAME,O_DPHD_GAU_LNAME=H.DPHD_GAU_LNAME,O_DPHD_GAU_FTHNAME=H.DPHD_GAU_FTHNAME,O_DPHD_GAU_DOB=H.DPHD_GAU_DOB,O_DPHD_GAU_PAN_NO=H.DPHD_GAU_PAN_NO,O_DPHD_GAU_GENDER=H.DPHD_GAU_GENDER,
O_dphd_nomgau_fname=H.dphd_nomgau_fname,O_dphd_nomgau_mname=H.dphd_nomgau_mname,O_dphd_nomgau_lname=H.dphd_nomgau_lname,O_dphd_nomgau_fthname=H.dphd_nomgau_fthname,O_dphd_nomgau_dob=H.dphd_nomgau_dob,O_dphd_nomgau_pan_no=H.dphd_nomgau_pan_no,O_dphd_nomgau_gender=H.dphd_nomgau_gender,O_NOM_NRN_NO=H.NOM_NRN_NO
FROM #hldrdates,#TMPDATA,dp_holder_dtls_hst H
WHERE HLDR_CODE = T_DPAM_ID 
AND T_DPAM_ID = DPHD_DPAM_ID
AND DPHD_LST_UPD_DT = LST_DT

update #TMPDATA
set O_BANM_NAME=B.BANM_NAME,O_BANM_BRANCH=B.BANM_BRANCH,O_BANM_MICR=B.BANM_MICR,O_CLIBA_AC_NO=H.CLIBA_AC_NO,O_CLIBA_AC_TYPE=H.CLIBA_AC_TYPE,O_CLIBA_AC_NAME=H.CLIBA_AC_NAME
FROM #bankdates,#TMPDATA,cliba_hst H,bank_mstr B
WHERE BANK_CODE = T_DPAM_ID 
AND T_DPAM_ID = cliba_clisba_id
AND CLIBA_LST_UPD_DT = LST_DT
AND cliba_banm_id = banm_id 
and banm_deleted_ind = 1



insert into #TMPDATA(T_CLIM_CRN_NO,T_DPAM_ID,Prop_DESC,Prop_value,O_Prop_value,Prop_lst_upd_by ,Prop_lst_dt,Record_type)
select DISTINCT cl_code,dpam_code,ENTPM_DESC,Prop_value, O_Prop_value,lst_upd_by ,lst_dt,'P'  
FROM #TMPDATACLIENTPROP,ENTITY_PROPERTY_MSTR
WHERE PROP_DESC = ENTPM_CD
AND ENTPM_DELETED_IND = 1

insert into #TMPDATA(T_CLIM_CRN_NO,T_DPAM_ID,Prop_DESC,Prop_value, O_Prop_value,Prop_lst_upd_by ,Prop_lst_dt,Record_type)
select DISTINCT cl_code,dpam_code,ACCPM_PROP_DESC,Prop_value, O_Prop_value,lst_upd_by ,lst_dt,'P'    
FROM #TMPDATAACCTPROP,ACCOUNT_PROPERTY_MSTR 
WHERE PROP_DESC = ACCPM_PROP_CD
AND ACCPM_DELETED_IND =1


update t
set t.CLIM_NAME1 = case when isnull(t.CLIM_NAME1,'') = '' then isnull(c.clim_name1,'') else  t.CLIM_NAME1 end,
t.CLIM_NAME2 = case when isnull(t.CLIM_NAME2,'') = '' then isnull(c.clim_name2,'') else  t.CLIM_NAME2 end,
t.CLIM_NAME3 = case when isnull(t.CLIM_NAME3,'') = '' then isnull(c.clim_name3,'') else  t.CLIM_NAME3 end,
t.dpam_sba_name = case when isnull(t.dpam_sba_name,'') = '' then isnull(d.dpam_sba_name,'') else  t.dpam_sba_name end,
t.dpam_sba_no = case when isnull(t.dpam_sba_no,'') = '' then isnull(d.dpam_sba_no,'') else  t.dpam_sba_no end
from #TMPDATA t,client_mstr c,
dp_acct_mstr d
where c.clim_crn_no = d.dpam_crn_no
and t.T_CLIM_CRN_NO = c.clim_crn_no
and t.T_CLIM_CRN_NO=d.dpam_crn_no
and t.T_DPAM_ID = d.dpam_id
and c.clim_deleted_ind = 1 
and d.dpam_deleted_ind = 1
--
--
--
--
--
SELECT T_CLIM_CRN_NO,T_DPAM_ID,CLIM_NAME1=isnull(CLIM_NAME1,''),O_CLIM_NAME1=isnull(O_CLIM_NAME1,''),CLIM_NAME2=isnull(CLIM_NAME2,''),O_CLIM_NAME2=isnull(O_CLIM_NAME2,''),CLIM_NAME3=isnull(CLIM_NAME3,''),O_CLIM_NAME3=isnull(O_CLIM_NAME3,''),CLIM_SHORT_NAME=isnull(CLIM_SHORT_NAME,''),O_CLIM_SHORT_NAME=isnull(O_CLIM_SHORT_NAME,''),CLIM_GENDER=isnull(CLIM_GENDER,''),O_CLIM_GENDER=isnull(O_CLIM_GENDER,''),CLIM_DOB,O_CLIM_DOB,T_CLIM_LST_UPD_DT,CLIM_LST_UPD_BY,
DPAM_ACCT_NO=isnull(DPAM_ACCT_NO,''),O_DPAM_ACCT_NO=isnull(O_DPAM_ACCT_NO,''),DPAM_SBA_NAME=isnull(DPAM_SBA_NAME,''),O_DPAM_SBA_NAME=isnull(O_DPAM_SBA_NAME,''),DPAM_SBA_NO=isnull(DPAM_SBA_NO,''),O_DPAM_SBA_NO=isnull(O_DPAM_SBA_NO,''),ENTTM_DESC=isnull(ENTTM_DESC,''),O_ENTTM_DESC=isnull(O_ENTTM_DESC,''),CLICM_DESC=isnull(CLICM_DESC,''),O_CLICM_DESC=isnull(O_CLICM_DESC,''),subcm_desc=isnull(subcm_desc,''),O_subcm_desc=isnull(O_subcm_desc,''),STAM_DESC=isnull(STAM_DESC,''),O_STAM_DESC=isnull(O_STAM_DESC,''),DPAM_LST_UPD_BY,T_DPAM_LST_UPD_DT,
DPHD_FH_FTHNAME=isnull(DPHD_FH_FTHNAME,''),O_DPHD_FH_FTHNAME=isnull(O_DPHD_FH_FTHNAME,''),DPHD_SH_FNAME=isnull(DPHD_SH_FNAME,''),O_DPHD_SH_FNAME=isnull(O_DPHD_SH_FNAME,''),
DPHD_SH_MNAME=isnull(DPHD_SH_MNAME,''),O_DPHD_SH_MNAME=isnull(O_DPHD_SH_MNAME,''),
DPHD_SH_LNAME=isnull(DPHD_SH_LNAME,''),O_DPHD_SH_LNAME=isnull(O_DPHD_SH_LNAME,''),DPHD_SH_FTHNAME=isnull(DPHD_SH_FTHNAME,''),O_DPHD_SH_FTHNAME=isnull(O_DPHD_SH_FTHNAME,''),
DPHD_SH_DOB,O_DPHD_SH_DOB,DPHD_SH_PAN_NO=isnull(DPHD_SH_PAN_NO,''),O_DPHD_SH_PAN_NO=isnull(O_DPHD_SH_PAN_NO,''),
DPHD_SH_GENDER=isnull(DPHD_SH_GENDER,''),O_DPHD_SH_GENDER=isnull(O_DPHD_SH_GENDER,''),
DPHD_TH_FNAME=isnull(DPHD_TH_FNAME,''),O_DPHD_TH_FNAME=isnull(O_DPHD_TH_FNAME,''),
DPHD_TH_MNAME=isnull(DPHD_TH_MNAME,''),O_DPHD_TH_MNAME=isnull(O_DPHD_TH_MNAME,''),DPHD_TH_LNAME=isnull(DPHD_TH_LNAME,''),O_DPHD_TH_LNAME=isnull(O_DPHD_TH_LNAME,''),
DPHD_TH_FTHNAME=isnull(DPHD_TH_FTHNAME,''),O_DPHD_TH_FTHNAME=isnull(O_DPHD_TH_FTHNAME,''),DPHD_TH_DOB,O_DPHD_TH_DOB,
DPHD_TH_PAN_NO=isnull(DPHD_TH_PAN_NO,''),O_DPHD_TH_PAN_NO=isnull(O_DPHD_TH_PAN_NO,''),DPHD_TH_GENDER=isnull(DPHD_TH_GENDER,''),O_DPHD_TH_GENDER=isnull(O_DPHD_TH_GENDER,''),
DPHD_NOM_FNAME=isnull(DPHD_NOM_FNAME,''),O_DPHD_NOM_FNAME=isnull(O_DPHD_NOM_FNAME,''),DPHD_NOM_MNAME=isnull(DPHD_NOM_MNAME,''),O_DPHD_NOM_MNAME=isnull(O_DPHD_NOM_MNAME,''),
DPHD_NOM_LNAME=isnull(DPHD_NOM_LNAME,''),O_DPHD_NOM_LNAME=isnull(O_DPHD_NOM_LNAME,''),DPHD_NOM_FTHNAME=isnull(DPHD_NOM_FTHNAME,''),O_DPHD_NOM_FTHNAME=isnull(O_DPHD_NOM_FTHNAME,''),
DPHD_NOM_DOB,O_DPHD_NOM_DOB,DPHD_NOM_PAN_NO=isnull(DPHD_NOM_PAN_NO,''),O_DPHD_NOM_PAN_NO=isnull(O_DPHD_NOM_PAN_NO,''),
DPHD_NOM_GENDER=isnull(DPHD_NOM_GENDER,''),O_DPHD_NOM_GENDER=isnull(O_DPHD_NOM_GENDER,''),DPHD_GAU_FNAME=isnull(DPHD_GAU_FNAME,''),O_DPHD_GAU_FNAME=isnull(O_DPHD_GAU_FNAME,''),
DPHD_GAU_MNAME=isnull(DPHD_GAU_MNAME,''),O_DPHD_GAU_MNAME=isnull(O_DPHD_GAU_MNAME,''),
DPHD_GAU_LNAME=isnull(DPHD_GAU_LNAME,''),O_DPHD_GAU_LNAME=isnull(O_DPHD_GAU_LNAME,''),DPHD_GAU_FTHNAME=isnull(DPHD_GAU_FTHNAME,''),O_DPHD_GAU_FTHNAME=isnull(O_DPHD_GAU_FTHNAME,''),
DPHD_GAU_DOB,O_DPHD_GAU_DOB,DPHD_GAU_PAN_NO=isnull(DPHD_GAU_PAN_NO,''),O_DPHD_GAU_PAN_NO=isnull(O_DPHD_GAU_PAN_NO,''),
DPHD_GAU_GENDER=isnull(DPHD_GAU_GENDER,''),O_DPHD_GAU_GENDER=isnull(O_DPHD_GAU_GENDER,''),dphd_nomgau_fname=isnull(dphd_nomgau_fname,''),O_dphd_nomgau_fname=isnull(O_dphd_nomgau_fname,''),
dphd_nomgau_mname=isnull(dphd_nomgau_mname,''),O_dphd_nomgau_mname=isnull(O_dphd_nomgau_mname,''),
dphd_nomgau_lname=isnull(dphd_nomgau_lname,''),O_dphd_nomgau_lname=isnull(O_dphd_nomgau_lname,''),
dphd_nomgau_fthname=isnull(dphd_nomgau_fthname,''),O_dphd_nomgau_fthname=isnull(O_dphd_nomgau_fthname,''),
dphd_nomgau_dob,O_dphd_nomgau_dob,dphd_nomgau_pan_no=isnull(dphd_nomgau_pan_no,''),O_dphd_nomgau_pan_no=isnull(O_dphd_nomgau_pan_no,''),
dphd_nomgau_gender=isnull(dphd_nomgau_gender,''),O_dphd_nomgau_gender=isnull(O_dphd_nomgau_gender,''),
NOM_NRN_NO=isnull(NOM_NRN_NO,''),O_NOM_NRN_NO=isnull(O_NOM_NRN_NO,''),DPHD_LST_UPD_BY,T_DPHD_LST_UPD_DT,
BANM_NAME=isnull(BANM_NAME,''),O_BANM_NAME=isnull(O_BANM_NAME,''),BANM_BRANCH=isnull(BANM_BRANCH,''),O_BANM_BRANCH=isnull(O_BANM_BRANCH,''),
BANM_MICR=isnull(BANM_MICR,''),O_BANM_MICR=isnull(O_BANM_MICR,''),CLIBA_AC_NO=isnull(CLIBA_AC_NO,''),O_CLIBA_AC_NO=isnull(O_CLIBA_AC_NO,''),
CLIBA_AC_TYPE=isnull(CLIBA_AC_TYPE,''),O_CLIBA_AC_TYPE=isnull(O_CLIBA_AC_TYPE,''),
CLIBA_AC_NAME=isnull(CLIBA_AC_NAME,''),O_CLIBA_AC_NAME=isnull(O_CLIBA_AC_NAME,''),
Prop_DESC=isnull(Prop_DESC,''),Prop_value=isnull(Prop_value,''), O_Prop_value=isnull(O_Prop_value,''),Prop_lst_upd_by ,Prop_lst_dt
,Record_type
FROM #TMPDATA
order by T_CLIM_CRN_NO,T_DPAM_ID,record_type


truncate table #TMPDATACLIENTPROP
truncate table #TMPDATAACCTPROP 
truncate table #TMPDATA
truncate table #Climdates
truncate table #dpamdates
truncate table #hldrdates
truncate table #bankdates
truncate table #Clientpropdates 
truncate table #Accountpropdates

drop table #TMPDATACLIENTPROP
drop table #TMPDATAACCTPROP
drop table #TMPDATA
drop table #Climdates
drop table #dpamdates
drop table #hldrdates
drop table #bankdates
drop table #Clientpropdates 
drop table #Accountpropdates


--select * from #TMPDATA order by clim_crn_no,dpam_id





end

GO
