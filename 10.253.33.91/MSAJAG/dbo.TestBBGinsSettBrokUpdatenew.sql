-- Object: PROCEDURE dbo.TestBBGinsSettBrokUpdatenew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Procedure TestBBGinsSettBrokUpdatenew (@tparty varchar(10), @tscrip_cd varchar(12),@tdate varchar(11),@sett_type varchar(2),@Memcode varchar(15),@tmark varchar(2),@Series Varchar(3)) as 
Declare
@@Sell_buy As Int,
@@Pqty As Int,
@@Sqty As Int,
@@Prate As Money,
@@Srate As Money,
@@PArticipantcode Varchar(25),
@@Tmark Varchar(3),
@@Sett_no  As varchar(10),
@@PMore AS Char (1),
@@PRateMore As Char(1),
@@SMore AS Char (1),
@@SRateMore As Char(1),
@@EQ As Char(1),
@@GetPos AS Cursor,
@@Series Varchar(3)

Select @Tdate = Ltrim(Rtrim(@Tdate))
If Len(@Tdate) = 10 
Begin
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')
End

Select @Tparty = Ltrim(Rtrim(@Tparty))
Select @Tscrip_cd = Ltrim(Rtrim(@TScrip_cd))
Select @Tmark = Ltrim(Rtrim(@Tmark))


Set @@GetPos = Cursor for 
        Select Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Tdate + ' 00:01:01' and End_date > @Tdate + ' 00:01:01' 
        Open @@GetPos
        Fetch next from @@GetPos into @@sett_no
        Close @@GetPos
        Deallocate @@GetPos  
Print 'Date is    ' +  @Tdate
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
partipantcode,Tmark
from Isettlement t1
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
And T1.partipantcode = @Memcode
Group by T1.Sett_No,T1.Sett_Type, t1.party_code,t1.scrip_cd,t1.series,t1.sell_buy,Left(Convert(varchar,sauda_date,109),11),partipantcode,tmark /* ,SettFlag */

Open @@GetPos
Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate,@@Participantcode,@@Tmark
    Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@Participantcode,@@Tmark 


While @@Fetch_status = 0 
Begin
/*     Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@Participantcode,@@Tmark */
     If @@Sell_buy = 1
     Begin
          Set @@Pqty = @@Pqty
          Set @@Prate = @@Prate
     End
     If @@Sell_buy = 2
     Begin
          Set @@Sqty = @@Sqty
          Set @@Srate = @@Srate
     End
     Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate,@@Participantcode,@@Tmark
End        

Select @@Pqty
Select @@Prate
Select @@SQty
Select @@Srate

Set @@Pmore = 'N'
Set @@SMore = 'N'
Set @@SrateMore = 'N'
Set @@PrateMore = 'N'
Set @@Eq= 'N'

If @@Pqty > @@Sqty 
Begin
     Set @@Pmore = 'Y'
End
If @@Sqty > @@Pqty 
Begin
     Set @@Smore = 'Y'
End

If @@Pqty = @@Sqty
Begin
     Set @@Pmore = 'Y'
     Set @@Smore = 'Y'
     Set @@Eq = 'Y' 
     If @@SRate > @@PRate 
     Begin
          Set @@SRatemore = 'Y'
     End
     If @@PRate > @@SRate 
     Begin
        Set @@PRatemore = 'Y'
     End
End

/*
Select @@Pmore
Select @@Smore
Select @@PRatemore
Select @@Sratemore
Select @@Eq
*/



