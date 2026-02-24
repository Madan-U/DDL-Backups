-- Object: PROCEDURE dbo.V2_DelBranchMark_Approval
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE    Proc [dbo].[V2_DelBranchMark_Approval]      
(      
 @BenType Varchar(4),    
 @ProcessTime Varchar(10),    
 @FromParty Varchar(10) = '0',    
 @ToParty Varchar(10) = 'ZZZZZZZZZZ'    
)      
      
AS      
       
DECLARE @Sauda_Date Varchar(11),    
@LedProcessFlag Varchar(3)    
    
if Len(@ProcessTime) = 0     
 Select @ProcessTime = ' ' +convert(varchar,GetDate(),108)     
    
Select Top 1 @LedProcessFlag = ProcessFor From delbranchMark_Settings    
--Select @LedProcessFlag       

Update DelBranchMark_New 
Set ReqDate = ReqSubDate, ReqBy = ReqSubBy, ReqFlag = 0
Where ReqSubDate <= Left(GetDate(),11) + @ProcessTime      
And ReqSubDate > 'Jan  1 1900 23:59' And ReqQty > 0       
And HoldType = @BenType 
And ReqDate Like 'JAN  1 1900%'
And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 And ReqFlag > 0    
And Party_Code between @FromParty And @ToParty
  
Select Distinct Party_Code into #del_New From DelBranchMark_New    
Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 
  
IF (SELECT ISNULL(COUNT(1),0) FROM #del_New ) > 0   
BEGIN  
  
CREATE INDEX [DELPOS]   
ON [dbo].[#DEL_NEW]   
(   
        [PARTY_CODE]  
)   
  
      
Select Party_Code = Convert(Varchar(10),''),       
AprNSECMAmount = Convert(Numeric(18,4),0),      
AprBSECMAmount = Convert(Numeric(18,4),0),      
AprNSEFOAmount = Convert(Numeric(18,4),0),      
AprMCDXAmount = Convert(Numeric(18,4),0),      
AprNCDXAmount = Convert(Numeric(18,4),0),      
Amount = Convert(Numeric(18,4),0)      
      
Into #Payout_Ledger      
      
If @LedProcessFlag = 'RMS'       
Begin       
 Insert into #Payout_Ledger                   
 SELECT R.Party_Code, 0, 0, 0, 0, 0, NB_Allowed  
 FROM MSAJAG.DBO.RMSALLSEGMENT R, #DEL_NEW D 
 WHERE SAUDA_DATE = (SELECT MAX(SAUDA_DATE) FROM MSAJAG.DBO.RMSALLSEGMENT)   
 AND R.PARTY_CODE = D.PARTY_CODE  
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
End      

If @LedProcessFlag = 'RMSCUST'       
Begin       
 Insert into #Payout_Ledger                   
 SELECT R.Party_Code, 0, 0, 0, 0, 0, FREEMARGIN = round(((STOCKN*70/100) + (STOCKY*50/100) + (nb_ledger_voc_bal) + (tot_collateral_nb) - (payinafterhaircut*130/100)),4)  
 FROM MSAJAG.DBO.RMSALLSEGMENT R, #DEL_NEW D 
 WHERE SAUDA_DATE = (SELECT MAX(SAUDA_DATE) FROM MSAJAG.DBO.RMSALLSEGMENT)   
 AND R.PARTY_CODE = D.PARTY_CODE  
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty   
End 

      
If @LedProcessFlag = 'EDT'       
Begin        
      Insert into #Payout_Ledger                   
      select       
            CltCode,      
            NSEAmount = isnull(sum(Case When L.DrCr = 'D'     
                Then -Vamt     
              Else +Vamt     
            End),0),    
     0, 0, 0, 0, 0       
        
      from       
            Account.DBO.Ledger L,       
            Account.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Edt >= SdtCur          
            And Edt <= LdtCur           
            And Curyear = 1     
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
      AND APRQTY = 0           
     And CltCode = Party_Code )    
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode    
    
/*=========================================================================================================      
      QueryFlag = 4 : Effective Date Wise Reverse Effect for over-lapping Reciept Entries.      
=========================================================================================================*/      
      Insert into #Payout_Ledger            
      select       
            CltCode,      
            NSEAmount = isnull(sum(Case When L.DrCr = 'D'     
                Then Vamt     
              Else -Vamt     
            End),0),    
     0, 0, 0, 0, 0      
      from       
            Account.DBO.Ledger L,       
            Account.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Vdt < SdtCur          
            And Edt >= SdtCur    
            And Edt <= LdtCur           
            And Curyear = 1    
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0      
     And CltCode = Party_Code )   
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode    
      
      Insert into #Payout_Ledger                   
      select       
            CltCode, 0,       
            BSEAmount = isnull(sum(Case When L.DrCr = 'D'     
                Then -Vamt     
              Else +Vamt     
            End),0),      
    0, 0, 0, 0      
        
      from       
            AccountBSE.DBO.Ledger L,       
            AccountBSE.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Edt >= SdtCur          
            And Edt <= LdtCur           
            And Curyear = 1       
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0     
     And CltCode = Party_Code )    
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode        
    
