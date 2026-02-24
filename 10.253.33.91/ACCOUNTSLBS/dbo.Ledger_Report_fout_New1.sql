-- Object: PROCEDURE dbo.Ledger_Report_fout_New1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



--insert into Owner select * from gunavatta.account.dbo.Owner
/****** Object:  Stored Procedure dbo.Ledger_Report_fout_New1    Script Date: 10/06/2004 5:29:07 PM ******/    
/****** Object:  Stored Procedure dbo.Ledger_Report_fout    Script Date: 09/14/2004 5:39:20 PM ******/              
              
/****** Object:  Stored Procedure dbo.Ledger_Report_fout    Script Date: 07/26/2004 5:48:37 PM ******/              
              
/****** Object:  Stored Procedure dbo.Ledger_Report_fout    Script Date: 07/24/2004 7:58:51 PM ******/              
              
              
/****** Object:  Stored Procedure dbo.Ledger_Report_fout    Script Date: 4/4/2004 3:47:46 PM ******/              
--exec Ledger_Report_fout 'MAR 1 2004','000501','A F PAREKH ','000501'              
--exec Ledger_Report_fout 'MAR 1 2004','000502','A H NAVSARIWALA '               
              
CREATE  PROCEDURE Ledger_Report_fout_New1              
(@FromDate as Varchar(11),              
@FromCltcode as varchar(10),              
@ToCltcode as varchar(10),              
@Opt                 as Varchar(10),              
@statusid as varchar(25),              
@statusname as varchar(50),              
@session as varchar(25),        
@reportopt as varchar(1))              
AS              
              
DECLARE @FAACTUAL1 Money              
DECLARE @FAACTUAL2 Money              
DECLARE @FAACTUAL3 Money              
DECLARE @FAACTUAL4 Money              
DECLARE @FAACTUAL5 Money              
DECLARE @FAACTUAL6 Money              
              
--lete from LedgerBalances where sessionid = @session              
/*              
if upper(@statusid) = 'BRANCH'              
begin              
 if @Opt = 'FAMILY'               
 Begin              
  insert Into LedgerBalances              
  Select Family,Party_code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.ClientMaster Where Family >= @FromCltCode               
  And Family <= @ToCltCode and Branch_cd = @statusname              
 End              
 Else              
 Begin              
  insert Into LedgerBalances              
  Select Family,Party_code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.ClientMaster Where Party_Code >= @FromCltCode               
  And Party_Code <= @ToCltCode and Branch_cd = @statusname              
 End              
end              
else              
begin              
 if @Opt = 'FAMILY'               
 Begin              
  insert Into LedgerBalances              
  Select Family,Party_code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.ClientMaster Where Family >= @FromCltCode               
  And Family <= @ToCltCode               
 End              
 Else              
 Begin              
  insert Into LedgerBalances              
  Select Family,Party_code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.ClientMaster Where Party_Code >= @FromCltCode               
  And Party_Code <= @ToCltCode               
 End              
end              
*/              
            
Create table #LedgerBalances            
(            
FamilyCode  varchar(50),            
CLTCODE     varchar(50),            
ACNAME       varchar(100),            
NSEBALANCE money,            
BSEBALANCE money,            
NSEFOBALANCE money,            
NSEESTIMATED1 money,            
NSEESTIMATED2 money,            
BSEESTIMATED1 money,            
BSEESTIMATED2 money,            
FAActual money,            
NonCash  money,            
Cash  money,            
IMMargin money,            
VarMargin money,            
sessionid varchar(25)            
)            
              
