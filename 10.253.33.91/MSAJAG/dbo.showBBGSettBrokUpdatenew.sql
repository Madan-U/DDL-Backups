-- Object: PROCEDURE dbo.showBBGSettBrokUpdatenew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Procedure showBBGSettBrokUpdatenew (@tparty varchar(10), @tscrip_cd varchar(12),@tdate varchar(11),@sett_type varchar(2),@Memcode varchar(15),@tmark varchar(2)) as 
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
@@PArticipantcode Varchar(25),
@@Tmark Varchar(3),
@@Sett_no  As varchar(10),
@@PMore AS Char (1),
@@PRateMore As Char(1),
@@SMore AS Char (1),
@@SRateMore As Char(1),
@@EQ As Char(1),
@@GetPos AS Cursor


Set @@GetPos = Cursor for 
        Select Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Tdate + ' 00:01:01' and End_date > @Tdate + ' 00:01:01' 
        Open @@GetPos
        Fetch next from @@GetPos into @@sett_no
        Close @@GetPos
        Deallocate @@GetPos  
Print 'Sett_no is ' +  @@Sett_no
Print 'Sett_type is ' + @Sett_type
Print 'Scrip_cd is  ' + @TScrip_cd
Print 'Tmark        ' + @Tmark
Print 'Participantcode ' + @Memcode 

Set @@Pqty = 0
Set @@Prate = 0
Set @@Sqty = 0
Set @@Srate = 0

Set @@GetPos = Cursor For
select Sell_buy, 
pqty = (Case When Sell_buy = 1 then isnull(sum(tradeqty),0) else 0 end ),
prate = (Case When Sell_buy = 1 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),
Sqty = (Case When Sell_buy = 2 then isnull(sum(tradeqty),0) else 0 end ),
srate = (Case When Sell_buy = 2 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),
Partipantcode,Tmark
from Settlement t1
Where
T1.Party_code = @Tparty
And
T1.Sett_no = @@Sett_no
And
T1.Scrip_cd = @TScrip_cd
And
T1.Tmark Like @Tmark +'%'
And
Left(Convert(varchar,T1.sauda_date,109),11) = @Tdate 
And T1.Sett_type = @Sett_type
And T1.Partipantcode = @Memcode
Group by T1.Sett_No,T1.Sett_Type, t1.party_code,t1.scrip_cd,t1.series,t1.sell_buy,Left(Convert(varchar,sauda_date,109),11),Partipantcode,tmark /* ,SettFlag */

Open @@GetPos
Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate,@@Participantcode,@@Tmark
/*     Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@Participantcode,@@Tmark   */


While @@Fetch_status = 0 
Begin
     Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@Participantcode,@@Tmark  
     If @@Sell_buy = 1
     Begin
          Print 'In sell_buy = 1'    
          Set @@TPqty = @@Pqty
          Set @@TPrate = @@Prate
     End
     If @@Sell_buy = 2
     Begin
        Print 'In sell_buy = 2'
          Set @@TSqty = @@Sqty
          Set @@TSrate = @@Srate
     End
     Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate,@@Participantcode,@@Tmark
End        
Select @@TPqty
Select @@TPrate
Select @@TSQty
Select @@TSrate

Set @@Pmore = 'N'
Set @@SMore = 'N'
Set @@SrateMore = 'N'
Set @@PrateMore = 'N'
Set @@Eq= 'N'

If @@TPqty > @@TSqty 
Begin
     Set @@Pmore = 'Y'
End
If @@TSqty > @@TPqty 
Begin
     Set @@Smore = 'Y'
End

If @@TPqty = @@TSqty
Begin
     Set @@Pmore = 'Y'
     Set @@Smore = 'Y'
     Set @@Eq = 'Y' 
     If @@TSRate > @@TPRate 
     Begin
          Set @@SRatemore = 'Y'
     End
     If @@TPRate > @@SRate 
     Begin
        Set @@PRatemore = 'Y'
     End
End


Select @@Pmore
Select @@Smore
Select @@PRatemore
Select @@Sratemore
Select @@Eq


