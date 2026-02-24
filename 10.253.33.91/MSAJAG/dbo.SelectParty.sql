-- Object: PROCEDURE dbo.SelectParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc SelectParty (@sett_no varchar(7),@sett_type varchar(2),@FromParty Varchar(10),@ToParty Varchar(10)) as
select Distinct Party_code from tempsettsum where sett_no = @sett_no and sett_type = @sett_type and Party_code >= @FromParty And Party_code <= @ToParty
union 
select Distinct Party_code from temphistsum where sett_no = @sett_no and sett_type = @sett_type and Party_code >= @FromParty And Party_code <= @ToParty
union 
select Distinct Party_code from oppalbm where sett_no = @sett_no  and sett_type = @sett_type and Party_code >= @FromParty And Party_code <= @ToParty
union 
select Distinct Party_code from PlusOneAlbm where sett_no =  ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_Type ) and sett_type = @sett_type 
and Party_code >= @FromParty And Party_code <= @ToParty

GO
