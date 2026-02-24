-- Object: PROCEDURE dbo.DelHoldingAsOnDate_TEST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc DelHoldingAsOnDate_TEST (@TransDate Varchar(11), @DpId Varchar(8), @CltDpId Varchar(16), @IsIn Varchar(12),@Flag Int) As          
Set Transaction isolation level read uncommitted            
select * into #Del_TransStat From BAK_Deltrans With( NoLock)                 
Where CertNo = @IsIn  
  
If (Select Isnull(Count(*) , 0) From Deliverydp Where Dpid = @Dpid And Dpcltno = @Cltdpid And Description Like '%pool%' ) > 0         
Begin        
If @Flag = 1        
Begin        
Select Scripname, Scrip_Cd, Series, Isin, Qty = Sum(Qty) From (         
Select D.Sett_No, D.Sett_Type, Party_Code, ScripName= D.Scrip_Cd, D.Scrip_Cd, D.Series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where     
Drcr = 'C'         
And Filler2 = 1 And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate <= @Transdate        
And Trtype <> 906 And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Sec_Payin > @Transdate      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.Scrip_Cd, D.series, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = d.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where     
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered = 'G' And TrType not in (907, 906)      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type      
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = d.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where       
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Party_Code <> 'Broker'        
And Filler2 = 1      
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered in ('G', 'D') And TrType in (907, 908)      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type      
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = d.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where    
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Filler2 = 1      
And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered = '0' And TrType <> 906      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type      
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno) A         
Group By Scripname, Scrip_Cd, Series, Isin        
Having Sum(Qty) > 0         
Order By Scripname, Scrip_Cd, Isin        
End        
Else        
Begin        
Select Sett_No, Sett_Type, Party_Code, Scripname, Scrip_Cd, Series, Isin, Qty = Sum(Qty) From (         
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = D.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where     
Drcr = 'C'         
And Filler2 = 1 And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate <= @Transdate        
And Trtype <> 906 And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Sec_Payin > @Transdate      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = D.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where         
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered = 'G' And TrType not in (907, 906)      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type      
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = D.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where        
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Party_Code <> 'Broker'        
And Filler2 = 1      
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered in ('G', 'D') And TrType in (907, 908)      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type      
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno       
Union All      
Select D.Sett_No, D.Sett_Type, Party_Code, Scripname = D.Scrip_Cd, D.Scrip_Cd, D.series, Isin = Certno, Qty = Sum(Qty)         
From #Del_TransStat D, Sett_Mst S      
Where     
Drcr = 'D' And Certno Like 'In%'         
And Certno Like @Isin         
And Transdate > @Transdate        
And Filler2 = 1      
And Party_Code <> 'Broker'        
And Bcltdpid = @Cltdpid And Bdpid = @Dpid        
And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type      
And Transdate > Sec_Payin       
And Delivered = '0' And TrType <> 906      
And Tcode In ( Select Tcode From #Del_TransStat D1, Sett_Mst S         
               Where Drcr = 'C' And Filler2 = 1 And Certno Like 'In%'         
               And Certno Like @Isin        
               And D.Sett_No = S.Sett_No And D.Sett_Type = S.Sett_Type     
               And D1.Sett_No = S.Sett_No And D1.Sett_Type = S.Sett_Type       
               And Bcltdpid = @Cltdpid And Bdpid = @Dpid      
               And Sec_Payin <= @Transdate)      
Group By D.Sett_No, D.Sett_Type, Party_Code, D.series, D.Scrip_Cd, Certno ) A         
Group By Sett_No, Sett_Type, Party_Code, Scripname, Scrip_Cd, series, Isin        
Having Sum(Qty) > 0         
Order By Sett_No, Sett_Type, Party_Code, Scripname, Scrip_Cd, Isin        
End        
End         
Else          
Begin          
if @Flag = 1          
Begin          
Select ScripName=D.Scrip_Cd,D.Scrip_CD,D.SERIES,IsIn=CertNo,Qty=Sum(CQty-DQty)          
From (           
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=BDpId, CltDpId=BCltDpID, TrType,           
 Reason = 'Trans To Ben', BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1          
 from #Del_TransStat D          
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = 'G' And Filler2 = 0           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And HolderName Like '%' + RTrim(LTRim(@CltDpId)) + '%'          
 And HolderName Not Like 'MARGIN%'            
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId            
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=DpId, CltDpId=CltDpID, TrType,           
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=2            
 from #Del_TransStat D          
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 And Filler2 = 1           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 AND FILLER1 NOT IN ('SPLIT','BONUS')          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason          
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo=0, DpId='', CltDpId='', TrType,           
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=3            
 from #Del_TransStat D          
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = '0' And Filler2 = 1           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 AND FILLER1 IN ('SPLIT','BONUS')          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason          
 Union All          
 select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = 0, DQty = Sum(Qty), SlipNo=(CASE WHEN FILLER1 = 'SPLIT' THEN 0 ELSE SLIPNO END),           
 DpId = (Case When TrType in (1000,907,908) then ''           
          When filler1 = 'split'  Then ''          
          Else DpId end),           
 CltDpId = (Case When TrType in (1000,907,908) then ''           
   When filler1 = 'split'  Then ''           
   else CltDpId end),TrType,           
 Reason = (Case When TrType in (1000,907,908)          
         Then 'Trans To Pool - ' + ISett_No + '-' + ISett_Type           
         Else (case when filler1 = 'split'           
              then 'CORPORATE ACTION'           
              when filler1 Like 'Change%'          
              then 'Pay-Out'              
              Else Reason end)          
           End), BDpId, BCltDpId, TransDate1 = TransDate,FLAG=4            
 from #Del_TransStat D          
 where filler2 = 1 and drcr = 'D' and Delivered <> '0'           
 And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 And HolderName Not Like 'MARGIN%'          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId , FILLER1, reason          
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = 0, DQty = Sum(Qty), SlipNo, DpId=dp.DpId, CltDpId=dp.dpcltno, TrType,           
 Reason = 'Trans To Ben', BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1          
 from #Del_TransStat D, deliverydp dp          
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = 'G' And Filler2 = 0           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 and ( holdername like 'ben ' + Dp.DpCltNo Or holdername like 'Margin ' + Dp.DpCltNo )          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, TrType, dp.dpid, dpcltno , ISett_No, ISett_Type, BDpId, BCltDpId            
) D           
Group by D.Scrip_CD,D.SERIES,CertNo          
Having Sum(CQty-DQty) > 0          
Order by D.Scrip_CD,D.SERIES,CertNo          
End          
Else          
Begin          
Select Sett_No,Sett_Type,Party_Code,ScripName=D.Scrip_Cd,D.Scrip_CD,D.SERIES,IsIn=CertNo,Qty=Sum(CQty-DQty)          
From (           
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=BDpId, CltDpId=BCltDpID, TrType,           
 Reason = 'Trans To Ben', BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1          
 from #Del_TransStat D          
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = 'G' And Filler2 = 0           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And HolderName Like '%' + RTrim(LTRim(@CltDpId)) + '%'          
 And HolderName Not Like 'MARGIN%'            
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId            
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo, DpId=DpId, CltDpId=CltDpID, TrType,           
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=2            
 from #Del_TransStat D          
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 /*and Delivered = '0'*/ And Filler2 = 1           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 /*And Sett_No = '2000000' */ AND FILLER1 NOT IN ('SPLIT','BONUS')          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,          
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason          
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = Sum(Qty), DQty = 0, SlipNo=0, DpId='', CltDpId='', TrType,           
 Reason , BDpId, BCltDpId, TransDate1 = TransDate,FLAG=3            
 from #Del_TransStat D          
 where drcr = 'C' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = '0' And Filler2 = 1           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 AND FILLER1 IN ('SPLIT','BONUS')          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId ,Reason          
 Union All          
 select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = 0, DQty = Sum(Qty), SlipNo=(CASE WHEN FILLER1 = 'SPLIT' THEN 0 ELSE SLIPNO END),           
 DpId = (Case When TrType in (1000,907,908) then ''           
          When filler1 = 'split'  Then ''          
          Else DpId end),           
 CltDpId = (Case When TrType in (1000,907,908) then ''           
   When filler1 = 'split'  Then ''           
   else CltDpId end),TrType,           
 Reason = (Case When TrType in (1000,907,908)          
         Then 'Trans To Pool - ' + ISett_No + '-' + ISett_Type           
         Else (case when filler1 = 'split'           
              then 'CORPORATE ACTION'           
              when filler1 Like 'Change%'          
              then 'Pay-Out'              
              Else Reason end)          
           End), BDpId, BCltDpId, TransDate1 = TransDate,FLAG=4            
 from #Del_TransStat D          
 where filler2 = 1 and drcr = 'D' and Delivered <> '0'           
 And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 And HolderName Not Like 'MARGIN%'          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, DpId, CltDpId, TrType, ISett_No, ISett_Type, BDpId, BCltDpId , FILLER1, reason          
 Union All          
 Select TransDate=Convert(Varchar,TransDate,103), Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, CertNo, CQty = 0, DQty = Sum(Qty), SlipNo, DpId=dp.DpId, CltDpId=dp.dpcltno, TrType,           
 Reason = 'Trans To Ben', BDpId, BCltDpId, TransDate1 = TransDate,FLAG=1          
 from #Del_TransStat D, deliverydp dp          
 where drcr = 'D' And ShareType <> 'AUCTION' And CertNo Like 'IN%'          
 and Delivered = 'G' And Filler2 = 0           
 And TransDate <= @TransDate          
 And CertNo Like @Isin          
 And BDpId like @DpId + '%'  And BCltDpId like @CltDpId + '%'          
 and ( holdername like 'ben ' + Dp.DpCltNo Or holdername like 'Margin ' + Dp.DpCltNo )          
 Group By TransDate, Sett_No, Sett_Type, D.Party_Code,           
 D.Scrip_Cd, Series, CertNo, SlipNo, TrType, dp.dpid, dpcltno , ISett_No, ISett_Type, BDpId, BCltDpId            
) D           
Group by Sett_No,Sett_Type,Party_Code,D.Scrip_CD,D.SERIES,CertNo          
Having Sum(CQty-DQty) > 0          
Order by Party_Code,D.Scrip_CD,D.SERIES,CertNo,Sett_No,Sett_Type          
End          
End          
  
drop table #Del_TransStat

GO