if upper(@statusid) = 'BRANCH'              
begin              
 if @Opt = 'BRANCH'               
 Begin              
  insert Into #LedgerBalances              
  Select Branch_cd,Cl_code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Branch_cd >= @FromCltCode               
  And Branch_cd <= @ToCltCode and Branch_cd = @statusname              
 End              
 else if @Opt = 'FAMILY'               
 Begin              
  insert Into #LedgerBalances              
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Family >= @FromCltCode               
  And Family <= @ToCltCode and Branch_cd = @statusname              
 End               
 else if @Opt = 'SUBBROKER'               
 Begin              
  insert Into #LedgerBalances              
  Select sub_broker,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where sub_broker >= @FromCltCode               
  And sub_broker <= @ToCltCode and Branch_cd = @statusname              
 End               
 else if @Opt = 'TRADER'               
 Begin              
  insert Into #LedgerBalances              
  Select trader,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where trader >= @FromCltCode               
  And trader <= @ToCltCode and Branch_cd = @statusname              
 End              
 else if @Opt = 'AREA'               
 Begin              
  insert Into #LedgerBalances              
  Select area,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where area >= @FromCltCode               
  And area <= @ToCltCode and Branch_cd = @statusname              
 End              
 Else              
 Begin              
  insert Into #LedgerBalances              
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Cl_Code >= @FromCltCode               
  And Cl_Code <= @ToCltCode and Branch_cd = @statusname              
 End              
end              
else if upper(@statusid) = 'BROKER'            
begin              
 if @Opt = 'BRANCH'               
 Begin              
  insert Into #LedgerBalances              
  Select branch_cd,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where branch_cd >= @FromCltCode               
  And branch_cd <= @ToCltCode               
 end              
 else if @Opt = 'FAMILY'               
 Begin              
  insert Into #LedgerBalances              
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Family >= @FromCltCode               
  And Family <= @ToCltCode               
 End              
 else if @Opt = 'SUBBROKER'               
 Begin              
  insert Into #LedgerBalances              
  Select sub_broker,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where sub_broker >= @FromCltCode               
  And sub_broker <= @ToCltCode              
 End               
 else if @Opt = 'TRADER'               
 Begin              
  insert Into #LedgerBalances              
  Select trader,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where trader >= @FromCltCode               
  And trader <= @ToCltCode              
 End              
 else if @Opt = 'AREA'               
 Begin              
  insert Into #LedgerBalances              
  Select area,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where area >= @FromCltCode               
  And area <= @ToCltCode              
 End      
 Else              
 Begin              
  insert Into #LedgerBalances              
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Cl_Code >= @FromCltCode               
  And Cl_Code <= @ToCltCode    
 End              
end            
 Else              
begin              
 if @Opt = 'FAMILY'               
 Begin              
  insert Into #LedgerBalances              
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Family >= @FromCltCode               
  And Family <= @ToCltCode and Sub_Broker = @statusname    
 End              
 else if @Opt = 'SUBBROKER'           
 Begin              
  insert Into #LedgerBalances              
  Select sub_broker,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where sub_broker >= @FromCltCode               
  And sub_broker <= @ToCltCode and Sub_Broker = @statusname    
 End               
 Else              
 Begin              
  insert Into #LedgerBalances      
  Select Family,Cl_Code, Long_Name, 0,0,0,0,0,0,0,0,0,0,0,0,@session              
  From MSAJAG.DBO.Client1 Where Cl_Code >= @FromCltCode               
  And Cl_Code <= @ToCltCode and Sub_Broker = @statusname    
 End              
end     
          
          
select * into #EDTNSELedger from ACCOUNT.DBO.LEDGER where 1=2          
select * into #VDTNSELedger from ACCOUNT.DBO.LEDGER where 1=2          
select * into #EDTBSELedger from ACCOUNTBSE.DBO.LEDGER where 1=2          
select * into #VDTBSELedger from ACCOUNTBSE.DBO.LEDGER where 1=2          
/*select * into #EDTFOLedger from ACCOUNTFO.DBO.LEDGER where 1=2          
select * into #VDTFOLedger from ACCOUNTFO.DBO.LEDGER where 1=2          */
      
      
          