/*=========================================================================================================      
      QueryFlag = 4 : Effective Date Wise Reverse Effect for over-lapping Reciept Entries.      
=========================================================================================================*/      
      Insert into #Payout_Ledger            
      select       
            CltCode, 0,      
            BSEAmount = isnull(sum(Case When L.DrCr = 'D'     
                Then Vamt     
              Else -Vamt     
            End),0),    
     0, 0, 0, 0      
      from       
            AccountBSE.DBO.Ledger L,       
            AccountBSE.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Vdt < SdtCur          
            And Edt >= SdtCur           
            And Edt <= LdtCur           
            And Curyear = 1        
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0  
     And CltCode = Party_Code )    
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode       
End      
      
If @LedProcessFlag = 'VDT'      
Begin       
set transaction isolation level read uncommitted            
/*=========================================================================================================      
      QueryFlag = 4 : Voucher Date Wise Balance      
=========================================================================================================*/      
      Insert into #Payout_Ledger            
      select       
            CltCode,       
            NSEAmount = Sum      
                        (      
                              Case       
                              When L.DrCr = 'D'       
                              Then -Vamt       
                              Else +Vamt       
                              end      
                        ),      
     0, 0, 0, 0, 0      
      from       
            Account.DBO.Ledger L,       
            Account.DBO.Parameter P            
      Where       
            VDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Vdt >= SdtCur          
            And Vdt <= LdtCur           
            And Curyear = 1      
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0  
     And CltCode = Party_Code )    
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode         
      
      Insert into #Payout_Ledger            
      select       
            CltCode, 0,       
            BSEAmount = Sum      
                        (      
                              Case       
                              When L.DrCr = 'D'       
                              Then -Vamt       
       Else +Vamt       
                              end      
                        ),      
    0, 0, 0, 0      
      from       
            AccountBSE.DBO.Ledger L,       
            AccountBSE.DBO.Parameter P            
      Where       
            VDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Vdt >= SdtCur          
            And Vdt <= LdtCur           
            And Curyear = 1           
       And CltCode In (    
       Select Distinct Party_Code From DelBranchMark_New    
     Where ReqDate <= Left(GetDate(),11) + @ProcessTime    
       And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
       And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0  
     And CltCode = Party_Code )    
     And CltCode >= @FromParty And CltCode <= @ToParty         
           Group by CltCode    
       
End      
      
Select * Into #DelBranchMark_New From DelBranchMark_New Where 1 = 2       
    
INSERT INTO DELBRANCHMARK_NEW_LOG     
SELECT *, LOGDATE=GETDATE() From DelBranchMark_New Where HoldType = @BenType    
And ReqFlag > 0 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
And ReqDate > 'Jan  1 1900 23:59'    
And Party_Code >= @FromParty And Party_Code <= @ToParty    
    
Delete From DelBranchMark_New Where HoldType = @BenType    
And ReqFlag > 0  and ReqDate <= Left(GetDate(),11) + @ProcessTime    
And ReqDate > 'Jan  1 1900 23:59'    
And Party_Code >= @FromParty And Party_Code <= @ToParty    
    
if @BenType = 'BEN'     
Begin    
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'BEN',       
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),       
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType = ''  
 From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Not Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER' 
 And AccountType <> 'MAR'	     
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.Series = D.Series      
 And DelBranchMark_New.CertNo = D.CertNo     
 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
   And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
   And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 )    
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId      
       
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'BEN',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),        
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,     
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType = ''  
 From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Not Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER'    
 And AccountType <> 'MAR'
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.CertNo = D.CertNo     
 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
   And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
   And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 )    
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId    
End    

