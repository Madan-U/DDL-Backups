-- Object: PROCEDURE dbo.V2_DelBranchMark_Request
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc V2_DelBranchMark_Request       
(      
 @BenType Varchar(4),    
 @FromParty Varchar(10) = '0',    
 @ToParty Varchar(10) = 'ZZZZZZZZZZ'    
)      
--EXEC V2_DelBranchMark_Request 'BEN'    
AS      
    
DECLARE @Sauda_Date Varchar(11),    
@LedProcessFlag Varchar(3)    
    
Select Top 1 @LedProcessFlag = ProcessFor From delbranchMark_Settings    
    
INSERT INTO DELBRANCHMARK_NEW_LOG     
SELECT *, LOGDATE=GETDATE() From DelBranchMark_New Where HoldType = @BenType And ReqStatus <> 'REQ'  
  
Select * Into #DelBranchMark_New_Old   
From DelBranchMark_New  
Where HoldType = @BenType And ReqStatus = 'REQ' And ReqQty > 0  
  
Delete From DelBranchMark_New Where HoldType = @BenType   
  
Select Party_Code = Convert(Varchar(10),''),       
ReqNSECMAmount = Convert(Numeric(18,4),0),      
ReqBSECMAmount = Convert(Numeric(18,4),0),      
ReqNSEFOAmount = Convert(Numeric(18,4),0),      
ReqMCDXAmount = Convert(Numeric(18,4),0),      
ReqNCDXAmount = Convert(Numeric(18,4),0),      
Amount = Convert(Numeric(18,4),0)      
      
Into #Payout_Ledger      
      
If @LedProcessFlag = 'RMS'       
Begin       
      Insert into #Payout_Ledger                   
      SELECT Party_Code, 0, 0, 0, 0, 0, NB_Allowed  
      FROM MSAJAG.DBO.RMSALLSEGMENT WHERE SAUDA_DATE = (SELECT MAX(SAUDA_DATE) FROM MSAJAG.DBO.RMSALLSEGMENT)
      AND Party_Code >= @FromParty And Party_Code <= @ToParty    
End      

If @LedProcessFlag = 'RMSCUST'       
Begin       
 Insert into #Payout_Ledger  
 SELECT Party_Code, 0, 0, 0, 0, 0, FREEMARGIN = round(((STOCKN*70/100) + (STOCKY*50/100) + (nb_ledger_voc_bal) + (tot_collateral_nb) - (payinafterhaircut*130/100)),4) FROM MSAJAG.DBO.RMSALLSEGMENT WHERE SAUDA_DATE = (SELECT MAX(SAUDA_DATE) FROM MSAJAG.DBO.RMSALLSEGMENT) 
 AND Party_Code >= @FromParty And Party_Code <= @ToParty 
End 
      
If @LedProcessFlag = 'EDT'       
Begin        
      Insert into #Payout_Ledger                   
      select       
            CltCode,      
            NSEAmount = sum(Case When L.DrCr = 'D'     
                Then -Vamt     
              Else +Vamt     
            End),    
     0, 0, 0, 0, 0       
        
      from       
            Account.DBO.Ledger L,       
            Account.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Edt >= SdtCur          
            And Edt <= LdtCur           
            And Curyear = 1      
     And CltCode >= @FromParty And CltCode <= @ToParty         
      Group by CltCode            
    
/*=========================================================================================================      
      QueryFlag = 4 : Effective Date Wise Reverse Effect for over-lapping Reciept Entries.      
=========================================================================================================*/      
      Insert into #Payout_Ledger            
      select       
            CltCode,      
            NSEAmount = sum(Case When L.DrCr = 'D'     
                Then Vamt     
              Else -Vamt     
            End),        
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
     And CltCode >= @FromParty And CltCode <= @ToParty         
      Group by CltCode            
      
      Insert into #Payout_Ledger                   
      select       
            CltCode, 0,       
            BSEAmount = sum(Case When L.DrCr = 'D'     
                Then -Vamt     
              Else +Vamt     
            End),      
    0, 0, 0, 0      
        
      from       
            AccountBSE.DBO.Ledger L,       
            AccountBSE.DBO.Parameter P            
      Where       
            EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'              
            And Edt >= SdtCur          
            And Edt <= LdtCur           
            And Curyear = 1           
     And CltCode >= @FromParty And CltCode <= @ToParty             Group by CltCode            
    
/*=========================================================================================================      
      QueryFlag = 4 : Effective Date Wise Reverse Effect for over-lapping Reciept Entries.      
=========================================================================================================*/      
      Insert into #Payout_Ledger            
      select       
            CltCode, 0,      
            BSEAmount = sum(Case When L.DrCr = 'D'     
                Then Vamt     
              Else -Vamt     
            End),        
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
     And CltCode >= @FromParty And CltCode <= @ToParty         
      Group by CltCode       
        
End      
    
If @BenType = 'BEN'     
Begin    
 Insert Into DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),  HoldType = 'BEN',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=Sum(Qty),      
 ReqHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqProcessDate=GetDate(),      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,      
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',    
ReqBy='',      
 ReqDate='',      
 AprFreeQty=0,      
 AprHoldQty=0,      
 AprPledgeQty=0,      
 AprProcessDate='',      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag = 3,    
 ReqStatus='',    
 ProcessStatus='REQ',    
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
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId      
       
 Insert Into DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'BEN',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=Sum(Qty),      
 ReqHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),       
 ReqProcessDate=GetDate(),      
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
 AprFreeQty=0,      
 AprHoldQty=0,      
 AprPledgeQty=0,      
 AprProcessDate='',      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,       
 AprBy='',      
 AprDate='',      
 ReqFlag = 3,    
 ReqStatus='',      
 ProcessStatus='REQ',    
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
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId      
End    
    