if @Opt = 'BRANCH'          
begin          
--NSE Ledger          
 insert into #EDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           
          
 insert into #VDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           
--BSE Ledger          
 insert into #EDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           
          
 insert into #VDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           
          
--FO Ledger          
/* insert into #EDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           
          
 insert into #VDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Branch_cd >= @FromCltCode               
 and Branch_cd <= @ToCltCode           */
          
end          
else if @Opt = 'FAMILY'          
begin          
--NSE Ledger          
 insert into #EDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Family >= @FromCltCode               
 And Family <= @ToCltCode           
          
 insert into #VDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Family >= @FromCltCode               
 And Family <= @ToCltCode           
          
--BSE Ledger          
 insert into #EDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Family >= @FromCltCode               
 And Family <= @ToCltCode           
          
 insert into #VDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code    
 and Family >= @FromCltCode               
 And Family <= @ToCltCode           
          
--FO Ledger          
/* insert into #EDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and Family >= @FromCltCode               
 And Family <= @ToCltCode           
          
 insert into #VDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
and Family >= @FromCltCode               
 And Family <= @ToCltCode          */
end          
else if @Opt = 'SUBBROKER'          
begin           
--NSE Ledger          
 insert into #EDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           
          
 insert into #VDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           
--BSE Ledger          
 insert into #EDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           
          
 insert into #VDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           
          
--FO Ledger          
/* insert into #EDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           
          
 insert into #VDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
and sub_broker >= @FromCltCode               
 And sub_broker <= @ToCltCode           */
end          
else if @Opt = 'TRADER'               
begin           
--NSE Ledger          
 insert into #EDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode               
          
 insert into #VDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode         
          
--BSE Ledger          
 insert into #EDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode               
          
 insert into #VDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode               
          
--FO Ledger          
/* insert into #EDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode               
          
 insert into #VDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and trader >= @FromCltCode               
 And trader <= @ToCltCode               */
          
end          
else if @Opt = 'AREA'               
begin           
--NSE Ledger          
 insert into #EDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               
          
 insert into #VDTNSELedger select ACCOUNT.DBO.LEDGER.* from ACCOUNT.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'       
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               
          
--BSE Ledger          
 insert into #EDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               
          
 insert into #VDTBSELedger select ACCOUNTBSE.DBO.LEDGER.* from ACCOUNTBSE.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               
          
--FO Ledger          
/* insert into #EDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               
          
 insert into #VDTFOLedger select ACCOUNTFO.DBO.LEDGER.* from ACCOUNTFO.DBO.LEDGER,MSAJAG.DBO.Client1          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode=cl_code          
 and area >= @FromCltCode               
 And area <= @ToCltCode               */
          
end          
else          
begin           
--NSE Ledger          
 insert into #EDTNSELedger select * from ACCOUNT.DBO.LEDGER          
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          
          
 insert into #VDTNSELedger select * from ACCOUNT.DBO.LEDGER          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          
          
--BSE Ledger          
 insert into #EDTBSELedger select * from ACCOUNTBSE.DBO.LEDGER           
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          
          
 insert into #VDTBSELedger select * from ACCOUNTBSE.DBO.LEDGER        where VDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          
          
--FO Ledger          
/* insert into #EDTFOLedger select * from ACCOUNTFO.DBO.LEDGER           
 where EDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          
          
 insert into #VDTFOLedger select * from ACCOUNTFO.DBO.LEDGER          
 where VDT <= @FromDate + ' 23:59:59'          
 and cltcode >= @FromCltCode          
 And cltcode <= @ToCltCode          */
          
end          
      
      
          
