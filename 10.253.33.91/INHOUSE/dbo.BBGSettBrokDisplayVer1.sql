-- Object: PROCEDURE dbo.BBGSettBrokDisplayVer1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE  procedure
	[dbo].[BBGSettBrokDisplayVer1]
	(
		@Sett_no Varchar(7),
		@Sett_type Varchar(2),
		@Party_Code varchar(10),
		@Scrip_Cd Varchar(12),
		@series Varchar(3),
		@Sell_buy Char(1),
		@TradeQty Integer, 
		@Marketrate SmallMoney,
		@Settflag Char(1),
		@Sauda_date Varchar(11),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as
-- Exec BBGSettBrokDisplayVer1 '1','D','ALWR1937','','','1',100,1000,4,'JAN  1 2000','broker',''

 SET @Sauda_date = convert(varchar(11),getdate(),109) -- Added by AngelBSECM (Approved by BG sir)

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
@@GetParty As Cursor,
@STT_From_Global float,
@Service_tax_From_Global float


Select @STT_From_Global=ISNULL((case when @Settflag=2 then TrdBuyTrans when @Settflag=3 then TrdSellTrans
									when @Settflag=4 then DelBuyTrans when @Settflag=5 then DelSellTrans else 0 end),0),
		@Service_tax_From_Global=isnull(service_tax,0)
from MSAJAG.dbo.Globals  where year_end_dt>getdate()					--Suggested by Dharmesh on Aug 06 2015

print @STT_From_Global
print @Service_tax_From_Global


CREATE TABLE #ViewSettlement(
	[ContractNo] [varchar](14) NOT NULL,
	[BillNo] [varchar](10) NOT NULL,
	[Trade_no] [varchar](20) NULL,
	[Party_Code] [varchar](10) NOT NULL,
	[Scrip_Cd] [varchar](10) NOT NULL,
	[User_id] [varchar](10) NULL,
	[Tradeqty] [int] NOT NULL,
	[AuctionPart] [varchar](2) NOT NULL,
	[MarketType] [varchar](2) NOT NULL,
	[Series] [char](2) NOT NULL,
	[Order_no] [varchar](16) NULL,
	[MarketRate] [money] NOT NULL,
	[Sauda_date] [datetime] NULL,
	[Table_No] [varchar](4) NOT NULL,
	[Line_No] [numeric](3, 0) NOT NULL,
	[Val_perc] [char](1) NOT NULL,
	[Normal] [money] NOT NULL,
	[Day_puc] [money] NOT NULL,
	[day_sales] [money] NOT NULL,
	[Sett_purch] [money] NOT NULL,
	[Sett_sales] [money] NOT NULL,
	[Sell_buy] [int] NOT NULL,
	[Settflag] [int] NOT NULL,
	[Brokapplied] [money] NOT NULL,
	[NetRate] [numeric](15, 7) NOT NULL,
	[Amount] [money] NOT NULL,
	[Ins_chrg] [money] NOT NULL,
	[turn_tax] [money] NOT NULL,
	[other_chrg] [money] NOT NULL,
	[sebi_tax] [money] NOT NULL,
	[Broker_chrg] [money] NOT NULL,
	[Service_tax] [money] NOT NULL,
	[Trade_amount] [money] NOT NULL,
	[Billflag] [int] NOT NULL,
	[sett_no] [varchar](7) NOT NULL,
	[NBrokApp] [money] NOT NULL,
	[NSerTax] [money] NOT NULL,
	[N_NetRate] [numeric](15, 7) NOT NULL,
	[sett_type] [varchar](3) NOT NULL,
	[Partipantcode] [varchar](15) NULL,
	[Status] [varchar](2) NULL,
	[Pro_Cli] [int] NULL,
	[CpId] [varchar](20) NULL,
	[Instrument] [varchar](2) NULL,
	[BookType] [varchar](2) NULL,
	[Branch_Id] [varchar](10) NULL,
	[TMark] [varchar](1) NULL,
	[Scheme] [varchar](2) NULL,
	[Dummy1] [money] NULL,
	[Dummy2] [varchar](5) NULL  --,
	--[SRNO] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 ) 

 Insert into #ViewSettlement Values(
