-- Object: PROCEDURE dbo.NBFC_MarginSec
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc NBFC_MarginSec 
(@FromDate Varchar(11))
As 
Begin Tran
Insert into TBLScripMargin
Select Scrip_Cd,@FromDate,'Dec 31 2049 23:59','Import',GetDate()
From MTFEligibility 
Where Scrip_Cd not in ( Select Scrip_cd From TBLScripMargin Where To_Date Like 'Dec 31 2049%' )
And Category = 1

Update TBLScripMargin Set To_Date = Convert(DateTime, @FromDate) - 1 
Where Scrip_Cd not in (Select Scrip_Cd From MTFEligibility Where Category = 1)
And To_Date Like 'Dec 31 2049%'
Commit Tran

GO
