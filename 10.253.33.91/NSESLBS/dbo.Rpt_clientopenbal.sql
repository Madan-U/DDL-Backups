-- Object: PROCEDURE dbo.Rpt_clientopenbal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/*  
Modified By Neelambari On 17 Oct 2001  
Changed Te Dat Type Of Todt From Varchar To Datetime  
*/  
/*  
   Report :  Allpartyledger  
   File : Ledgerview.Asp  
   
Calculates Balance Till Date */  
CREATE  Procedure Rpt_clientopenbal  
@Todt Datetime ,   
@Cltcode Varchar (10),   
@Sortby Varchar(3)  
As  
If @Sortby = 'Vdt'   
Begin  
 Select Drtot = Isnull((Case Drcr When 'D' Then Sum(Vamt) End), 0),   
 Crtot = Isnull((Case Drcr When 'C' Then Sum(Vamt) End), 0)   
 From Account.Dbo.ledger   
 Where  Vdt < @Todt   
 And Cltcode = @Cltcode  
 Group By Drcr   
End   
Else  
Begin  
 Select Drtot = Isnull((Case Drcr When 'D' Then Sum(Vamt) End), 0),   
 Crtot = Isnull((Case Drcr When 'C' Then Sum(Vamt) End), 0)   
 From Account.Dbo.ledger   
 Where  Edt < @Todt   
 And Cltcode = @Cltcode  
 Group By Drcr   
End

GO
