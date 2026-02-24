-- Object: PROCEDURE dbo.BBGSettBrokUpdateNew_temp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
CREATE procedure  
 [dbo].[BBGSettBrokUpdateNew_temp]   
as  
  
Declare  
@@Sell_buy As Int,  
@@Pqty As Int,  
@@Sqty As Int,  
@@Prate As Money,  
@@Srate As Money,  
@@TPqty As Int,  
@@TSqty As Int,  
@@TPrate As Money,  
@@TSrate As Money,  
@@PARTIPANTCODE Varchar(25),  
@@Tmark Varchar(3),  
@@Sett_no  As varchar(10),  
@@PMore AS Char (1),  
@@PRateMore As Char(1),  
@@SMore AS Char (1),  
@@SRateMore As Char(1),  
@@EQ As Char(1),  
@@GetPos AS Cursor,  
@@Series Varchar(3)  
  
Update bbgsettlement set Tmark = 'N'   
  
select t1.party_code,t1.scrip_cd,t1.series,  
pqty = Sum(Case When Sell_buy = 1 then tradeqty else 0 end ),  
prate = (Case When Sum(Case When Sell_buy = 1 then tradeqty else 0 end ) > 0   
         Then Sum(Case When Sell_buy = 1 then tradeqty*MarketRate else 0 end )/ Sum(Case When Sell_buy = 1 then tradeqty else 0 end ) Else 0 End),  
sqty = Sum(Case When Sell_buy = 2 then tradeqty else 0 end ),  
srate = (Case When Sum(Case When Sell_buy = 2 then tradeqty else 0 end ) > 0   
         Then Sum(Case When Sell_buy = 2 then tradeqty*MarketRate else 0 end )/ Sum(Case When Sell_buy = 2 then tradeqty else 0 end ) Else 0 End)  
