-- Object: PROCEDURE dbo.Nsecmvalan
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

 CREATE   Proc [dbo].[Nsecmvalan] (            
@sett_no Varchar(7),                       
@sett_type Varchar(2),            
@sdate Varchar(11),            
@party_code Varchar(10),            
@scrip_cd Varchar(12),            
@series Varchar(3),            
@statusname Varchar(15))            
As             
/* Drop Proc Nsecmvalan */            
            
/* Set Nocount On */            
            
If @party_code = ''             
 Select @party_code = '%'            
            
If @scrip_cd = ''             
 Select @scrip_cd = '%'            
            
If @series = ''             
 Select @series = '%'            
            
If @sdate = ''             
   Select @sdate = '%'            
            
truncate table CMBillValan_Up    
            
Insert Into CMBillValan_Up    
            
/* Normal Trade From settlement_valan Without Nd Scrip */            
Select S.sett_no,s.sett_type,billno,s.contractno,s.party_code,party_name= C1.long_name,s.scrip_cd,s.series,            
Scrip_name='',isin='',sauda_date=left(convert(varchar,s.sauda_date,109),11),            
Pqtytrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag = 2             
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag = 2             
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Pamttrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag = 2             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag = 2             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Pqtydel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag In (1,4)             
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag In (1,4)            
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Pamtdel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag In (1,4)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag In (1,4)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Sqtytrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag = 3            
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag = 3             
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Samttrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag = 3             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag = 3             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Sqtydel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag In (1,5)            
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag In (1,5)            
        Then Tradeqty             
          Else 0             
     End )             
      End),             
