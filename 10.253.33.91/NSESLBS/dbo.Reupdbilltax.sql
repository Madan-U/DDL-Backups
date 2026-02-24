-- Object: PROCEDURE dbo.Reupdbilltax
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 01/15/2005 1:13:35 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 12/16/2003 2:31:22 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 05/08/2002 12:35:05 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 01/14/2002 20:32:47 ******/  
  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 12/26/2001 1:23:13 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 4/6/01 7:04:01 Pm ******/  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 3/17/01 9:55:54 Pm ******/  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 3/21/01 12:50:11 Pm ******/  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 20-mar-01 11:38:53 Pm ******/  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 2/5/01 12:06:15 Pm ******/  
/****** Object:  Stored Procedure Dbo.reupdbilltax    Script Date: 12/27/00 8:58:52 Pm ******/  
  
/* Changed By Bgg 24 Apr 2001 For Rounding   */  
  
Create Proc Reupdbilltax (@sett_no Varchar(10), @sett_type Varchar(3),@scrip_cd Varchar(12),@series Varchar(2)) As  
Update Settlement Set  
 Nbrokapp = (  Case    
 When ( Settlement.billflag = 4  And Broktable.val_perc ="v" )  
 Then /* Broktable.normal  */  
  ((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))  
 When ( Settlement.billflag = 4  And Broktable.val_perc ="p" )  
 Then  /* Round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to) */  
  ((floor(( ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))  
 When ( Settlement.billflag = 5  And Broktable.val_perc ="v" )  
 Then /* Broktable.normal  */  
  ((floor(( Broktable.normal * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))  
 When ( Settlement.billflag = 5  And Broktable.val_perc ="p" )  
 Then /* Round((broktable.normal /100 ) * Settlement.marketrate,broktable.round_to)*/  
   ((floor(( ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
   (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
   Power(10,broktable.round_to))  
  
                  Else    
                       Brokapplied   
                  End   
                  ),  
     N_netrate = (  Case    
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="v" )  
                        Then /* ((broktable.normal + Settlement.marketrate ) ) */  
  ((floor(( ((broktable.normal + Settlement.marketrate ) ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))  
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="p" )  
/*                        Then ((settlement.marketrate + Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to))) */  
                        Then Settlement.marketrate +   
  ((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))                          
                        When ( Settlement.billflag =5  And Broktable.val_perc ="v" )  
                        Then /* (( Settlement.marketrate - Broktable.normal )) */  
  ((floor(( (( Settlement.marketrate - Broktable.normal )) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))                          
                        When ( Settlement.billflag =5  And Broktable.val_perc ="p" )  
/*                        Then ((settlement.marketrate - Round((broktable.normal /100 )* Settlement.marketrate,broktable.round_to))) */  
                        Then Settlement.marketrate -   
  ((floor(( ((broktable.normal /100 )* Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
  Power(10,broktable.round_to))  
                    Else    
                        Netrate   
                    End   
                 ),  
  
Nsertax = (case   
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="v" )  
                             Then   
                                 /*  Round((round(broktable.normal,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to) */  
                                       ((floor((   
                                                  (((((floor((( Broktable.normal)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
                                                             (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))      
                                  
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="p" )  
                             Then /* Round(((round(( Broktable.normal/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */  
                                  ((floor((   
                                             (((((floor((   ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
                                                          Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
                                                          (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))  
                                    
                               
                        When ( Settlement.billflag = 5  And Broktable.val_perc ="v" )  
                             Then   
                                  /* Round ( (round(broktable.normal ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)  */  
                                  ((floor((   
                                             (((((floor((( Broktable.normal)  * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  
                                                            Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100)   *   Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /                                                               (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))      
  
                        When ( Settlement.billflag = 5  And Broktable.val_perc ="p" )  
                             Then /*  Round(((round((broktable.normal/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to) */  
                                      ((floor((   
                                                   (((((floor((   ((broktable.normal /100 ) * Settlement.marketrate) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable
.nozero ) ) /  
                                                          Power(10,broktable.round_to))) * Settlement.tradeqty * Globals.service_tax) / 100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
                                                          (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to))  
   Else   
                         Settlement.service_tax  
                    End   
                ),  
  
  
  
  
  
  
  
  
  
  
  /*       Nsertax = (case   
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="v" )  
                             Then Round((round(broktable.normal,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) / 100,broktable.round_to)  
                        When ( Settlement.billflag = 4  And Broktable.val_perc ="p" )  
                             Then Round(((round(( Broktable.normal/100) *  Settlement.marketrate,broktable.round_to)  * Settlement.tradeqty * Globals.service_tax)/100 ),broktable.round_to)  
                        When ( Settlement.billflag = 5  And Broktable.val_perc ="v" )  
                             Then Round ( (round(broktable.normal ,broktable.round_to) * Settlement.tradeqty* Globals.service_tax) /100,broktable.round_to)  
                        When ( Settlement.billflag = 5  And Broktable.val_perc ="p" )  
                             Then  Round(((round((broktable.normal/100) * Settlement.marketrate,broktable.round_to) * Settlement.tradeqty * Globals.service_tax)  /100),broktable.round_to)   
   Else   
                         Settlement.service_tax  
                    End   
                ),  
  
  
        Ins_chrg  = Round(((taxes.insurance_chrg * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),   
        Turn_tax  = Round(((taxes.turnover_tax * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to),                
        Other_chrg = Round(((taxes.other_chrg * Settlement.marketrate * Settlement.tradeqty)/100 ),broktable.round_to),   
        Sebi_tax = Round(((taxes.sebiturn_tax * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to),                
        Broker_chrg = Round(((taxes.broker_note * Settlement.marketrate * Settlement.tradeqty)/100),broktable.round_to)   */  
  
  
        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /power(10,broktable.round_to)),  
        Turn_tax  =  ((floor(( ((taxes.turnover_tax *settlement.marketrate *settlement.tradeqty)/100 ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) /  
  (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /    Power(10,broktable.round_to)),  
        Other_chrg = ((floor(( ((taxes.other_chrg *settlement.marketrate *settlement.tradeqty)/100 ) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /  Power(10,broktable.round_to)),  
        Sebi_tax =     ((floor(( ((taxes.sebiturn_tax *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) / Power(10,broktable.round_to)),  
        Broker_chrg =  ((floor(( ((taxes.broker_note *settlement.marketrate *settlement.tradeqty)/100) * Power(10,broktable.round_to)+broktable.rofig + Broktable.errnum ) / (broktable.rofig + Broktable.nozero )) * (broktable.rofig +broktable.nozero ) ) /power(10,broktable.round_to)),   Amount = Netrate * Tradeqty , Trade_amount = Tradeqty * Marketrate  
        From Broktable,client2,taxes,globals,scrip1,scrip2,sett_mst,client1      Where   
            Settlement.party_code = Client2.party_code  
        And  
            Client1.cl_code=client2.cl_code  
        And     
           ((settlement.sauda_date <= Sett_mst.end_date) And (settlement.sauda_date >= Sett_mst.start_date))  
      
       And  
           (sett_mst.sett_type = Settlement.sett_type       )    
       And   
           (settlement.series = Scrip2.series)  
       And  
          (scrip2.scrip_cd = Settlement.scrip_cd)  
       And   
          (scrip2.co_code = Scrip1.co_code)   
       And  
          (scrip2.series = Scrip1.series)   
       And   
           Broktable.table_no = ( Case When (client2.tran_cat = 'trd')  Then   
                           Client2.sub_tableno              
   End )  
            And   
            Broktable.line_no = ( Case When (client2.tran_cat = 'trd')   Then   
     (select Min(broktable.line_no) From Broktable Where  
                                Broktable.table_no = Client2.sub_tableno  
     And Settlement.party_code =  Client2.party_code      
     And Trd_del = 'd'  
                                          And Settlement.marketrate <= Broktable.upper_lim )              
                       End )   
                 
                 
           And  
             (client2.tran_cat = Taxes.trans_cat)  
           And  
             (taxes.exchange = 'nse')          
And Client2.tran_cat = 'trd'      
  And (billflag = 4 Or Billflag = 5)  
  And Settlement.tradeqty > 0  
  And Settlement.sett_type Not In ('l','p')  
  And Settlement.status <> 'e'   /*added By Vaishali On 03/03/2001*/   
And Settlement.sett_no = @sett_no  
And Settlement.sett_type = @sett_type  
And Settlement.scrip_cd = @scrip_cd  
And Settlement.series = @series  
  
  
/*  Added By Animesh For Angel Cause They Want Stamp Duty For Only In Delivery Position On 13 Aug 2001 */  
  
Update History Set Broker_chrg = 0 Where Billflag In (2,3)

GO
