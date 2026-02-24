-- Object: PROCEDURE dbo.rpt_NSEDelGive
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE RPT_NSEDelGive      
@dematid varchar(2),      
@Sett_No varchar(7),      
@Sett_Type varchar(3)      
AS       
Set Transaction Isolation level read uncommitted    

Select * Into #Del From DelTrans  
Where Sett_No = @Sett_No  
And Sett_Type = @Sett_Type  
And Filler2 = 1   
And TrType = 906  
And CertNo <> 'AUCTION'  
  
 Select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,giveNse=d.Qty,      
 givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),      
 ReceivedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0),  
 Cl_Rate = Convert(Numeric(18,4),0)  
 Into #Short from DelNet d Left Outer Join #Del DT      
 On (DT.sett_no = d.sett_no and Dt.sett_type = d.sett_type and       
 DT.scrip_cd = d.scrip_cd and Dt.series = d.series and TrType = 906       
 And filler2 = 1 )      
 where D.sett_no = @Sett_No and d.sett_type = @Sett_Type and inout = 'I'       
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Qty      
  
 Update #Short Set Cl_Rate = C.Cl_Rate                   
 From Closing C, Sett_Mst S                   
 Where S.Sett_No = #Short.Sett_No                  
 And S.Sett_Type = #Short.Sett_Type                  
 And C.Scrip_Cd = #Short.Scrip_CD                  
 And C.Series = #Short.Series                  
 And SysDate Like ( Select Max(SysDate) From Closing C1                   
       Where C.Scrip_Cd = C1.Scrip_CD                  
                           And C.Series = C1.Series And SysDate > Start_Date And SysDate < Sec_PayIn)   
  
Select * From #Short   
Order By scrip_cd,series

GO
