-- Object: PROCEDURE dbo.Rpt_DeliveryBenout_ilfs_rms
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_DeliveryPayout_Karvy    Script Date: 01/17/2005 1:50:33 PM ******/  
CREATE Proc [dbo].[Rpt_DeliveryBenout_ilfs_rms]
(@FromParty Varchar(10),  
 @ToParty Varchar(10),  
 @FromScrip Varchar(12),  
 @ToScrip Varchar(12),  
 @DpType Varchar(4),    
 @BDpType Varchar(4),  
 @BDpId Varchar(8),  
 @BCltDpId Varchar(16), 
 @AcName Varchar(100),
 @ClType Varchar(3), 
 @ChkOption Varchar(20),
 @PayOption Int)  
AS  
  
Set NoCount On  
if @PayOption = 0 And @ChkOption <> 'Third Party'
Begin
	Set Transaction Isolation Level Read Uncommitted  
	select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(Introducer,''),TrType,
	D.DpType,CltDpId,D.DpId,D.CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,
	Amount=(CASE WHEN TRTYPE = 905 THEN 1 ELSE IsNull(LedBal,0) END),
	ActPayOut=(CASE WHEN TRTYPE = 905 THEN SUM(QTY) ELSE IsNull(ActPayOut,0) END),
	ISett_No,Isett_Type,Sett_no=' ',Sett_Type=' ',Ser=D.Series, Cl_Rate = Convert(Numeric(18,4),0) 
	into #DelPayout from Client1 C1, Client2 C2, MultiCltId M, DelTrans D 
	     Left Outer Join MSAJAG.DBO.DelPayoutView P
		 On ( P.Party_code = D.Party_Code And P.Scrip_Cd = D.Scrip_Cd 
			  And P.Series = D.Series And D.CertNo = P.CertNo And P.DebitQty > 0
			  And P.Exchange = 'NSE' And TrType = 904)
	where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And TrType In (904,905)
	and D.Party_code = M.Party_code and M.DpId = D.DpId And M.CltDpNo = D.CltDpId 
	And M.DpType = D.DpType	And Delivered = '0' And D.Party_Code <> 'BROKER' 
	And BDpType = @BDpType And BDpId = @BDpId and BCltDpId = @BCltDpId And DrCr = 'D' 
	And Filler2 = 1 And D.Party_Code Between @FromParty And @ToParty
	And D.Scrip_Cd Between @FromScrip And @ToScrip
	And TrType = (Case When @ChkOption = 'Branch Request' And IsNull(ActPayOut,0) = 0 
		           Then 905 
			       When @ChkOption = 'RMS' And IsNull(ActPayOut,0) > 0 
				   THEN 904
				   When @ChkOption = 'Check All' OR @ChkOption =  'UnCheck All'
				   THEN 904	
				   ELSE 1
		          End)
	And Cl_Type = (Case When @ClType = 'ALL' Or @ClType = '%' Or @ClType = '' 
			    Then Cl_Type 
			    Else @ClType 
		       End)
	And D.DpType = @DpType
	Group by D.Scrip_cd,D.Series,D.Party_Code,IsNull(Introducer,''),TrType,CltDpId,D.DpId,
	D.CertNo, bdptype,bdpid,bcltdpid,LedBal,ISett_No,Isett_Type,D.DpType, ActPayOut 
	order by D.DpType,D.Party_Code,D.Scrip_Cd,ISett_No,ISett_Type

	Update #DelPayOut Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayOut.scrip_cd                  
	And C1.series In ('eq','be') And #DelPayOut.Ser In ('eq','be')                
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayOut.scrip_cd                  
	And #DelPayOut.Ser In ('eq','be') 
	And C.series In ('eq','be')                 
	And #DelPayOut.cl_rate = 0

	Update #DelPayOut Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayOut.scrip_cd                  
	And C1.series = #DelPayOut.Ser            
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayOut.scrip_cd                  
	And C.series = #DelPayOut.Ser  
	And #DelPayOut.cl_rate = 0

	Select * From #DelPayout  
End

