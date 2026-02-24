-- Object: PROCEDURE dbo.HIRERCHYLISTING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC HIRERCHYLISTING AS
Select B.Branch_Code, Branch_Name = B.Branch, S.Sub_Broker, Sub_Broker_Name = S.Name,
Trader = Short_Name, RegionCode, RegionName = R.Description, 
AreaCode, AreaName = A.Description
from Branch B, SubBrokers S, Branches T, Area A, Region R
Where B.Branch_Code = S.Branch_Code
And B.Branch_Code = T.Branch_Cd
And B.Branch_Code = R.Branch_Code
And B.Branch_Code = A.Branch_Code
Order by B.Branch_Code, S.Sub_Broker, Short_Name, RegionCode, AreaCode

GO
