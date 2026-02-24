-- Object: PROCEDURE dbo.datesertaxpt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE datesertaxpt
@startdate varchar(11),
@enddate varchar(20)
AS
SELECT DISTINCT convert(varchar,s.sauda_date,103), BOKERAGE =ROUND(isnull(SUM(s.TRADEQTY*s.BROKAPPLIED),0),2), 
DELCHRG =  ROUND(isnull(SUM(s.TRADEQTY*(s.NBROKAPP - s.BROKAPPLIED)),0),2), 
SERVICE_TAX = Round(isnull(SUM(NSertax),0),2),YY=Year(Sauda_Date),MM=Month(Sauda_Date),DD=Day(Sauda_Date)
FROM SETTLEMENT s, client1 c1,client2 c2
Where  c2.Party_Code = s.Party_Code And c1.cl_code = c2.cl_code 
and  s. Sauda_date  >=@startdate and s.sauda_date <=@enddate 
group by convert(varchar,s.sauda_date,103),Year(Sauda_Date),Month(Sauda_Date),Day(Sauda_Date)
Union All
SELECT DISTINCT convert(varchar,h.sauda_date,103),BOKERAGE =round(isnull(SUM(TRADEQTY*BROKAPPLIED),0),2), 
DELCHRG = round(isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),2), 
SERVICE_TAX = Round(isnull(SUM(NSertax),0),2),YY=Year(Sauda_Date),MM=Month(Sauda_Date),DD=Day(Sauda_Date)
FROM history h,  client1 c1,client2 c2 
Where  c2.Party_Code = h.Party_Code And c1.cl_code = c2.cl_code 
and h. Sauda_date  >=@startdate  and h.sauda_date <= @enddate 
group by convert(varchar,h.sauda_date,103),Year(Sauda_Date),Month(Sauda_Date),Day(Sauda_Date)
order by Year(Sauda_Date),Month(Sauda_Date),Day(Sauda_Date)

GO