Samtdel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag In (1,5)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag In (1,5)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Pbroktrd = Sum(case When Billno > 0             
         Then (case When Sell_buy = 1 And Billflag = 2             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 1 And Settflag = 2            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),             
Sbroktrd = Sum(case When Billno > 0             
         Then (case When Sell_buy = 2 And Billflag = 3            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 2 And Settflag = 3            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),            
Pbrokdel = Sum(case When Billno > 0             
         Then (case When Sell_buy = 1 And Billflag In (1,4)             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 1 And Settflag In (1,4)            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),            
Sbrokdel =  Sum(case When Billno > 0             
         Then (case When Sell_buy = 2 And Billflag In (1,5)             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 2 And Settflag In (1,5)            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),            
Family,familyname='',terminal_id=user_id,clienttype=cl_type,tradetype='s',trader,sub_broker,branch_cd,partipantcode,            
Pamt = Isnull(sum(case When Sell_buy = 1             
      Then (case When Service_chrg = 2             
                 Then Tradeqty * N_netrate               
          Else Tradeqty * N_netrate + Nsertax            
     End ) +             
    (case When Dispcharge = 1              
          Then (case When Turnover_tax = 1             
                       Then Turn_tax            
                     Else 0             
         End )                
          Else 0            
     End ) +             
    (case When Dispcharge = 1             
          Then (case When Sebi_turn_tax = 1             
       Then (sebi_tax)               
              Else 0             
         End )                
          Else 0         
     End ) +             
    (case When Dispcharge = 1             
          Then (case When Insurance_chrg = 1             
       Then Ins_chrg            
                     Else 0             
         End )            
          Else 0             
     End ) +             
    (case When Dispcharge = 1             
          Then (case When Brokernote = 1             
       Then (broker_chrg)               
              Else 0             
                       End )                           Else 0             
     End ) +             
    (case When Dispcharge = 1             
          Then (case When C2.other_chrg = 1             
       Then (s.other_chrg)               
                     Else 0             
         End )                
                               Else 0            
  End )              
   Else 0             
   End),0),              
Samt = Isnull(sum(case When Sell_buy = 2             
      Then (case When Service_chrg = 2             
                 Then Tradeqty * N_netrate            
          Else Tradeqty * N_netrate - Nsertax            
     End ) -             
    (case When Dispcharge = 1             
          Then (case When Turnover_tax = 1             
            Then Turn_tax            
                     Else 0             
         End )                
          Else 0            
     End ) -             
    (case When Dispcharge = 1             
          Then (case When Sebi_turn_tax = 1             
       Then (sebi_tax)               
              Else 0             
         End )                
          Else 0             
     End ) -             
    (case When Dispcharge = 1             
          Then (case When Insurance_chrg = 1             
       Then Ins_chrg            
                     Else 0             
         End )            
          Else 0             
     End ) -             
    (case When Dispcharge = 1             
          Then (case When Brokernote = 1             
       Then (broker_chrg)               
              Else 0             
                       End )                
                 Else 0             
     End ) -            
    (case When Dispcharge = 1             
          Then (case When C2.other_chrg = 1             
       Then (s.other_chrg)               
                     Else 0             
         End )                
                               Else 0            
                          End )              
   Else 0             
   End),0),              
Prate = Sum(case When Sell_buy = 1 Then (tradeqty*s.dummy1) Else 0 End),              
Srate = Sum(case When Sell_buy = 2 Then (tradeqty*s.dummy1) Else 0 End),            
Trdamt = Sum(Case When AuctionPart Like 'F%' Then 0 Else Tradeqty*S.Marketrate End),            
Delamt = Sum((Case When billflag in (4,5)    
         Then Case When AuctionPart Like 'F%' Then 0 Else Tradeqty*S.Marketrate End    
        Else 0           
   End)),              
Serinex = Service_chrg,            
Service_tax = Sum(nsertax),            
Exservice_tax = Sum(case When Service_chrg = 2             
        Then (nsertax)            
        Else 0             
   End),             
Turn_tax = Sum(case When Dispcharge = 1             
   Then (case When Turnover_tax = 1             
              Then (turn_tax)               
                 Else 0             
         End)                
          Else 0             
     End ),            
Sebi_tax = Sum(case When Dispcharge = 1             
   Then (case When Sebi_turn_tax = 1             
              Then (sebi_tax)               
       Else 0             
         End)                
   Else 0             
     End),              
Ins_chrg = Sum(case When Dispcharge = 1             
   Then (case When Insurance_chrg = 1             
       Then (ins_chrg)               
            Else 0             
         End)                
   Else 0             
     End),            
Broker_chrg = Sum(case When Dispcharge = 1             
      Then (case When Brokernote = 1             
          Then (broker_chrg)               
                 Else 0             
            End)            
      Else 0             
        End),            
Other_chrg = Sum(case When Dispcharge = 1             
     Then (case When C2.other_chrg = 1             
                Then (s.other_chrg)               
                Else 0             
           End)                
     Else 0             
       End),              
Region, Start_date='', End_date='', Update_date=left(convert(varchar,getdate(),109),11), Status_name=@statusname,            
Exchange='nse',segment='capital',membertype=membercode,companyname='',dummy1='',dummy2='',dummy3='',dummy4=0,dummy5=0, Area    
From settlement_valan S, Client2 C2, Owner,client1  C1             
Where C2.party_code = S.party_code And C1.cl_code = C2.cl_code              
And S.sett_no = @sett_no And S.sett_type = @sett_type And Tradeqty > 0    
And Auctionpart Not In ('ap','ar')            
Group By Sett_no,sett_type,contractno,billno,s.party_code,c1.long_name,s.scrip_cd,s.series,left(convert(varchar,s.sauda_date,109),11),            
C1.family,user_id,trader,sub_broker,partipantcode,membercode,            
Service_chrg,branch_cd,cl_type, Region, Area             
      
Insert Into CMBillValan_Up             
Select S.CD_sett_no,S.CD_sett_type,billno=0,contractno='0',S.CD_party_code,      
party_name= C1.long_name,Scrip_Cd = (Case When S.CD_scrip_cd = '' Then 'BROKERAGE' Else S.CD_scrip_cd End),      
Series = (Case When S.CD_series = '' Then (Case When CD_Sett_Type = 'W' Then 'BE' Else 'EQ' End) Else S.CD_series End),      
Scrip_name='',isin='',sauda_date=left(convert(varchar,S.CD_sauda_date,109),11),            
Pqtytrd = 0,             
Pamttrd = Sum(CD_TrdBuyBrokerage       
       +(case When Service_chrg = 1             
                Then CD_TrdBuySerTax                
  Else 0      
           End)),             
Pqtydel =0,             
Pamtdel = Sum(CD_DelBuyBrokerage       
       + (case When Service_chrg = 1             
                Then CD_DelBuySerTax                
  Else 0      
           End)),      
Sqtytrd =0,             
Samttrd= Sum(CD_TrdSellBrokerage       
       + (case When Service_chrg = 1             
                Then CD_TrdSellSerTax                
  Else 0      
           End)),             
Sqtydel =0,             
Samtdel =Sum(CD_DelSellBrokerage       
       + (case When Service_chrg = 1             
                Then CD_DelSellSerTax                
  Else 0      
           End)),             
Pbroktrd =  Sum(CD_TrdBuyBrokerage),             
Sbroktrd =  Sum(CD_TrdSellBrokerage),      
Pbrokdel =  Sum(CD_DelBuyBrokerage),      
Sbrokdel = Sum(CD_DelSellBrokerage),      
Family,familyname='',terminal_id='0',clienttype=cl_type,tradetype='s',trader,sub_broker,branch_cd,Membercode,            
Pamt = Sum(CD_TrdBuyBrokerage+ CD_DelBuyBrokerage      
       + (case When Service_chrg = 1             
                Then CD_TrdBuySerTax+CD_DelBuySerTax                
  Else 0      
           End)),              
Samt = Sum(CD_TrdSellBrokerage+ CD_DelSellBrokerage      
       + (case When Service_chrg = 1             
                Then CD_TrdSellSerTax+CD_DelSellSerTax                
  Else 0      
           End)),              
Prate = 0,      
Srate = 0,      
Trdamt = 0,      
Delamt =0,             
Serinex=Service_chrg,            
Service_tax=Sum(CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax ),            
Exservice_tax= Sum(case When Service_chrg = 2            
        Then (CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax )            
        Else 0             
   End),             
Turn_tax = 0,            
Sebi_tax =0,              
Ins_chrg =0,            
Broker_chrg =0,            
Other_chrg =0,              
Region, Start_date='', End_date='', Update_date=left(convert(varchar,getdate(),109),11), Status_name=@statusname,            
Exchange='nse',segment='capital',membertype=membercode,companyname='',dummy1='',dummy2='',dummy3='',dummy4=0,dummy5=0, Area            
From Charges_Detail S, Client2 C2, Owner,client1  C1             
Where C2.party_code = S.CD_party_code And C1.cl_code = C2.cl_code              
And S.CD_sett_no = @sett_no And S.CD_sett_type = @sett_type            
Group By cd_Sett_no,cd_sett_type,S.CD_party_code,c1.long_name,S.CD_scrip_cd,S.CD_series,left(convert(varchar,S.CD_sauda_date,109),11),            
C1.family,trader,sub_broker,membercode,Service_chrg,branch_cd,cl_type, Region, Area             
            
Insert Into CMBillValan_Up             
Select S.sett_no,s.sett_type,billno,s.contractno,s.party_code,party_name= C1.long_name,s.scrip_cd,s.series,            
Scrip_name='',isin='',sauda_date=left(convert(varchar,s.sauda_date,109),11),            
Pqtytrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag = 2             
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag = 2             
          Then Tradeqty             
     Else 0             
     End )             
      End),             
Pamttrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag = 2             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag = 2             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Pqtydel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag In (1,4)             
          Then Tradeqty             
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag In (1,4)            
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Pamtdel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 1 And Billflag In (1,4)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 1 And Settflag In (1,4)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate + Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Sqtytrd = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag = 3            
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag = 3             
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Samttrd = Sum(case When Billno > 0             
            Then (case When Sell_buy = 2 And Billflag = 3             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag = 3             
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Sqtydel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag In (1,5)            
          Then Tradeqty            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag In (1,5)            
          Then Tradeqty             
          Else 0             
     End )             
      End),             
Samtdel = Sum(case When Billno > 0             
             Then (case When Sell_buy = 2 And Billflag In (1,5)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      Else (case When Sell_buy = 2 And Settflag In (1,5)            
        Then (case When Service_chrg = 1             
                           Then Tradeqty * N_netrate - Nsertax               
                           Else Tradeqty * N_netrate             
                  End )            
          Else 0             
     End )             
      End),             
Pbroktrd = Sum(case When Billno > 0             
         Then (case When Sell_buy = 1 And Billflag = 2             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 1 And Settflag = 2            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),             
Sbroktrd = Sum(case When Billno > 0             
         Then (case When Sell_buy = 2 And Billflag = 3            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 2 And Settflag = 3            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),            
Pbrokdel = Sum(case When Billno > 0             
         Then (case When Sell_buy = 1 And Billflag In (1,4)             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 1 And Settflag In (1,4)            
           Then Tradeqty*nbrokapp            
                      Else 0             
           End)            
              End),            
Sbrokdel =  Sum(case When Billno > 0             
         Then (case When Sell_buy = 2 And Billflag In (1,5)             
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
  Else            
            (case When Sell_buy = 2 And Settflag In (1,5)            
                      Then Tradeqty*nbrokapp            
                      Else 0             
            End)            
              End),            
Family,familyname='',terminal_id=user_id,clienttype=cl_type,tradetype='i',trader,sub_broker,branch_cd,partipantcode,            
Pamt = Isnull(sum(case When Sell_buy = 1             
      Then (case When Service_chrg = 2             
                 Then Tradeqty * N_netrate               
          Else Tradeqty * N_netrate + Nsertax            
     End )             
   Else 0             
   End),0),              
Samt = Isnull(sum(case When Sell_buy = 2             
      Then (case When Service_chrg = 2             
                 Then Tradeqty * N_netrate               
          Else Tradeqty * N_netrate - Nsertax            
     End )             
   Else 0             
   End),0),              
Prate = 0,              
Srate = 0,            
Trdamt = Sum(tradeqty*s.marketrate),             
Delamt = Sum(tradeqty*s.marketrate),             
Serinex = Service_chrg,            
Service_tax = Sum(nsertax),            
Exservice_tax = Sum(case When Service_chrg = 2             
        Then (nsertax)            
        Else 0             
   End),            
Turn_tax = 0,            
Sebi_tax = 0,              
Ins_chrg = Sum(case When Dispcharge = 1             
   Then (case When Insurance_chrg = 1             
       Then (ins_chrg)               
            Else 0             
         End)                
   Else 0             
     End),            
Broker_chrg = 0,            
Other_chrg = 0,              
Region, Start_date='', End_date='', Update_date=left(convert(varchar,getdate(),109),11), Status_name=@statusname,            
Exchange='nse',segment='capital',membertype=membercode,companyname='',dummy1='',dummy2='',dummy3='',dummy4=0,dummy5=0,area            
From Isettlement_valan S, Client2 C2, Owner,client1  C1             
Where C2.party_code = S.party_code And C1.cl_code = C2.cl_code              
And S.sett_no = @sett_no And S.sett_type = @sett_type             
And Auctionpart Not In ('ap','ar')              
Group By Sett_no,sett_type,contractno,billno,s.party_code,c1.long_name,s.scrip_cd,s.series,left(convert(varchar,s.sauda_date,109),11),            
C1.family,user_id,trader,sub_broker,partipantcode,membercode,            
Service_chrg,branch_cd,cl_type, Region, Area            
            
Update CMBillValan_Up Set Scrip_name = S1.long_name From Scrip1 S1, Scrip2 S2             
Where S1.co_code = S2.co_code And S1.series = S2.series And S2.scrip_cd = CMBillValan_Up.scrip_cd             
And CMBillValan_Up.sett_no = @sett_no And CMBillValan_Up.sett_type = @sett_type            
            
Update CMBillValan_Up Set Isin = M.isin From Multiisin M             
Where M.scrip_cd = CMBillValan_Up.scrip_cd And Valid = 1             
And CMBillValan_Up.sett_no = @sett_no And CMBillValan_Up.sett_type = @sett_type            
    
Update CMBillValan_Up Set Family_name = C1.long_name From Client1 C1            
Where C1.family = CMBillValan_Up.family             
And CMBillValan_Up.sett_no = @sett_no And CMBillValan_Up.sett_type = @sett_type            
    
Update CMBillValan_Up Set Start_date = Left(convert(varchar,s.start_date,109),11),end_date = Left(convert(varchar,s.end_date,109),11)            
From Sett_mst S Where S.sett_no = CMBillValan_Up.sett_no And S.sett_type = CMBillValan_Up.sett_type            
And CMBillValan_Up.sett_no = @sett_no And CMBillValan_Up.sett_type = @sett_type            
    
Delete From CMBillValan Where Sett_no = @sett_no And Sett_type = @sett_type            
    
Insert into CmBillValan    
Select * from CMBillValan_Up

GO
