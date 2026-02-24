-- Object: PROCEDURE dbo.rpt_MisReporInterest_Check
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--sp_helptext rpt_MisReporInterest_Check  
--Text  
CREATE Procedure  [dbo].[rpt_MisReporInterest_Check]    
@fromparty varchar(10),    
@toparty varchar(10),    
@fromdt varchar(11),    
@todate varchar(11),    
@reporttype varchar(30),    
@branchcode varchar(10),    
@reportby varchar(10),    
@StatusId Varchar(30),    
@StatusName Varchar(30)    
    
as    
/*    
exec rpt_MisReporInterest_Check 'a00000', 'Z','Apr 1 2006', 'Nov 29 2006','PARTY','rnaspravin','SUMMARY', 'subbroker', 'rnaspravin'    
*/    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
if upper(rtrim(@reporttype)) = 'FAMILY' or  upper(rtrim(@reporttype)) =  'c'    
 Begin    
  Set @reportby =  'DETAIL'    
 End    
    
if @reportby <>  'SUMMARY'    
 Begin    
  if upper(rtrim(@reporttype)) = 'PARTY'    
   begin    
    Select    
     BalanceDate,    
     CltCode = C2.Party_Code,    
     Short_Name = C1.Long_Name,    
     Balance,    
     Interest=abs(Interest),  
     MBalance,    
     MInterest=abs(MInterest),  
     IntRateCr,    
     IntRateDr    
    INTO #Interest    
    From    
     Tbl_Report_Interest_Margin (nolock),    
     msaJag.dbo.Client1 C1 (nolock),    
     msaJag.dbo.Client2 C2 (nolock)    
    Where    
     C1.Cl_Code = C2.Cl_Code    
     And Tbl_Report_Interest_Margin.Cltcode = C2.Party_Code    
     And BalanceDate Between @fromdt And @todate + ' 23:59'    
     And C2.Party_Code Between @fromparty And @toparty    
     And @StatusName = (Case When @StatusId = 'Region' Then C1.Region    
          When @StatusId = 'Area' Then C1.Area    
          When @StatusId = 'Branch' Then C1.Branch_Cd    
          When @StatusId = 'SubBroker' Then C1.Sub_Broker    
          When @StatusId = 'Trader' Then C1.Trader    
          When @StatusId = 'Family' Then C1.Family    
          When @StatusId = 'Client' Then C2.Party_Code    
          Else 'Broker' End)    
     And C1.Branch_Cd like case When @branchcode <> '' Then @branchcode Else  '%' End    
/*    SELECT * FROM #Interest where MBalance > 0 Order By Cltcode, BalanceDate    */
    SELECT * FROM #Interest Order By Cltcode, BalanceDate    
    DROP TABLE #Interest    
   end    
  else if upper(rtrim(@reporttype)) = 'FAMILY'    
   begin    
    Select    
     BalanceDate,    
     C1.Family,    
     Short_Name = C1.Long_Name ,    
     Balance,    
     Interest=abs(Interest),    
     MBalance,    
     MInterest=abs(MInterest),    
     IntRateCr,    
     IntRateDr    
    INTO #Interest1    
    From    
     Tbl_Report_Interest_Margin with(index(indxIntBal_Margin)),    
     msaJag.dbo.Client1 C1 (nolock),    
     msaJag.dbo.Client2 C2 (noLock)    
    Where    
     C1.Cl_Code = C2.Cl_Code    
     And Tbl_Report_Interest_Margin.Cltcode = C2.Party_Code    
     And BalanceDate Between @fromdt And @todate + ' 23:59'    
     And C1.Family Between @fromparty And @toparty    
     And C1.branch_cd like case When @branchcode <> '' Then @branchcode Else  '%' End    
     And @StatusName = (Case When @StatusId = 'Region' Then C1.Region    
          When @StatusId = 'Area' Then C1.Area    
          When @StatusId = 'Branch' Then C1.Branch_Cd    
          When @StatusId = 'SubBroker' Then C1.Sub_Broker    
          When @StatusId = 'Trader' Then C1.Trader    
          When @StatusId = 'Family' Then C1.Family    
          When @StatusId = 'Client' Then C2.Party_Code    
          Else 'Broker' End)    
    SELECT * FROM #Interest1 Order By Family    
    DROP TABLE #Interest1    
   End    
  else if upper(rtrim(@reporttype)) = 'FAMILYPARTY'    
   begin    
    Select    
     BalanceDate,    
     CltCode = C2.Party_Code,    
     Short_Name = C1.Long_Name,    
     Balance,    
     Interest=abs(Interest),    
     MBalance,    
     MInterest=abs(MInterest),    
     IntRateCr,    
     IntRateDr    
    Into #Interest2    
    From    
 	 Tbl_Report_Interest_Margin with(index(indxIntBal_Margin)),    
     msaJag.dbo.Client1 C1 (noLock),    
     msaJag.dbo.Client2 C2 (noLock)    
    Where    
     C1.Cl_Code = C2.Cl_Code    
     And Tbl_Report_Interest_Margin.Cltcode = C2.Party_Code    
     And BalanceDate Between @fromdt And @todate + ' 23:59'    
     And C1.Family Between @fromparty And @toparty    
     And C1.branch_cd like case When @branchcode <> '' Then @branchcode Else  '%' End    
     And @StatusName = (Case When @StatusId = 'Region' Then C1.Region    
          When @StatusId = 'Area' Then C1.Area    
          When @StatusId = 'Branch' Then C1.Branch_Cd    
          When @StatusId = 'SubBroker' Then C1.Sub_Broker    
          When @StatusId = 'Trader' Then C1.Trader    
          When @StatusId = 'Family' Then C1.Family    
          When @StatusId = 'Client' Then C2.Party_Code    
          Else 'Broker' End)    
    SELECT * FROM #Interest2 Order By CltCode    
    DROP TABLE #Interest2    
   End    
 End    
