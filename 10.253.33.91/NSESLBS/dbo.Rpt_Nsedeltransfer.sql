-- Object: PROCEDURE dbo.Rpt_Nsedeltransfer
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc Rpt_Nsedeltransfer   
(@Statusid Varchar(15), @Statusname Varchar(25),   
 @Fromparty Varchar(10), @Toparty Varchar(10),   
 @Fromscrip Varchar(12), @Toscrip Varchar(12),
 @FromDate Varchar(11), @ToDate Varchar(11)
)  
As   

Select Sett_No, Sett_Type, D.Party_Code, C1.Long_Name, Scrip_Cd, Series, Qty = Sum(Qty), Dpid, Cltdpid,   
Transdate = Left(Convert(Varchar, Transdate, 109), 11), Bdpid, Bcltdpid, Trtype, Isett_No, Isett_Type   
From Deltrans D, Client1 C1, Client2 C2 Where Delivered = 'D' And Filler2 = 1 And Drcr = 'D'   
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code   
And D.Party_Code > = @Fromparty And D.Party_Code < = @Toparty  
And D.Scrip_Cd > = @Fromscrip And D.Scrip_Cd < = @Toscrip   
And D.TransDate Between @FromDate And @ToDate + ' 23:59'
Group By D.Party_Code, C1.Long_Name, Scrip_Cd, Series, Sett_No, Sett_Type, Dpid,   
Cltdpid, Left(Convert(Varchar, Transdate, 109), 11), Bdpid, Bcltdpid, Trtype, Isett_No, Isett_Type   
Order By D.Party_Code, C1.Long_Name, Scrip_Cd, Series, Sett_No, Sett_Type

GO