into #SETT_BAK from bbgsettlement t1  
WHERE TRADEQTY > 0   
Group by t1.party_code,t1.scrip_cd,t1.series  
  
  
/*Select @Tparty,@TdATE ,@Tscrip_cd,@Tmark*/  
update bbgsettlement set Tmark = Tmark,  
    Table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,  
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,  
    Sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,  
    BrokApplied =(Case  
  when bbgsettlement.status = 'N' then 0  
        else  
               (  case  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                              Then  /* broktable.Normal */  
  ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* broktable.Normal  */  
  ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * bbgsettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                        when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)         */  
  ((floor(( ((broktable.Normal /100 )* bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                            Then /* ((broktable.day_puc)) */  
  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                             Then /* round((broktable.day_puc/100) * bbgsettlement.marketrate,CT.Round_To)  */  
  ((floor(( ((broktable.day_puc/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                   when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
       Then /* broktable.day_sales */  
  
  ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                  when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                             Then /*round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((broktable.day_sales/ 100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_purch  */  
  ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((broktable.sett_purch/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
             when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_sales */  
  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)*/  
  ((floor(( ((broktable.sett_sales/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
   Else  0  
                        End)  
                       END  ),  
       NetRate = (Case  
  when bbgsettlement.status = 'N' then bbgsettlement.MARKETRATE  
        else  
(  case  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( bbgsettlement.marketrate + broktable.Normal),CT.Round_To) */  
                                                                 bbgsettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
  
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                                                       Then /* round((bbgsettlement.marketrate - broktable.Normal ),CT.Round_To )    */  
                                                                  bbgsettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To)) 
 
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (bbgsettlement.marketrate + round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)) */  
                                                                   bbgsettlement.marketrate + ((floor(( (((broktable.Normal /100 )* bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                                   Then /* (bbgsettlement.marketrate - round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To))           */  
                                                                   bbgsettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* bbgsettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                                                    Then /* round((broktable.day_puc + bbgsettlement.marketrate ),CT.Round_To)*/  
                                                                 bbgsettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) 
 
                                         when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate + round((broktable.day_puc/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                bbgsettlement.marketrate + ((floor(( (((broktable.day_puc/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero )
 )  / power(10,CT.Round_To))  
                                          when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                                                     Then /* round((bbgsettlement.marketrate - broktable.day_sales),CT.Round_To)*/  
                                                               bbgsettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate - round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                bbgsettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                                                     Then /* round((broktable.sett_purch + bbgsettlement.marketrate ),CT.Round_To )*/  
                                                                 bbgsettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To
))  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                                                      Then /* (bbgsettlement.marketrate + round(( broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                 bbgsettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                        when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='V' )  
                                                      Then /* round(( bbgsettlement.marketrate - broktable.sett_sales ),CT.Round_To) */  
                                                                   bbgsettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
  
                                         when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='P' )  
                                                     Then /* (bbgsettlement.marketrate - round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)) */  
                                                                 bbgsettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To))  
   Else  0  
                        End)  
                    END     ),  
       Amount = (Case  
  when bbgsettlement.status = 'N' then bbgsettlement.MARKETRATE * bbgsettlement. TRADEQTY  
        else  
(  case  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( bbgsettlement.marketrate + broktable.Normal),CT.Round_To) */  
                                                             bbgsettlement.Tradeqty  *  (  bbgsettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
  
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                                                       Then /* round((bbgsettlement.marketrate - broktable.Normal ),CT.Round_To )    */  
                                                                bbgsettlement.Tradeqty * (   bbgsettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) 
 /  power(10,CT.Round_To)))  
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (bbgsettlement.marketrate + round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)) */  
                                                               bbgsettlement.Tradeqty  * (   bbgsettlement.marketrate + ((floor(( (((broktable.Normal /100 )* bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                                                       Then /* (bbgsettlement.marketrate - round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To))           */  
                                                                bbgsettlement.Tradeqty * (   bbgsettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* bbgsettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                                                    Then /* round((broktable.day_puc + bbgsettlement.marketrate ),CT.Round_To)*/  
                                                             bbgsettlement.Tradeqty * (    bbgsettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) 
 / power(10,CT.Round_To)))  
                                         when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate + round((broktable.day_puc/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                          bbgsettlement.Tradeqty * ( bbgsettlement.marketrate + ((floor(( (((broktable.day_puc/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (
CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                                                     Then /* round((bbgsettlement.marketrate - broktable.day_sales),CT.Round_To)*/  
                                                              bbgsettlement.Tradeqty * ( bbgsettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  
/ power(10,CT.Round_To)))  
                                         when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate - round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                              bbgsettlement.Tradeqty * (  bbgsettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                                                     Then /* round((broktable.sett_purch + bbgsettlement.marketrate ),CT.Round_To )*/  
                                                               bbgsettlement.Tradeqty * (  bbgsettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero )
 )  / power(10,CT.Round_To)))  
  
  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                                                      Then /* (bbgsettlement.marketrate + round(( broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                               bbgsettlement.Tradeqty * (  bbgsettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                        when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='V' )  
                                                      Then /* round(( bbgsettlement.marketrate - broktable.sett_sales ),CT.Round_To) */  
                                                     bbgsettlement.Tradeqty * ( bbgsettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power
(10,CT.Round_To)) )  
                                         when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='P' )  
                                                     Then /* (bbgsettlement.marketrate - round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)) */  
                                                       bbgsettlement.Tradeqty  * (  bbgsettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero ))
 * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To)))  
   Else  0  
                        End )  
                      END   ),  
/*       Ins_chrg  =(Case  
  when bbgsettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.insurance_chrg * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),  
  
  
        turn_tax  = (Case  
  when bbgsettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.turnover_tax * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /  
  power(10,CT.Round_To))END),  
  
        other_chrg =(Case  
  when bbgsettlement.status = 'N' then 0  
  ELSE  ((floor(( ((CT.other_chrg * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /  power(10,CT.Round_To))END),  
  
        sebi_tax =(Case  
  when bbgsettlement.status = 'N' then 0  
     ELSE  ((floor(( ((CT.sebiturn_tax * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) / power(10,CT.Round_To))END),  
  
        Broker_chrg = (Case  
  when bbgsettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.broker_note * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),  
*/  
  
  
        Ins_chrg  = ((CT.insurance_chrg * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100),  
        turn_tax  = ((CT.turnover_tax * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100 ),  
        other_chrg = ((CT.other_chrg * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100 ),  
        sebi_tax = ((CT.sebiturn_tax * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100),  
        Broker_chrg = ((CT.broker_note * bbgsettlement.marketrate * bbgsettlement.Tradeqty)/100),  
  
        Service_tax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1  
        Then 0  
        Else (Case  
  when bbgsettlement.status = 'N' then 0  
        else  
 (  case  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                              Then  
  ( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* broktable.Normal  */  
  (( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To))) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                      ((    ((floor ( (((broktable.Normal /100 ) * bbgsettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                        when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)         */  
  ((  ((floor(( ((broktable.Normal /100 )* bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                            Then /* ((broktable.day_puc)) */  
  ((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                             Then /* round((broktable.day_puc/100) * bbgsettlement.marketrate,CT.Round_To)  */  
  (( ((floor(( ((broktable.day_puc/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                   when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                             Then /* broktable.day_sales */  
  (( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))   ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                  when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                             Then /*round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ( (  ((floor(( ((broktable.day_sales/ 100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                 when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_purch  */  
  (( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((  ((floor(( ((broktable.sett_purch/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
             when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_sales */  
  ((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
 when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)*/  
  ((  ((floor(( ((broktable.sett_sales/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
   Else  0  
                        End  
                         )  
   End )  
                     END    )/*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Globals.service_tax)  END )*/,  
      Trade_amount = bbgsettlement.Tradeqty * bbgsettlement.MarketRate,  
      NBrokApp = (Case  
  when bbgsettlement.status = 'N' then 0  
        else  
(  case  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                              Then  /* broktable.Normal */  
  ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* broktable.Normal  */  
  ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * bbgsettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                        when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)         */  
  ((floor(( ((broktable.Normal /100 )* bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                            Then /* ((broktable.day_puc)) */  
  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                             Then /* round((broktable.day_puc/100) * bbgsettlement.marketrate,CT.Round_To)  */  
  ((floor(( ((broktable.day_puc/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                   when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                             Then /* broktable.day_sales */  
  ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                  when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                             Then /*round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((broktable.day_sales/ 100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_purch  */  
  ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((broktable.sett_purch/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
             when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_sales */  
  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)*/  
  ((floor(( ((broktable.sett_sales/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
   Else  0  
                        End )  
                        end ),  
        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1  
        Then 0  
        Else  (Case  
  when bbgsettlement.status = 'N' then 0  
        else  
 (  case  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                              Then  
  ( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* broktable.Normal  */  
  (( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To))) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                      ((    ((floor ( (((broktable.Normal /100 ) * bbgsettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                        when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)         */  
  ((  ((floor(( ((broktable.Normal /100 )* bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                            Then /* ((broktable.day_puc)) */  
  ((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                             Then /* round((broktable.day_puc/100) * bbgsettlement.marketrate,CT.Round_To)  */  
  (( ((floor(( ((broktable.day_puc/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                   when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                             Then /* broktable.day_sales */  
  (( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))   ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                  when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                             Then /*round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ( (  ((floor(( ((broktable.day_sales/ 100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                 when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_purch  */  
  (( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To) */  
  ((  ((floor(( ((broktable.sett_purch/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
             when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='V' )  
                             Then /* broktable.sett_sales */  
  ((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
 when ( bbgsettlement.SettFlag = 5  and broktable.val_perc ='P' )  
                             Then /* round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)*/  
  ((  ((floor(( ((broktable.sett_sales/100) * bbgsettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( bbgsettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
   Else  0  
                        End  
                         )  
   End )  
                     END    ),  
N_NetRate =(Case  
  when bbgsettlement.status = 'N' then bbgsettlement.MARKETRATE  
        else  
(  case  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( bbgsettlement.marketrate + broktable.Normal),CT.Round_To) */  
                                                                 bbgsettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
  
  
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)  
                                           Then /* round((bbgsettlement.marketrate - broktable.Normal ),CT.Round_To )    */  
                                                                  bbgsettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To)) 
 
                                           when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (bbgsettlement.marketrate + round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To)) */  
                                                                   bbgsettlement.marketrate + ((floor(( (((broktable.Normal /100 )* bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when ( bbgsettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)  
                                                       Then /* (bbgsettlement.marketrate - round((broktable.Normal /100 )* bbgsettlement.marketrate,CT.Round_To))           */  
                                                                   bbgsettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* bbgsettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='V' )  
                                                    Then /* round((broktable.day_puc + bbgsettlement.marketrate ),CT.Round_To)*/  
                                                                 bbgsettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) 
 
                                         when (bbgsettlement.SettFlag = 2  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate + round((broktable.day_puc/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                bbgsettlement.marketrate + ((floor(( (((broktable.day_puc/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero )
 )  / power(10,CT.Round_To))  
                                          when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='V' )  
                                                     Then /* round((bbgsettlement.marketrate - broktable.day_sales),CT.Round_To)*/  
                                                               bbgsettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (bbgsettlement.SettFlag = 3  and broktable.val_perc ='P' )  
                                                    Then /* (bbgsettlement.marketrate - round((broktable.day_sales/ 100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                bbgsettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='V' )  
                                                     Then /* round((broktable.sett_purch + bbgsettlement.marketrate ),CT.Round_To )*/  
                                                                 bbgsettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To
))  
                                         when ( bbgsettlement.SettFlag = 4  and broktable.val_perc ='P' )  
                                                      Then /* (bbgsettlement.marketrate + round(( broktable.sett_purch/100) * bbgsettlement.marketrate ,CT.Round_To))*/  
                                                                 bbgsettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                        when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='V' )  
                                                      Then /* round(( bbgsettlement.marketrate - broktable.sett_sales ),CT.Round_To) */  
                                                                   bbgsettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when ( bbgsettlement.SettFlag =5  and broktable.val_perc ='P' )  
                                                     Then /* (bbgsettlement.marketrate - round((broktable.sett_sales/100) * bbgsettlement.marketrate ,CT.Round_To)) */  
                                                                 bbgsettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * bbgsettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To))  
   Else  0  
                        End )  
                        end )  
  
   FROM trd_BrokTable BrokTable ,Client2 ,bbgsettlement ,globals, client1 , trd_ClientBrok_Scheme S, trd_ClientTaxes_New CT, Owner, #SETT_BAK T  
   WHERE bbgsettlement.Party_Code = Client2.Party_code  
   and client1.cl_code=client2.cl_code  
   And Client2.Party_Code = CT.Party_Code  
   And Client2.Tran_Cat = CT.Trans_Cat  
   And bbgsettlement.Party_Code = T.Party_code  
   And bbgsettlement.Scrip_Cd = T.Scrip_Cd  
   And bbgsettlement.Series = T.Series  
   And S.Trade_Type = (Case When bbgsettlement.PARTIPANTCODE = MemberCode Then 'NRM' Else 'INS' End)  
   And bbgsettlement.Sauda_Date Between FromDate And ToDate  
   And S.Table_No = Broktable.Table_no  
   And S.Scheme_Type = Client2.Tran_Cat  
   And S.Scrip_Cd = 'ALL'  
   And S.PARTY_CODE = bbgsettlement.Party_Code  
   And bbgsettlement.Sauda_Date Between S.From_Date And S.To_Date  
   And Broktable.Line_no = ( case when S.BrokScheme = 2 then  
           (Select min(Broktable.line_no) from trd_BrokTable broktable where  
                                                     S.Table_No = Broktable.Table_no  
                         and Trd_Del =  
           ( Case When PQty = SQty then  
          ( Case When PRate > SRate  
          then ( Case When ( bbgsettlement.Sell_Buy = 1 )  
                          Then 'F'  
                          Else 'S'  
                 End )  
          Else  
               ( Case When ( bbgsettlement.Sell_Buy = 2 )  
                          Then 'F'  
                   Else 'S'  
                 End )  
          End )  
           Else  
         ( Case When PQty >= SQty  
                then ( Case When ( bbgsettlement.Sell_Buy = 1 )  
                         Then 'F'  
  
                         Else 'S'  
                End )  
                Else  
                    ( Case When ( bbgsettlement.Sell_Buy = 2 )  
                               Then  
                                                                                              'F'  
                                                                                          Else  
              'S'  
                      End )  
           End )  
           End )  
           and bbgsettlement.Party_Code =  Client2.Party_code  
                                                     and bbgsettlement.marketrate <= Broktable.upper_lim)  
      else ( case when S.BrokScheme = 1 then  
                 (Select min(Broktable.line_no) from trd_BrokTable broktable where  
                                                     S.Table_No = Broktable.Table_no  
                         and Trd_Del = ( Case When PQty >= SQty  
           then ( Case When ( bbgsettlement.Sell_Buy = 1 )  
                    Then 'F'  
                    Else 'S'  
                 End )  
                Else  
                ( Case When ( bbgsettlement.Sell_Buy = 2 )  
                    Then 'F'  
                    Else 'S'  
                 End )  
             End )  
                                                     and bbgsettlement.Party_Code =  Client2.Party_code  
                                                     and bbgsettlement.marketrate <= Broktable.upper_lim)  
       else ( case when S.BrokScheme = 3 then  
                     (Select min(Broktable.line_no) from trd_BrokTable broktable where  
                                                             S.Table_No = Broktable.Table_no  
                                 and Trd_Del = ( Case When PQty <= SQty  
                   then ( Case When ( bbgsettlement.Sell_Buy = 2 )  
                               Then 'F'  
                             Else 'S'  
                   End )  
                   Else ( Case When ( bbgsettlement.Sell_Buy = 1 )  
                        Then 'F'  
                        Else 'S'  
                     End )  
                     End )  
                                                      and bbgsettlement.Party_Code =  Client2.Party_code  
                                                      and bbgsettlement.marketrate <= Broktable.upper_lim)  
        else  
               (Select min(Broktable.line_no) from broktable  
                where S.Table_No = Broktable.Table_no  
                 And Trd_Del = 'T'  
                                and bbgsettlement.Party_Code =  Client2.Party_code  
                      and bbgsettlement.marketrate <= Broktable.upper_lim )  
        end )  
       end )  
      end )  
  and bbgsettlement.status <> 'E'  
  And CT.Trans_cat = Client2.Tran_cat  
  and bbgsettlement.tradeqty > 0  
  And bbgsettlement.Status <> 'E'  
  And Sauda_date > Globals.year_start_dt  
  And Sauda_date < Globals.year_end_dt  
  and trade_no not like '%C%'  
  AND TRADEQTY > 0

GO