Select @Tparty,@TdATE ,@Tscrip_cd,@Tmark,
    table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    BrokApplied = (  case  
                         when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                               Then  
                               ((floor ( (((broktable.Normal /100 ) * s.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* s.marketrate,broktable.round_to)         */
		((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                      when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * s.marketrate,broktable.round_to)  */
		((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                   when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                  when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to) */
		((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * s.marketrate ,broktable.round_to) */
		((floor(( ((broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
             when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
                         when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)*/
		((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 		power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       NetRate = (  case  
                                          when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( s.marketrate + broktable.Normal),broktable.round_to) */
                                                                 s.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                                           when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((s.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                  s.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                                           when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to)) */
                                                                   s.marketrate + ((floor(( (((broktable.Normal /100 )* s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to))           */
                                                                   s.marketrate -  ((floor((  ( ((broktable.Normal /100 )* s.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + s.marketrate ),broktable.round_to)*/
                                                                 s.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (s.marketrate + round((broktable.day_puc/100) * s.marketrate ,broktable.round_to))*/
                                                                s.marketrate + ((floor(( (((broktable.day_puc/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                          when (s.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((s.marketrate - broktable.day_sales),broktable.round_to)*/
                                                               s.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when (s.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (s.marketrate - round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to))*/
                                                                s.marketrate - ((floor((  (((broktable.day_sales/ 100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + s.marketrate ),broktable.round_to )*/
                                                                 s.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (s.marketrate + round(( broktable.sett_purch/100) * s.marketrate ,broktable.round_to))*/
                                                                 s.marketrate + ((floor(( ( (( broktable.sett_purch/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( s.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                                   s.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                                         when ( s.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)) */
                                                                 s.marketrate -  ((floor((  (((broktable.sett_sales/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
   Else  0 

                        End 
                         ),
       Amount = 
                             (  case  
                                          when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 1)
                                                      Then /* round (( s.marketrate + broktable.Normal),broktable.round_to) */
                                                             s.Tradeqty  *  (  s.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +
broktable.NoZero ) )  / power(10,broktable.round_to)))

                                           when ( s.SettFlag = 1 and broktable.val_perc ="V" and sell_buy = 2)
                                                       Then /* round((s.marketrate - broktable.Normal ),broktable.round_to )    */
                                                                s.Tradeqty * (   s.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
                                           when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 1)
                                                        Then /* (s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to)) */
                                                               s.Tradeqty  * (   s.marketrate + ((floor(( (((broktable.Normal /100 )* s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero
 )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when ( s.SettFlag = 1 and broktable.val_perc ="P" and sell_buy = 2)
                                                       Then /* (s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to))           */
                                                                s.Tradeqty * (   s.marketrate -  ((floor((  ( ((broktable.Normal /100 )* s.marketrate))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                                                    Then /* round((broktable.day_puc + s.marketrate ),broktable.round_to)*/
                                                             s.Tradeqty * (    s.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                                                    Then /* (s.marketrate + round((broktable.day_puc/100) * s.marketrate ,broktable.round_to))*/
                                                               s.Tradeqty * ( s.marketrate + ((floor(( (((broktable.day_puc/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero ))
 * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                          when (s.SettFlag = 3  and broktable.val_perc ="V" )
                                                     Then /* round((s.marketrate - broktable.day_sales),broktable.round_to)*/
                                                              s.Tradeqty * ( s.marketrate - ((floor(( (( broktable.day_sales)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when (s.SettFlag = 3  and broktable.val_perc ="P" )
                                                    Then /* (s.marketrate - round((broktable.day_sales/ 100) * s.marketrate ,broktable.round_to))*/
                                                              s.Tradeqty * (  s.marketrate - ((floor((  (((broktable.day_sales/ 100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                         when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                                                     Then /* round((broktable.sett_purch + s.marketrate ),broktable.round_to )*/
                                                               s.Tradeqty * (  s.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable
.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))


                                         when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                                                      Then /* (s.marketrate + round(( broktable.sett_purch/100) * s.marketrate ,broktable.round_to))*/
                                                               s.Tradeqty * (  s.marketrate + ((floor(( ( (( broktable.sett_purch/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)))
                                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
                                                      Then /* round(( s.marketrate - broktable.sett_sales ),broktable.round_to) */
                                                     s.Tradeqty * ( s.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  	(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) )
                                         when ( s.SettFlag =5  and broktable.val_perc ="P" )
                                                     Then /* (s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to)) */
                                                       s.Tradeqty  * (  s.marketrate -  ((floor((  (((broktable.sett_sales/100) * s.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) 
* (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to)))
   Else  0 

                        End 
                         ),

/*        Ins_chrg  = round(((taxes.insurance_chrg * s.marketrate * s.Tradeqty)/100),broktable.round_to),
        turn_tax  = round(((taxes.turnover_tax * s.marketrate * s.Tradeqty)/100 ),broktable.round_to),
        other_chrg = round(((taxes.other_chrg * s.marketrate * s.Tradeqty)/100 ),broktable.round_to),
        sebi_tax = round(((taxes.sebiturn_tax * s.marketrate * s.Tradeqty)/100),broktable.round_to),
        Broker_chrg = round(((taxes.broker_note * s.marketrate * s.Tradeqty)/100),broktable.round_to),
*/
        Ins_chrg  = ((floor(( ((taxes.insurance_chrg *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),
        turn_tax  =  ((floor(( ((taxes.turnover_tax *s.marketrate *s.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
		power(10,broktable.round_to)),
        other_chrg = ((floor(( ((taxes.other_chrg *s.marketrate *s.Tradeqty)/100 ) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) / 	power(10,broktable.round_to)),
        sebi_tax =     ((floor(( ((taxes.sebiturn_tax *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /	power(10,broktable.round_to)),
        Broker_chrg =  ((floor(( ((taxes.broker_note *s.marketrate *s.Tradeqty)/100) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) / (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /power(10,broktable.round_to)),

 /*        Service_tax = (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to) 
                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then  round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)
   Else  0 
                        End 
                         ),  */

        Service_tax =  (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                        (((((floor((   ((broktable.Normal /100 ) * s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                          power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) 
) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero 
) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero
 ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero
 ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
      Trade_amount = s.Tradeqty * s.MarketRate,
      NBrokApp = (  case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 1)
                             Then /* broktable.Normal */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 2)
                             Then /* broktable.Normal     */
			((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 1)
                             Then /* round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) */
			((floor(( ((broktable.Normal /100 ) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* s.marketrate,broktable.round_to)         */
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc)) */
			((floor(( ((broktable.day_puc)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /* round((broktable.day_puc/100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /* broktable.day_sales */
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /* round((broktable.day_sales/ 100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then /* broktable.sett_purch                         */
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_purch/100) * s.marketrate,broktable.round_to)  */
			((floor(( ((broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then /* broktable.sett_sales */
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then /* round((broktable.sett_sales/100) * s.marketrate,Broktable.round_to) */
			((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         ),
    /*     NSertax = (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)
                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to) 
   Else  0 
                        End 
                         ),        */


        NserTax =  (case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V")
                             Then    /*  round((round (broktable.Normal,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)     */
                                       ((floor(( 
                                                    (((((floor((( Broktable.Normal)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 1 and broktable.val_perc ="P")
                             Then /*  round(((round((broktable.Normal /100 ) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to)  */
                                      ((floor(( 
                                                   (((((floor((   ((broktable.Normal /100 ) * s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero )
 ) /
                                                          power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100) * power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                          (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))


                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then  /*  round ( (round(broktable.day_puc,broktable.round_to) * s.Tradeqty * globals.service_tax) /100,broktable.round_to )   */
                                       ((floor(( 
                                                    (((((floor(( (broktable.day_puc) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
                             Then /*  round(((round((broktable.day_puc/100) *  s.marketrate,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100),broktable.round_to) */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_puc/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) 
) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
                             Then /*  round((round(broktable.day_sales,broktable.round_to) * s.Tradeqty * Globals.service_tax) / 100,broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( broktable.day_Sales ) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
                             Then /*  round(((round((broktable.day_sales/ 100) *  s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax) / 100),broktable.round_to )  */
                                       ((floor(( 
                                                    (((((floor((( (broktable.day_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero 
) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
                             Then  /*   round((round(broktable.sett_purch,broktable.round_to) * s.Tradeqty* Globals.service_tax) / 100,broktable.round_to)  */
                                       ((floor(( 
                                                    (((((floor((( broktable.sett_purch)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    



                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
                             Then /*   round(((round(( broktable.sett_purch/100) *  s.marketrate,broktable.round_to)  * s.Tradeqty * Globals.service_tax)/100 ),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_purch/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero
 ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="V" )
                             Then    /*    round ( (round(broktable.sett_sales ,broktable.round_to) * s.Tradeqty* Globals.service_tax) /100,broktable.round_to)   */

                                       ((floor(( 
                                                    (((((floor((( broktable.sett_Sales)  * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    


                        when ( s.SettFlag = 5  and broktable.val_perc ="P" )
                             Then  /*  round(((round((broktable.sett_sales/100) * s.marketrate,broktable.round_to) * s.Tradeqty * globals.service_tax)  /100),broktable.round_to)   */
                                       ((floor(( 
                                                    (((((floor((( (broktable.sett_Sales/100) *  s.marketrate) * power(10,broktable.round_to)+Broktable.roFig + Broktable.errnum ) / (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero
 ) ) /
                                                            power(10,Broktable.round_to))) * s.Tradeqty * Globals.service_tax) / 100)   *   power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                             (Broktable.RoFig + Broktable.Nozero )) * (Broktable.rofig +Broktable.NoZero ) ) / power(10,Broktable.round_to))    

   Else  0 
                        End 
                         ),
N_NetRate = (  case  
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 1)
                             Then /* ( ( s.marketrate + broktable.Normal)) */
			((floor(( ( ( s.marketrate + broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="V" and s.sell_buy = 2)
                             Then /* ((s.marketrate - broktable.Normal ) ) */
			((floor(( ((s.marketrate - broktable.Normal ) )  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))  
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 1)
/*                             Then ((s.marketrate + round((broktable.Normal /100 )* s.marketrate,broktable.round_to))) */
                             Then s.marketrate + 
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 1 and broktable.val_perc ="P" and s.sell_buy = 2)
/*                             Then ((s.marketrate - round((broktable.Normal /100 )* s.marketrate,broktable.round_to)))         */
                             Then s.marketrate -
			((floor(( ((broktable.Normal /100 )* s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="V" ) 
                             Then /* ((broktable.day_puc + s.marketrate )) */
			((floor(( ((broktable.day_puc + s.marketrate )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 2  and broktable.val_perc ="P" ) 
/*                             Then ((s.marketrate + round((broktable.day_puc/100) * s.marketrate,broktable.round_to )))	*/
                             Then 	s.marketrate + 
			((floor(( ((broktable.day_puc/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="V" )
/*                             Then ((  s.marketrate - broktable.day_sales)) */
                             Then 	s.marketrate - 
			((floor(( broktable.day_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when (s.SettFlag = 3  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate - round((broktable.day_sales/ 100) * s.marketrate,broktable.round_to ))) */
                             Then 	s.marketrate - 
			((floor(( ((broktable.day_sales/ 100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="V" )
/*                             Then ((broktable.sett_purch + s.marketrate ) ) */
                             Then 	s.marketrate + 
			((floor(( broktable.sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag = 4  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate + round(( broktable.sett_purch/100) * s.marketrate,broktable.round_to ))) */
                             Then s.marketrate + 
			((floor(( (( broktable.sett_purch/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag =5  and broktable.val_perc ="V" )
/*                             Then (( s.marketrate - broktable.sett_sales )) */
                             Then s.marketrate - 
			((floor(( broktable.sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
                        when ( s.SettFlag =5  and broktable.val_perc ="P" )
/*                             Then ((s.marketrate - round((broktable.sett_sales/100) * s.marketrate ,broktable.round_to))) */
                             Then s.marketrate - 
			((floor(( ((broktable.sett_sales/100) * s.marketrate) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /
			(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) ) /
			power(10,broktable.round_to))
   Else  0 
                        End 
                         )

                                              
      FROM BrokTable,Client2,isettlement s,taxes,globals,scrip1,scrip2,Sett_mst,client1  /* , BrokCursorSalePurins C */
      WHERE 
            s.Party_Code = Client2.Party_code
    and
     client1.cl_code=client2.cl_code
           And  
 S.SETT_NO = SETT_MST.SETT_NO 
 AND 
 S.SETT_TYPE= SETT_MST.SETT_TYPE
 AND
              (s.Series = scrip2.series)
           And
             (scrip2.scrip_cd = s.scrip_cd)
           And 
             (scrip2.co_code = scrip1.co_code) 
           And
             (scrip2.series = scrip1.series) 
           AND 
           Broktable.Table_no = ( case when ( s.series = 'EQ'  and s.markettype = '3' ) Then
				       ( Case When ( s.SELL_BUY = 1 AND s.TMARK = '$' )
					      Then client2.P_To_P
					      Else ( Case When ( s.SELL_BUY = 2 AND s.TMARK = '$' )
							    Then client2.sb_tableno
							    Else AlbmCF_tableno
						     End )
					 End )		
				  else ( case when (client2.Tran_cat = 'DEL') AND (scrip1.demat_date <= Sett_mst.Sec_payout)
		                              then client2.demat_tableno 
		                              Else ( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )
						          then client2.Sub_TableNo          
				  			  else Client2.table_no   
				                     end )
					 end  ) 
				  End )	
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'DEL') AND (s.TMark = 'D' )  then /*modified by bhagyashree on 19-07-2001 :added case for delivery client for line no selection*/
					( case when (scrip1.demat_date <= Sett_mst.Sec_payout) then
		                          (Select min(Broktable.line_no) from broktable where
		                        	Broktable.table_no = client2.demat_tableno and Trd_Del = 'D'  
                                        	and s.Party_Code =  Client2.Party_code   	
		                        	and s.marketrate <= Broktable.upper_lim )	
					else		       
					  (Select min(Broktable.line_no) from broktable where
		                       		Broktable.table_no = client2.Table_No and Trd_Del = 'D'  
                                        	and s.Party_Code =  Client2.Party_code   	
		                        	and s.marketrate <= Broktable.upper_lim ) end)
else
( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )  then 
				       (Select min(Broktable.line_no) from broktable where
		           Broktable.table_no = client2.Sub_TableNo and Trd_Del = 'D'  
                                        and s.Party_Code =  Client2.Party_code   	
		                        and s.marketrate <= Broktable.upper_lim )
				  ELSE ( case when ( s.series = 'EQ'  and s.markettype = '3' ) Then
					     (Select min(Broktable.line_no) from broktable where
	                                      Broktable.table_no = ( Case When ( s.SELL_BUY = 1 AND s.TMARK = '$' )
								     Then client2.P_To_P
								     Else ( Case When ( s.SELL_BUY = 2 AND s.TMARK = '$' )
									     	 Then client2.sb_tableno
								     		 Else AlbmCF_tableno
									    End )
								     End )		
                                              and s.Party_Code =  Client2.Party_code and Trd_Del = 'T'  	
		                              and s.marketrate <= Broktable.upper_lim )
				         Else ( case when (client2.Tran_cat = 'TRD') AND (s.TMark = 'D' )  then 
					             (Select min(Broktable.line_no) from broktable where
		                               	      Broktable.table_no = client2.demat_tableno and Trd_Del = 'D'  
                                                      and s.Party_Code =  Client2.Party_code   	
		                                      and s.marketrate <= Broktable.upper_lim )				
				  		else ( case when client2.brok_scheme = 2 then	
							    (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.table_no                                            						
				                	    and Trd_Del =							
							    ( Case When @@EQ = 'Y'/* c.PQty = c.SQty */ then	
								  ( Case When @@PrateMore = 'Y'  /* c.PRate >= c.SRate */
									 then ( Case When ( s.Sell_Buy = 1 ) 
							    		             Then 'F'  
							    		             Else 'S'
									        End )
									 Else
									      ( Case When ( s.Sell_Buy = 2 ) 
							    		             Then 'F'  
							    			     Else 'S'
									        End )					
									 End )
								   Else
									( Case When @@Pmore = 'Y' /* c.Pqty >= c.Sqty */
									       then ( Case When ( s.Sell_Buy = 1 ) 
							    			           Then 'F'  
							    			           Else 'S'
										      End )
									       Else
									           ( Case When ( s.Sell_Buy = 2 ) 
							    		                  Then 'F'  
							    			          Else 'S'
									             End )					
									  End )
								   End )
							    and s.Party_Code =  Client2.Party_code   	
                                               		    and s.marketrate <= Broktable.upper_lim)	
						else ( case when client2.brok_scheme = 1 then					
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.table_no                                            						
				                	    and Trd_Del = ( Case When @@Pmore = 'Y' /* c.Pqty >= c.Sqty */
										 then ( Case When ( s.Sell_Buy = 1 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( s.Sell_Buy = 2 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )					
									    End )
                                                	    and s.Party_Code =  Client2.Party_code   	
                                               		    and s.marketrate <= Broktable.upper_lim)							    
						else ( case when client2.brok_scheme = 3 then					
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    Broktable.table_no = Client2.table_no                                            						
				                	    and Trd_Del = ( Case When @@Smore = 'Y' /* c.Pqty > c.Sqty */
										 then ( Case When ( s.Sell_Buy = 2 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( s.Sell_Buy = 1 ) 
							    			 	    Then 'F'  
							    			 	    Else 'S'
										       End )					
									    End )
                                        	        		    and s.Party_Code =  Client2.Party_code   	
                                               			    and s.marketrate <= Broktable.upper_lim)							    
							else 
						    	   (Select min(Broktable.line_no) from broktable 
						    	    where Broktable.table_no = client2.table_no   
   		                   			    and s.Party_Code =  Client2.Party_code        
				           		    and s.marketrate <= Broktable.upper_lim )	
							end )
						end )
              				end ) 
				end )
			      end )
		end )end)
 and Taxes.Trans_cat  = (Case When client1.Cl_Type = 'PRO' Then 'PRO' Else Client2.Tran_cat End ) 
  And taxes.exchange = 'NSE'
 and RTrim(s.party_code ) = @tparty  
 and s.scrip_cd   =  @tscrip_cd  
  and s.tradeqty > 0
  and s.series Like @series
and s.sett_no = @@sett_no
and s.sett_type = @sett_Type 	
And s.Status <> 'E'
and Left(convert(varchar,s.sauda_date,109),11) = @tdate

Print 'Completed the Select '

/* If @@Rowcount = 0
 Insert into errorlog Values (Getdate(), '  In BBGinssettbrokupdatenew  did not updated  any rows   ',  @TParty + '      ' +@TScrip_cd +'     ' +@Tdate + '      ' +  @Sett_type +'   '+ @@Sett_no ,'      ' +  @Memcode + '     ' +@TMark  +   '    '  ,'      ')
*/

GO