If @BenType = 'POOL'     
Begin    
 Insert Into DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End),  HoldType = 'POOL',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=Sum(Qty),      
 ReqHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqProcessDate=GetDate(),      
 ReqNSECMAmount=0,      
 ReqBSECMAmount=0,      
 ReqNSEFOAmount=0,      
 ReqMCDXAmount=0,      
 ReqNCDAmount=0,      
 ReqAmt=0,      
 Cl_Rate=0,    
 ReqQty=0,      
 ReqSubBy='',      
 ReqSubDate='',    
 ReqBy='',      
 ReqDate='',      
 AprFreeQty=0,      
 AprHoldQty=0,      
 AprPledgeQty=0,      
 AprProcessDate='',      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,      
 AprBy='',      
 AprDate='',      
 ReqFlag=3,    
 ReqStatus='',      
 ProcessStatus='REQ',    
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
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId, BDpType    
       
 Insert Into DelBranchMark_New      
 Select Exchg=(Case When RefNo = 110 Then 'NSE' Else 'BSE' End), HoldType = 'POOL',    
 D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo,       
 ReqFreeQty=Sum(Qty),      
 ReqHoldQty=Sum(Case When TrType = 904 And Description Not Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqPledgeQty=Sum(Case When TrType = 909 OR Description Like '%PLEDGE%' Then Qty Else 0 End),      
 ReqProcessDate=GetDate(),      
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
 AprFreeQty=0,      
 AprHoldQty=0,      
 AprPledgeQty=0,      
 AprProcessDate='',      
 AprNSECMAmount=0,      
 AprBSECMAmount=0,      
 AprNSEFOAmount=0,      
 AprMCDXAmount=0,      
 AprNCDXAmount=0,      
 AprAmt=0,      
 AprQty=0,       
 AprBy='',      
 AprDate='',      
 ReqFlag=3,    
 ReqStatus='',      
 ProcessStatus='REQ',    
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
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
 Group By D.Party_Code, C1.Long_Name, Branch_Cd, Sub_Broker, Scrip_CD, Series, CertNo, RefNo, D.DpId, D.CltDpId, BDpType  
End    
    
Update DelBranchMark_New Set       
ReqAmt         = Amount,       
ReqNSECMAmount = A.ReqNSECMAmount,      
ReqBSECMAmount = A.ReqBSECMAmount,      
ReqNSEFOAmount = A.ReqNSEFOAmount,      
ReqMCDXAmount  = A.ReqMCDXAmount,      
ReqNCDXAmount  = A.ReqNCDXAmount       
From (Select Party_Code,       
      Amount      = Sum(Amount + ReqNSECMAmount + ReqBSECMAmount + ReqNSEFOAmount + ReqMCDXAmount + ReqNCDXAmount),      
      ReqNSECMAmount = Sum(ReqNSECMAmount),      
      ReqBSECMAmount = Sum(ReqBSECMAmount),      
      ReqNSEFOAmount = Sum(ReqNSEFOAmount),      
      ReqMCDXAmount  = Sum(ReqMCDXAmount),      
      ReqNCDXAmount  = Sum(ReqNCDXAmount)      
From #Payout_Ledger Group By Party_Code ) A      
Where DelBranchMark_New.Party_Code = A.Party_Code      
And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty      
    
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
            DelBranchMark_New       
      Set       
            Cl_Rate = C.Cl_Rate       
      From       
            #NSE_LatestClosing C       
      Where         
            C.Scrip_Cd = DelBranchMark_New.Scrip_Cd                  
            And C.Series = (Case When DelBranchMark_New.Series In ('EQ', 'BE') Then 'EQ' Else DelBranchMark_New.Series End)      
          And DelBranchMark_New.Exchg = 'NSE'      
     And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty      
    
      Update       
            DelBranchMark_New       
      Set       
            Cl_Rate = C.Cl_Rate       
      From       
            #BSE_LatestClosing C       
      Where                   
            C.Scrip_Cd = DelBranchMark_New.Scrip_Cd                  
            And C.Series = DelBranchMark_New.Series         
     And DelBranchMark_New.Exchg = 'BSE'    
     And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty      
    
     Update DelBranchMark_New Set Series = S2.Scrip_CD    
     From BSEDB.DBO.Scrip2 S2 Where DelBranchMark_New.Scrip_Cd = S2.BSECODE    
     And DelBranchMark_New.Party_Code >= @FromParty And DelBranchMark_New.Party_Code <= @ToParty      
     And Exchg = 'BSE'  
  
 Update DelBranchMark_New Set   
 ReqQty = D.ReqQty,   
 ReqSubBy = D.ReqSubBy,   
 ReqSubDate = D.ReqSubDate,   
 ReqBy = D.ReqBy,   
 ReqDate = D.ReqDate,   
 ReqFlag = D.ReqFlag,  
 ReqStatus = D.ReqStatus  
 From #DelBranchMark_New_Old D  
 Where D.Exchg = DelBranchMark_New.Exchg  
 And D.HoldType = DelBranchMark_New.HoldType  
 And D.Party_Code = DelBranchMark_New.Party_Code  
 And D.Scrip_Cd = DelBranchMark_New.Scrip_Cd  
 And D.Series = DelBranchMark_New.Series  
 And D.CertNo = DelBranchMark_New.CertNo  
 And D.BDpType = DelBranchMark_New.BDpType  
 --And D.DpId = DelBranchMark_New.DpId  
 --And D.CltDpId = DelBranchMark_New.CltDpId

GO
