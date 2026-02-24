-- Object: PROCEDURE dbo.PAY_IN_DP_NOT_MAPPED
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--Altered this SP under SRE-34226
CREATE PROCEDURE  [dbo].[PAY_IN_DP_NOT_MAPPED]
AS

Begin

  Select distinct Party_code into #check from ANGELDEMAT.[MSAJAG].[dbo].deliveryclt d,ANGELDEMAT.[MSAJAG].[dbo].sett_mst s
where d.sett_no=s.sett_no  and d.sett_type =s.sett_type
and start_date=convert(varchar(11),getdate(),120) 

select  distinct(cd.cl_code),cd.pan_gir_no  into  #pay_in from  ANAND1.[MSAJAG].[dbo].[Client_Details] cd  
Inner JOIN  ANAND1.[MSAJAG].[dbo].CLIENT_BROK_DETAILS CBD ON CD.cl_code = CBD.cl_code  where cbd.deactive_value not in ('C','T') and cd.cl_code in (Select    party_code from  #check)
 

select p.*,dp.client_code,dp.type,dp.sub_type,dp.poa_name,dp.nise_party_code,dp.First_hold_pan, dp.first_hold_name,  dp.status   into   #DP from  #pay_in p inner join  [10.253.33.189].[DMAT].[dbo].TBL_CLIENT_MASTER dp
on p.pan_gir_no=dp.First_hold_pan
 
 insert   into   #DP
 select p.*,dp.client_code,dp.type,dp.sub_type,dp.poa_name,dp.nise_party_code,dp.First_hold_pan, dp.first_hold_name,  dp.status  from  #pay_in p inner join  TBL_CLIENT_MASTER dp
on p.pan_gir_no=dp.First_hold_pan
 
  insert   into   #DP
 select p.*,dp.client_code,dp.type,dp.sub_type,dp.poa_name,dp.nise_party_code,dp.First_hold_pan, dp.first_hold_name,  dp.status  from  #pay_in p inner join  [10.253.33.227].[DMAT].[dbo].TBL_CLIENT_MASTER dp
on p.pan_gir_no=dp.First_hold_pan
 
 insert   into   #DP
 select p.*,dp.client_code,dp.type,dp.sub_type,dp.poa_name,dp.nise_party_code,dp.First_hold_pan, dp.first_hold_name,  dp.status  from  #pay_in p inner join  [ABVSDP203].[DMAT].[dbo].TBL_CLIENT_MASTER dp
on p.pan_gir_no=dp.First_hold_pan
  
   insert   into   #DP
 select p.*,dp.client_code,dp.type,dp.sub_type,dp.poa_name,dp.nise_party_code,dp.First_hold_pan, dp.first_hold_name,  dp.status  from  #pay_in p inner join  [ABVSDP204].[DMAT].[dbo].TBL_CLIENT_MASTER dp
on p.pan_gir_no=dp.First_hold_pan
 

 select * into #MultiCltId from [ANAND].[BSEDB_AB].[dbo].[MultiCltId] WITH (NOLOCK)

 select * into #MultiCltId1 from ANAND1.[MSAJAG].[dbo].MultiCltId  WITH (NOLOCK)
   
	select a.*,b.* into #PAY_IN_AL from  #DP a left outer join  ANGELDEMAT.[BSEDB].[dbo].MultiCltId b on a.client_code=b.CltDpNo  where a.status like '%ACTIVE%'   
	insert into #PAY_IN_AL 
	select a.*,b.* from  #DP a left outer join  #MultiCltId1 b on a.client_code=b.CltDpNo  where a.status like '%ACTIVE%'   

	insert into #PAY_IN_AL 
	select a.*,b.* from  #DP a left outer join   #MultiCltId b on a.client_code=b.CltDpNo  where a.status like '%ACTIVE%'   

	 


select replace(replace(client_code , char(10), ''), char(13),'') As 'client_code' into #C from #PAY_IN_AL   


 SELECT * into #NOT_EXISTS_PAY_IN
FROM   #C
WHERE  NOT EXISTS
  (SELECT *
   FROM   #PAY_IN_AL
   WHERE  #PAY_IN_AL.CltDpNo = #C.client_code)
    
	insert into PAY_IN_DP_NOT_MAPPED_Report
    select distinct (cl_code),pan_gir_no	,client_code,	poa_name,type,SUB_TYPE,	nise_party_code	,First_hold_pan,	first_hold_name,	status	 ,PAY_IN_DP='NOT MAPPED' 
	,Create_Date=GETDATE()  
	from #PAY_IN_AL    where client_code in (select client_code from #NOT_EXISTS_PAY_IN);

	select * from PAY_IN_DP_NOT_MAPPED_Report
  	
END

GO
