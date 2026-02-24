-- Object: PROCEDURE dbo.BBOCodeNOTMapped
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--Altered this sp under SRE-34226
CREATE PROCEDURE [dbo].[BBOCodeNOTMapped]
AS
 
 SET NOCOUNT ON; 

select CLIENT_CODE,NISE_PARTY_CODE,DP_INT_REFNO,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN into #BBO  from   TBL_CLIENT_MASTER WITH (NOLOCK)
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '1900-01-01 00:00:00.000' and GETDATE()-2 order by ACTIVE_DATE asc
  
  insert into #BBO  
select CLIENT_CODE,NISE_PARTY_CODE,DP_INT_REFNO,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN from  [10.253.33.189].[DMAT].[dbo].TBL_CLIENT_MASTER WITH (NOLOCK)
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '1900-01-01 00:00:00.000' and GETDATE()-2 order by ACTIVE_DATE asc


  insert into #BBO  
select CLIENT_CODE,NISE_PARTY_CODE,DP_INT_REFNO,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN from  [10.253.33.227].[DMAT].[dbo].TBL_CLIENT_MASTER WITH (NOLOCK)
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '1900-01-01 00:00:00.000' and GETDATE()-2 order by ACTIVE_DATE asc


 insert into #BBO  
select CLIENT_CODE,NISE_PARTY_CODE,DP_INT_REFNO,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN from  [ABVSDP203].[DMAT].[dbo].TBL_CLIENT_MASTER WITH (NOLOCK)
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '1900-01-01 00:00:00.000' and GETDATE()-2 order by ACTIVE_DATE asc


insert into #BBO  
select CLIENT_CODE,NISE_PARTY_CODE,DP_INT_REFNO,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN from  [ABVSDP204].[DMAT].[dbo].TBL_CLIENT_MASTER WITH (NOLOCK)
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '1900-01-01 00:00:00.000' and GETDATE()-2 order by ACTIVE_DATE asc

select  tbl.*,cbd.Cl_Code  into #BO from  
#BBO  tbl
left outer JOIN  ANAND1.[MSAJAG].[dbo].CLIENT_DETAILS CD ON tbl.FIRST_HOLD_PAN= cd.pan_gir_no  
left outer  join   ANAND1.[MSAJAG].[dbo].CLIENT_brok_DETAILS cbd on cd.cl_code = cbd.Cl_Code where cbd.Deactive_value not in ('C','T')
 

select distinct(CLIENT_CODE),	NISE_PARTY_CODE,DP_INT_REFNO	,status,	ACTIVE_DATE,	FIRST_HOLD_NAME,	FIRST_HOLD_PAN	,Cl_Code  from #BO

GO
