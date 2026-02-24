-- Object: PROCEDURE dbo.SelParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SelParty    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.SelParty    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.SelParty    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.SelParty    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.SelParty    Script Date: 12/27/00 8:59:02 PM ******/

CREATE Proc SelParty ( @Sett_no Varchar(7),@FromParty Varchar(10),@ToParty Varchar(10),@Flag int) As
if @flag = 1 
SELECT DISTINCT Party_code from settlement where sett_no = @Sett_No and sett_type in ( 'W') and Party_Code >= @FromParty And Party_Code <= @ToParty
union 
SELECT DISTINCT Party_code from tempsettalbmsum where sett_no =  ( select min( Sett_No ) from sett_mst where sett_no > @Sett_No and sett_type = 'W'  )  and sett_type = 'P' and Party_Code >= @FromParty And Party_Code <= @ToParty
order by party_code
else
SELECT DISTINCT Party_code from History where sett_no = @Sett_No and sett_type in ( 'W')  and Party_Code >= @FromParty And Party_Code <= @ToParty
union 
SELECT DISTINCT Party_code from tempsettalbmsum where sett_no = ( select min( Sett_No ) from sett_mst where sett_no > @Sett_No and sett_type = 'W' ) and sett_type = 'P' and Party_Code >= @FromParty And Party_Code <= @ToParty
order by party_code

GO
