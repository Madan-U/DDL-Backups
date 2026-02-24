-- Object: PROCEDURE dbo.Newupdbilltax
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.newupdbilltax    Script Date: 10/06/2004 11:37:22 AM ******/    
    
CREATE proc [dbo].[Newupdbilltax](@SETTNO VARCHAR(7),@SETTYPE VARCHAR(2)) as    
  
Select Distinct Party_Code, Sauda_Date = Convert(DateTime,Left(Convert(Varchar,Sauda_Date,109),11))       
Into #sett      
From Settlement      
Where Sett_No = @settno And Sett_Type = @settype      
And BillFlag > 3      

truncate table Trd_ClientTaxes_New
Insert Into Trd_ClientTaxes_New      
Select C.*  From ClientTaxes_New C
Where   
trans_cat = 'del'  
and Party_Code In (Select Party_Code From #sett Where Sauda_Date Between FromDate And ToDate)
     

truncate table Trd_Clientbrok_scheme
Insert Into Trd_Clientbrok_scheme         
Select C.Scheme_Id,C.Party_Code,C.Table_No,C.Scheme_Type,C.Scrip_Cd,C.Trade_Type,C.Brokscheme,C.From_Date,C.To_Date
From Clientbrok_scheme C
Where scheme_type = 'del'   
and Party_Code In (Select Party_Code From #sett Where Sauda_Date Between From_Date And To_Date)

Truncate Table Trd_Client2
insert Into Trd_Client2
Select Cl_Code,Exchange,Tran_Cat,Scrip_Cat,Party_Code,Table_No,Sub_Tableno,Margin,Turnover_Tax,
Sebi_Turn_Tax,Insurance_Chrg,Service_Chrg,Std_Rate,P_To_P,Exposure_Lim,Demat_Tableno,Bankid,
Cltdpno,Printf,Albmdelchrg,Albmdelivery,Albmcf_Tableno,Mf_Tableno,Sb_Tableno,Brok1_Tableno,
Brok2_Tableno,Brok3_Tableno,Brokernote,Other_Chrg,Brok_Scheme,Contcharge,Mincontamt,Addledgerbal,
Dummy1,Dummy2,Inscont,Sertaxmethod,Dummy6,Dummy7,Dummy8,Dummy9,Dummy10
From Client2
Where Party_Code In (Select Party_Code From #sett)

Truncate table Trd_BROKTABLE  
Insert into Trd_BROKTABLE  
SELECT * 
FROM BROKTABLE WHERE TABLE_NO IN (SELECT DISTINCT TABLE_NO FROM Trd_Clientbrok_scheme)  
  
Update settlement set       
      NBrokApp = (  case      
    when (  broktable.val_perc ='V' )    
                             Then     
  ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /      
    
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /     
    
  power(10,CT.Round_To))    
    
                        when (  broktable.val_perc ='P' )    
                             Then      ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))    
   Else      
          BrokApplied     
                        End     
                         ),    
       N_NetRate = (  case      
                      when (  broktable.val_perc ='V' AND settlement.SELL_BUY = 1)    
                             Then    
                                  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))    
                      when (  broktable.val_perc ='P' AND settlement.SELL_BUY = 1 )    
                             Then settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))    
    
                      when (broktable.val_perc ='V' AND settlement.SELL_BUY =2 )    
                             Then settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To))    
                      when ( broktable.val_perc ='P' AND settlement.SELL_BUY = 2 )    
                             Then       
                      settlement.marketrate - ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))    
   Else      
             NetRate     
                        End     
                         ),/*modified by bhayashree on 27-12-2000*/    
    
        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1     
        Then 0    
        Else (case      
   when ( broktable.val_perc ='V' ) Then    
      ( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /      
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /     
  power(10,CT.Round_To)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )    
    
                      when (broktable.val_perc ='P' )    
                           Then                                       ((    ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,
  
CT.Round_To)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )    
    
   Else      
       settlement.Service_tax    
                        End ) End    
                ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + settlement.service_tax)  END )*/,    
/*    
Ins_chrg  =(Case    
  when settlement.status = 'N' then 0    
   else ((CT.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) End),     
*/    
turn_tax  = (Case    
  when settlement.status = 'N' then 0    
   else ((CT.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) end),                  
other_chrg =(Case    
  when settlement.status = 'N' then 0    
   else ((CT.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) end),     
sebi_tax = (Case    
  when settlement.status = 'N' then 0    
   else ((CT.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) end),                  
Broker_chrg =(Case    
  when settlement.status = 'N' then 0    
else ((CT.broker_note * settlement.marketrate * settlement.Tradeqty)/100) end)    
    
FROM Trd_BROKTABLE BrokTable, Trd_Client2 Client2, globals, Settlement,  Trd_Clientbrok_scheme S, Trd_ClientTaxes_New CT, Owner    
    
WHERE SETTLEMENT.SETT_NO = @SETTNO    
      AND SETTLEMENT.SETT_TYPE = @SETTYPE
	  And settlement.Party_Code = Client2.Party_code
      And Client2.Party_Code = CT.Party_Code    
      And CT.trans_Cat = 'DEL'     
      And S.Trade_Type = (Case When Settlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)           
      And Settlement.Sauda_Date Between FromDate And ToDate     
      And S.Table_No = Broktable.Table_no    
      And S.Scheme_Type = 'DEL'    
      And S.Scrip_Cd = 'ALL'    
      And S.PARTY_CODE = Settlement.Party_Code    
      And Settlement.Sauda_Date Between S.From_Date And S.To_Date 
	  And settlement.marketrate > Broktable.Lower_Lim	         
	  And settlement.marketrate <= Broktable.upper_lim	         
      And Trd_Del = 'D'  
      And Globals.exchange = 'NSE'
      And settlement.billflag in(4,5)     
      And settlement.status <> 'E'    
      And Sauda_date > Globals.year_start_dt    
      And Sauda_date < Globals.year_end_dt    
      AND AUCTIONPART NOT LIKE 'A%'
      AND AUCTIONPART NOT LIKE 'F%'

GO
