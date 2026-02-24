-- Object: PROCEDURE dbo.BBGInsSettBrokUpdateNew
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure  
 BBGInsSettBrokUpdateNew  
 (  
  @tparty varchar(10),  
  @tscrip_cd varchar(12),  
  @tdate varchar(11),  
  @sett_type varchar(2),  
  @Memcode varchar(15),  
  @tmark varchar(2),  
  @Series Varchar(3),  
  @StatusName VarChar(50),  
  @FromWhere VarChar(50)  
 )  
  
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

Select C.* Into #Client2
From Client2 C  
Where Party_Code = @TParty

Select C.* Into #Client1
From Client1 C, #Client2 C2
Where C2.Cl_Code = C.Cl_Code
And Party_Code = @TParty

Select C.* Into #CLIENTTAXES_NEW       
From ClientTaxes_New C  
Where C.Party_Code = @TParty     
And @tdate Between FromDate And ToDate       
      
Select C.* Into #ClientBrok_Scheme      
From ClientBrok_Scheme C  
Where C.Party_Code = @TParty     
And @tdate Between From_Date And To_Date       
      
Select * INTO #Broktable       
From BrokTable      
Where Table_No in (Select Distinct Table_No From #ClientBrok_Scheme) 
  
Select @@Sett_no = Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Tdate + ' 00:01:01' and End_date > @Tdate + ' 00:01:01'  
  
Set @@Pqty = 0  
Set @@Prate = 0  
Set @@Sqty = 0  
Set @@Srate = 0  
  
  
Update ISettlement set Tmark = 'N' where  
Party_code = @Tparty  
And  
Sett_no = @@Sett_no  
And  
Scrip_cd = @TScrip_cd  
And  
Tmark Like @Tmark +'%'  
And  
Left(Convert(varchar,sauda_date,109),11) = @Tdate  
And Sett_type = @Sett_type  
And partipantcode = @Memcode  
  
Set @@GetPos = Cursor For  
select Sell_buy,  
pqty = (Case When Sell_buy = 1 then isnull(sum(tradeqty),0) else 0 end ),  
prate = (Case When Sell_buy = 1 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),  
Sqty = (Case When Sell_buy = 2 then isnull(sum(tradeqty),0) else 0 end ),  
srate = (Case When Sell_buy = 2 then isnull(sum(tradeqty*marketrate)/(case when sum(tradeqty) = 0 then 1 else sum(tradeqty)end ),0) else 0 end ),  
partipantcode,Tmark  
from ISettlement t1  
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
  
  
While @@Fetch_status = 0  
Begin  
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
     Fetch Next from @@Getpos into @@Sell_buy,@@Pqty,@@Prate,@@Sqty,@@Srate,@@Participantcode,@@Tmark  
End  
  
/* Select @@Pqty  
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
  
/*Select @Tparty,@TdATE ,@Tscrip_cd,@Tmark*/  
update ISettlement set Tmark = Tmark,  
    Table_no = #Broktable.table_no, line_no = #Broktable.line_no,val_perc = #Broktable.val_perc,  
    Normal = #Broktable.Normal, day_puc= #Broktable.Day_puc,day_sales = #Broktable.day_sales,  
    Sett_purch =   #Broktable.Sett_purch,sett_sales = #Broktable.Sett_sales,  
    BrokApplied =(Case   
  when ISettlement.status = 'N' then 0  
        else  
               (  case  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                              Then  /* #Broktable.Normal */  
  ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* #Broktable.Normal  */  
  ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                          ((floor ( (((#Broktable.Normal /100 ) * ISettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                        when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)         */  
  ((floor(( ((#Broktable.Normal /100 )* ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                            Then /* ((#Broktable.day_puc)) */  
  ((floor(( ((#Broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.day_puc/100) * ISettlement.marketrate,CT.Round_To)  */  
  ((floor(( ((#Broktable.day_puc/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                   when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.day_sales */  
  
  ((floor(( #Broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                  when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                             Then /*round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((#Broktable.day_sales/ 100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_purch  */  
  ((floor(( #Broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((#Broktable.sett_purch/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
             when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_sales */  
  ((floor(( #Broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)*/  
  ((floor(( ((#Broktable.sett_sales/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
   Else  0  
                        End)  
                       END  ),  
       NetRate = (Case  
  when ISettlement.status = 'N' then ISettlement.MARKETRATE  
        else  
(  case  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( ISettlement.marketrate + #Broktable.Normal),CT.Round_To) */  
                                                                 ISettlement.marketrate + ((floor((  (( #Broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                                                       Then /* round((ISettlement.marketrate - #Broktable.Normal ),CT.Round_To )    */  
                                                                  ISettlement.marketrate - ((floor(( (( #Broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To))  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (ISettlement.marketrate + round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)) */  
                                                                   ISettlement.marketrate + ((floor(( (((#Broktable.Normal /100 )* ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) 
)  / power(10,CT.Round_To))  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                                                       Then /* (ISettlement.marketrate - round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To))           */  
                                                                   ISettlement.marketrate -  ((floor((  ( ((#Broktable.Normal /100 )* ISettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                                                    Then /* round((#Broktable.day_puc + ISettlement.marketrate ),CT.Round_To)*/  
                                                                 ISettlement.marketrate + ((floor(( ((#Broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                                                    Then /* (ISettlement.marketrate + round((#Broktable.day_puc/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                ISettlement.marketrate + ((floor(( (((#Broktable.day_puc/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  
/ power(10,CT.Round_To))  
                                          when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                                                     Then /* round((ISettlement.marketrate - #Broktable.day_sales),CT.Round_To)*/  
                                                               ISettlement.marketrate - ((floor(( (( #Broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                                                    Then /* (ISettlement.marketrate - round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                ISettlement.marketrate - ((floor((  (((#Broktable.day_sales/ 100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero )
 )  / power(10,CT.Round_To))  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                                                     Then /* round((#Broktable.sett_purch + ISettlement.marketrate ),CT.Round_To )*/  
                                                                 ISettlement.marketrate + ((floor(( ((#Broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                                                      Then /* (ISettlement.marketrate + round(( #Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                 ISettlement.marketrate + ((floor(( ( (( #Broktable.sett_purch/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero
 ) )  / power(10,CT.Round_To))  
                                        when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='V' )  
                                                      Then /* round(( ISettlement.marketrate - #Broktable.sett_sales ),CT.Round_To) */  
                                                                   ISettlement.marketrate - ((floor(( (( #Broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To
))  
  
                                         when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='P' )  
                                                     Then /* (ISettlement.marketrate - round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)) */  
                                                                 ISettlement.marketrate -  ((floor((  (((#Broktable.sett_sales/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero
 ) )  /  power(10,CT.Round_To))  
   Else  0  
                        End)  
                    END     ),  
       Amount = (Case  
  when ISettlement.status = 'N' then ISettlement.MARKETRATE * ISettlement. TRADEQTY  
        else  
(  case  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( ISettlement.marketrate + #Broktable.Normal),CT.Round_To) */  
                                                             ISettlement.Tradeqty  *  (  ISettlement.marketrate + ((floor((  (( #Broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power
(10,CT.Round_To)))  
  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                                                       Then /* round((ISettlement.marketrate - #Broktable.Normal ),CT.Round_To )    */  
                                                                ISettlement.Tradeqty * (   ISettlement.marketrate - ((floor(( (( #Broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
power(10,CT.Round_To)))  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (ISettlement.marketrate + round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)) */  
                                                               ISettlement.Tradeqty  * (   ISettlement.marketrate + ((floor(( (((#Broktable.Normal /100 )* ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) *
 (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                                                       Then /* (ISettlement.marketrate - round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To))           */  
                                                                ISettlement.Tradeqty * (   ISettlement.marketrate -  ((floor((  ( ((#Broktable.Normal /100 )* ISettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero 
)) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                                                    Then /* round((#Broktable.day_puc + ISettlement.marketrate ),CT.Round_To)*/  
                                                             ISettlement.Tradeqty * (    ISettlement.marketrate + ((floor(( ((#Broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                         when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                                                    Then /* (ISettlement.marketrate + round((#Broktable.day_puc/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                               ISettlement.Tradeqty * ( ISettlement.marketrate + ((floor(( (((#Broktable.day_puc/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                          when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                                                     Then /* round((ISettlement.marketrate - #Broktable.day_sales),CT.Round_To)*/  
                                                              ISettlement.Tradeqty * ( ISettlement.marketrate - ((floor(( (( #Broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                         when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                                                    Then /* (ISettlement.marketrate - round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                              ISettlement.Tradeqty * (  ISettlement.marketrate - ((floor((  (((#Broktable.day_sales/ 100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                                                     Then /* round((#Broktable.sett_purch + ISettlement.marketrate ),CT.Round_To )*/  
                                                               ISettlement.Tradeqty * (  ISettlement.marketrate + ((floor(( ((#Broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
  
  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                                                      Then /* (ISettlement.marketrate + round(( #Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                               ISettlement.Tradeqty * (  ISettlement.marketrate + ((floor(( ( (( #Broktable.sett_purch/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)))  
                                        when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='V' )  
                                                      Then /* round(( ISettlement.marketrate - #Broktable.sett_sales ),CT.Round_To) */  
                                                     ISettlement.Tradeqty * ( ISettlement.marketrate - ((floor(( (( #Broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) )  
                                         when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='P' )  
                                                     Then /* (ISettlement.marketrate - round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)) */  
                                                       ISettlement.Tradeqty  * (  ISettlement.marketrate -  ((floor((  (((#Broktable.sett_sales/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To)))  
   Else  0  
                        End )  
                      END   ),  
/*       Ins_chrg  =(Case  
  when ISettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.insurance_chrg * ISettlement.marketrate * ISettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),  
  
  
        turn_tax  = (Case  
  when ISettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.turnover_tax * ISettlement.marketrate * ISettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /  
  power(10,CT.Round_To))END),  
  
        other_chrg =(Case  
  when ISettlement.status = 'N' then 0  
  ELSE  ((floor(( ((CT.other_chrg * ISettlement.marketrate * ISettlement.Tradeqty)/100 ) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /  power(10,CT.Round_To))END),  
  
        sebi_tax =(Case  
  when ISettlement.status = 'N' then 0  
     ELSE  ((floor(( ((CT.sebiturn_tax * ISettlement.marketrate * ISettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) / power(10,CT.Round_To))END),  
  
        Broker_chrg = (Case  
  when ISettlement.status = 'N' then 0  
  ELSE ((floor(( ((CT.broker_note * ISettlement.marketrate * ISettlement.Tradeqty)/100) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) / (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) ) /power(10,CT.Round_To))END),  
*/  
  
  
        Ins_chrg  = ((CT.insurance_chrg * ISettlement.marketrate * ISettlement.Tradeqty)/100),  
        turn_tax  = ((CT.turnover_tax * ISettlement.marketrate * ISettlement.Tradeqty)/100 ),  
        other_chrg = ((CT.other_chrg * ISettlement.marketrate * ISettlement.Tradeqty)/100 ),  
        sebi_tax = ((CT.sebiturn_tax * ISettlement.marketrate * ISettlement.Tradeqty)/100),  
        Broker_chrg = ((CT.broker_note * ISettlement.marketrate * ISettlement.Tradeqty)/100),  
  
        Service_tax = (Case When #Client2.Service_Chrg = 1 And #Client2.SerTaxMethod = 1  
        Then 0  
        Else (Case  
  when ISettlement.status = 'N' then 0  
        else  
 (  case  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                              Then  
  ( ( ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* #Broktable.Normal  */  
  (( ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To))) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                      ((    ((floor ( (((#Broktable.Normal /100 ) * ISettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( ISettlement
.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                        when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)         */  
  ((  ((floor(( ((#Broktable.Normal /100 )* ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                            Then /* ((#Broktable.day_puc)) */  
  ((  ((floor(( ((#Broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.day_puc/100) * ISettlement.marketrate,CT.Round_To)  */  
  (( ((floor(( ((#Broktable.day_puc/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                   when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.day_sales */  
  (( ((floor(( #Broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))   ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                  when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                             Then /*round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To) */  
  ( (  ((floor(( ((#Broktable.day_sales/ 100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END )  
  
                 when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_purch  */  
  (( ((floor(( #Broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To) */  
  ((  ((floor(( ((#Broktable.sett_purch/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
             when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_sales */  
  ((  ((floor(( #Broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
 when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)*/  
  ((  ((floor(( ((#Broktable.sett_sales/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
   Else  0  
                        End  
                         )  
   End )  
                     END    )/*  /  ( CASE WHEN #Client2.Service_chrg =  0 THEN 100 ELSE (100 + Globals.service_tax)  END )*/,  
      Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,  
      NBrokApp = (Case  
  when ISettlement.status = 'N' then 0  
        else  
(  case  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                              Then  /* #Broktable.Normal */  
  ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* #Broktable.Normal  */  
  ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                               Then  
                                          ((floor ( (((#Broktable.Normal /100 ) * ISettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                        when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)         */  
  ((floor(( ((#Broktable.Normal /100 )* ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                            Then /* ((#Broktable.day_puc)) */  
  ((floor(( ((#Broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.day_puc/100) * ISettlement.marketrate,CT.Round_To)  */  
  ((floor(( ((#Broktable.day_puc/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                   when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.day_sales */  
  ((floor(( #Broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                  when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                             Then /*round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((#Broktable.day_sales/ 100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_purch  */  
  ((floor(( #Broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To) */  
  ((floor(( ((#Broktable.sett_purch/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
             when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_sales */  
  ((floor(( #Broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
                         when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)*/  
  ((floor(( ((#Broktable.sett_sales/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  
   Else  0  
                        End )  
                        end ),  
        NSertax = (Case When #Client2.Service_Chrg = 1 And #Client2.SerTaxMethod = 1  
        Then 0  
        Else (Case  
  when ISettlement.status = 'N' then 0  
        else  
 (  case  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                              Then  
  ( ( ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                              Then /* #Broktable.Normal  */  
  (( ((floor(( #Broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  power(10,CT.Round_To))) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                   Then  
                                      ((    ((floor ( (((#Broktable.Normal /100 ) * ISettlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                        when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                             Then /* round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)         */  
  ((  ((floor(( ((#Broktable.Normal /100 )* ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                            Then /* ((#Broktable.day_puc)) */  
  ((  ((floor(( ((#Broktable.day_puc))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                      when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.day_puc/100) * ISettlement.marketrate,CT.Round_To)  */  
  (( ((floor(( ((#Broktable.day_puc/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                   when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.day_sales */  
  (( ((floor(( #Broktable.day_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))   ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
                  when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                             Then /*round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To) */  
  ( (  ((floor(( ((#Broktable.day_sales/ 100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                 when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_purch  */  
  (( ((floor(( #Broktable.sett_purch * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To))  ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To) */  
  ((  ((floor(( ((#Broktable.sett_purch/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
             when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='V' )  
                             Then /* #Broktable.sett_sales */  
  ((  ((floor(( #Broktable.sett_sales * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
  
 when ( ISettlement.SettFlag = 5  and #Broktable.val_perc ='P' )  
                             Then /* round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)*/  
  ((  ((floor(( ((#Broktable.sett_sales/100) * ISettlement.marketrate) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  
  
  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  
  
  power(10,CT.Round_To)) ) * ( ISettlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN #Client2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )  
   Else  0  
                        End  
                         )  
   End )  
                     END    ),  
N_NetRate =(Case  
  when ISettlement.status = 'N' then ISettlement.MARKETRATE  
        else  
(  case  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 1)  
                                                      Then /* round (( ISettlement.marketrate + #Broktable.Normal),CT.Round_To) */  
                                                                 ISettlement.marketrate + ((floor((  (( #Broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
  
  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='V' and sell_buy = 2)  
                                                       Then /* round((ISettlement.marketrate - #Broktable.Normal ),CT.Round_To )    */  
                                                                  ISettlement.marketrate - ((floor(( (( #Broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /  power(10,CT.Round_To))  
                                           when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 1)  
                                                        Then /* (ISettlement.marketrate + round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To)) */  
                                                                   ISettlement.marketrate + ((floor(( (((#Broktable.Normal /100 )* ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) 
)  / power(10,CT.Round_To))  
                                          when ( ISettlement.SettFlag = 1 and #Broktable.val_perc ='P' and sell_buy = 2)  
                                                       Then /* (ISettlement.marketrate - round((#Broktable.Normal /100 )* ISettlement.marketrate,CT.Round_To))           */  
                                                                   ISettlement.marketrate -  ((floor((  ( ((#Broktable.Normal /100 )* ISettlement.marketrate))  * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                          when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='V' )  
                                                    Then /* round((#Broktable.day_puc + ISettlement.marketrate ),CT.Round_To)*/  
                                                                 ISettlement.marketrate + ((floor(( ((#Broktable.day_puc  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (ISettlement.SettFlag = 2  and #Broktable.val_perc ='P' )  
                         Then /* (ISettlement.marketrate + round((#Broktable.day_puc/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                ISettlement.marketrate + ((floor(( (((#Broktable.day_puc/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  
/ power(10,CT.Round_To))  
                                          when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='V' )  
                                                     Then /* round((ISettlement.marketrate - #Broktable.day_sales),CT.Round_To)*/  
                                                               ISettlement.marketrate - ((floor(( (( #Broktable.day_sales)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))  
                                         when (ISettlement.SettFlag = 3  and #Broktable.val_perc ='P' )  
                                                    Then /* (ISettlement.marketrate - round((#Broktable.day_sales/ 100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                ISettlement.marketrate - ((floor((  (((#Broktable.day_sales/ 100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero )
 )  / power(10,CT.Round_To))  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='V' )  
                                                     Then /* round((#Broktable.sett_purch + ISettlement.marketrate ),CT.Round_To )*/  
                                                                 ISettlement.marketrate + ((floor(( ((#Broktable.sett_purch  )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
  
                                         when ( ISettlement.SettFlag = 4  and #Broktable.val_perc ='P' )  
                                                      Then /* (ISettlement.marketrate + round(( #Broktable.sett_purch/100) * ISettlement.marketrate ,CT.Round_To))*/  
                                                                 ISettlement.marketrate + ((floor(( ( (( #Broktable.sett_purch/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero
 ) )  / power(10,CT.Round_To))  
                                        when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='V' )  
                                                      Then /* round(( ISettlement.marketrate - #Broktable.sett_sales ),CT.Round_To) */  
                                                                   ISettlement.marketrate - ((floor(( (( #Broktable.sett_sales )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /   (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To
))  
                                         when ( ISettlement.SettFlag =5  and #Broktable.val_perc ='P' )  
                                                     Then /* (ISettlement.marketrate - round((#Broktable.sett_sales/100) * ISettlement.marketrate ,CT.Round_To)) */  
                                                                 ISettlement.marketrate -  ((floor((  (((#Broktable.sett_sales/100) * ISettlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero
 ) )  /  power(10,CT.Round_To))  
   Else  0  
                        End )  
                        end )  
  
   FROM #Broktable, #Client2 ,ISettlement ,globals, #Client1 , #ClientBrok_Scheme S, #ClientTaxes_New CT, Owner  
   WHERE ISettlement.Party_Code = #Client2.Party_code  
   and #Client1.cl_code=#Client2.cl_code  
   And #Client2.Party_Code = CT.Party_Code  
   And #Client2.Tran_Cat = CT.Trans_Cat  
   And S.Trade_Type = (Case When ISettlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)  
   And ISettlement.Sauda_Date Between FromDate And ToDate  
   And S.Table_No = #Broktable.Table_no  
   And S.Scheme_Type = #Client2.Tran_Cat  
   And S.Scrip_Cd = 'ALL'  
   And S.PARTY_CODE = iSettlement.Party_Code  
   And ISettlement.Sauda_Date Between S.From_Date And S.To_Date  
   And #Broktable.Line_no = ( case when S.BrokScheme = 2 then  
           (Select min(#Broktable.line_no) from #Broktable where  
                                                     S.Table_No = #Broktable.Table_no  
                         and Trd_Del =  
           ( Case When @@Eq = 'Y' then  
          ( Case When @@PRatemore = 'Y'  
          then ( Case When ( ISettlement.Sell_Buy = 1 )  
                          Then 'F'  
                          Else 'S'  
                 End )  
          Else  
               ( Case When ( ISettlement.Sell_Buy = 2 )  
                          Then 'F'  
                   Else 'S'  
                 End )  
          End )  
           Else  
         ( Case When @@PMore = 'Y'  
                then ( Case When ( ISettlement.Sell_Buy = 1 )  
                         Then 'F'  
  
                         Else 'S'  
                End )  
                Else  
                    ( Case When ( ISettlement.Sell_Buy = 2 )  
                               Then  
                                                                                              'F'  
                                                                                          Else  
                                                                                              'S'  
                      End )  
           End )  
           End )  
           and ISettlement.Party_Code =  #Client2.Party_code  
                                                     and ISettlement.marketrate <= #Broktable.upper_lim)  
      else ( case when S.BrokScheme = 1 then  
                 (Select min(#Broktable.line_no) from #Broktable where  
                                                     S.Table_No = #Broktable.Table_no  
                         and Trd_Del = ( Case When @@PMore = 'Y'  
           then ( Case When ( ISettlement.Sell_Buy = 1 )  
                    Then 'F'  
                    Else 'S'  
                 End )  
                Else  
                ( Case When ( ISettlement.Sell_Buy = 2 )  
                    Then 'F'  
                    Else 'S'  
                 End )  
             End )  
                                                     and ISettlement.Party_Code =  #Client2.Party_code  
                                                     and ISettlement.marketrate <= #Broktable.upper_lim)  
       else ( case when S.BrokScheme = 3 then  
                     (Select min(#Broktable.line_no) from #Broktable where  
                                                             S.Table_No = #Broktable.Table_no  
                                 and Trd_Del = ( Case When @@SMore ='Y'  
                   then ( Case When ( ISettlement.Sell_Buy = 2 )  
                               Then 'F'  
                             Else 'S'  
                   End )  
                   Else ( Case When ( ISettlement.Sell_Buy = 1 )  
                        Then 'F'  
                        Else 'S'  
                     End )  
                     End )  
                                                      and ISettlement.Party_Code =  #Client2.Party_code  
                                                      and ISettlement.marketrate <= #Broktable.upper_lim)  
        else  
               (Select min(#Broktable.line_no) from #Broktable  
                where S.Table_No = #Broktable.Table_no  
                 And Trd_Del = 'T'  
                                and ISettlement.Party_Code =  #Client2.Party_code  
                      and ISettlement.marketrate <= #Broktable.upper_lim )  
        end )  
       end )  
      end )  
  and ISettlement.status <> 'E'  
  And CT.Trans_cat = #Client2.Tran_cat  
  and RTrim(ISettlement.party_code ) = @tparty  
  and ISettlement.scrip_cd   =  @tscrip_cd  
  and ISettlement.tradeqty > 0  
  and ISettlement.series Like @series  
  and ISettlement.sett_no = @@sett_no  
  and ISettlement.sett_type = @sett_Type  
  And ISettlement.Status <> 'E'  
  and Left(convert(varchar,ISettlement.sauda_date,109),11) = @tdate  
  and partipantcode = @Memcode  
  And Sauda_date > Globals.year_start_dt  
  And Sauda_date < Globals.year_end_dt  
  
If @@Rowcount = 0  
 Insert into errorlog Values (Getdate(), '  In BBGsettbrokupdatenew  did not updated  any rows   ',  @TParty + '      ' +@TScrip_cd +'     ' +@Tdate + '      ' +  @Sett_type +'   '+ @@Sett_no ,'      ' +  @Memcode + '     ' +@TMark  +   '    '  ,'      ')
  
  
if @@error = 0  
begin  
 insert into inst_log values  
 (  
  ltrim(rtrim(@tparty)), /*party_code*/  
  ltrim(rtrim(@tparty)), /*new_party_code*/  
  convert(datetime, ltrim(rtrim(@tdate))),  /*sauda_date*/  
  ltrim(rtrim('')),  /*sett_no*/  
  ltrim(rtrim(@sett_type)),  /*sett_type*/  
  ltrim(rtrim(@tscrip_cd)), /*scrip_cd*/  
  ltrim(rtrim(@Series)), /*series*/  
  ltrim(rtrim('')),  /*order_no*/  
  ltrim(rtrim('')),  /*trade_no*/  
  ltrim(rtrim('')), /*sell_buy*/  
  ltrim(rtrim('')), /*contract_no*/  
  ltrim(rtrim('')), /*new_contract_no*/  
  0,  /*brokerage*/  
  0,  /*new_brokerage*/  
  0,  /*market_rate*/  
  0,  /*new_market_rate*/  
  0,  /*net_rate*/  
  0,  /*new_net_rate*/  
  0,  /*qty*/  
  0,  /*new_qty*/  
  ltrim(rtrim(@Memcode)),  /*participant_code*/  
  ltrim(rtrim(@Memcode)),  /*new_participant_code*/  
  ltrim(rtrim(@StatusName)),  /*username*/  
  ltrim((@FromWhere)),  /*module*/  
  'BBGInsSettBrokUpdateNew', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
