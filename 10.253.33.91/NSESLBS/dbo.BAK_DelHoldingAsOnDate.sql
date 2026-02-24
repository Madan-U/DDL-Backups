-- Object: PROCEDURE dbo.BAK_DelHoldingAsOnDate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc bak_DelHoldingAsOnDate (@TransDate Varchar(11), @DpId Varchar(8), @CltDpId Varchar(16), @IsIn Varchar(12),@Flag Int) As
Set Transaction isolation level read uncommitted                      
select * into #Del_TransStat From DelTrans With( NoLock)                           
Where CertNo Like @IsIn            
    
If (Select IsNull(Count(*) ,0) From DeliveryDp Where DpID = @DpId And DpCltNo = @CltDpId And Description Like '%POOL%' ) > 0                     
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
BEGIN
Select Scrip_Cd,Series,IsIn,Qty=Sum(Qty) From ( 
Select D.Scrip_CD,D.Series,IsIn=CertNo,Qty=Sum(Qty)
From #Del_TransStat D
Where Tcode in ( 
Select TCode
From #Del_TransStat 
Where TransDate < @TransDate
And Filler2 = 1 And DrCr = 'C' And CertNo = D.CertNo and Filler2 = D.Filler2 And TCode = D.TCode) And Filler2 = 1
And DrCr = 'D' And Delivered = '0' 
And BCltDpId Like @CltDpId And BDpId = @DpId
And CertNo Like 'IN%' 
and CertNo Like @IsIn
And TrType <> 906 And Party_Code <> 'BROKER'
Group By D.Scrip_Cd,D.Series,CertNo
Union All
Select D.Scrip_CD,D.Series,IsIn=CertNo,Qty=Sum(Qty)
From #Del_TransStat D
Where Tcode in ( 
Select TCode
From #Del_TransStat 
Where TransDate <= @TransDate
And Filler2 = 1 And DrCr = 'C' And CertNo = D.CertNo 
and Filler2 = D.Filler2 And TCode = D.TCode) And Filler2 = 1
And DrCr = 'D' And Delivered <> '0' And TransDate >= @TransDate
And BCltDpId Like @CltDpId And BDpId = @DpId
And CertNo Like 'IN%' and CertNo Like @IsIn
And TrType <> 906 And Party_Code <> 'BROKER'
Group By D.Scrip_Cd,D.Series,CertNo ) A 
Group by Scrip_Cd,Series,IsIn
Having Sum(Qty) > 0 
Order By Scrip_Cd,IsIn
END
ELSE
BEGIN
Select Sett_No,Sett_Type,Party_Code,Scrip_Cd,Series,IsIn,Qty=Sum(Qty) From ( 
Select Sett_No,Sett_Type,Party_Code,D.Scrip_Cd,D.Series,IsIn=CertNo,Qty=Sum(Qty)
From #Del_TransStat D 
Where Tcode in ( 
Select TCode
From #Del_TransStat 
Where TransDate <= @TransDate
And Filler2 = 1 And DrCr = 'C' And CertNo = D.CertNo and Filler2 = D.Filler2 And TCode = D.TCode) And Filler2 = 1
And DrCr = 'D' And Delivered = '0' 
And BCltDpId Like @CltDpId And BDpId = @DpId
And CertNo Like 'IN%' 
and CertNo Like @IsIn
And TrType <> 906 And Party_Code <> 'BROKER'
Group By Sett_No,Sett_Type,Party_Code,D.Scrip_Cd,D.Series,CertNo
Union All
Select Sett_No,Sett_Type,Party_Code,D.Scrip_Cd,D.Series,IsIn=CertNo,Qty=Sum(Qty)
From #Del_TransStat D
Where Tcode in ( 
Select TCode
From #Del_TransStat 
Where TransDate <= @TransDate
And Filler2 = 1 And DrCr = 'C' And CertNo = D.CertNo and Filler2 = D.Filler2 And TCode = D.TCode) And Filler2 = 1
And DrCr = 'D' And Delivered <> '0' And TransDate >= @TransDate
And BCltDpId Like @CltDpId And BDpId = @DpId
And CertNo Like 'IN%' and CertNo Like @IsIn
And TrType <> 906 And Party_Code <> 'BROKER'
Group By Sett_No,Sett_Type,Party_Code,D.Scrip_Cd,D.Series,CertNo ) A 
Group by Sett_No,Sett_Type,Party_Code,Scrip_Cd,Series,IsIn
Having Sum(Qty) > 0 
Order By Sett_No,Sett_Type,Party_Code,Scrip_Cd,IsIn
END
end
 
drop table #Del_TransStat

GO
