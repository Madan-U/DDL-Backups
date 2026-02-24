-- Object: PROCEDURE dbo.CLIENT_COUNT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---EXEC CLIENT_COUNT 'JAN 12 2021'
---EXEC CLIENT_COUNT_CASH_FO 'JAN 12 2021'


CREATE PROCEDURE CLIENT_COUNT 
(
@DATE VARCHAR(20)
)
AS
BEGIN

select Distinct party_code into #party from cash_cn where sdate >=@DATE

select distinct party_code into #cn  from Contractnote_Daily where party_code not in (select * from #party)

insert into  #cn
select distinct party_code   from Contractnote_Daily where Segment='Futures'

insert into  #cn
select distinct party_code  from Contractnote_Daily where Sett_type in ('A','X')

---select distinct party_code ,'FUTURES'AS DATA from #cn



---cash
select distinct party_code ,'FUTURES'AS DATA from #cn
UNION ALL
select party_code ,'CASH'AS DATA from #party
UNION ALL
select distinct party_code,'AUCTION'AS DATA  from Contractnote_Daily WITH(NOLOCK) where Sett_type in ('A','X')
UNION ALL
select distinct(party_Code),'TOTAL'AS DATA from Contractnote_Daily WITH(NOLOCK)

END

GO
