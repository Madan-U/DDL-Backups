-- Object: PROCEDURE dbo.Rpt_NseBseDelPos
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_NseBseDelPos    Script Date: 12/16/2003 2:31:23 PM ******/  
  
CREATE Proc Rpt_NseBseDelPos   
@PayInDate Varchar(11)  
As  
Select N.Party_Code,Long_Name=Left(Long_Name,25),N.Scrip_Cd,N.Series,BseCode=B.Scrip_Cd,N.IsIn,  
NseSett_No=N.Sett_No,NseSett_Type=N.Sett_Type,NseQty=N.Qty,  
BseSett_No=B.Sett_No,BseSett_Type=B.Sett_Type,BseQty=B.Qty,  
TotQty = N.Qty + B.Qty  
From Rpt_NseDelPos N, Rpt_BseDelPos B, Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = N.Party_Code  
And N.IsIn = B.IsIn   
And N.Party_Code = B.Party_Code  
And N.Sec_PayIn = B.Sec_PayIn   
And N.Sec_PayIn Like @PayInDate + '%'  
And N.Sett_Type <> 'A' And B.Sett_Type <> 'AD'  
Order By N.Party_Code,N.Scrip_Cd,N.Series

GO
