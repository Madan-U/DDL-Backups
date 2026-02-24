-- Object: PROCEDURE dbo.DelHoldingAsOnDate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.Delholdingasondate    Script Date: 12/11/2004 4:50:23 Pm ******/      
/****** Object:  Stored Procedure Dbo.Delholdingasondate    Script Date: 11/10/2004 6:50:36 Pm ******/      
  
/****** Object:  Stored Procedure Dbo.Delholdingasondate    Script Date: 10/20/2004 7:22:30 Pm ******/      
CREATE Proc Delholdingasondate (@Transdate Varchar(11), @Dpid Varchar(8), @Cltdpid Varchar(16), @Isin Varchar(12), @Flag Int) As      
--Delholdingasondate 'May 27 2004', 'In302201', '10152958', 'Ine009a01021', 1  
Set Transaction isolation level read uncommitted                      
select * into #Del_TransStat From DelTrans With( NoLock)                           
Where CertNo Like @IsIn    
    
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
If @Flag = 1      
Begin      
Select Scripname = Scrip_Name, D.Scrip_Cd, D.Series, Isin = Certno, Qty = Sum(Cqty-Dqty)      
From (       
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, D.Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno, Dpid = Bdpid, Cltdpid = Bcltdpid, Trtype,       
 Reason = 'Trans To Ben', Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 1      
 From #Del_TransStat D   
 Where    
 Drcr = 'D' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = 'G' And Filler2 = 0       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Holdername Like '%' + Rtrim(Ltrim(@Cltdpid)) + '%'      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code, D.Scrip_Cd,       
 D.Scrip_Cd, D.Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid        
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, D.Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno, Dpid = Dpid, Cltdpid = Cltdpid, Trtype,       
 Reason , Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 2        
 From #Del_TransStat D     
 Where Drcr = 'C' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Filler2 = 1       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And Filler1 Not In ('Split', 'Bonus')      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code, D.Scrip_Cd,       
 D.Scrip_Cd, D.Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, D.Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno = 0, Dpid = '', Cltdpid = '', Trtype,       
 Reason , Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 3        
 From #Del_TransStat D    
        Where   
 Drcr = 'C' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = '0' And Filler2 = 1       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And Filler1 In ('Split', 'Bonus')      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code, D.Scrip_Cd,       
 D.Scrip_Cd, D.Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, D.Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = 0, Dqty = Sum(Qty), Slipno = (Case When Filler1 = 'Split' Then 0 Else Slipno End),       
 Dpid = (Case When Trtype In (1000, 907, 908) Then ''       
          When Filler1 = 'Split'  Then ''      
          Else Dpid End),       
 Cltdpid = (Case When Trtype In (1000, 907, 908) Then ''       
   When Filler1 = 'Split'  Then ''       
   Else Cltdpid End), Trtype,       
 Reason = (Case When Trtype In (1000, 907, 908)      
         Then 'Trans To Pool - ' + Isett_No + '-' + Isett_Type       
         Else (Case When Filler1 = 'Split'       
              Then 'Corporate Action'       
              When Filler1 Like 'Change%'      
              Then 'Pay-Out'          
              Else Reason End)      
           End), Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 4        
 From #Del_TransStat D     
        Where Filler2 = 1 And Drcr = 'D' And Delivered <> '0'       
 And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And Holdername Not Like 'Margin%'      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code, D.Scrip_Cd,       
 D.Scrip_Cd, D.Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Filler1, Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, D.Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = 0, Dqty = Sum(Qty), Slipno, Dpid = Dp.Dpid, Cltdpid = Dp.Dpcltno, Trtype,       
 Reason = 'Trans To Ben', Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 1      
 From #Del_TransStat D, Deliverydp Dp   
 Where   
 Drcr = 'D' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = 'G' And Filler2 = 0       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And ( Holdername Like 'Ben ' + Dp.Dpcltno Or Holdername Like 'Margin ' + Dp.Dpcltno)      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code, D.Scrip_Cd,       
 D.Scrip_Cd, D.Series, Certno, Slipno, Trtype, Dp.Dpid, Dpcltno , Isett_No, Isett_Type, Bdpid, Bcltdpid        
) D       
Group By Scrip_Name, D.Scrip_Cd, D.Series, Certno      
Having Sum(Cqty-Dqty) <> 0      
Order By Scrip_Name, D.Scrip_Cd, D.Series, Certno      
End      
Else      
Begin      
Select Sett_No, Sett_Type, Party_Code, Scripname = D.Scrip_Cd, D.Scrip_Cd, D.Series, Isin = Certno, Qty = Sum(Cqty-Dqty)      
From (       
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno, Dpid = Bdpid, Cltdpid = Bcltdpid, Trtype,       
 Reason = 'Trans To Ben', Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 1      
 From #Del_TransStat D      
 Where Drcr = 'D' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = 'G' And Filler2 = 0       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Holdername Like '%' + Rtrim(Ltrim(@Cltdpid)) + '%'      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid        
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno, Dpid = Dpid, Cltdpid = Cltdpid, Trtype,       
 Reason , Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 2        
 From #Del_TransStat D      
 Where Drcr = 'C' And Sharetype <> 'Auction' And Certno Like 'In%'      
 /*And Delivered = '0'*/ And Filler2 = 1       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 /*And Sett_No = '2000000' */ And Filler1 Not In ('Split', 'Bonus')      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = Sum(Qty), Dqty = 0, Slipno = 0, Dpid = '', Cltdpid = '', Trtype,       
 Reason , Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 3        
 From #Del_TransStat D      
 Where Drcr = 'C' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = '0' And Filler2 = 1       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And Filler1 In ('Split', 'Bonus')      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = 0, Dqty = Sum(Qty), Slipno = (Case When Filler1 = 'Split' Then 0 Else Slipno End),       
 Dpid = (Case When Trtype In (1000, 907, 908) Then ''       
          When Filler1 = 'Split'  Then ''      
          Else Dpid End),       
 Cltdpid = (Case When Trtype In (1000, 907, 908) Then ''       
   When Filler1 = 'Split'  Then ''       
   Else Cltdpid End), Trtype,       
 Reason = (Case When Trtype In (1000, 907, 908)      
         Then 'Trans To Pool - ' + Isett_No + '-' + Isett_Type       
         Else (Case When Filler1 = 'Split'       
              Then 'Corporate Action'       
              When Filler1 Like 'Change%'      
              Then 'Pay-Out'          
              Else Reason End)      
           End), Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 4        
 From #Del_TransStat D      
 Where Filler2 = 1 And Drcr = 'D' And Delivered <> '0'       
 And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And Holdername Not Like 'Margin%'      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Certno, Slipno, Dpid, Cltdpid, Trtype, Isett_No, Isett_Type, Bdpid, Bcltdpid , Filler1, Reason      
 Union All      
 Select Transdate = Convert(Varchar, Transdate, 103), Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Scrip_Name = D.Scrip_Cd, Certno, Cqty = 0, Dqty = Sum(Qty), Slipno, Dpid = Dp.Dpid, Cltdpid = Dp.Dpcltno, Trtype,       
 Reason = 'Trans To Ben', Bdpid, Bcltdpid, Transdate1 = Transdate, Flag = 1      
 From #Del_TransStat D, Deliverydp Dp      
 Where Drcr = 'D' And Sharetype <> 'Auction' And Certno Like 'In%'      
 And Delivered = 'G' And Filler2 = 0       
 And Transdate < = @Transdate      
 And Certno = @Isin And Party_Code <> 'Broker'      
 And Bdpid Like @Dpid + '%'  And Bcltdpid Like @Cltdpid + '%'      
 And ( Holdername Like 'Ben ' + Dp.Dpcltno Or Holdername Like 'Margin ' + Dp.Dpcltno)      
 Group By Transdate, Sett_No, Sett_Type, D.Party_Code,       
 D.Scrip_Cd, Series, Certno, Slipno, Trtype, Dp.Dpid, Dpcltno , Isett_No, Isett_Type, Bdpid, Bcltdpid        
) D   
Group By Sett_No, Sett_Type, Party_Code, D.Scrip_Cd, D.Scrip_Cd, D.Series, Certno      
Having Sum(Cqty-Dqty) <> 0      
Order By Party_Code, D.Scrip_Cd, D.Series, Certno, Sett_No, Sett_Type       
End      
End

GO