/*          
update #LedgerBalances set NSEBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21)  Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set NSEBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTNSELedger L, ACCOUNT.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21)  Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
          
/*            
update #LedgerBalances set NSEBALANCE = NSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set NSEBALANCE = NSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #VDTNSELedger L, ACCOUNT.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
/*             
update #LedgerBalances set NSEBALANCE = NSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set NSEBALANCE = NSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTNSELedger L, ACCOUNT.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
/*           
update #LedgerBalances set BSEBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set BSEBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTBSELedger L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
/*              
update #LedgerBalances set BSEBALANCE = BSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A       
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set BSEBALANCE = BSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #VDTBSELedger L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
/*              
update #LedgerBalances set BSEBALANCE = BSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A           
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
update #LedgerBalances set BSEBALANCE = BSEBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTBSELedger L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
          
/*              
update #LedgerBalances set NSEFOBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session         
*/          
          
/*update #LedgerBalances set NSEFOBALANCE = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTFOLedger L, ACCOUNTFO.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp not in (2,15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               */
          
/*              
update #LedgerBalances set NSEFOBALANCE = NSEFOBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
/*update #LedgerBalances set NSEFOBALANCE = NSEFOBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #VDTFOLedger L, ACCOUNTFO.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               */
          
/*              
update #LedgerBalances set NSEFOBALANCE = NSEFOBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
*/          
          
/*update #LedgerBalances set NSEFOBALANCE = NSEFOBALANCE + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM #EDTFOLedger L, ACCOUNTFO.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp in (15,21) Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               */
          
drop table #EDTNSELedger          
drop table #VDTNSELedger          
drop table #EDTBSELedger          
drop table #VDTBSELedger          
--drop table #EDTFOLedger          
--drop table #VDTFOLedger          
          
              
Select Exc='NSE', Vdt, CltCode,Amount=CONVERT(NUMERIC(18,4),isnull(Sum(Case When DrCr = 'D' Then Vamt Else -Vamt End),0) )              
Into #LdegerEstimate From ACCOUNT.DBO.LEDGER L, MSAJAG.DBO.Sett_Mst S               
Where L.narration Like '%' + RTrim(Sett_No) + 'NSECM' + RTrim(Sett_Type) + '%'               
And Vdt >= S.Start_Date And Vdt <= S.Sec_PayIn And Vdt <= @FromDate + ' 23:59:59'              
And Vtyp in (15,21) AND Edt >= @FromDate + ' 23:59:59' and L.cltcode >= @FromCltcode and L.cltcode <= @ToCltcode               
Group By VDT,CltCode              
              
Insert Into #LdegerEstimate               
Select Exc='BSE', Vdt,CltCode,Amount=CONVERT(NUMERIC(18,4),isnull(Sum(Case When DrCr = 'D' Then Vamt Else -Vamt End),0) )              
From ACCOUNTBSE.DBO.LEDGER L, BSEDB.DBO.Sett_Mst S               
Where L.narration Like '%' + RTrim(Sett_No) + 'BSECM' + RTrim(Sett_Type) + '%'               
And Vdt >= S.Start_Date And Vdt <= S.Sec_PayIn And Vdt <= @FromDate + ' 23:59:59'              
And Vtyp in (15,21) AND Edt >= @FromDate + ' 23:59:59' and L.cltcode >= @FromCltcode and L.cltcode <= @ToCltcode               
Group By VDT,CltCode               
              