Select @Tdate = Ltrim(Rtrim(@Tdate))
If Len(@Tdate) = 10 
Begin
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')
End

Select @Tparty = Ltrim(Rtrim(@Tparty))
Select @Tscrip_cd = Ltrim(Rtrim(@TScrip_cd))
Select @Tmark = Ltrim(Rtrim(@Tmark))

Select @Tparty,@TdATE ,@Tscrip_cd,@Tmark

Select Trade_no,Tradeqty,Partipantcode, 
 Tmark = Tmark,    Table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    Sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    BrokApplied =(Case
		when settlement.status = 'N' then 0
	       else
               (  case  
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * settlement.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                   when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                  when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
             when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
   Else  0 
                        End) 
                       END  ),
       NetRate = (Case
		when settlement.status = 'N' then settlement.MARKETRATE
	       else
(  case  
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( settlement.marketrate + broktable.Normal),broktable.round_to) */
                                                                 settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((settlement.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)) */
                                                                   settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))           */
                                                                   settlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* settlement.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + settlement.marketrate ),broktable.round_to)*/
                                                                 settlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate + ((floor(( (((broktable.day_puc/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((settlement.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               settlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + settlement.marketrate ),broktable.round_to )*/
                                                                 settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to))*/
                                                                 settlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( settlement.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                                   settlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)) */
                                                                 settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 
                        End)
                    END     ),
       Amount = (Case
		when settlement.status = 'N' then settlement.MARKETRATE * settlement. TRADEQTY
	       else
(  case  
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( settlement.marketrate + broktable.Normal),broktable.round_to) */
                                                             settlement.Tradeqty  *  (  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))

                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((settlement.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                settlement.Tradeqty * (   settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)) */
                                                               settlement.Tradeqty  * (   settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))           */
                                                                settlement.Tradeqty * (   settlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* settlement.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + settlement.marketrate ),broktable.round_to)*/
                                                             settlement.Tradeqty * (    settlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate ,broktable.round_to))*/
                                                               settlement.Tradeqty * ( settlement.marketrate + ((floor(( (((broktable.day_puc/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((settlement.marketrate - broktable.day_sales),broktable.round_to)*/
                                                              settlement.Tradeqty * ( settlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to))*/
                                                              settlement.Tradeqty * (  settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + settlement.marketrate ),broktable.round_to )*/
                                                               settlement.Tradeqty * (  settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))


                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to))*/
                                                               settlement.Tradeqty * (  settlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( settlement.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                     settlement.Tradeqty * ( settlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) )
                                         when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)) */
                                                       settlement.Tradeqty  * (  settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
   Else  0 
                        End )
                      END   ),
      Ins_chrg  =(Case
		when settlement.status = 'N' then 0
		ELSE ((floor(( ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to))END),


        turn_tax  = (Case
		when settlement.status = 'N' then 0
		ELSE ((floor(( ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to))END),

        other_chrg =(Case
		when settlement.status = 'N' then 0
		ELSE  ((floor(( ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to))END),

        sebi_tax =(Case
		when settlement.status = 'N' then 0
   		ELSE  ((floor(( ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to))END),

        Broker_chrg = (Case
		when settlement.status = 'N' then 0
		ELSE ((floor(( ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to))END),

        Service_tax =(Case
		when settlement.status = 'N' then 0
	       else
(case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))       Else  0 
                        End) /*ADDED ON 27-12-2000 BY BHAGYASHREE*/
                     END    )/*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Globals.service_tax)  END )*/,
      Trade_amount = settlement.Tradeqty * settlement.MarketRate,
      NBrokApp = (Case
		when settlement.status = 'N' then 0
	       else 
(  case  
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                                          ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                      when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * settlement.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                   when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                  when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
             when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
                         when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * settlement.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))
   Else  0 
                        End )
                        end ),
        NSertax =(Case
		when settlement.status = 'N' then 0
	       else
(case  
                        when ( settlement.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * settlement.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * settlement.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  settlement.marketrate,broktable.round_to)  * settlement.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * settlement.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( settlement.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * settlement.marketrate,broktable.round_to) * settlement.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  settlement.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * settlement.Tradeqty * Globals.service_tax) /( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END ))   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))       Else  0 
                        End) /*ADDED ON 27-12-2000 BY BHAGYASHREE*/
                     END    ),       
N_NetRate =(Case
		when settlement.status = 'N' then settlement.MARKETRATE
	       else (  case  
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( settlement.marketrate + broktable.Normal),broktable.round_to) */
                                                                 settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((settlement.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (settlement.marketrate + round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to)) */
                                                                   settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( settlement.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (settlement.marketrate - round((broktable.Normal /100 )* settlement.marketrate,broktable.round_to))           */
                                                                   settlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* settlement.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + settlement.marketrate ),broktable.round_to)*/
                                                                 settlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (settlement.marketrate + round((broktable.day_puc/100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate + ((floor(( (((broktable.day_puc/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (settlement.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((settlement.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               settlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (settlement.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (settlement.marketrate - round((broktable.day_sales/ 100) * settlement.marketrate ,broktable.round_to))*/
                                                                settlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + settlement.marketrate ),broktable.round_to )*/
                                                                 settlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (settlement.marketrate + round(( broktable.sett_purch/100) * settlement.marketrate ,broktable.round_to))*/
                                                                 settlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( settlement.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( settlement.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                                   settlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( settlement.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (settlement.marketrate - round((broktable.sett_sales/100) * settlement.marketrate ,broktable.round_to)) */
                                                                 settlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 
                        End )
                        end )
                                              
      FROM BrokTable BrokTable,Client2 client2,settlement, taxes,globals, scrip1, scrip2,Sett_mst,client1 client1  /* ,BseBrokCursorAmtQtySumins c  */
      WHERE 
            settlement.Party_Code = Client2.Party_code
  and
 client1.cl_code=client2.cl_code 
 And
 settlement.SETT_NO = SETT_MST.SETT_NO 
 AND 
 settlement.SETT_TYPE= SETT_MST.SETT_TYPE
 AND
             (scrip2.bsecode = settlement.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
And Broktable.Table_no = ( Case When (client2.Tran_cat = 'DEL')  AND (scrip1.demat_date <= Sett_mst.Sec_payout) 
				 Then client2.demat_tableno
             /* To be Added by BBG fro C type of settlement  
                                             When (trade.markettype = 'O' or scrip2.delsc_Cat = 'Z')  */
                                
			         Else ( Case When  (settlement.tmark = 'Z' and client2.Tran_cat = 'TRD') 
					     Then client2.sub_tableno  	
					     Else ( case   when settlement.TMARK ='V' 
					        	 Then Client2.P_To_P
							 Else ( Case When settlement.tmark = 'S' 
					    			     Then Client2.Sb_TableNo	
					    			     Else ( Case When settlement.tmark = 'C'  	
						           			 Then Client2.AlbmCF_tableno
										 Else CLIENT2.TABLE_NO 
									    End )
					    		        End )
				       		   End )		
					End )
			   End )
	And 
	Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD') AND (settlement.TMark = 'D' )  then 
				       (Select min(Broktable.line_no) from broktable where
		                        Broktable.table_no = client2.Sub_TableNo and Trd_Del = 'D'  
                                        and settlement.Party_Code =  Client2.Party_code   	
		                        and settlement.marketrate <= Broktable.upper_lim )
				Else ( case when (client2.Tran_cat = 'DEL')   then 
					             (Select min(Broktable.line_no) from broktable where
		                               	      Broktable.table_no =   (case when settlement.tmark = 'V' then client2.p_to_p 
										else
										( Case When (scrip1.demat_date <= Sett_mst.Sec_payout)
										  Then client2.demat_tableno 
									 
										  Else client2.table_no 
									    end) End ) 	
						      and Trd_Del = 'D'  
                                                      and settlement.Party_Code =  Client2.Party_code   	
		                                      and settlement.marketrate <= Broktable.upper_lim )	
				  ELSE ( case when ( settlement.TMark = 'V' or settlement.TMark = 'S' or settlement.Tmark = 'C' ) Then
					     (Select min(Broktable.line_no) from broktable where
	                                      Broktable.table_no = ( Case When ( settlement.SELL_BUY = 2 AND settlement.TMARK = 'V' )
								     Then client2.P_To_P
								     Else ( Case When ( settlement.SELL_BUY = 1 AND settlement.TMARK = 'S' )
									     	 Then client2.sb_tableno
								     		 Else AlbmCF_tableno
									    End )
								     End )		
                                              and settlement.Party_Code =  Client2.Party_code and Trd_Del = 'T'  	
		                              and settlement.marketrate <= Broktable.upper_lim )
				  		else ( case when client2.brok_scheme = 2 then	
							    (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.table_no                                            						
				                	    and Trd_Del =							
							    ( Case When @@Eq = 'Y' then	
								  ( Case When @@PRatemore = 'Y' 
									 then ( Case When ( settlement.Sell_Buy = 1 ) 
							    		             Then 'F'  
							    		             Else 'S'
									        End )
									 Else
									      ( Case When ( settlement.Sell_Buy = 2 ) 
							    		             Then 'F'  
							    			     Else 'S'
									        End )					
									 End )
								   Else
									( Case When @@PMore = 'Y' 
									       then ( Case When ( settlement.Sell_Buy = 1 ) 
							    			           Then 'F'  
							    			           Else 'S'
										      End )
									       Else
									           ( Case When ( settlement.Sell_Buy = 2 ) 
							    		                  Then
                                                                                              'F'  
                                                                                          Else 
                                                                                              'S'
									             End )					
									  End )
								   End )
							    and settlement.Party_Code =  Client2.Party_code   	
                                               		    and settlement.marketrate <= Broktable.upper_lim)	
						else ( case when client2.brok_scheme = 1 then					
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.table_no                                            						
				                	    and Trd_Del = ( Case When @@PMore = 'Y'
										 then ( Case When ( settlement.Sell_Buy = 1 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( settlement.Sell_Buy = 2 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )					
									    End )
                                                	    and settlement.Party_Code =  Client2.Party_code   	
                                               		    and settlement.marketrate <= Broktable.upper_lim)
							else ( case when client2.brok_scheme = 3 then					
					       		   	   (Select min(Broktable.line_no) from broktable where
                                               		            Broktable.table_no = Client2.table_no                                            						
				                	            and Trd_Del = ( Case When @@SMore ='Y' 
									        	 then ( Case When ( settlement.Sell_Buy = 2 ) 
							    			           	     Then 'F'  
							    			 	             Else 'S'
										         End )
									     	    Else ( Case When ( settlement.Sell_Buy = 1 ) 
							    			 	        Then 'F'  
							    			 	        Else 'S'
										           End )					
									            End )
        	                                        	    and settlement.Party_Code =  Client2.Party_code   	
	                                               		    and settlement.marketrate <= Broktable.upper_lim)								    
								else 
							    	   (Select min(Broktable.line_no) from broktable 
							    	    where Broktable.table_no = client2.table_no   
							     	    And Trd_Del = 'T'
   		                   				    and settlement.Party_Code =  Client2.Party_code        
				           			    and settlement.marketrate <= Broktable.upper_lim )	
								end )
							end )
						end )
              				end ) 
			      end )
		end ) 	
  and settlement.status <> 'E'
           And
       Taxes.Trans_cat  = (Case When Cl_Type = 'PRO' Then 'PRO' Else Client2.Tran_cat End )
           And
             (taxes.exchange = 'NSE')
  and settlement.party_code = @tparty  
  and left(convert(varchar,settlement.sauda_date,109),11)= @tdate
  and settlement.scrip_cd = @tscrip_cd
  and settlement.tmark like @tmark + '%'
  and settlement.tradeqty > 0
  And settlement.Sett_type = @Sett_type
  And settlement.Sett_no = @@Sett_no
  And settlement.Partipantcode = @Memcode
  And Trade_no not like 'C%'   
 And  Status <> 'E'

GO
