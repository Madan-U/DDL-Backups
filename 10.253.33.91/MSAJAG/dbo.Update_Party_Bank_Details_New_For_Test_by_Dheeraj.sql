-- Object: PROCEDURE dbo.Update_Party_Bank_Details_New_For_Test_by_Dheeraj
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc [dbo].[Update_Party_Bank_Details_New_For_Test_by_Dheeraj]          
as          
          
          
/*          
Create Table Party_Bank_Details          
(          
Party_Code varchar(10),          
Exchange varchar(11),          
BankName varchar(100),          
Branch Varchar(100),          
AcNum Varchar(64),          
AcType Varchar(20)          
)          
*/          
         
select top 0 * into #Party_Bank_Details    from Party_Bank_Details      
  
  --Added clustered index on 6th May 2020

 -- Create clustered index cl_idx on #Party_Bank_Details(Party_Code asc)   ( mostly doing insertion clustered index won't help much)
  
  /****** Object:  Index [ix_code]    Script Date: 24-03-2021 10:11:29 ******/
CREATE NONCLUSTERED INDEX [ncl_ix_code] ON [dbo].[#Party_Bank_Details]
(
	[Party_Code] ASC
)
INCLUDE([Exchange],[BankName],[AcNum]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