if @BenType = 'MAR'     
Begin    
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'MAR',       
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),       
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType = ''  
 From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Not Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER' 
 And AccountType = 'MAR'	     
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.Series = D.Series      
 And DelBranchMark_New.CertNo = D.CertNo     
 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
   And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
   And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 )    
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId      
       
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'MAR',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),        
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,     
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType = ''  
 From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Not Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER'    
 And AccountType = 'MAR'
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.CertNo = D.CertNo     
 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
   And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
   And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0 )    
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId    
End
    
if @BenType = 'POOL'     
Begin    
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'POOL',       
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),       
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType  
 From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER'      
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.Series = D.Series      
 And DelBranchMark_New.CertNo = D.CertNo     
 and ReqDate <= Left(GetDate(),11) + @ProcessTime    
 And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
 And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0  And BDpType = D.BDpType)    
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId,  BDpType  
       
 Insert Into #DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'POOL',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=0,      
 ReqHoldQty=0,      
 ReqPledgeQty=0,      
 ReqProcessDate='',      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDXAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',      
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=Sum(Qty),      
 AprHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 AprPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),        
 AprProcessDate=GetDate(),      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 0,    
 ReqStatus='',      
 ProcessStatus='APR',    
 Remark = '',    
 PayQty = 0,    
 D.DpId,    
 D.CltDpId,  
 BDpType  
 From BSEDB.DBO.DelTrans D, BSEDB.DBO.DeliveryDp DP, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2      
 Where C1.Cl_Code = C2.Cl_Code      
 And C2.Party_Code = D.Party_Code      
 And Filler2 = 1 And DrCr = 'D'      
 And Delivered = '0'       
 And ShareType = 'DEMAT'      
 And BDpType = DP.DpType      
 And BDpID = Dp.DpId      
 And BCltDpId = DpCltNo      
 And Description Like '%POOL%'      
 And TrType in (904, 909)      
 And D.DpId <> ''      
 And D.Party_Code <> 'BROKER'      
 And Exists (Select Party_Code From DelBranchMark_New    
 Where DelBranchMark_New.Party_Code = D.Party_Code      
 And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
 And DelBranchMark_New.CertNo = D.CertNo     
 And ReqDate <= Left(GetDate(),11) + @ProcessTime    
 And ReqDate > 'Jan  1 1900 23:59' And ReqQty > 0     
 And HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0  And BDpType = D.BDpType)    
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId,BDpType  
End    
    
