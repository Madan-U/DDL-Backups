-- Object: PROCEDURE dbo.Rpt_DelBenPayout_RMS_ClRate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[Rpt_DelBenPayout_RMS_ClRate] (  
@BDpType Varchar(4), @BdpId Varchar(8), @BCltDpId Varchar(16),   
@FromParty Varchar(10), @ToParty Varchar(10),  
@FromScrip Varchar(10), @ToScrip Varchar(10),  
@acname Varchar(100),  
@chkFlag Varchar(20), @PayFlag int)  
as       
  
 select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(Introducer,' '),TrType,  
 D.DpType,CltDpId,D.DpId,D.CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=IsNull(LedBal,0),  
 ISett_No=' ',Isett_Type=' ',ActPayOut=IsNull(ActPayOut,0),Sett_no=' ',Sett_Type=' ', SeriesId = D.Series,  
 Cl_Rate = Convert(Numeric(18,4),0)  
 into #delPayOut  
 from MultiCltId M, DelTrans D Left Outer Join MSAJAG.DBO.DelPayoutView P  
   On ( P.Party_code = D.Party_Code And D.CertNo = P.CertNo And P.DebitQty > 0   
   And P.Exchange = 'NSE' And TrType = 904)  
 where TrType In (904,905)   
 and D.Party_code = M.Party_code and M.DpId = D.DpId And M.CltDpNo = D.CltDpId And M.DpType = D.DpType  
 And Delivered = '0' And D.Party_Code <> 'BROKER'  
 And BDpType = @BDpType And BDpId = @BDpId and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
 And D.Party_Code Between @FromParty And @ToParty  
 And D.Scrip_Cd Between @FromScrip And @ToScrip  
 And D.CertNo Like 'IN%'  
 Group by D.Scrip_cd,D.Series,D.Party_Code,IsNull(Introducer,' '),TrType,CltDpId,D.DpId,   
 D.CertNo, bdptype,bdpid,bcltdpid,LedBal,ISett_No,Isett_Type,D.DpType,IsNull(ActPayOut,0)   
 order by D.DpType,IsNull(Introducer,' '),D.Party_Code,D.Scrip_Cd  
  
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

GO
