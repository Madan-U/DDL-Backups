-- Object: PROCEDURE dbo.Rpt_DelDpCharges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DelDpCharges (@FromDate Varchar(11), @ToDate Varchar(11), @FromParty Varchar(10), @ToParty Varchar(10)) As
Select Party_Code, Amount = Round(Sum(TotalCharges+Service_Tax),2), DrCr = 'D', 
Narration = 'Dp Charges for the period ' + @FromDate + ' - ' + @ToDate  
From DeliveryDPChargesFinalAmount
Where TransDate >= @FromDate And TransDate <= @ToDate
And Party_Code>= @FromParty And Party_Code <= @ToParty
Group By Party_Code
Having Round(Sum(TotalCharges),2) > 0 
Order By Party_Code

GO
