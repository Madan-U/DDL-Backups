-- Object: PROCEDURE dbo.V2_OFFLINE_COSTCENTER_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Procedure [dbo].[V2_OFFLINE_COSTCENTER_REPORT]  
as  
  
select  /*a.FldAuto as [S No],  */
 a.VoucherNo as [Ref No],  
 a.LedgerVNo as [V No],  
 a.VoucherType as [V Type],    
 a.BookType as [Book Type],    
 a.SNo  as [L No],    
 a.VDate as [V Dt],    
 a.Edate as [E Dt],    
 a.CltCode  as [Clt Code],    
 a.OppCode  as [GL Code],    
 [Credit Amt] = (Case when b.CreditAmt <> 0 then b.CreditAmt else a.CreditAmt end),  
 [Debit Amt] = (case when b.DebitAmt <> 0 then b.DebitAmt else a.DebitAmt end),  
 isnull(b.BranchCode, a.BranchCode) as [Branch Cd],  
 isnull(b.CatCode, a.BranchCode) as [Cat Cd],  
 isnull(b.CostCode, a.BranchCode) as [Cost Cd]/*,  
 a.addby  as [Add By],    
 a.adddt  as [Add Dt] */
from   
AngelBSECM.ACCOUNT_AB.DBO.v2_offline_cc_entries b  
inner  join   
 v2_offline_ledger_entries a  
 on (b.VOLE_RefNo = a.FldAuto)  
Where  
 a.RowState = 0  
Order by A.FldAuto

GO
