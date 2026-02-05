-- Object: PROCEDURE dbo.Nominee_Summary_Previous_Day
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 CREATE PROCEDURE [dbo].[Nominee_Summary_Previous_Day]
AS

 select * into #vw_equity_client_nominee  from KYC1DB.AngelBrokingWebDB.DBO.vw_equity_client_nominee   WHERE   nominee_share ='100.00' and 
 CONVERT(DATETIME,ADDED_ON,105)  =  CONVERT(VARCHAR(11),GETDATE()-2)       /*single nominee*/
 
 
  
 
select  
b.client_code as BOId,a.client_code,b.status as DP_Status,a.ADDED_ON as ADDED_ON_Date,Nominee_Status =  'Single',Nominee_Request_Status = CASE
                     WHEN nom.name is null  THEN 'NOT_UPDATED'
				   WHEN b.status ='CLOSED'
                   THEN 'NA'
                 ELSE 'UPDATED'
               END   into #Single_Nominee_PPR_T_2
from #vw_equity_client_nominee a left outer join [10.253.33.231].[inhouse].dbo.tbl_client_master b on  a.client_code = b.nise_party_code
left outer join [10.253.33.231].[inhouse].dbo.Nominee_Multi nom on  b.client_code =nom.BOID  




 SELECT client_code,BOID , 	 ADDED_ON_Date,
[NOT_UPDATED]=ISNULL(CONVERT(VARCHAR(20),[NOT_UPDATED],105),'-'),   [UPDATED]=ISNULL(CONVERT(VARCHAR(20),[UPDATED],105),'-'),
[NA]=ISNULL(CONVERT(VARCHAR(20),[NA],105),'-')  into #Nominee
FROM (SELECT client_code,BOID , 
	 ADDED_ON_Date,  	Nominee_Request_Status  FROM  #Single_Nominee_PPR_T_2 where Nominee_Status = 'Single' and boid is not null ) AS SourceTable PIVOT
(Max(Nominee_Request_Status) FOR Nominee_Request_Status IN ([NOT_UPDATED],[UPDATED],[NA] )) AS PivotTable

select * into #Nominee_200  from #Nominee where  boid like '12033200%'


select * into #Nominee_201  from #Nominee where  boid like '12033201%'

select * into #Nominee_202  from #Nominee where  boid like '12033202%'


select DPID='DP_200',Total_Nominee_Request_On_Previous_Day=count(client_code),NOT_UPDATED  = (select count(NOT_UPDATED) from  #Nominee_200 where NOT_UPDATED !='-' and UPDATED ='-') ,UPDATED  = (select count(UPDATED) from  #Nominee_200 where UPDATED !='-' and  NOT_UPDATED ='-'),
NA = (select count(NA) from  #Nominee_200 where NA !='-')  into #t_1
from #Nominee_200  

insert  into #t_1
select DPID='DP_201', Total_Nominee_Request_On_Previous_Day=count(client_code),NOT_UPDATED  = (select count(NOT_UPDATED) from  #Nominee_201 where NOT_UPDATED !='-' and UPDATED ='-') ,UPDATED  = (select count(UPDATED) from  #Nominee_201 where UPDATED !='-' and  NOT_UPDATED ='-'),
NA = (select count(NA) from  #Nominee_201 where NA !='-')
from #Nominee_201  

insert  into #t_1
select DPID='DP_202',Total_Nominee_Request_On_Previous_Day=count(client_code),NOT_UPDATED  = (select count(NOT_UPDATED) from  #Nominee_202 where NOT_UPDATED !='-' and UPDATED ='-') ,UPDATED  = (select count(UPDATED) from  #Nominee_202 where UPDATED !='-' and  NOT_UPDATED ='-'),
NA = (select count(NA) from  #Nominee_202 where NA !='-')
from #Nominee_202  


select * from  #t_1

select * from #Single_Nominee_PPR_T_2 where boid in (select boid from #Nominee where NOT_UPDATED = 'NOT_UPDATED')

 drop table #Nominee_200
 drop table #Nominee_201
 drop table #Nominee_202

GO
