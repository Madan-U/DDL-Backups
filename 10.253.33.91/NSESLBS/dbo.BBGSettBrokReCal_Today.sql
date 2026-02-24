-- Object: PROCEDURE dbo.BBGSettBrokReCal_Today
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE procedure
	BBGSettBrokReCal_Today
	(
		@Sett_no Varchar(7),
		@Sett_type Varchar(2),
		@Party_Code varchar(10),
		@Scrip_Cd Varchar(12),
		@series Varchar(3),
		@Sauda_date Varchar(11),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as

Declare
@@Party_code As Varchar(12),
@@Scrip_cd As Varchar(12),
@@Series As Varchar(3),
@@PartipantCode Varchar(15),
@@Sell_buy As Int,
@@Pqty As Int,
@@Sqty As Int,
@@Prate As Money,
@@Srate As Money,
@@TPqty As Int,
@@TSqty As Int,
@@TPrate As Money,
@@TSrate As Money,
@@Tmark Varchar(3),
@@Sett_no  As varchar(10),
@@PMore AS Char (1),
@@PRateMore As Char(1),
@@SMore AS Char (1),
@@SRateMore As Char(1),
@@EQ As Char(1),
@@GetPos AS Cursor,
@@GetParty As Cursor

Set @@Getparty = Cursor For
Select distinct Party_code,Scrip_cd,Series,PartipantCode From sett_25_new
Where
Sett_no = @sett_no
And
Sett_type = @Sett_type
And
Party_Code = @Party_Code
And
Scrip_Cd Like @Scrip_Cd
And
Series Like @Series
And
Sauda_Date Like @Sauda_Date + '%'

Open @@Getparty
Fetch Next from @@Getparty into @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode
/*  Select  @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode */
While @@fetch_status = 0
Begin
     Set @@Pqty = 0
     Set @@Prate = 0
     Set @@Sqty = 0
     Set @@Srate = 0
     Set @@TPqty = 0
     Set @@TPrate = 0
     Set @@TSqty = 0
     Set @@TSrate = 0
/*  Select  @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode */

     Set @@GetPos = Cursor For
     Select Sell_buy,
     pqty = (Case When Sell_buy = 1 then isnull(sum(tradeqty),0) else 0 end ),
     prate = (Case When Sell_buy = 1 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),
     Sqty = (Case When Sell_buy = 2 then isnull(sum(tradeqty),0) else 0 end ),
     srate = (Case When Sell_buy = 2 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end )
     From sett_25_new t1
     Where
     T1.Party_code = @@party_code
     And
     T1.Sett_no = @Sett_no
     And
     T1.Scrip_cd = @@Scrip_cd
     And
     T1.Series =  @@Series
     And
     T1.Sett_type = @Sett_type
     And
     T1.PartipantCode = @@PartipantCode
     Group by T1.Sett_No,T1.Sett_Type, t1.party_code,t1.scrip_cd,t1.series,t1.sell_buy,PartipantCode

     Open @@GetPos
     Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate


     While @@Fetch_status = 0
     Begin
/*     Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@PartipantCode,@@Tmark */
     If @@Sell_buy = 1
     Begin
          Set @@TPqty = @@Pqty
          Set @@TPrate = @@Prate
     End
     If @@Sell_buy = 2
     Begin
          Set @@TSqty = @@Sqty
          Set @@TSrate = @@Srate
     End
          Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate
     End
/*
Select @@Pqty
Select @@Prate
Select @@SQty
Select @@Srate
*/

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
     If @@TPRate > @@TSRate
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

/* Select @Tdate = Ltrim(Rtrim(@Tdate))
If Len(@Tdate) = 10
Begin
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')
End
*/
/*Select @Tparty = Ltrim(Rtrim(@Tparty))
Select @Tscrip_cd = Ltrim(Rtrim(@TScrip_cd))
Select @Tmark = Ltrim(Rtrim(@Tmark))
*/
/*Select @Tparty,@TdATE ,@Tscrip_cd,@Tmark*/

update sett_25_new set
/* Select Trade_no,Tradeqty,PartipantCode, */ Tmark = Tmark,
    Table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    Sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    BrokApplied =(Case
		when sett_25_new.status = 'N' then 0
	       else
               (  case
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                          ((floor ( (((broktable.Normal /100 ) * sett_25_new.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                        when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)         */
		((floor(( ((broktable.Normal /100 )* sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * sett_25_new.marketrate,CT.Round_To)  */
		((floor(( ((broktable.day_puc/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                   when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */

		((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                  when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To) */
		((floor(( ((broktable.day_sales/ 100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To) */
		((floor(( ((broktable.sett_purch/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
             when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)*/
		((floor(( ((broktable.sett_sales/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
   Else  0
                        End)
                       END  ),
       NetRate = (Case
		when sett_25_new.status = 'N' then sett_25_new.MARKETRATE
	       else
(  case
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( sett_25_new.marketrate + broktable.Normal),CT.Round_To) */
                                                                 sett_25_new.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((sett_25_new.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                  sett_25_new.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (sett_25_new.marketrate + round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)) */
                                                                   sett_25_new.marketrate + ((floor(( (((broktable.Normal /100 )* sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (sett_25_new.marketrate - round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To))           */
                                                                   sett_25_new.marketrate -  ((floor((  ( ((broktable.Normal /100 )* sett_25_new.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + sett_25_new.marketrate ),CT.Round_To)*/
                                                                 sett_25_new.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate + round((broktable.day_puc/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                sett_25_new.marketrate + ((floor(( (((broktable.day_puc/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((sett_25_new.marketrate - broktable.day_sales),CT.Round_To)*/
                                                               sett_25_new.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate - round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                sett_25_new.marketrate - ((floor((  (((broktable.day_sales/ 100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + sett_25_new.marketrate ),CT.Round_To )*/
                                                                 sett_25_new.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (sett_25_new.marketrate + round(( broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                 sett_25_new.marketrate + ((floor(( ( (( broktable.sett_purch/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                        when ( sett_25_new.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( sett_25_new.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                                   sett_25_new.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                                         when ( sett_25_new.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (sett_25_new.marketrate - round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)) */
                                                                 sett_25_new.marketrate -  ((floor((  (((broktable.sett_sales/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
   Else  0
                        End)
                    END     ),
       Amount = (Case
		when sett_25_new.status = 'N' then sett_25_new.MARKETRATE * sett_25_new. TRADEQTY
	       else
(  case
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( sett_25_new.marketrate + broktable.Normal),CT.Round_To) */
                                                             sett_25_new.Tradeqty  *  (  sett_25_new.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))

                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((sett_25_new.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                sett_25_new.Tradeqty * (   sett_25_new.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To)))
                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (sett_25_new.marketrate + round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)) */
                                                               sett_25_new.Tradeqty  * (   sett_25_new.marketrate + ((floor(( (((broktable.Normal /100 )* sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (sett_25_new.marketrate - round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To))           */
                                                                sett_25_new.Tradeqty * (   sett_25_new.marketrate -  ((floor((  ( ((broktable.Normal /100 )* sett_25_new.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + sett_25_new.marketrate ),CT.Round_To)*/
                                                             sett_25_new.Tradeqty * (    sett_25_new.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate + round((broktable.day_puc/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                               sett_25_new.Tradeqty * ( sett_25_new.marketrate + ((floor(( (((broktable.day_puc/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((sett_25_new.marketrate - broktable.day_sales),CT.Round_To)*/
                                                              sett_25_new.Tradeqty * ( sett_25_new.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate - round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                              sett_25_new.Tradeqty * (  sett_25_new.marketrate - ((floor((  (((broktable.day_sales/ 100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + sett_25_new.marketrate ),CT.Round_To )*/
                                                               sett_25_new.Tradeqty * (  sett_25_new.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))


                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (sett_25_new.marketrate + round(( broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                               sett_25_new.Tradeqty * (  sett_25_new.marketrate + ((floor(( ( (( broktable.sett_purch/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                        when ( sett_25_new.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( sett_25_new.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                     sett_25_new.Tradeqty * ( sett_25_new.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) )
                                         when ( sett_25_new.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (sett_25_new.marketrate - round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)) */
                                                       sett_25_new.Tradeqty  * (  sett_25_new.marketrate -  ((floor((  (((broktable.sett_sales/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To)))
   Else  0
                        End )
                      END   ),
/*       Ins_chrg  =(Case
		when sett_25_new.status = 'N' then 0
		ELSE ((floor(( ((CT.insurance_chrg * sett_25_new.marketrate * sett_25_new.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),


        turn_tax  = (Case
		when sett_25_new.status = 'N' then 0
		ELSE ((floor(( ((CT.turnover_tax * sett_25_new.marketrate * sett_25_new.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /
		power(10,CT.Round_To))END),

        other_chrg =(Case
		when sett_25_new.status = 'N' then 0
		ELSE  ((floor(( ((CT.other_chrg * sett_25_new.marketrate * sett_25_new.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) / 	power(10,CT.Round_To))END),

        sebi_tax =(Case
		when sett_25_new.status = 'N' then 0
   		ELSE  ((floor(( ((CT.sebiturn_tax * sett_25_new.marketrate * sett_25_new.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /	power(10,CT.Round_To))END),

        Broker_chrg = (Case
		when sett_25_new.status = 'N' then 0
		ELSE ((floor(( ((CT.broker_note * sett_25_new.marketrate * sett_25_new.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),
*/


        Ins_chrg  = ((CT.insurance_chrg * sett_25_new.marketrate * sett_25_new.Tradeqty)/100),
        turn_tax  = ((CT.turnover_tax * sett_25_new.marketrate * sett_25_new.Tradeqty)/100 ),
        other_chrg = ((CT.other_chrg * sett_25_new.marketrate * sett_25_new.Tradeqty)/100 ),
        sebi_tax = ((CT.sebiturn_tax * sett_25_new.marketrate * sett_25_new.Tradeqty)/100),
        Broker_chrg = ((CT.broker_note * sett_25_new.marketrate * sett_25_new.Tradeqty)/100),

        Service_tax =(Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else (Case
		when sett_25_new.status = 'N' then 0
	       else
 (  case
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then
		( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )


                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		(( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To))) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                      ((    ((floor ( (((broktable.Normal /100 ) * sett_25_new.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)         */
		((  ((floor(( ((broktable.Normal /100 )* sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * sett_25_new.marketrate,CT.Round_To)  */
		(( ((floor(( ((broktable.day_puc/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                   when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		(( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))   ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                  when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To) */
		( (  ((floor(( ((broktable.day_sales/ 100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                 when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		(( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))  ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To) */
		((  ((floor(( ((broktable.sett_purch/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
             when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

 when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)*/
		((  ((floor(( ((broktable.sett_sales/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   Else  0
                        End
                         )
			End )
                     END    )/*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Globals.service_tax)  END )*/,
      Trade_amount = sett_25_new.Tradeqty * sett_25_new.MarketRate,
      NBrokApp = (Case
		when sett_25_new.status = 'N' then 0
	       else
(  case
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                          ((floor ( (((broktable.Normal /100 ) * sett_25_new.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                        when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)         */
		((floor(( ((broktable.Normal /100 )* sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * sett_25_new.marketrate,CT.Round_To)  */
		((floor(( ((broktable.day_puc/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                   when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                  when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To) */
		((floor(( ((broktable.day_sales/ 100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To) */
		((floor(( ((broktable.sett_purch/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
             when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)*/
		((floor(( ((broktable.sett_sales/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
   Else  0
                        End )
                        end ),
        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else  (Case
		when sett_25_new.status = 'N' then 0
	       else
 (  case
                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then
		( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )


                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		(( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To))) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                      ((    ((floor ( (((broktable.Normal /100 ) * sett_25_new.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)         */
		((  ((floor(( ((broktable.Normal /100 )* sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * sett_25_new.marketrate,CT.Round_To)  */
		(( ((floor(( ((broktable.day_puc/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                   when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		(( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))   ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                  when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To) */
		( (  ((floor(( ((broktable.day_sales/ 100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                 when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		(( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))  ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To) */
		((  ((floor(( ((broktable.sett_purch/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
             when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

 when ( sett_25_new.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)*/
		((  ((floor(( ((broktable.sett_sales/100) * sett_25_new.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( sett_25_new.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   Else  0
                        End
                         )
			End )
                     END    ),
N_NetRate =(Case
		when sett_25_new.status = 'N' then sett_25_new.MARKETRATE
	       else
(  case
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( sett_25_new.marketrate + broktable.Normal),CT.Round_To) */
                                                                 sett_25_new.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))


                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((sett_25_new.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                  sett_25_new.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                                           when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (sett_25_new.marketrate + round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To)) */
                                                                   sett_25_new.marketrate + ((floor(( (((broktable.Normal /100 )* sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when ( sett_25_new.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (sett_25_new.marketrate - round((broktable.Normal /100 )* sett_25_new.marketrate,CT.Round_To))           */
                                                                   sett_25_new.marketrate -  ((floor((  ( ((broktable.Normal /100 )* sett_25_new.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (sett_25_new.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + sett_25_new.marketrate ),CT.Round_To)*/
                                                                 sett_25_new.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (sett_25_new.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate + round((broktable.day_puc/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                sett_25_new.marketrate + ((floor(( (((broktable.day_puc/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (sett_25_new.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((sett_25_new.marketrate - broktable.day_sales),CT.Round_To)*/
                                                               sett_25_new.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (sett_25_new.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (sett_25_new.marketrate - round((broktable.day_sales/ 100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                sett_25_new.marketrate - ((floor((  (((broktable.day_sales/ 100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + sett_25_new.marketrate ),CT.Round_To )*/
                                                                 sett_25_new.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( sett_25_new.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (sett_25_new.marketrate + round(( broktable.sett_purch/100) * sett_25_new.marketrate ,CT.Round_To))*/
                                                                 sett_25_new.marketrate + ((floor(( ( (( broktable.sett_purch/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                        when ( sett_25_new.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( sett_25_new.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                                   sett_25_new.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( sett_25_new.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (sett_25_new.marketrate - round((broktable.sett_sales/100) * sett_25_new.marketrate ,CT.Round_To)) */
                                                                 sett_25_new.marketrate -  ((floor((  (((broktable.sett_sales/100) * sett_25_new.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
   Else  0
                        End )
                        end )

   FROM BrokTable ,Client2 ,sett_25_new ,globals, client1 , ClientBrok_Scheme S, ClientTaxes_New CT, Owner
   WHERE sett_25_new.Party_Code = Client2.Party_code
   and client1.cl_code=client2.cl_code
   And Client2.Party_Code = CT.Party_Code
   And Client2.Tran_Cat = CT.Trans_Cat
   And S.Trade_Type = (Case When sett_25_new.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
   And sett_25_new.Sauda_Date Between FromDate And ToDate
   And S.Table_No = Broktable.Table_no
   And S.Scheme_Type = Client2.Tran_Cat
   And S.Scrip_Cd = 'ALL'
   And S.PARTY_CODE = sett_25_new.Party_Code
   And sett_25_new.Sauda_Date Between S.From_Date And S.To_Date
   And Broktable.Line_no = ( case when S.BrokScheme = 2 then
							    (Select min(Broktable.line_no) from broktable where
                                               		    S.Table_No = Broktable.Table_no
				                	    and Trd_Del =
							    ( Case When @@Eq = 'Y' then
								  ( Case When @@PRatemore = 'Y'
									 then ( Case When ( sett_25_new.Sell_Buy = 1 )
							    		             Then 'F'
							    		             Else 'S'
									        End )
									 Else
									      ( Case When ( sett_25_new.Sell_Buy = 2 )
							    		             Then 'F'
							    			     Else 'S'
									        End )
									 End )
								   Else
									( Case When @@PMore = 'Y'
									       then ( Case When ( sett_25_new.Sell_Buy = 1 )
							    			           Then 'F'

							    			           Else 'S'
										      End )
									       Else
									           ( Case When ( sett_25_new.Sell_Buy = 2 )
							    		                  Then
                                                                                              'F'
                                                                                          Else
                                                                                              'S'
									             End )
									  End )
								   End )
							    and sett_25_new.Party_Code =  Client2.Party_code
                                               		    and sett_25_new.marketrate <= Broktable.upper_lim)
						else ( case when S.BrokScheme = 1 then
					       		   (Select min(Broktable.line_no) from broktable where
                                               		    S.Table_No = Broktable.Table_no
				                	    and Trd_Del = ( Case When @@PMore = 'Y'
										 then ( Case When ( sett_25_new.Sell_Buy = 1 )
							    			 	    Then 'F'
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( sett_25_new.Sell_Buy = 2 )
							    			 	    Then 'F'
							    			 	    Else 'S'
										       End )
									    End )
                                                	    and sett_25_new.Party_Code =  Client2.Party_code
                                               		    and sett_25_new.marketrate <= Broktable.upper_lim)
							else ( case when S.BrokScheme = 3 then
					       		   	   (Select min(Broktable.line_no) from broktable where
                                               		            S.Table_No = Broktable.Table_no
				                	            and Trd_Del = ( Case When @@SMore ='Y'
									        	 then ( Case When ( sett_25_new.Sell_Buy = 2 )
							    			           	     Then 'F'
							    			 	             Else 'S'
										         End )
									     	    Else ( Case When ( sett_25_new.Sell_Buy = 1 )
							    			 	        Then 'F'
							    			 	        Else 'S'
										           End )
									            End )
        	                                        	    and sett_25_new.Party_Code =  Client2.Party_code
	                                               		    and sett_25_new.marketrate <= Broktable.upper_lim)
								else
							    	   (Select min(Broktable.line_no) from broktable
							    	    where S.Table_No = Broktable.Table_no
							     	    And Trd_Del = 'T'
   		                   				    and sett_25_new.Party_Code =  Client2.Party_code
				           			    and sett_25_new.marketrate <= Broktable.upper_lim )
								end )
							end )
						end )
  and sett_25_new.status <> 'E'
  And CT.Trans_cat = Client2.Tran_cat
  and sett_25_new.party_code = @@party_code
  and sett_25_new.scrip_cd = @@scrip_cd
  and sett_25_new.tradeqty > 0
  And sett_25_new.Sett_type = @Sett_type
  And sett_25_new.Sett_no = @Sett_no
  And sett_25_new.PartipantCode = @@PartipantCode
  And Sauda_date > Globals.year_start_dt
  And Sauda_date < Globals.year_end_dt

Fetch Next from @@Getparty into @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode

End


if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@Party_Code)),	/*party_code*/
		ltrim(rtrim(@Party_Code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(@Sauda_date))),	 /*sauda_date*/
		ltrim(rtrim(@Sett_no)),	 /*sett_no*/
		ltrim(rtrim(@Sett_type)),	 /*sett_type*/
		ltrim(rtrim(@Scrip_Cd)),	/*scrip_cd*/
		ltrim(rtrim(@series)),	/*series*/
		ltrim(rtrim('')),	 /*order_no*/
		ltrim(rtrim('')),	 /*trade_no*/
		ltrim(rtrim('')),	/*sell_buy*/
		ltrim(rtrim('')),	/*contract_no*/
		ltrim(rtrim('')),	/*new_contract_no*/
		0,		/*brokerage*/
		0,		/*new_brokerage*/
		0,		/*market_rate*/
		0,		/*new_market_rate*/
		0,		/*net_rate*/
		0,		/*new_net_rate*/
		0,		/*qty*/
		0,		/*new_qty*/
		ltrim(rtrim('')),	 /*participant_code*/
		ltrim(rtrim('')),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'BBGSettBrokReCal',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
