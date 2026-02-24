-- Object: PROCEDURE dbo.C_getscripqtysp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure C_getscripqtysp
@exchange Varchar(3),
@segment Varchar(20),
@party_code Varchar(10),
@effdate Varchar(11)
As
Select Balqty = Sum(crqty) - Sum(drqty), Scrip_cd, Series, Isin From C_calculatesecview
Where Party_code = @party_code And Effdate <=@effdate + '  23:59:59'
And Exchange = @exchange And Segment =  @segment
Group By Scrip_cd,series, Isin

GO