else    
--Print 'vinay '
 Begin    
  if upper(rtrim(@reporttype)) = 'PARTY'    
   begin    
    Select    
     Cltcode = C2.Party_Code,    
     Short_Name = C1.Long_Name,    
     InterestDr = Sum(Case When Balance > 0 Then Interest Else 0 End),    
     InterestCr =abs(Sum(Case When Balance < 0 Then Interest Else 0 End)),    
     MInterestCr =abs(Sum(Case When MBalance < 0 Then MInterest Else 0 End)),    
     IntRateCr,    
     IntRateDr,    
--     netInterest  =  abs(Sum(Case When Balance > 0 Then Interest Else 0 End) - (abs(Sum(Case When Balance < 0 Then Interest Else 0 End)) + abs(Sum(Case When MBalance < 0 Then MInterest Else 0 End))))  
     netInterest  =   (abs(Sum(Case When Balance < 0 Then Interest Else 0 End)) + abs(Sum(Case When MBalance < 0 Then MInterest Else 0 End))) - Sum(Case When Balance > 0 Then Interest Else 0 End)  
    INTO #Interest3    
    From    
     Tbl_Report_Interest_Margin with(index(indxIntBal_Margin)),    
     msaJag.dbo.Client1 C1 (noLock),    
     msaJag.dbo.Client2 C2 (noLock)    
    Where    
     C1.Cl_Code = C2.Cl_Code    
     And Tbl_Report_Interest_Margin.Cltcode = C2.party_Code    
     And BalanceDate Between @fromdt And @todate + ' 23:59'    
     And C2.Party_Code Between @fromparty And @toparty    
     And C1.Branch_Cd like case When @branchcode <> '' Then @branchcode Else  '%' End    
     And @StatusName = (Case When @StatusId = 'Region' Then C1.Region    
          When @StatusId = 'Area' Then C1.Area    
          When @StatusId = 'Branch' Then C1.Branch_Cd    
          When @StatusId = 'SubBroker' Then C1.Sub_Broker    
          When @StatusId = 'Trader' Then C1.Trader    
          When @StatusId = 'Family' Then C1.Family    
          When @StatusId = 'Client' Then C2.Party_Code    
          Else 'Broker' End)    
    Group By    
     C2.Party_Code,    
     C1.Long_Name,    
     IntRateDr,    
     IntRateCr    
      SELECT * FROM #Interest3 where (InterestDr<>0 or InterestCr<>0)  Order By Cltcode    
--	  SELECT * FROM #Interest3 Order By Cltcode    
    DROP TABLE #Interest3    
   End    
 End

GO
