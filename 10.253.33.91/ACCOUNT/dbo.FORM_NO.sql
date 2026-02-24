-- Object: PROCEDURE dbo.FORM_NO
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc [dbo].[FORM_NO] (

@FROMDATE VARCHAR (11),
@TODATE   VARCHAR (11)
)
AS BEGIN 
select
[DPAM_CRN_NO]=DPAM_CRN_NO,
[DPAM_ACCT_NO]=DPAM_ACCT_NO,
[DPAM_SBA_NAME]=DPAM_SBA_NAME,
[DPAM_SBA_NO]=DPAM_SBA_NO,
[DPAM_CREATED_DT]=DPAM_CREATED_DT,
[DPAM_CREATED_BY]=DPAM_CREATED_BY,
[DPAM_BBO_CODE]=DPAM_BBO_CODE
 into #temp50  from AGMUBODPL3.dmat.citrus_usr.dp_acct_mstr where DPAM_CREATED_DT >=@FROMDATE
 AND DPAM_CREATED_DT<=@TODATE + ' 23:59:59:999'
 and DPAM_ACCT_NO<>DPAM_SBA_NO

 
 select 
 [CL_CODE]=A.CL_CODE,
 [EXCHANGE]=A.EXCHANGE,
 [SEGMENT]=A.SEGMENT,
 [ACTIVE_DATE]=A.ACTIVE_DATE,
 [FORMNO]=B.FORMNO
 
 into #temp150 
 from msajag..CLIENT_BROK_DETAILS a,
 msajag..client_master_ucc_data b
 where a.active_date >=@FROMDATE AND A.ACTIVE_DATE<=@TODATE + ' 23:59:59:999'
 and a.cl_code=b.party_code



 select B.DPAM_CRN_NO,B.DPAM_ACCT_NO,B.DPAM_SBA_NAME,B.DPAM_SBA_NO,B.DPAM_CREATED_DT,B.DPAM_CREATED_BY,B.DPAM_BBO_CODE
 ,A.cl_code,A.exchange,A.segment,A.formno from #temp150 a
 left outer join 
 #temp50 b
 on B.DPAM_ACCT_NO=A.formno
 order by A.cl_code
 
 END

GO
