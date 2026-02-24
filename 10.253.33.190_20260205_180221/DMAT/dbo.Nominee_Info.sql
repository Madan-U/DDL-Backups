-- Object: PROCEDURE dbo.Nominee_Info
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [dbo].[Nominee_Info]
AS
 select * into #vw_equity_client_nominee  from KYC1DB.AngelBrokingWebDB.DBO.vw_equity_client_nominee   WHERE   nominee_share ='100.00' and  CONVERT(DATETIME,ADDED_ON,105) >= '15 SEP 2023'
 --CONVERT(DATETIME,ADDED_ON,105) =  CONVERT(VARCHAR(11),GETDATE()-1)       /*single nominee*/

delete from  Single_Nominee_PPR
 
  
insert  into Single_Nominee_PPR
select substring(a.nominee_name, 1, len(a.nominee_name)-CHARINDEX(' ', reverse(a.nominee_name))) as
Name  ,SUBSTRING( a.nominee_name , LEN(a.nominee_name) -  CHARINDEX(' ',REVERSE(a.nominee_name)) + 2  , LEN(a.nominee_name)  ) as SearchName  ,FIRST_HOLD_ADD1 as Addr1
,FIRST_HOLD_ADD2 as Addr2,FIRST_HOLD_ADD3 as Addr3,FIRST_HOLD_ADD4 as City
,FIRST_HOLD_STATE as State,FIRST_HOLD_CNTRY as Country,FIRST_HOLD_PIN as 	PinCode	, a.nominee_pan as PANGIR   ,
b.client_code as BOId,RES_SEC_FLg ='Y',NOM_Sr_No= '01',rel_WITH_BO = 
	CASE WHEN nominee_relation  in ('Spouse','Wife') THEN '01'
	 WHEN nominee_relation = 'Son' THEN '02'
	 WHEN nominee_relation = 'Daughter' THEN '03'
	  WHEN nominee_relation = 'Father' THEN '04'
	   WHEN nominee_relation = 'Mother' THEN '05'
	    WHEN nominee_relation = 'Brother' THEN '06'
		 WHEN nominee_relation = 'Sister' THEN '07'
		 WHEN nominee_relation = 'GRANDSON' THEN '08'
		 WHEN nominee_relation = 'GRANDDAUGHTER' THEN '09'
		 WHEN nominee_relation = 'GRANDFATHER' THEN '10'
		 WHEN nominee_relation = 'GRANDMOTHER' THEN '11'
		 WHEN nominee_relation is null THEN '12'
	ELSE '13' END,perc_OF_SHARES = nominee_share,FIRST_HOLD_STATE AS 
statecode,FIRST_HOLD_CNTRY AS countrycode,
    right(convert(VARCHAR,nominee_dob,112),2) + 
       substring(convert(VARCHAR,nominee_dob,112),6,2) + 
       left(convert(VARCHAR,nominee_dob,112),4) AS DateOfBirth ,  right(convert(VARCHAR,GETDATE(),112),2) + 
       substring(convert(VARCHAR,GETDATE(),112),5,2) + 
       left(convert(VARCHAR,GETDATE(),112),4) AS 
DateOfSetup  ,a.client_code,b.status as DP_Status,a.ADDED_ON as ADDED_ON_Date,Nominee_Status =  'Single',Nominee_Request_Status = CASE
                     WHEN nom.name is null  THEN 'NOT_UPDATED'
				   WHEN b.status ='CLOSED'
                   THEN 'NA'
                 ELSE 'UPDATED'
               END   
from #vw_equity_client_nominee a left outer join [10.253.33.231].[inhouse].dbo.tbl_client_master b on  a.client_code = b.nise_party_code
left outer join [10.253.33.231].[inhouse].dbo.Nominee_Multi nom on  b.client_code =nom.BOID  

delete from  mkt_bulk_nominee

 insert into mkt_bulk_nominee
 select *  from  Single_Nominee_PPR where Nominee_Request_Status !='NA'
 
delete   from mkt_bulk_nominee  where  DateOfBirth  like '%-%' or DateOfBirth  like '%[A-Z]%' or BOId is null
 
--	   select *  into  mkt_bulk_nominee_SC  from mkt_bulk_nominee  where   DateOfBirth   like '%a%' or DateOfBirth   like '%e%' 
--or DateOfBirth   like '%o%' or DateOfBirth   like '%u%' or  DateOfBirth   like '%/%'

-- delete from  mkt_bulk_nominee_SC  from mkt_bulk_nominee  where   DateOfBirth   like '%a%' or DateOfBirth   like '%e%' 
--or DateOfBirth   like '%o%' or DateOfBirth   like '%u%' or  DateOfBirth   like '%/%'

GO