'0',  --[ContractNo] [varchar](14) NOT NULL,
'0',  --[BillNo] [varchar](10) NOT NULL,
'0',  --[Trade_no] [varchar](20) NULL,
@Party_Code,-- [Party_Code] [varchar](10) NOT NULL,
@Scrip_Cd, --[Scrip_Cd] [varchar](10) NOT NULL,
'0',--[User_id] [varchar](10) NULL,
@TradeQty, --[Tradeqty] [int] NOT NULL,
'',--[AuctionPart] [varchar](2) NOT NULL,
'',--[MarketType] [varchar](2) NOT NULL,
'',--[Series] [char](2) NOT NULL,
'0',--[Order_no] [varchar](16) NULL,
@Marketrate,--[MarketRate] [money] NOT NULL,
getdate(),--[Sauda_date] [datetime] NULL,
'',--[Table_No] [varchar](4) NOT NULL,
0,--[Line_No] [numeric](3, 0) NOT NULL,
'V',--[Val_perc] [char](1) NOT NULL,
0,--[Normal] [money] NOT NULL,
0,--[Day_puc] [money] NOT NULL,
0,--[day_sales] [money] NOT NULL,
0,--[Sett_purch] [money] NOT NULL,
0,--[Sett_sales] [money] NOT NULL,
@Sell_buy,--[Sell_buy] [int] NOT NULL,
@Settflag, --[Settflag] [int] NOT NULL,
0,--[Brokapplied] [money] NOT NULL,
0,--[NetRate] [numeric](15, 7) NOT NULL,
0,--[Amount] [money] NOT NULL,
0,--[Ins_chrg] [money] NOT NULL,
0,--[turn_tax] [money] NOT NULL,
0,--[other_chrg] [money] NOT NULL,
0,--[sebi_tax] [money] NOT NULL,
0,--[Broker_chrg] [money] NOT NULL,
0,--[Service_tax] [money] NOT NULL,
0,--[Trade_amount] [money] NOT NULL,
0,--[Billflag] [int] NOT NULL,
'2000001',--[sett_no] [varchar](7) NOT NULL,
0,--[NBrokApp] [money] NOT NULL,
0,--[NSerTax] [money] NOT NULL,
0,--[N_NetRate] [numeric](15, 7) NOT NULL,
'D',--[sett_type] [varchar](3) NOT NULL,
'0',--[Partipantcode] [varchar](15) NULL,
'A',--[Status] [varchar](2) NULL,
0,--[Pro_Cli] [int] NULL,
'',--[CpId] [varchar](20) NULL,
'',--[Instrument] [varchar](2) NULL,
'',--[BookType] [varchar](2) NULL,
'',--[Branch_Id] [varchar](10) NULL,
'',--[TMark] [varchar](1) NULL,
'',--[Scheme] [varchar](2) NULL,
'',--[Dummy1] [money] NULL,
'' --,--[Dummy2] [varchar](5) NULL --,
--1,--[SRNO] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 ) 


--select * from #ViewSettlement
 

If @Settflag in (2,3) 
Begin
Set @@Getparty = Cursor For
Select distinct Party_code,Scrip_cd,Series,PartipantCode From #ViewSettlement
--Where
--Sett_no = @sett_no
--And
--Sett_type = @Sett_type
--And
--Party_Code = @Party_Code
--And
--Scrip_Cd Like @Scrip_Cd
--And
--Series Like @Series
--And
--Sauda_Date Like @Sauda_Date + '%'

Open @@Getparty
Fetch Next from @@Getparty into @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode
--Select  @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode 
--Return


While @@fetch_status = 0
Begin
     Set @@Pqty = 0
     Set @@Prate = 0
     Set @@Sqty = 0
     Set @@Srate = 0
     Set @@Tpqty = 0
     Set @@Tprate = 0
     Set @@TSqty = 0
     Set @@TSrate = 0
/*  Select  @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode */

     Set @@GetPos = Cursor For
     Select Sell_buy,
     pqty = (Case When Sell_buy = 1 then isnull(sum(tradeqty),0) else 0 end ),
     prate = (Case When Sell_buy = 1 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),
     Sqty = (Case When Sell_buy = 2 then isnull(sum(tradeqty),0) else 0 end ),
     srate = (Case When Sell_buy = 2 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end )
     From #ViewSettlement t1
     /* Where
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
     T1.PartipantCode = @@PartipantCode*/
     Group by T1.Sett_No,T1.Sett_Type, t1.party_code,t1.scrip_cd,t1.series,t1.sell_buy,PartipantCode

     Open @@GetPos
     Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate


     While @@Fetch_status = 0
     Begin
     --Select @@Sell_buy,@@Pqty,@@Sqty,@@Prate,@@Srate,@@PartipantCode,@@Tmark 
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
--Return

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

