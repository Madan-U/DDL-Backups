-- Object: PROCEDURE dbo.CLIENT_COUNT_CASH_FO
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
---EXEC CLIENT_COUNT 'JAN 12 2021'  
---EXEC CLIENT_COUNT_CASH_FO 'Aug 17 2023'  
  
  
CREATE PROCEDURE [dbo].[CLIENT_COUNT_CASH_FO]   
(  
@DATE VARCHAR(20)  
)  
AS  
BEGIN  
  
--select Distinct party_code into #party from cash_cn where sdate >=@DATE and sdate <=@DATE +' 23:59:00'--ORE-3178

select Distinct party_code into #party from cash_cn where sdate >=@DATE and sdate <=@DATE +' 23:59:59'
  
Create index #party on #party(party_code)

select distinct party_code into #cn  from Contractnote_Daily C  (Nolock) where  not exists (select party_code from #party p where p.party_code =c.PARTY_CODE )  
  
insert into  #cn  
select distinct party_code   from Contractnote_Daily (Nolock) where Segment='Futures' and Exchange in ('NSE', 'BSE')
  
insert into  #cn  
select distinct party_code  from Contractnote_Daily (Nolock) where Sett_type in ('A','X')  
  
---select distinct party_code ,'FUTURES'AS DATA from #cn  
  
  
  
---cash  
select distinct party_code ,'FUTURES'AS DATA from #cn  
UNION ALL  
select party_code ,'CASH'AS DATA from #party  
UNION ALL  
select distinct party_code,'AUCTION'AS DATA  from Contractnote_Daily WITH(NOLOCK) where Sett_type in ('A','X')  
--UNION ALL  
--select distinct(party_Code),'TOTAL'AS DATA from Contractnote_Daily WITH(NOLOCK) where exchange <>'NSX'  
  
END

GO
