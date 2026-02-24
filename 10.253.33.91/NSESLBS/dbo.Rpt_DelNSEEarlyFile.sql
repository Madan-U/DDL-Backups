-- Object: PROCEDURE dbo.Rpt_DelNSEEarlyFile
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DelNSEEarlyFile (      
@TransDate Varchar(11),        
@FromBatchNo Int,      
@ToBatchNo Int,      
@FromSlipNo Varchar(10),      
@ToSlipNo Varchar(10) ) As      
      
Select RECTYPE = 20, SETT_NO, SETT_TYPE, SCRIP_CD = Upper(SCRIP_CD), 
SERIES = Upper(SERIES), PARTY_CODE, QTY = SUM(QTY)  
From deltrans D    
where Filler2 = 1 And DrCr = 'C' And CertNo Like 'IN%'    
And TCODE IN (Select TCODE from deltrans D1    
where d.sett_no = D1.sett_no    
and D.sett_type = D1.Sett_Type    
And Filler2 = 1 And DrCr = 'D' And TrType = 906 And Delivered <> '0'    
And ( Reason Like 'EARLY%' Or Filler1 Like 'EARLY%' ) And D.CertNo = D1.CertNo    
And Convert(Int,BatchNo) >= @FromBatchNo    
And Convert(Int,BatchNo) <= @ToBatchNo    
And SlipNo >= @FromSlipNo    
And SlipNo <= @ToSlipNo   
And TransDate Like @TransDate + '%')    
Group by SETT_NO, SETT_TYPE, SCRIP_CD, SERIES, PARTY_CODE   
Order By SETT_NO, SETT_TYPE, SCRIP_CD, SERIES, PARTY_CODE

GO