Update #DelBranchMark_New Set       
AprAmt      = A.Amount,      
AprNSECMAmount = A.AprNSECMAmount,      
AprBSECMAmount = A.AprBSECMAmount,      
AprNSEFOAmount = A.AprNSEFOAmount,      
AprMCDXAmount  = A.AprMCDXAmount,      
AprNCDXAmount  = A.AprNCDXAmount       
From (Select Party_Code,       
      Amount      = Sum(Amount + AprNSECMAmount + AprBSECMAmount + AprNSEFOAmount + AprMCDXAmount + AprNCDXAmount),      
      AprNSECMAmount = Sum(AprNSECMAmount),      
      AprBSECMAmount = Sum(AprBSECMAmount),      
      AprNSEFOAmount = Sum(AprNSEFOAmount),      
      AprMCDXAmount  = Sum(AprMCDXAmount),      
      AprNCDXAmount  = Sum(AprNCDXAmount)      
From #Payout_Ledger Group By Party_Code ) A      
Where #DelBranchMark_New.Party_Code = A.Party_Code      
  
      SELECT         
            C.Scrip_Cd,         
            Series='EQ',         
            C.Cl_Rate,         
            C.SysDate         
      INTO #NSE_LatestClosing         
      FROM MSAJAG.DBO.Closing C,    
 (        
                  SELECT         
                        SYSDATE=MAX(SYSDATE), SCRIP_CD, SERIES = 'EQ'  
                  FROM MSAJAG.DBO.Closing   
    WHERE SERIES In ('BE', 'EQ')     
                  GROUP BY SCRIP_CD  
        ) P  
      WHERE C.SYSDATE = P.SYSDATE         
      AND C.SCRIP_CD = P.SCRIP_CD        
      And C.SERIES In ('BE', 'EQ')       
        
      INSERT INTO #NSE_LatestClosing         
      SELECT         
            C.Scrip_Cd,         
            C.Series,         
            C.Cl_Rate,         
            C.SysDate         
      FROM MSAJAG.DBO.Closing C,    
 (        
                  SELECT         
                        SYSDATE=MAX(SYSDATE), SCRIP_CD, SERIES  
                  FROM MSAJAG.DBO.Closing   
    WHERE SERIES NOT In ('BE', 'EQ')     
                  GROUP BY SCRIP_CD, SERIES  
        ) P  
      WHERE C.SYSDATE = P.SYSDATE         
      AND C.SCRIP_CD = P.SCRIP_CD        
      AND C.SERIES = P.SERIES   
          
      SELECT         
            C.Scrip_Cd,         
            C.Series,         
            C.Cl_Rate,         
            C.SysDate         
      INTO #BSE_LatestClosing         
      FROM BSEDB.DBO.Closing C,(        
                  SELECT         
                        SYSDATE=MAX(SYSDATE), SCRIP_CD, SERIES  
                  FROM BSEDB.DBO.Closing   
                  GROUP BY SCRIP_CD, SERIES  
        ) P   
      WHERE C.SYSDATE = P.SYSDATE         
      AND C.SCRIP_CD = P.SCRIP_CD        
      AND C.SERIES = P.SERIES         
        
      Update         
            #DelBranchMark_New         
      Set         
            Cl_Rate = C.Cl_Rate         
      From         
            #NSE_LatestClosing C         
      Where           
            C.Scrip_Cd = #DelBranchMark_New.Scrip_Cd                    
            And C.Series = (Case When #DelBranchMark_New.Series In ('EQ', 'BE') Then 'EQ' Else #DelBranchMark_New.Series End)        
          And #DelBranchMark_New.Exchg = 'NSE'        
     And #DelBranchMark_New.Party_Code >= @FromParty And #DelBranchMark_New.Party_Code <= @ToParty        
      
      Update         
            #DelBranchMark_New         
      Set         
            Cl_Rate = C.Cl_Rate         
      From         
            #BSE_LatestClosing C         
      Where                     
            C.Scrip_Cd = #DelBranchMark_New.Scrip_Cd                    
            And C.Series = #DelBranchMark_New.Series           
     And #DelBranchMark_New.Exchg = 'BSE'      
     And #DelBranchMark_New.Party_Code >= @FromParty And #DelBranchMark_New.Party_Code <= @ToParty  
      
Update DelBranchMark_New Set       
AprFreeQty     = D.AprFreeQty,       
AprHoldQty     = D.AprHoldQty,       
AprPledgeQty   = D.AprPledgeQty,       
AprProcessDate = D.AprProcessDate,       
AprAmt         = D.AprAmt,      
AprNSECMAmount    = D.AprNSECMAmount,      
AprBSECMAmount    = D.AprBSECMAmount,      
AprNSEFOAmount    = D.AprNSEFOAmount,      
AprMCDXAmount     = D.AprMCDXAmount,      
AprNCDXAmount     = D.AprNCDXAmount,      
ProcessStatus  = D.ProcessStatus,    
DpId           = D.DpId,    
CltDpId        = D.CltDpID,  
CL_RATE        = D.CL_RATE    
From #DelBranchMark_New D      
Where DelBranchMark_New.Exchg = D.Exchg      
And DelBranchMark_New.Party_Code = D.Party_Code      
And DelBranchMark_New.Scrip_Cd = D.Scrip_cd      
And DelBranchMark_New.Series = (Case When D.Exchg = 'BSE' Then DelBranchMark_New.Series Else D.Series End)     
And DelBranchMark_New.CertNo = D.CertNo    
And DelBranchMark_New.HoldType = D.HoldType    
and DelBranchMark_New.ReqDate <= Left(GetDate(),11) + @ProcessTime    
And DelBranchMark_New.ReqDate > 'Jan  1 1900 23:59'    
And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty    
And DelBranchMark_New.BDpType = D.BDpType  
    
Update DelBranchMark_New Set ProcessStatus = 'APR'    
Where HoldType = @BenType And (ProcessStatus = 'REQ' OR ProcessStatus = 'APR')
AND APRQTY = 0     
and ReqDate <= Left(GetDate(),11) + @ProcessTime    
And ReqDate > 'Jan  1 1900 23:59'    
And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty    
  
  
END

GO
