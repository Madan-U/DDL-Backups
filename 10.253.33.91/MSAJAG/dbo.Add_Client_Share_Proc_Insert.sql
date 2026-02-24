-- Object: PROCEDURE dbo.Add_Client_Share_Proc_Insert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE  Proc Add_Client_Share_Proc_Insert (
@Exchange Varchar(3), 
@Segment Varchar(7), 
@Branch_Cd Varchar(10), 
@FromParty Varchar(10),
@ToParty Varchar(10),
@MainDate Varchar(30),
@DetDate Varchar(30)
) As

Update Owner Set MemberCode = MemberCode

GO