update #ViewSettlement set
/* Select Trade_no,Tradeqty,PartipantCode,Select  */  Tmark = Tmark,
    Table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    Sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    BrokApplied =(Case
		when #ViewSettlement.status = 'N' then 0
	       else
               (  case
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                          ((floor ( (((broktable.Normal /100 ) * #ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                        when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)         */
		((floor(( ((broktable.Normal /100 )* #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * #ViewSettlement.marketrate,CT.Round_To)  */
		((floor(( ((broktable.day_puc/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                   when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */

		((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                  when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((floor(( ((broktable.day_sales/ 100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((floor(( ((broktable.sett_purch/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
             when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)*/
		((floor(( ((broktable.sett_sales/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
   Else  0
                        End)
                       END  ),
       NetRate = (Case
		when #ViewSettlement.status = 'N' then #ViewSettlement.MARKETRATE
	       else
(  case
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( #ViewSettlement.marketrate + broktable.Normal),CT.Round_To) */
                                                                 #ViewSettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((#ViewSettlement.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                  #ViewSettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (#ViewSettlement.marketrate + round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)) */
                                                                   #ViewSettlement.marketrate + ((floor(( (((broktable.Normal /100 )* #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (#ViewSettlement.marketrate - round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To))           */
                                                                   #ViewSettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* #ViewSettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + #ViewSettlement.marketrate ),CT.Round_To)*/
                                                                 #ViewSettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate + round((broktable.day_puc/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                #ViewSettlement.marketrate + ((floor(( (((broktable.day_puc/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((#ViewSettlement.marketrate - broktable.day_sales),CT.Round_To)*/
                                                               #ViewSettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate - round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                #ViewSettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + #ViewSettlement.marketrate ),CT.Round_To )*/
                                                                 #ViewSettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (#ViewSettlement.marketrate + round(( broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                 #ViewSettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                        when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( #ViewSettlement.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                                   #ViewSettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                                         when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (#ViewSettlement.marketrate - round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)) */
                                                                 #ViewSettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
   Else  0
                        End)
                    END     ),
       Amount = (Case
		when #ViewSettlement.status = 'N' then #ViewSettlement.MARKETRATE * #ViewSettlement. TRADEQTY
	       else
(  case
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( #ViewSettlement.marketrate + broktable.Normal),CT.Round_To) */
                                                             #ViewSettlement.Tradeqty  *  (  #ViewSettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))

                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((#ViewSettlement.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                #ViewSettlement.Tradeqty * (   #ViewSettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To)))
                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (#ViewSettlement.marketrate + round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)) */
                                                               #ViewSettlement.Tradeqty  * (   #ViewSettlement.marketrate + ((floor(( (((broktable.Normal /100 )* #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (#ViewSettlement.marketrate - round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To))           */
                                                                #ViewSettlement.Tradeqty * (   #ViewSettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* #ViewSettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + #ViewSettlement.marketrate ),CT.Round_To)*/
                                                             #ViewSettlement.Tradeqty * (    #ViewSettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate + round((broktable.day_puc/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                               #ViewSettlement.Tradeqty * ( #ViewSettlement.marketrate + ((floor(( (((broktable.day_puc/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                          when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((#ViewSettlement.marketrate - broktable.day_sales),CT.Round_To)*/
                                                              #ViewSettlement.Tradeqty * ( #ViewSettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate - round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                              #ViewSettlement.Tradeqty * (  #ViewSettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + #ViewSettlement.marketrate ),CT.Round_To )*/
                                                               #ViewSettlement.Tradeqty * (  #ViewSettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))


                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (#ViewSettlement.marketrate + round(( broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                               #ViewSettlement.Tradeqty * (  #ViewSettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))
                                        when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( #ViewSettlement.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                     #ViewSettlement.Tradeqty * ( #ViewSettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) )
                                         when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (#ViewSettlement.marketrate - round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)) */
                                                       #ViewSettlement.Tradeqty  * (  #ViewSettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To)))
   Else  0
                        End )
                      END   ),
/*       Ins_chrg  =(Case
		when #ViewSettlement.status = 'N' then 0
		ELSE ((floor(( ((CT.insurance_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),


        turn_tax  = (Case
		when #ViewSettlement.status = 'N' then 0
		ELSE ((floor(( ((CT.turnover_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /
		power(10,CT.Round_To))END),

        other_chrg =(Case
		when #ViewSettlement.status = 'N' then 0
		ELSE  ((floor(( ((CT.other_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) / 	power(10,CT.Round_To))END),

        sebi_tax =(Case
		when #ViewSettlement.status = 'N' then 0
   		ELSE  ((floor(( ((CT.sebiturn_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /	power(10,CT.Round_To))END),

        Broker_chrg = (Case
		when #ViewSettlement.status = 'N' then 0
		ELSE ((floor(( ((CT.broker_note * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),
*/


        --Ins_chrg  = ((CT.insurance_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100),
        Ins_chrg  = ((@STT_From_Global * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100),               --Suggested by Dharmesh on Aug 06 2015
        turn_tax  = ((CT.turnover_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ),
        other_chrg = ((CT.other_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ),
        sebi_tax = ((CT.sebiturn_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100),
        Broker_chrg = ((CT.broker_note * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100),

        Service_tax =(Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else (Case
		when #ViewSettlement.status = 'N' then 0
	       else
 (  case
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then
		( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )


                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		(( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To))) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                      ((    ((floor ( (((broktable.Normal /100 ) * #ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)         */
		((  ((floor(( ((broktable.Normal /100 )* #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * #ViewSettlement.marketrate,CT.Round_To)  */
		(( ((floor(( ((broktable.day_puc/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                   when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		(( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))   ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                  when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To) */
		( (  ((floor(( ((broktable.day_sales/ 100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                 when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		(( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))  ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((  ((floor(( ((broktable.sett_purch/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
             when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

 when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)*/
		((  ((floor(( ((broktable.sett_sales/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   Else  0
                        End
                         )
			End )
                     END    )/*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Globals.service_tax)  END )*/,
      Trade_amount = #ViewSettlement.Tradeqty * #ViewSettlement.MarketRate,
      NBrokApp = (Case
		when #ViewSettlement.status = 'N' then 0
	       else
(  case
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then  /* broktable.Normal */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                          ((floor ( (((broktable.Normal /100 ) * #ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                        when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)         */
		((floor(( ((broktable.Normal /100 )* #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * #ViewSettlement.marketrate,CT.Round_To)  */
		((floor(( ((broktable.day_puc/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                   when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                  when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((floor(( ((broktable.day_sales/ 100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((floor(( ((broktable.sett_purch/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
             when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
                         when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)*/
		((floor(( ((broktable.sett_sales/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))
   Else  0
                        End )
                        end ),
        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else  (Case
		when #ViewSettlement.status = 'N' then 0
	       else
 (  case
                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                              Then
		( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )


                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                              Then /* broktable.Normal  */
		(( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
		power(10,CT.Round_To))) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                               Then
                                      ((    ((floor ( (((broktable.Normal /100 ) * #ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                             Then /* round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)         */
		((  ((floor(( ((broktable.Normal /100 )* #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                            Then /* ((broktable.day_puc)) */
		((  ((floor(( ((broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                             Then /* round((broktable.day_puc/100) * #ViewSettlement.marketrate,CT.Round_To)  */
		(( ((floor(( ((broktable.day_puc/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                   when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                             Then /* broktable.day_sales */
		(( ((floor(( broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))   ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                  when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                             Then /*round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To) */
		( (  ((floor(( ((broktable.day_sales/ 100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                 when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                             Then /* broktable.sett_purch  */
		(( ((floor(( broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))  ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To) */
		((  ((floor(( ((broktable.sett_purch/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
             when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='V' )
                             Then /* broktable.sett_sales */
		((  ((floor(( broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

 when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='P' )
                             Then /* round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)*/
		((  ((floor(( ((broktable.sett_sales/100) * #ViewSettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   Else  0
                        End
                         )
			End )
                     END    ),
N_NetRate =(Case
		when #ViewSettlement.status = 'N' then #ViewSettlement.MARKETRATE
	       else
(  case
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
                                                      Then /* round (( #ViewSettlement.marketrate + broktable.Normal),CT.Round_To) */
                                                                 #ViewSettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))


                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
                                                       Then /* round((#ViewSettlement.marketrate - broktable.Normal ),CT.Round_To )    */
                                                                  #ViewSettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                                           when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
                                                        Then /* (#ViewSettlement.marketrate + round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To)) */
                                                                   #ViewSettlement.marketrate + ((floor(( (((broktable.Normal /100 )* #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
                                                       Then /* (#ViewSettlement.marketrate - round((broktable.Normal /100 )* #ViewSettlement.marketrate,CT.Round_To))           */
                                                                   #ViewSettlement.marketrate -  ((floor((  ( ((broktable.Normal /100 )* #ViewSettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
                                                    Then /* round((broktable.day_puc + #ViewSettlement.marketrate ),CT.Round_To)*/
                                                                 #ViewSettlement.marketrate + ((floor(( ((broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate + round((broktable.day_puc/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                #ViewSettlement.marketrate + ((floor(( (((broktable.day_puc/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                          when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
                                                     Then /* round((#ViewSettlement.marketrate - broktable.day_sales),CT.Round_To)*/
                                                               #ViewSettlement.marketrate - ((floor(( (( broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
                                                    Then /* (#ViewSettlement.marketrate - round((broktable.day_sales/ 100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                #ViewSettlement.marketrate - ((floor((  (((broktable.day_sales/ 100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
                                                     Then /* round((broktable.sett_purch + #ViewSettlement.marketrate ),CT.Round_To )*/
                                                                 #ViewSettlement.marketrate + ((floor(( ((broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
                                                      Then /* (#ViewSettlement.marketrate + round(( broktable.sett_purch/100) * #ViewSettlement.marketrate ,CT.Round_To))*/
                                                                 #ViewSettlement.marketrate + ((floor(( ( (( broktable.sett_purch/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                        when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='V' )
                                                      Then /* round(( #ViewSettlement.marketrate - broktable.sett_sales ),CT.Round_To) */
                                                                   #ViewSettlement.marketrate - ((floor(( (( broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  	(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                                         when ( #ViewSettlement.SettFlag =5  and broktable.val_perc ='P' )
                                                     Then /* (#ViewSettlement.marketrate - round((broktable.sett_sales/100) * #ViewSettlement.marketrate ,CT.Round_To)) */
                                                                 #ViewSettlement.marketrate -  ((floor((  (((broktable.sett_sales/100) * #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
   Else  0
                        End )
                        end )

   FROM Msajag.dbo.BrokTable BrokTable,Msajag.dbo.Client2 Client2 ,#ViewSettlement ,Msajag.dbo.globals globals, Msajag.dbo.client1 client1, 
   Msajag.dbo.ClientBrok_Scheme S, Msajag.dbo.ClientTaxes_New CT, Msajag.dbo.Owner
   WHERE #ViewSettlement.Party_Code = Client2.Party_code
   and client1.cl_code=client2.cl_code
   And Client2.Party_Code = CT.Party_Code
   And Client2.Tran_Cat = CT.Trans_Cat
   And S.Trade_Type = 'NRM' --(Case When #ViewSettlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
   And #ViewSettlement.Sauda_Date Between FromDate And ToDate
   And S.Table_No = Broktable.Table_no
   And S.Scheme_Type = Client2.Tran_Cat
   And S.Scrip_Cd = 'ALL'
   And S.PARTY_CODE = #ViewSettlement.Party_Code
   And #ViewSettlement.Sauda_Date Between S.From_Date And S.To_Date
   And Broktable.Line_no = ( case when S.BrokScheme = 2 then
							    (Select min(Broktable.line_no) from  Msajag.dbo.broktable with(nolock), Msajag.Dbo.ClientBrok_Scheme S with(nolock) where
                                               		    S.Table_No = Broktable.Table_no
														and S.party_code = #ViewSettlement.Party_Code
				                	    and Trd_Del =
							    ( Case When @@Eq = 'Y' then
								  ( Case When @@PRatemore = 'Y'
									 then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
							    		             Then 'F'
							    		             Else 'S'
									        End )
									 Else
									      ( Case When ( #ViewSettlement.Sell_Buy = 2 )
							    		             Then 'F'
							    			     Else 'S'
									        End )
									 End )
								   Else
									( Case When @@PMore = 'Y'
									       then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
							    			           Then 'F'

							    			           Else 'S'
										      End )
									       Else
									           ( Case When ( #ViewSettlement.Sell_Buy = 2 )
							    		                  Then
                                                                                              'F'
                                                                                          Else
                                                                                              'S'
									             End )
									  End )
								   End )
							    and #ViewSettlement.Party_Code =  Client2.Party_code
                                               		    and #ViewSettlement.marketrate <= Broktable.upper_lim)
						else ( case when S.BrokScheme = 1 then
					       		   (Select min(Broktable.line_no) from broktable with(nolock), Msajag.Dbo.ClientBrok_Scheme S with(nolock) where
                                               		    S.Table_No = Broktable.Table_no
														and S.party_code = #ViewSettlement.Party_Code
				                	    and Trd_Del = ( Case When @@PMore = 'Y'
										 then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
							    			 	    Then 'F'
							    			 	    Else 'S'
										       End )
									     	 Else
										      ( Case When ( #ViewSettlement.Sell_Buy = 2 )
							    			 	    Then 'F'
							    			 	    Else 'S'
										       End )
									    End )
                                                	    and #ViewSettlement.Party_Code =  Client2.Party_code
                                               		    and #ViewSettlement.marketrate <= Broktable.upper_lim)
							else ( case when S.BrokScheme = 3 then
					       		   	   (Select min(Broktable.line_no) from broktable with(nolock), Msajag.Dbo.ClientBrok_Scheme S with(nolock) where
                                               		            S.Table_No = Broktable.Table_no
																and S.party_code = #ViewSettlement.Party_Code
				                	            and Trd_Del = ( Case When @@SMore ='Y'
									        	 then ( Case When ( #ViewSettlement.Sell_Buy = 2 )
							    			           	     Then 'F'
							    			 	             Else 'S'
										         End )
									     	    Else ( Case When ( #ViewSettlement.Sell_Buy = 1 )
							    			 	        Then 'F'
							    			 	        Else 'S'
										           End )
									            End )
        	                                        	    and #ViewSettlement.Party_Code =  Client2.Party_code
	                                               		    and #ViewSettlement.marketrate <= Broktable.upper_lim)
								else
							    	   (Select min(Broktable.line_no) from broktable with(nolock), Msajag.Dbo.ClientBrok_Scheme S with(nolock)
							    	    where S.Table_No = Broktable.Table_no
										and S.party_code = #ViewSettlement.Party_Code
							     	    And Trd_Del = 'T'
   		                   				    and #ViewSettlement.Party_Code =  Client2.Party_code
				           			    and #ViewSettlement.marketrate <= Broktable.upper_lim )
								end )
							end )
						end )
  and #ViewSettlement.status <> 'E'
  And CT.Trans_cat = Client2.Tran_cat
  --and #ViewSettlement.party_code = @@party_code
  --and #ViewSettlement.scrip_cd = @@scrip_cd
  and #ViewSettlement.tradeqty > 0
  --And #ViewSettlement.Sett_type = @Sett_type
  --And #ViewSettlement.Sett_no = @Sett_no
  --And #ViewSettlement.PartipantCode = @@PartipantCode

  And Sauda_date > Globals.year_start_dt
  And Sauda_date < Globals.year_end_dt

Fetch Next from @@Getparty into @@Party_code,@@Scrip_cd,@@Series,@@PartipantCode

End
End


If @settflag in(4,5)
Begin
Update #ViewSettlement set Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    NBrokApp = (  case
    when (  broktable.val_perc ='V' )
                             Then
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))

                        when (  broktable.val_perc ='P' )
                             Then      ((floor ( (((broktable.Normal /100 ) * #ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
   Else
          BrokApplied
                        End
                         ),
       N_NetRate = (  case
                      when (  broktable.val_perc ='V' AND #ViewSettlement.SELL_BUY = 1)
                             Then
                                  #ViewSettlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                      when (  broktable.val_perc ='P' AND #ViewSettlement.SELL_BUY = 1 )
                             Then #ViewSettlement.marketrate + ((floor(( (((broktable.Normal /100 )* #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                      when (broktable.val_perc ='V' AND #ViewSettlement.SELL_BUY =2 )
                             Then #ViewSettlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                      when ( broktable.val_perc ='P' AND #ViewSettlement.SELL_BUY = 2 )
                             Then
                      #ViewSettlement.marketrate - ((floor(( (((broktable.Normal /100 )* #ViewSettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
   Else
             NetRate
                        End
                         ),/*modified by bhayashree on 27-12-2000*/

        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else (case when ( broktable.val_perc ='V' )
			Then ( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
				(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
				power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when (broktable.val_perc ='P' )
                        Then ((((floor ( (((broktable.Normal /100 ) *#ViewSettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( #ViewSettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   			Else #ViewSettlement.Service_tax
                        End ) End
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Settlement.service_tax)  END )*/,
--Ins_chrg  =(Case when #ViewSettlement.status = 'N' then 0 else ((CT.insurance_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) End),
Ins_chrg  =(Case when #ViewSettlement.status = 'N' then 0 else ((@STT_From_Global * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) End),   -- Suggested by Dharmesh on Aug 06 2015
turn_tax  = (Case when #ViewSettlement.status = 'N' then 0 else ((CT.turnover_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ) end),
other_chrg =(Case when #ViewSettlement.status = 'N' then 0 else ((CT.other_chrg * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100 ) end),
sebi_tax = (Case when #ViewSettlement.status = 'N' then 0 else ((CT.sebiturn_tax * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) end),
Broker_chrg =(Case when #ViewSettlement.status = 'N' then 0 else ((CT.broker_note * #ViewSettlement.marketrate * #ViewSettlement.Tradeqty)/100) end)

      FROM Msajag.dbo.BrokTable BrokTable,Msajag.Dbo.Client2,globals, #ViewSettlement,Msajag.Dbo.Client1, Msajag.Dbo.ClientBrok_Scheme S, Msajag.Dbo.ClientTaxes_New CT, Msajag.Dbo.Owner
      WHERE #ViewSettlement.Party_Code = Client2.Party_code
      And Client2.Cl_code = Client1.Cl_code
      And Client2.Party_Code = CT.Party_Code
      And CT.trans_Cat = 'DEL'
      And S.Trade_Type = 'NRM' --(Case When #ViewSettlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
      And #ViewSettlement.Sauda_Date Between FromDate And ToDate
      And S.Table_No = Broktable.Table_no
      And S.Scheme_Type = 'DEL'
      And S.Scrip_Cd = 'ALL'
      And S.PARTY_CODE = #ViewSettlement.Party_Code
      And #ViewSettlement.Sauda_Date Between S.From_Date And S.To_Date

      And Broktable.Line_no = (Select min(Broktable.line_no) from Msajag.dbo.broktable with(nolock), Msajag.Dbo.ClientBrok_Scheme S with(nolock) where
		               S.Table_No = Broktable.Table_no
			       And Trd_Del = 'D' And #ViewSettlement.Party_Code =  Client2.Party_code
			       And #ViewSettlement.marketrate <= Broktable.upper_lim 
				   and S.party_code = #ViewSettlement.Party_Code)
      And (Globals.exchange = 'NSE')

      --AND Settlement.SETT_NO = @SETTNO
      --AND Settlement.SETT_TYPE = @SETTYPE
      --and Settlement.billflag in(4,5)
      and #ViewSettlement.status <> 'E'
      and #ViewSettlement.party_code = @party_code
      --and Settlement.scrip_cd = @Scrip_cd
      And Sauda_date > Globals.year_start_dt
      And Sauda_date < Globals.year_end_dt


End


--Update #ViewSettlement set Service_tax=Service_tax+(turn_tax*14/100), NSerTax=NSerTax +(turn_tax*14/100)
--							,Ins_chrg=Round(Ins_chrg,0)								-- Suggested by Dharmesh on Aug 06 2015 and approved by BG sir

declare @Trans_Cat varchar(100)
declare @Levies_Brokerage varchar(20)
Declare @Brokerage_Type varchar(2)
Declare @Min_Brok_limit money
Declare @Max_Brok_limit money
Declare @Brokerage money

If @Settflag in (2,3) 
Begin

	Select @Levies_Brokerage =	(Case when #ViewSettlement.status = 'N' then 0
										else (  case
												when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 1)
													 Then  broktable.Normal
												when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='V' and sell_buy = 2)
													 Then broktable.Normal
												when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 1)
													  Then broktable.Normal --/100
												when ( #ViewSettlement.SettFlag = 1 and broktable.val_perc ='P' and sell_buy = 2)
													 Then (broktable.Normal) --/100 
												when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='V' )
													 Then (broktable.day_puc)
												when (#ViewSettlement.SettFlag = 2  and broktable.val_perc ='P' )
													 Then broktable.day_puc --/100
												when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='V' )
													 Then  broktable.day_sales
												when (#ViewSettlement.SettFlag = 3  and broktable.val_perc ='P' )
													 Then broktable.day_sales
												when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='V' )
													 Then broktable.sett_purch
												when ( #ViewSettlement.SettFlag = 4  and broktable.val_perc ='P' )
													 Then broktable.sett_purch  --/100
												when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='V' )
													 Then broktable.sett_sales
												when ( #ViewSettlement.SettFlag = 5  and broktable.val_perc ='P' )
													 Then broktable.sett_sales --/100
												Else  0
												End )
										end ),
			@Min_Brok_limit=Lower_lim,
			@Max_Brok_limit=Upper_lim,
			@Brokerage_Type=BrokTable.Val_perc

	FROM Msajag.dbo.BrokTable BrokTable,Msajag.dbo.Client2 Client2 ,#ViewSettlement ,Msajag.dbo.globals globals, Msajag.dbo.client1 client1, 
	   Msajag.dbo.ClientBrok_Scheme S, Msajag.dbo.ClientTaxes_New CT, Msajag.dbo.Owner
	   WHERE #ViewSettlement.Party_Code = Client2.Party_code
	   and client1.cl_code=client2.cl_code
	   And Client2.Party_Code = CT.Party_Code
	   And Client2.Tran_Cat = CT.Trans_Cat
	   And S.Trade_Type = 'NRM' --(Case When #ViewSettlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
	   And #ViewSettlement.Sauda_Date Between FromDate And ToDate
	   And S.Table_No = Broktable.Table_no
	   And S.Scheme_Type = Client2.Tran_Cat
	   And S.Scrip_Cd = 'ALL'
	   And S.PARTY_CODE = #ViewSettlement.Party_Code
	   And #ViewSettlement.Sauda_Date Between S.From_Date And S.To_Date
	   --And Broktable.Line_no = ( case when S.BrokScheme = 2 then
				--					(Select min(Broktable.line_no) from broktable where
    --                                           				S.Table_No = Broktable.Table_no
				--                			and Trd_Del =
				--					( Case When @@Eq = 'Y' then
				--					  ( Case When @@PRatemore = 'Y'
				--						 then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
				--			    						 Then 'F'
				--			    						 Else 'S'
				--								End )
				--						 Else
				--							  ( Case When ( #ViewSettlement.Sell_Buy = 2 )
				--			    						 Then 'F'
				--			    					 Else 'S'
				--								End )
				--						 End )
				--					   Else
				--						( Case When @@PMore = 'Y'
				--							   then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
				--			    						   Then 'F'

				--			    						   Else 'S'
				--								  End )
				--							   Else
				--								   ( Case When ( #ViewSettlement.Sell_Buy = 2 )
				--			    							  Then
				--																				  'F'
				--																			  Else
				--																				  'S'
				--									 End )
				--						  End )
				--					   End )
				--					and #ViewSettlement.Party_Code =  Client2.Party_code
    --                                           				and #ViewSettlement.marketrate <= Broktable.upper_lim)
				--			else ( case when S.BrokScheme = 1 then
				--	       			   (Select min(Broktable.line_no) from broktable where
    --                                           				S.Table_No = Broktable.Table_no
				--                			and Trd_Del = ( Case When @@PMore = 'Y'
				--							 then ( Case When ( #ViewSettlement.Sell_Buy = 1 )
				--			    			 			Then 'F'
				--			    			 			Else 'S'
				--								   End )
				--					     		 Else
				--								  ( Case When ( #ViewSettlement.Sell_Buy = 2 )
				--			    			 			Then 'F'
				--			    			 			Else 'S'
				--								   End )
				--							End )
    --                                            			and #ViewSettlement.Party_Code =  Client2.Party_code
    --                                           				and #ViewSettlement.marketrate <= Broktable.upper_lim)
				--				else ( case when S.BrokScheme = 3 then
				--	       		   		   (Select min(Broktable.line_no) from broktable where
    --                                           						S.Table_No = Broktable.Table_no
				--                					and Trd_Del = ( Case When @@SMore ='Y'
				--					        		 then ( Case When ( #ViewSettlement.Sell_Buy = 2 )
				--			    			           			 Then 'F'
				--			    			 					 Else 'S'
				--									 End )
				--					     			Else ( Case When ( #ViewSettlement.Sell_Buy = 1 )
				--			    			 				Then 'F'
				--			    			 				Else 'S'
				--									   End )
				--									End )
    --    	                                        			and #ViewSettlement.Party_Code =  Client2.Party_code
	   --                                            				and #ViewSettlement.marketrate <= Broktable.upper_lim)
				--					else
				--			    		   (Select min(Broktable.line_no) from broktable
				--			    			where S.Table_No = Broktable.Table_no
				--			     			And Trd_Del = 'T'
   	--	                   						and #ViewSettlement.Party_Code =  Client2.Party_code
				--           					and #ViewSettlement.marketrate <= Broktable.upper_lim )
				--					end )
				--				end )
				--			end )
	  and #ViewSettlement.status <> 'E'
	  And CT.Trans_cat = Client2.Tran_cat
	  --and #ViewSettlement.party_code = @@party_code
	  --and #ViewSettlement.scrip_cd = @@scrip_cd
	  and #ViewSettlement.tradeqty > 0
	  --And #ViewSettlement.Sett_type = @Sett_type
	  --And #ViewSettlement.Sett_no = @Sett_no
	  --And #ViewSettlement.PartipantCode = @@PartipantCode

	  And Sauda_date > Globals.year_start_dt
	  And Sauda_date < Globals.year_end_dt
	  and BrokTable.Trd_Del = 'f'
	--and BrokTable.Lower_lim>=@TradeQty
	  and @Marketrate >= BrokTable.Lower_lim 
	  and @Marketrate <= BrokTable.Upper_lim
 end
 If @Settflag in (4,5) 
Begin

	Select @Levies_Brokerage =	case  when (broktable.val_perc ='V' )
											Then broktable.Normal
										   when (broktable.val_perc ='P' )
											Then broktable.Normal --/100 
										   Else
											BrokApplied
								End,
			@Min_Brok_limit=Lower_lim,
			@Max_Brok_limit=Upper_lim,
			@Brokerage_Type=BrokTable.Val_perc

	FROM Msajag.dbo.BrokTable BrokTable,Msajag.Dbo.Client2,globals, #ViewSettlement,Msajag.Dbo.Client1, Msajag.Dbo.ClientBrok_Scheme S, Msajag.Dbo.ClientTaxes_New CT, Msajag.Dbo.Owner
      WHERE #ViewSettlement.Party_Code = Client2.Party_code
      And Client2.Cl_code = Client1.Cl_code
      And Client2.Party_Code = CT.Party_Code
      And CT.trans_Cat = 'DEL'
      And S.Trade_Type = 'NRM' --(Case When #ViewSettlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
      And #ViewSettlement.Sauda_Date Between FromDate And ToDate
      And S.Table_No = Broktable.Table_no
      And S.Scheme_Type = 'DEL'
      And S.Scrip_Cd = 'ALL'
      And S.PARTY_CODE = #ViewSettlement.Party_Code
      And #ViewSettlement.Sauda_Date Between S.From_Date And S.To_Date

      --And Broktable.Line_no = (Select min(Broktable.line_no) from broktable where
		    --           S.Table_No = Broktable.Table_no
			   --    And Trd_Del = 'D' And #ViewSettlement.Party_Code =  Client2.Party_code
			   --    And #ViewSettlement.marketrate <= Broktable.upper_lim )
      And (Globals.exchange = 'NSE')
      and #ViewSettlement.status <> 'E'
      and #ViewSettlement.party_code = @party_code
      --and Settlement.scrip_cd = @Scrip_cd
      And Sauda_date > Globals.year_start_dt
      And Sauda_date < Globals.year_end_dt
	  --and BrokTable.Trd_Del = 'f'
	   and BrokTable.Trd_Del = 'D'
   --and BrokTable.Lower_lim>=@TradeQty
      and @Marketrate >= BrokTable.Lower_lim 
	  and @Marketrate <= BrokTable.Upper_lim
 end

--Select @Brokerage=NBrokApp*@TradeQty from #ViewSettlement

--if(@Brokerage<@Min_Brok_limit)
--BEGIN
--	--Set @Levies_Brokerage=@Min_Brok_limit
--	set @Brokerage_Type='V'
--END
--else if(@Brokerage>@Max_Brok_limit)
--BEGIN
--	--Set @Levies_Brokerage=@Max_Brok_limit
--	set @Brokerage_Type='V'
--END
--else
--BEGIN
--	--Set @Levies_Brokerage=@brokerage_Percentage
--	set @Brokerage_Type='P'
--END

 Update #ViewSettlement set Service_tax=(((NBrokApp*@TradeQty)+turn_tax+sebi_tax)*@Service_tax_From_Global/100)
							, NSerTax=(((NBrokApp*@TradeQty)+turn_tax+sebi_tax)*@Service_tax_From_Global/100)
							, Ins_chrg=Round(Ins_chrg,0)								-- Suggested by Dharmesh on Aug 06 2015 and approved by BG sir 
							,other_chrg=isnull(@Levies_Brokerage,0.00)

select @Trans_Cat= case when @Settflag in ('2','3') then 'TRD' else  'DEL' end
--print @Trans_Cat

Select *,LeviesSTT=@STT_From_Global,LeviesServ_Tax=@Service_tax_From_Global,
Levies_TurnoverTax=turnover_tax, Levies_SebiTax=sebiturn_tax, Levies_StampDuty=broker_note, Levies_Brokerage=@Levies_Brokerage, Brokerage_Type=isnull(@Brokerage_Type,'P') 
from #ViewSettlement , Msajag.dbo.ClientTaxes_New CT with(nolock) 
where #ViewSettlement.Party_Code= CT.Party_Code
and CT.Todate>getdate()
and Trans_Cat=@Trans_Cat


/*

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

*/

GO