if @PayOption = 0 And @ChkOption = 'Third Party'
Begin
	Set Transaction Isolation Level Read Uncommitted  
	select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(C1.Long_Name,''),TrType,D.DpType,
	D.CltDpId,D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=1,ActPayOut=SUM(qty),
    ISett_No,Isett_Type,Sett_no=' ',Sett_Type=' ',Ser=D.Series, Cl_Rate = Convert(Numeric(18,4),0) 
	into #DelPayoutThird from Client1 C1, Client2 C2, DelTrans D 
	where TrType In (904,905)
	and D.Party_code = C2.Party_code And C1.Cl_Code = C2.Cl_Code
	And Delivered = '0' And D.Party_Code <> 'BROKER' And BDpType = @BDpType 
	And BDpId = @BDpId and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1 
        And D.Party_Code Between @FromParty And @ToParty
	And D.Scrip_Cd Between @FromScrip And @ToScrip
	And Filler1 Like 'Third Party'
	And Cl_Type = (Case When @ClType = 'ALL' Or @ClType = '%' Or @ClType = '' 
			    Then Cl_Type 
			    Else @ClType 
		       End)
	And D.DpType = @DpType
	Group by D.Scrip_cd,D.Series,D.Party_Code,c1.long_name,TrType,CltDpId,D.DpId,
	CertNo, bdptype,bdpid,bcltdpid,ISett_No,Isett_Type,D.DpType 
	order by D.DpType,D.Party_Code,D.Scrip_Cd,ISett_No,ISett_Type

	Update #DelPayoutThird Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutThird.scrip_cd                  
	And C1.series In ('eq','be') And #DelPayoutThird.Ser In ('eq','be')                
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayoutThird.scrip_cd                  
	And #DelPayoutThird.Ser In ('eq','be') 
	And C.series In ('eq','be')                 
	And #DelPayoutThird.cl_rate = 0

	Update #DelPayoutThird Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutThird.scrip_cd                  
	And C1.series = #DelPayoutThird.Ser            
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayoutThird.scrip_cd                  
	And C.series = #DelPayoutThird.Ser  
	And #DelPayoutThird.cl_rate = 0

	Select * From #DelPayoutThird
End

if @PayOption = 1 
Begin
	Set Transaction Isolation Level Read Uncommitted  
	select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=' ',TrType,DT.DpType,CltDpId=DpCltNo,
	DT.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=0,ActPayOut=SUM(qty),
	ISett_No=' ',Isett_Type=' ',Sett_no=' ',Sett_Type=' ',Ser=D.Series, Cl_Rate = Convert(Numeric(18,4),0) 
	into #DelPayoutBen from Client1 C1, Client2 C2, DelTrans D, DeliveryDp DT 
	where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code And TrType = 904
	And Dt.Description = @AcName
	And Delivered = '0' And D.Party_Code <> 'BROKER' And BDpType = @BDpType 
	And BDpId = @BDpId and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1 
        And D.Party_Code Between @FromParty And @ToParty
	And D.Scrip_Cd Between @FromScrip And @ToScrip
	And Cl_Type = (Case When @ClType = 'ALL' Or @ClType = '%' Or @ClType = '' 
			    Then Cl_Type 
			    Else @ClType 
		       End)
	Group by D.Scrip_cd,D.Series,D.Party_Code,TrType,DpCltNo,DT.DpId,CertNo,
	bdptype,bdpid,bcltdpid,DT.DpType 
	order by D.Party_Code,D.Scrip_Cd

	Update #DelPayoutBen Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutBen.scrip_cd                  
	And C1.series In ('eq','be') And #DelPayoutBen.Ser In ('eq','be')                
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayoutBen.scrip_cd                  
	And #DelPayoutBen.Ser In ('eq','be') 
	And C.series In ('eq','be')                 
	And #DelPayoutBen.cl_rate = 0

	Update #DelPayoutBen Set Cl_rate = C.cl_rate From Closing C Where                   
	Sysdate = (Select Max(SysDate) From closing C1 Where C1.scrip_cd = #DelPayoutBen.scrip_cd                  
	And C1.series = #DelPayoutBen.Ser            
	And Sysdate <= Left(GetDate(),11) + ' 23:59' )            
	And C.scrip_cd = #DelPayoutBen.scrip_cd                  
	And C.series = #DelPayoutBen.Ser  
	And #DelPayoutBen.cl_rate = 0
	
	Select * From #DelPayoutBen
End

GO