update #LedgerBalances set NSEESTIMATED1 = Amount From (Select CltCode, Amount=IsNull(Sum(Amount),0) From #LdegerEstimate L              
Where Vdt Like (Select Left(Convert(Varchar,Min(Vdt),109),11) + '%' From #LdegerEstimate Where L.Exc = Exc And Exc = 'NSE' ) Group By CltCode ) A              
Where #LedgerBalances.cltcode=A.Cltcode and sessionid = @session               
              
update #LedgerBalances set NSEESTIMATED2 = Amount From (Select CltCode, Amount=IsNull(Sum(Amount),0) From #LdegerEstimate L              
Where Vdt Not Like (Select Left(Convert(Varchar,Min(Vdt),109),11) + '%' From #LdegerEstimate Where L.Exc = Exc And Exc = 'NSE' ) Group By CltCode ) A              
Where #LedgerBalances.cltcode=A.Cltcode and sessionid = @session               
              
update #LedgerBalances set BSEESTIMATED1 = Amount From (Select CltCode, Amount=IsNull(Sum(Amount),0) From #LdegerEstimate L              
Where Vdt Like (Select Left(Convert(Varchar,Min(Vdt),109),11) + '%' From #LdegerEstimate Where L.Exc = Exc And Exc = 'BSE' ) Group By CltCode ) A              
Where #LedgerBalances.cltcode=A.Cltcode and sessionid = @session               
              
update #LedgerBalances set BSEESTIMATED2 = Amount From (Select CltCode, Amount=IsNull(Sum(Amount),0) From #LdegerEstimate L              
Where Vdt Not Like (Select Left(Convert(Varchar,Min(Vdt),109),11) + '%' From #LdegerEstimate Where L.Exc = Exc And Exc = 'BSE') Group By CltCode ) A              
Where #LedgerBalances.cltcode=A.Cltcode and sessionid = @session               
              
update #LedgerBalances set FAACTUAL = Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp <> 2 Group By CltCode) A               
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
              
update #LedgerBalances set FAACTUAL = FAACTUAL + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNT.DBO.LEDGER L, ACCOUNT.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
              
update #LedgerBalances set FAACTUAL = FAACTUAL + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp <> 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
              
update #LedgerBalances set FAACTUAL =  FAACTUAL + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTBSE.DBO.LEDGER L, ACCOUNTBSE.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               
              
/*update #LedgerBalances set FAACTUAL = FAACTUAL + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P              
WHERE VDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp <> 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               */
              
/*update #LedgerBalances set FAACTUAL = FAACTUAL + Amt From (SELECT CltCode, Amt = CONVERT(NUMERIC(18,4),ISNULL(SUM(CASE WHEN L.DRCR = 'D' THEN VAMT ELSE -VAMT END),0))              
FROM ACCOUNTFO.DBO.LEDGER L, ACCOUNTFO.DBO.PARAMETER P              
WHERE EDT <= @FromDate + ' 23:59:59' AND VDT >= SDTCUR AND VDT<= ldtcur              
And @FromDate BetWeen SDTCUR And ldtcur And Vtyp = 2 Group By CltCode) A              
where #LedgerBalances.cltcode=A.cltcode and sessionid = @session               */
              
Update #LedgerBalances Set NonCash = C.NonCash, Cash = C.Cash              
From MSAJAG.DBO.Collateral C               
Where Trans_Date Like @FromDate +'%'               
And #LedgerBalances.cltcode=C.Party_Code and sessionid = @session               
              
/*Update #LedgerBalances Set IMMargin = IsNull(Margin,0) From (Select Party_Code, Margin = Sum(PspanMargin)                
From NSEFO.DBO.FoMarginNew F Where Mdate = (Select Max(MDate) From NSEFO.DBO.FoMarginNew Where MDate <= @FromDate +' 23:59:59' )         
Group By Party_Code ) A              
Where #LedgerBalances.cltcode=A.Party_Code and sessionid = @session               */
              
/*Update #LedgerBalances Set VarMargin = IsNull(VMargin,0) From (Select Party_Code, VMargin = Sum(MtoM)                
From NSEFO.DBO.FoMarginNew F Where Mdate = (Select Max(MDate) From NSEFO.DBO.FoMarginNew Where MDate <= @FromDate +' 23:59:59' )         
Group By Party_Code ) A              
Where #LedgerBalances.cltcode=A.Party_Code and sessionid = @session        */
              
Update #LedgerBalances Set NonCash = (Case When (IMMargin + VarMargin) / 2 < NonCash Then  (IMMargin + VarMargin) / 2 Else nonCash End)         
where sessionid = @session               
              
Delete From #LedgerBalances               
Where NSEBALANCE   = 0               
And BSEBALANCE      = 0               
And NSEFOBALANCE  = 0               
And NSEESTIMATED1 = 0               
And NSEESTIMATED2 = 0               
And BSEESTIMATED1 = 0               
And BSEESTIMATED2 = 0               
And FAActual           = 0               
And NonCash           = 0               
And Cash                = 0               
And IMMargin           = 0               
And VarMargin         = 0              
and sessionid = @session               
          
--insert into LedgerBalances select * from #LedgerBalances              
--select * from #LedgerBalances  order by FamilyCode,CltCode          
/*          
if @Opt <> 'CLIENT'          
begin          
 if @Opt = 'BRANCH'          
 select FamilyCode,CLTCODE,ACNAME=C.Long_Name,          
 NSEBALANCE=Sum(NSEBALANCE),BSEBALANCE=Sum(BSEBALANCE),          
 NSEFOBALANCE=Sum(NSEFOBALANCE),NSEESTIMATED1=Sum(NSEESTIMATED1),           
 NSEESTIMATED2=Sum(NSEESTIMATED2),          
 BSEESTIMATED1=Sum(BSEESTIMATED1),BSEESTIMATED2=Sum(BSEESTIMATED2),          
 FAActual=Sum(FAActual),Res_Phone1,Cash=Sum(Cash),NonCash=Sum(NonCash),          
 IMMargin=Sum(IMMargin),VarMargin=Sum(VarMargin)           
 from LedgerBalances L, MSAJAG.DBO.Client1 C           
 Where C.Cl_Code = L.CltCode and sessionid=@session          
 Group By FamilyCode,c.branch_cd,C.Long_Name,Res_Phone1           
 Order By FamilyCode,CLTCODE,C.Long_Name,Res_Phone1          
          
end          
Else          
begin          
 select FamilyCode,CLTCODE,ACNAME,NSEBALANCE,BSEBALANCE,NSEFOBALANCE,NSEESTIMATED1,NSEESTIMATED2,           
 BSEESTIMATED1,BSEESTIMATED2,FAActual,Res_Phone1,Cash,NonCash,IMMargin,VarMargin           
 from LedgerBalances L,MSAJAG.DBO.ClientMaster C           
 Where C.Party_Code = L.CltCode and sessionid=@session          
 Order By FamilyCode,CLTCODE,C.Long_Name,Res_Phone1           
end          
*/            
if @reportopt='D'        
begin        
 select FamilyCode,CLTCODE,ACNAME,NSEBALANCE,BSEBALANCE,NSEFOBALANCE,NSEESTIMATED1,NSEESTIMATED2,           
 BSEESTIMATED1,BSEESTIMATED2,FAActual,Res_Phone1,Cash,NonCash,IMMargin,VarMargin           
 from #LedgerBalances L,MSAJAG.DBO.ClientMaster C           
 Where C.Party_Code = L.CltCode and sessionid=@session          
 Order By FamilyCode,CLTCODE,C.Long_Name,Res_Phone1           
end        
else        
begin        
-- select FamilyCode,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
-- sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
-- sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
-- sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
-- sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
-- sum(FAActual) as TotFAACTUAL,        
-- sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
-- sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
-- sum(FAActual -         
-- (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)         
-- + IMMargin + VarMargin - NONCASH - CASH) as TotFinTotalParty           
-- from #LedgerBalances L,MSAJAG.DBO.ClientMaster C           
-- Where C.Party_Code = L.CltCode and sessionid=@session          
-- group By FamilyCode        
-- Order By FamilyCode        
      
 if @Opt = 'BRANCH'      
 begin      
/*    
   select c.branch_cd as FamilyCode,b.branch as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual -         
   (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)         
   + IMMargin + VarMargin - NONCASH - CASH) as TotFinTotalParty           
   from #LedgerBalances L,MSAJAG.DBO.Client1 C , MSAJAG.DBO.Branch B          
   Where C.Cl_Code = L.CltCode and c.branch_cd=b.branch_code and sessionid=@session          
   group By c.branch_cd,b.branch      
   Order By c.branch_cd      
*/    
   select c.branch_cd as FamilyCode,b.branch as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty              
   from #LedgerBalances L,MSAJAG.DBO.Client1 C , MSAJAG.DBO.Branch B          
   Where C.Cl_Code = L.CltCode and c.branch_cd=b.branch_code and sessionid=@session          
   group By c.branch_cd,b.branch      
   Order By c.branch_cd      
    
 end      
 else if @Opt = 'FAMILY'      
 begin      
   select FamilyCode,FamilyCode as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
  sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
  sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
  sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
  sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
  sum(FAActual) as TotFAACTUAL,        
  sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
  sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
  sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty             
  from #LedgerBalances L,MSAJAG.DBO.ClientMaster C           
  Where C.Party_Code = L.CltCode and sessionid=@session          
  group By FamilyCode        
  Order By FamilyCode        
 end      
 else if @Opt = 'SUBBROKER'      
 begin      
   select c.sub_broker as FamilyCode,b.Name as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty              
   from #LedgerBalances L,MSAJAG.DBO.Client1 C,MSAJAG.DBO.SubBrokers B           
   Where C.Cl_Code = L.CltCode and c.sub_broker=b.sub_broker and sessionid=@session          
   group By c.sub_broker,b.Name      
   Order By c.sub_broker      
 end      
 else if @Opt = 'TRADER'      
 begin      
   select c.trader as FamilyCode,b.short_name as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty              
   from #LedgerBalances L,MSAJAG.DBO.Client1 C , MSAJAG.DBO.Branches B          
   Where C.Cl_Code = L.CltCode and c.branch_cd=b.branch_cd and sessionid=@session          
   group By c.trader,b.short_name      
   Order By c.trader      
 end      
 else if @Opt = 'AREA'      
 begin      
   select c.area as FamilyCode,b.description as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty              
   from #LedgerBalances L,MSAJAG.DBO.Client1 C,MSAJAG.DBO.Area B           
   Where C.Cl_Code = L.CltCode and c.area=b.areacode and sessionid=@session          
   group By c.area,b.description      
   Order By c.area       
 end      
 else      
 begin      
   select c.cl_code as FamilyCode,c.short_name as AcName,sum(NSEBALANCE) as TotNSEBALANCE,sum(BSEBALANCE) as TotBSEBALANCE,sum(NSEFOBALANCE) as TotNSEFOBALANCE,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE ) as TotTotalParty,        
   sum(NSEESTIMATED1) as TotNSEESTIMATED1,sum(NSEESTIMATED2) as TotNSEESTIMATED2,           
   sum(BSEESTIMATED1) as TotBSEESTIMATED1,sum(BSEESTIMATED2) as TotBSEESTIMATED2,        
   sum(NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2) as TotEstimateTotalParty,        
   sum(FAActual) as TotFAACTUAL,        
   sum(FAActual - (NSEBALANCE + BSEBALANCE + NSEFOBALANCE + NSEESTIMATED1 + NSEESTIMATED2 + BSEESTIMATED1 + BSEESTIMATED2)) as TotFANETPARTY,        
   sum(Cash) as TotCASH,sum(NonCash) as TotNonCash, sum(IMMargin) as TotIMMargin,sum(VarMargin) as TotVarMargin,        
   sum(FAActual + IMMargin + VarMargin + NONCASH + CASH) as TotFinTotalParty           
   from #LedgerBalances L,MSAJAG.DBO.Client1 C           
   Where C.Cl_Code = L.CltCode and sessionid=@session          
   group By c.cl_code,c.Short_Name      
   Order By cl_code        
 end      
end           
          
drop table #LedgerBalances

GO
