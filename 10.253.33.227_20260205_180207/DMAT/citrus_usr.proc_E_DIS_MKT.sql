-- Object: PROCEDURE citrus_usr.proc_E_DIS_MKT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


  
  
  
      
 CREATE Proc [citrus_usr].[proc_E_DIS_MKT]   (@sett_no varchar(16),@sett_type varchar(5))     
AS        
       
      
declare @payindate varchar(11)  
  
select @payindate=replace(LEFT(CONVERT(VARCHAR,Sec_payin, 104), 10),'.','') from [ANGELDEMAT].msajag.dbo.sett_mst m with(Nolock)  
where sett_no=@sett_no and sett_type =@sett_type  
  
Select distinct party_Code into #del from [ANGELDEMAT].msajag.dbo.Deliveryclt   
where sett_no=@sett_no  and sett_type =@sett_type and inout='I'  
  
Create index #s on #del(party_code)  
  
  
  
SELECT DISTINCT  BOID,ISIN,QTY=(CASE WHEN CAST(ISNULL(PEND_QTY,0)AS FLOAT)>0 THEN CAST(ISNULL(PEND_QTY,0) AS FLOAT) ELSE QTY END )      
,FLAG,REQUEST_DATE,NO_OF_DAYS ,DIS_TRXN_STATUS=ISNULL(DUMMY3,''),TRXN_ID=CDSL_TRXN_ID  
FROM  E_DIS_TRXN_DATA T (NOLOCK) ,#del d  
WHERE REQUEST_DATE >getdate()-10   
AND ISNULL(VALID,0)=0 AND ISNULL(DUMMY3,'')<>'E'  and d.party_code=t.Partycode     
and dummy2 =@payindate  
--and Request_date>='2021-02-22'  
---and NO_of_days=5

GO
