-- Object: PROCEDURE dbo.Rpt_ShortagePayinScrip_Test
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Rpt_ShortagePayinScrip    Script Date: 09/20/2004 6:00:02 PM ******/  
  
  
  
CREATE Proc Rpt_ShortagePayinScrip_Test (@StatusId Varchar(15), @StatusName Varchar(25),@FromSett_no Varchar(7),@ToSett_no Varchar(7), @sett_Type Varchar(2)) As   
  
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,  
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)   
into #DelAucNew from Client2 C2,Client1 C1, 
(
	Select Sett_no,Sett_Type,scrip_cd,series,Party_code,  
	BuyQty=Sum(Case When Inout = 'O' Then Qty Else 0 End),  
	SellQty=Sum(Case When Inout = 'I' Then Qty Else 0 End)  
	from DeliveryClt
	where sett_no >= @fromsett_no
	and sett_no <= @tosett_no
	and sett_type = @sett_type  
	Group BY Sett_no,Sett_Type,scrip_cd,series,Party_code  
) d Left Outer Join DelTrans de   
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not in ('A', 'X') Then 'AUCTION' Else '' End) )  
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And D.Sett_no >= @FromSett_No   
And D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type  
And Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)  
And Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)  
And Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)  
And Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)  
And area Like (Case When @Statusid = 'area' Then @statusname else '%' End)  
And region Like (Case When @Statusid = 'region' Then @statusname else '%' End)  
And D.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)  
Group By d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,BuyQty,SellQty  
Having ( BuyQty <> Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)   
    Or SellQty <> Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) )  
  
Insert Into #DelAucNew  
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) ,  
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)  
from Client2 C2,Client1 C1 , DelTrans d   
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code   
And D.Sett_no >= @FromSett_No And D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type  
and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not in ('A', 'X') Then 'AUCTION' Else '' End)  
And Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)  
And Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)  
And Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)  
And Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)  
And area Like (Case When @Statusid = 'area' Then @statusname else '%' End)  
And region Like (Case When @Statusid = 'region' Then @statusname else '%' End)  
And D.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)  
And D.Party_Code Not in ( Select Party_Code From DeliveryClt De  
     Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
     and de.series = d.series and de.party_code = d.party_code  )  
Group By d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series  
Having Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) <>   
Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)  
  
If @Sett_Type <> 'W'   
Begin   
 Select Sett_no,Sett_Type,Party_Code,Short_Name,Scrip_Cd,Series,BuyTradeQty,BuyRecQty,SellTradeQty,SellRecQty,  
 BuyShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) > 0   
            Then ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )  
     Else 0 End ) ,  
 SellShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) < 0   
            Then Abs( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )  
     Else 0 End ) , Cl_Rate = Convert(Numeric(18,4),0)   
 Into #DelAucShort From #DelAucNew  
 Where ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) <> 0   
  
 Update #DelAucShort Set Cl_Rate = C.Cl_Rate   
 From MSAJAG.DBO.Closing C, Sett_Mst S   
 Where S.Sett_No = #DelAucShort.Sett_No  
 And S.Sett_Type = #DelAucShort.Sett_Type  
 And C.Scrip_Cd = #DelAucShort.Scrip_CD  
 And C.Series = #DelAucShort.Series  
 And SysDate Like ( Select Max(SysDate) From MSAJAG.DBO.Closing C1   
       Where C.Scrip_Cd = C1.Scrip_CD  
                           And C.Series = C1.Series And SysDate <= Sec_PayOut)  
  
 select * from #delaucshort  
 where sellshortage > 0   
 Order BY sett_no, sett_type, scrip_cd, series, Party_Code, Short_Name  
  
End  
Else  
Begin  
 Select Sett_no,Sett_Type,Party_Code,Short_Name,Scrip_Cd,Series,BuyTradeQty,BuyRecQty,SellTradeQty,SellRecQty,  
 BuyShortage=(Case When ( BuyTradeQty > BuyRecQty )  
            Then BuyTradeQty - BuyRecQty   
     Else   
      Case When ( BuyTradeQty < BuyRecQty )  
      Then (Case When ( SellTradeQty < SellRecQty And (BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty) < 0 )       
        Then Abs(BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty)  
             Else 0   
          End )    
           Else (CASE WHEN SellTradeQty < SellRecQty   
      THEN SellRecQty - SellTradeQty     
      ELSE 0 End ) END  
     End ),  
 SellShortage=(Case When ( SellTradeQty > SellRecQty )  
            Then SellTradeQty - SellRecQty   
     Else   
      Case When ( SellTradeQty < SellRecQty )  
      Then (Case When ( BuyTradeQty < BuyRecQty And (SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty ) < 0 )       
        Then Abs(SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty )  
             Else 0   
          End )    
           Else (CASE WHEN BuyTradeQty < BuyRecQty   
      THEN BuyRecQty - BuyTradeQty     
      ELSE 0 End ) END  
     End ) , Cl_Rate = Convert(Numeric(18,4),0)   
 Into #DelAucShort1 From #DelAucNew  
 Where ( (Case When ( SellTradeQty > SellRecQty )  
            Then SellTradeQty - SellRecQty   
     Else   
      Case When ( SellTradeQty < SellRecQty )  
      Then (Case When ( BuyTradeQty < BuyRecQty And (SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty ) < 0 )       
        Then Abs(SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty )  
             Else 0   
          End )    
           Else (CASE WHEN BuyTradeQty < BuyRecQty   
      THEN BuyRecQty - BuyTradeQty     
      ELSE 0 End ) END  
     End )  <> 0   
   Or    
  (Case When ( BuyTradeQty > BuyRecQty )  
            Then BuyTradeQty - BuyRecQty   
     Else   
      Case When ( BuyTradeQty < BuyRecQty )  
      Then (Case When ( SellTradeQty < SellRecQty And (BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty) < 0 )       
        Then Abs(BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty)  
             Else 0   
          End )    
           Else (CASE WHEN SellTradeQty < SellRecQty   
      THEN SellRecQty - SellTradeQty     
      ELSE 0 End ) END  
     End ) <> 0 )  
  
 Update #DelAucShort1 Set Cl_Rate = C.Cl_Rate   
 From MSAJAG.DBO.Closing C, Sett_Mst S   
 Where S.Sett_No = #DelAucShort1.Sett_No  
 And S.Sett_Type = #DelAucShort1.Sett_Type  
 And C.Scrip_Cd = #DelAucShort1.Scrip_CD  
 And C.Series = #DelAucShort1.Series  
 And SysDate Like ( Select Max(SysDate) From MSAJAG.DBO.Closing C1   
       Where C.Scrip_Cd = C1.Scrip_CD  
                           And C.Series = C1.Series And SysDate <= Sec_PayOut)  
  
 select * from #delaucshort1  
 where sellshortage > 0   
 Order BY sett_no, sett_type, scrip_cd, series, Party_Code, Short_Name  
End

GO
