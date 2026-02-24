-- Object: PROCEDURE dbo.GetBillDataSum
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Proc GetBillDataSum      
@Sett_No As Varchar(7),      
@Sett_Type As Varchar(2),      
@ShareDb As Varchar(15),      
@DispOpt As Varchar(7) = 'Summary',      
@Disp123 As Varchar(2) = 'N'      
      
--exec GetBillDataSum '2004042', 'N', 'MSAJAG', 'Details'      
--Exec GetBillDataSum '2013117', 'L ', 'NSESLBS'      
      
As      
      
Declare      
@@SQLQry As Varchar(2000)      
      
Set @@SQLQry = "Select Party_Code, M.Acname, Round(Amount,2) As Amount, Sell_Buy, Bill_No From " + @ShareDb + " "      
Set @@SQLQry = @@SQLQry + ".Dbo.Accbill a, Acmast m  WITH(NOLOCK)"      
Set @@SQLQry = @@SQLQry + " Where Sett_no ='" + @Sett_No + "' and sett_type='" + @Sett_Type + "'"      
Set @@SQLQry = @@SQLQry + " And A.party_code = M.Cltcode and branchcd = 'ZZZ' "      
--Set @@SQLQry = @@SQLQry + " And Round(Amount,2) <> 0 "      
--Set @@SQLQry = @@SQLQry + " Order By Party_Code "  
Set @@SQLQry = @@SQLQry + " union all "      
      
If @DispOpt = 'Summary'      
 Begin      
  Set @@SQLQry = @@SQLQry + " Select 'Party Dr', 'Party Amount Receivables', Round(sum(Amount),2) As Amount, Sell_buy, bill_no "      
  Set @@SQLQry = @@SQLQry + " from "+ @ShareDb + ".dbo.accbill a, "      
  Set @@SQLQry = @@SQLQry + " Acmast m  where sett_no ='" + @Sett_No + "' and sett_type='" + @Sett_Type + "'"      
  Set @@SQLQry = @@SQLQry + " and A.party_code = M.cltcode and m.accat = 4  and sell_buy = '1' "      
  Set @@SQLQry = @@SQLQry + " group by bill_no, Sell_Buy "      
--  Set @@SQLQry = @@SQLQry + " Having Round(sum(Amount),2) <> 0 "      
  Set @@SQLQry = @@SQLQry + " union all "      
 End      
Else      
 Begin      
  Set @@SQLQry = @@SQLQry + " Select Party_Code ,M.AcName, Round(sum(Amount),2) As Amount, Sell_buy, bill_no "      
  Set @@SQLQry = @@SQLQry + " from "+ @ShareDb + ".dbo.accbill a, "      
  Set @@SQLQry = @@SQLQry + " Acmast m  where sett_no ='" + @Sett_No + "' and sett_type='" + @Sett_Type + "'"      
  Set @@SQLQry = @@SQLQry + " and A.party_code = M.cltcode and m.accat = 4  and sell_buy = '1' "      
  Set @@SQLQry = @@SQLQry + " group by Party_Code ,M.AcName, bill_no, Sell_Buy "      
--  Set @@SQLQry = @@SQLQry + " Having Round(sum(Amount),2) <> 0 "      
  Set @@SQLQry = @@SQLQry + " union all "      
 End      
If @DispOpt = 'Summary'      
 Begin      
  Set @@SQLQry = @@SQLQry + " Select 'Party CR', 'Party Amount Payables', Round(sum(Amount),2) As Amount,Sell_buy, bill_no "      
  Set @@SQLQry = @@SQLQry + " from "+ @ShareDb + ".dbo.Accbill a, acmast m "      
  Set @@SQLQry = @@SQLQry + " where sett_no ='" + @Sett_No + "' and sett_type='" + @Sett_Type + "'"      
  Set @@SQLQry = @@SQLQry + " and A.party_code = M.cltcode and m.accat = 4   and sell_buy = '2' "      
  Set @@SQLQry = @@SQLQry + " group by bill_no, Sell_Buy "      
--  Set @@SQLQry = @@SQLQry + " Having Round(sum(Amount),2) <> 0 "      
 End      
Else      
 Begin      
  Set @@SQLQry = @@SQLQry + " Select Party_Code, M.AcName, Round(sum(Amount),2) As Amount,Sell_buy, bill_no "      
  Set @@SQLQry = @@SQLQry + " from "+ @ShareDb + ".dbo.Accbill a, acmast m "      
  Set @@SQLQry = @@SQLQry + " where sett_no ='" + @Sett_No + "' and sett_type='" + @Sett_Type + "'"      
  Set @@SQLQry = @@SQLQry + " and A.party_code = M.cltcode and m.accat = 4   and sell_buy = '2' "      
  Set @@SQLQry = @@SQLQry + " group by Party_Code, M.AcName, bill_no, Sell_Buy "      
--  Set @@SQLQry = @@SQLQry + " Having Round(sum(Amount),2) <> 0 "      
 End      
      
Print @@SQLQry      
Exec(@@SQLQry)      
      
SET QUOTED_IDENTIFIER ON

GO
