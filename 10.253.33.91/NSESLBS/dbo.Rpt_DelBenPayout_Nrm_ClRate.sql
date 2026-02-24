-- Object: PROCEDURE dbo.Rpt_DelBenPayout_Nrm_ClRate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[Rpt_DelBenPayout_Nrm_ClRate] (  
@BDpType Varchar(4), @BdpId Varchar(8), @BCltDpId Varchar(16),   
@FromParty Varchar(10), @ToParty Varchar(10),  
@FromScrip Varchar(10), @ToScrip Varchar(10),  
@acname Varchar(100),  
@chkFlag Varchar(20), @PayFlag int)  
as       
  
if @chkFlag <> 'Third Party' And @PayFlag = 1  
Begin  
 Exec InsDelAccCheck  
  
 select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(Introducer,' '),TrType,  
 D.DpType,CltDpId,D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=IsNull(Amount,0),  
 ISett_No=' ',Isett_Type=' ',Sett_no=' ',Sett_Type=' ',SeriesId=D.Series,Cl_Rate = Convert(Numeric(18,4),0)   
 into #DelPayout   
 From MultiCltId M, DelTrans D Left Outer Join DelAccBalance A   
  On ( A.CltCode = D.Party_Code )   
 Where TrType In (904,905) And D.Party_code = M.Party_code and M.DpId = D.DpId And M.CltDpNo = D.CltDpId   
 And M.DpType = D.DpType And Delivered = '0' And D.Party_Code <> 'BROKER'   
 And BDpType = @BDpType And BDpId = @BdpId  
 And BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty  
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip  
 Group by D.Scrip_cd,D.Series,D.Party_Code,IsNull(Introducer,' '),TrType,CltDpId,D.DpId,  
 CertNo, bdptype,bdpid,bcltdpid,Amount,D.DpType   
 order by D.DpType,D.Party_Code,D.Scrip_Cd  
  
 Update #DelPayOut Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayOut.scrip_cd                    
 And C1.series In ('eq','be') And #DelPayOut.seriesid In ('eq','be')                  
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayOut.scrip_cd                    
 And #DelPayOut.seriesid In ('eq','be')   
 And C.series In ('eq','be')                   
 And #DelPayOut.cl_rate = 0  
  
 Update #DelPayOut Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayOut.scrip_cd                    
 And C1.series = #DelPayOut.seriesid              
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayOut.scrip_cd                    
 And C.series = #DelPayOut.seriesid    
 And #DelPayOut.cl_rate = 0  
  
 Select * From #DelPayout   
  
End  
  
if @chkFlag = 'Third Party' And @PayFlag = 1  
Begin  
 select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(C1.Long_Name,' '),TrType,  
 D.DpType,D.CltDpId,D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=0,  
 ISett_No=' ',Isett_Type=' ',Sett_no=' ',Sett_Type=' ', SeriesId=D.Series,Cl_Rate = Convert(Numeric(18,4),0)   
 into #DelPayoutThird   
 from Client1 C1, Client2 C2, DelTrans D   
 where TrType In (904,905) and D.Party_code = C2.Party_code And C1.Cl_Code = C2.Cl_Code   
 And Delivered = '0' And D.Party_Code <> 'BROKER'   
 And BDpType = @BDpType And BDpId = @BdpId  
 And BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty  
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip  
 And Filler1 Like 'Third Party'  
 Group by D.Scrip_cd,D.Series,D.Party_Code,c1.long_name,TrType,CltDpId,D.DpId,   
 CertNo, bdptype,bdpid,bcltdpid,D.DpType   
 order by D.DpType,D.Party_Code,D.Scrip_Cd  
  
 Update #DelPayOut Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayOut.scrip_cd                    
 And C1.series In ('eq','be') And #DelPayOut.seriesid In ('eq','be')                  
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayOut.scrip_cd                    
 And #DelPayOut.seriesid In ('eq','be')   
 And C.series In ('eq','be')                   
 And #DelPayOut.cl_rate = 0  
  
 Update #DelPayoutThird Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutThird.scrip_cd                    
 And C1.series = #DelPayoutThird.seriesid              
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayoutThird.scrip_cd                    
 And C.series = #DelPayoutThird.seriesid    
 And #DelPayoutThird.cl_rate = 0  
  
 Select * From #DelPayoutThird   
  
End  
  
if @PayFlag = 0  
Begin  
 select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=' ',TrType,DT.DpType,CltDpId=DpCltNo,  
 DT.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=0,ISett_No=' ',Isett_Type=' ',  
 Sett_no=' ',Sett_Type=' ', SeriesId = D.Series, Cl_Rate = Convert(Numeric(18,4),0)   
 into #DelPayoutBen  
 from DelTrans D, DeliveryDp DT   
 where TrType = 904 And Dt.Description Like @acname  
 And Delivered = '0' And D.Party_Code <> 'BROKER'   
 And BDpType = @BDpType And BDpId = @BdpId  
 And BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
 And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty  
 And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip  
 Group by D.Party_Code, D.Scrip_cd,D.Series,TrType,DpCltNo,DT.DpId,CertNo,bdptype,bdpid,bcltdpid,DT.DpType   
 order by D.Party_Code, D.Scrip_Cd  
  
 Update #DelPayoutBen Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutBen.scrip_cd                    
 And C1.series In ('eq','be') And #DelPayoutBen.seriesid In ('eq','be')                  
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayoutBen.scrip_cd                    
 And #DelPayoutBen.seriesid In ('eq','be')   
 And C.series In ('eq','be')                   
 And #DelPayoutBen.cl_rate = 0  
  
 Update #DelPayoutBen Set Cl_rate = C.cl_rate From Closing C Where                     
 Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutBen.scrip_cd                    
 And C1.series = #DelPayoutBen.seriesid              
 And Sysdate <= Left(GetDate(),11) + ' 23:59' )              
 And C.scrip_cd = #DelPayoutBen.scrip_cd                    
 And C.series = #DelPayoutBen.seriesid    
 And #DelPayoutBen.cl_rate = 0  
  
 Select * From #DelPayoutBen   
  
End

GO
