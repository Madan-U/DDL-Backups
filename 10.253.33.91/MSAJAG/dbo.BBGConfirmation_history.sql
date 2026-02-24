-- Object: PROCEDURE dbo.BBGConfirmation_history
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE Procedure [dbo].[BBGConfirmation_history] ( 
@Sett_no Varchar(10), 		 ---1  Settlement No(from)
@Tosett_No Varchar(10),		 ---2  Settlement no (to)
@Sett_type Varchar(3),		 ---3  Settlement type 
@Sauda_date Varchar(11),	 ---4 Sauda_date (from)
@ToDate Varchar(11),		 ---5 Sauda_date (to)
@FromScrip Varchar(10),		 ---6 From scrip_cd (from)
@ToScrip Varchar(10),		 ---7 To Scrip_cd (to)
@From Varchar(20), 		 ---8  From Consol
@To Varchar (20), 		 ---9  To Consol
@Consol Varchar(10),		 ---10  Consol indicates that whether is "Party_code","Trader","Sub Broker","Branch"
@Detail Varchar(3),		 ---11  This is other details in Query "B" = "Bill","C" = "Confirmation","P" = "Position","Br" = "Brokerage","S" = "Sauda summary"
@Level  SmallInt,                                  --- 12 Will be used to Select  Level of Consolidation Default 0
@GroupF Varchar(500),		 ---13 (any necessary Grouping) This can be defined on the fly by developer
@OrderF Varchar(500),		 ---14 (any necessary Order by) This can de defined on the fly by developer 
@Use1 Varchar(10),                    --- 15 To be used later  for other purposes
@statusid varchar(15),
@statusname varchar(25) )

As
Declare
@@Getstyle as Cursor,
@@Sett_no As Varchar(10),
@@Fromparty_code as varchar(10),
@@Toparty_code  As Varchar(10),
@@FromSett_type As Varchar(3),
@@ToSett_type As Varchar(3),
@@Myquery As Varchar(4000),
@@MyReport As Varchar(50),
@@MyOrder As Varchar(1500),
@@Mygroup As Varchar(1500),
@@Part As varchar(8000),
@@Part1 As varchar(8000),
@@Part2 As Varchar(8000),
@@Part3 As Varchar(8000),
@@Part4 As Varchar(8000),
@@Part5 As Varchar(8000),
@@Part6 As Varchar(8000),
@@WiseReport As Varchar(10),
@@Dummy1 As Varchar(1000),
@@Dummy2 As Varchar(1000),
@@FromRegion As varchar(10),
@@ToRegion  As Varchar(10),
@@FromFamily As varchar(10),
@@ToFamily  As Varchar(10),
@@FromBranch_cd As varchar(15),
@@ToBranch_cd  As Varchar(15),
@@FromSub_Broker As varchar(15),
@@ToSub_Broker  As Varchar(15),
@@FromTrader As varchar(15),
@@ToTrader  As Varchar(15),
@@Dummy3 As Varchar(1000),
@@FromTable As Varchar(1000),    --------------------   This string will enable us to code conditions Like From settlement
@@SelectFlex As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectFlex1 As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectBody As Varchar(8000),  ---------------------   This is regular Select Body
@@SelectBody1 As Varchar(8000),  ---------------------   This is regular Select Body
@@WhereText As Varchar(8000),  ---------------------  This will be used for Coding Where condition  
@@FromTable1 As Varchar(1000), ---------------------   This is Another String that can be used for  
@@Wherecond1 As Varchar(2000)



If ((@Consol = "PARTY_CODE" Or @Consol = "BROKER")) And  ((@From <> "") And (@To = "" ) ) 
Begin
          Select @@FromParty_code = @From
          Select @@ToParty_code = @From 
End

If ((@Consol = "PARTY_CODE" Or @Consol = "BROKER")) And  ((@From <> "") And (@To <> "" ) ) 
Begin
          Select @@FromParty_code = @From
          Select @@ToParty_code = @To 
End


If (@Consol = "FAMILY") And  ((@From <> "") And (@To <> "" ) ) 
Begin
          Select @@FromFamily = @From
          Select @@ToFamily = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code and Client1.Family between @@FromFamily  And @@ToFamily
End
else If (@Consol = "FAMILY") And  ((@From = "") And (@To = "" ) ) 
Begin          
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromFamily = Min(Family) , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code 
End

If (@Consol = "Branch_cd") And  ((@From <> "") And (@To <> "" ) ) 
Begin
          Select @@FromBranch_cd = @From
          Select @@ToBranch_cd = @To 

          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Branch_cd  Between @@FromBranch_cd  And @@ToBranch_cd
End
Else If (@Consol = "Branch_cd") And  ((@From = "") And (@To = "" ) ) 
Begin
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code),@@FromBranch_Cd = Min(Branch_Cd), @@ToBranch_Cd = Max(Branch_Cd) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code 
End

If (@Consol = "Trader") And  ((@From <> "") And (@To <> "" ) ) 
Begin
          Select @@FromTrader = @From
          Select @@ToTrader = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Trader Between @@FromTrader  And @@ToTrader
End
else If (@Consol = "Trader")  And ( ( @From = "" ) And ( @To = "" ) )  
begin
	Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromTrader=Min(Trader),@@ToTrader=Max(Trader) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code 
End


If (@Consol = "Sub_Broker") And  ((@From <> "") And (@To <> "" ) ) 
Begin
          Select @@FromSub_Broker = @From
          Select @@ToSub_broker = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Sub_Broker Between @@FromSub_Broker  And @@ToSub_Broker      	
end
else If (@Consol = "Sub_Broker")  And ( ( @From = "" ) And ( @To = "" ) )  
begin
	Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromSub_broker=Min(Sub_Broker),@@ToSub_Broker=Max(Sub_Broker) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code 
End


If ( (@Consol = "PARTY_CODE" Or @Consol = "BROKER")) And ( ( @From = "" ) And ( @To = "" ) ) 
Begin
     Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details 
End

If (@Consol = "Region")  And ( ( @From = "" ) And ( @To = "" ) )  
Begin
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromRegion=Min(Region),@@ToRegion = Max(Region) From Cmbillvalan  
End

If (@Consol = "Region")  And ( ( @From <> "" ) And ( @To <> "" ) )  
Begin
     Set @@FromRegion = @From
     Set @@ToRegion = @To
     Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code)  From cmbillvalan   where region between @@Fromregion and @@Toregion
End

-----------------------------------------------------------------------------------------
If @Sett_type  <>  "%" 

Begin
     Select @@FromSett_type = @Sett_type
     Select @@ToSett_type = @Sett_type
End


If @Sett_type  =  "%" 
Begin
      Select @@FromSett_type = Min(Sett_type), @@ToSett_type = Max(Sett_type) From Details
End

-----------------------------------------------------------------------------------------
If  ( (@FromScrip = "") And  (@ToScrip = "") )
   Select @FromScrip = Min(Scrip_cd) ,@ToScrip = Max(Scrip_cd) From Scrip2

If (@FromScrip = "")
   Select @FromScrip = Min(Scrip_Cd) From Scrip2

If (@ToScrip = "")
   Select @ToScrip = Max(Scrip_cd) From Scrip2
-----------------------------------------------------------------------------------------
If @Tosett_no = "" 
   Set @Tosett_no = @Sett_no

Select @Sauda_date = Ltrim(Rtrim(@Sauda_date))
If Len(@Sauda_date) = 10 
Begin
          Set @Sauda_date = STUFF(@Sauda_date, 4, 1,"  ")
End

Select @Todate = Ltrim(Rtrim(@Todate))

If Len(@Todate) = 10 
Begin
          Set @Todate = STUFF(@Todate, 4, 1,"  ")
End
--------------------------------------------------- Find SaudaDate From To From Settlement Range  -------------------------------------------------------------------------------------------------------
If ( @Todate  = "" ) 
Begin
        Select @Todate = End_date from sett_mst where Sett_type = @Sett_type and Sett_no = @ToSett_no 
End

If ( @Sauda_date  = "" ) 
Begin
        Select @Sauda_date = Start_date from sett_mst where Sett_type = @Sett_type and Sett_no = @Sett_no 
End
----------------------------------------------------Find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------
If ( (@Sett_no = "" ) And ( Len(@Sauda_date) > 1)) 
Begin
         Select @sett_no = Min(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type And @@Tosett_type  and Start_Date < @Sauda_date + " 00:01"  and End_date >= @Sauda_date + " 23:58:59"   
         If @Todate = "" 
         Set @Tosett_no = @Sett_no
     
End

If ( (@ToSett_no = "" ) And ( Len(@Todate) > 1)) 
Begin
        Select @Tosett_no = Max(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type  and @@ToSett_type and Start_Date < @Todate + " 00:01" and End_date >= @Todate  + " 23:58:59" 
        
End
-----------------------------------------------------------------------------------------
 
If @Detail = "C" 
   Set @@MyReport = "Confirmation"





If @OrderF = "0"       ------------------------------ To be used For Contract / Bill Printing  ------------------------
Begin
          If @Consol = "Party_code"
             Set @@MyOrder = " Order by S.party_code, S.ContractNo,S.Sett_No, S.Sett_Type,  S.Scrip_Cd Asc, S.Series, TradeTyp , BillNo, ContractNo, S.Sauda_date Option (Fast 10 )  "
End
	
If @OrderF = "1"  ------------------------ To be used for Gross position Across Range ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order   by Region,S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order   by S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty  Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order  by Branch_cd, S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family,S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader,S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker,S.Party_code,sett_no,sett_type,Contractno,Scrip_cd,Series,Sell_buy,sauda_date,Tradeqty Option (Fast 1 ) "
End

If @OrderF = "1.1"  ------------------------ To be used for Gross position Across Range ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, Region  Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, party_code  Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, Branch_cd  Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, Family Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, Trader Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order by s.scrip_cd, s.series, Sub_Broker Option (Fast 1 ) "
End

If @OrderF = "2"   ------------------------ To be used for Net position Across Settlement  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order  by  S.Sett_no,S.Sett_type Option (Fast 1 ) "

          If @Consol = "Party_code"
             Set  @@MyOrder = " Order  by  S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder  = " Order  by S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder  = " Order  by S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder  = " Order  by S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Sub_broker"
     Set  @@MyOrder = " Order by S.Sett_no,S.Sett_type Option (Fast 1 )"
End


If @OrderF = "3"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order  by S.Scrip_cd ,S.Series Option (Fast 1 ) "

          If @Consol = "Party_code"
             Set  @@MyOrder = " Order  by S.Scrip_cd ,S.Series Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder  = " Order  by S.Scrip_cd ,S.Series  Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder  = " Order  by S.Scrip_cd ,S.Series  Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder  = " Order  by S.Scrip_cd ,S.Series  Option (Fast 1 ) "
          If @Consol = "Sub_broker"
     Set  @@MyOrder = " Order by S.Scrip_cd ,S.Series  Option (Fast 1 )"
End

If @OrderF = "3.1"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by Region , S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.party_code , S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order by Branch_cd  ,S.Sett_no,S.Sett_type ,S.Scrip_cd , S.Series Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family , S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader  , S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker  , S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 )"
End

If @OrderF = "3.11"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by Region,S.party_code  Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.party_code  Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order by Branch_cd  ,S.Party_code Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family , S.Party_code Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader  , S.Party_code Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker  , S.Party_code Option (Fast 1 )"
End

If @OrderF = "3.2"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by Region , S.Sauda_date ,S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "

          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.party_code , S.Sauda_date ,S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order by Branch_cd  ,S.Sauda_date ,S.Sett_no,S.Sett_type ,S.Scrip_cd , S.Series Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family , S.Sauda_date ,S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader  , S.Sauda_date ,S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker  , S.Sauda_date ,S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 )"
End

If @OrderF = "3.3"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by Region  ,S.Scrip_cd, S.Series Option (Fast 1 ) "

          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.party_code  ,S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order by Branch_cd  ,S.Scrip_cd , S.Series Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader  , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker  , S.Scrip_cd, S.Series Option (Fast 1 )"
End

If @OrderF = "3.4"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by S.Sett_no,S.Sett_type ,S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.Sett_no,S.Sett_type ,S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Branch_Cd"

             Set  @@MyOrder = " Order by S.Sett_no,S.Sett_type  ,S.Scrip_cd , S.Series Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  byS.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by S.Sett_no,S.Sett_type , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by S.Sett_no,S.Sett_type  , S.Scrip_cd, S.Series Option (Fast 1 )"
End

If @OrderF = "4"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Sauda_date,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by S.Sauda_date , S.Sett_no,S.Sett_type  Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.Sauda_date , S.Sett_no,S.Sett_type  Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order  by S.Sauda_date  , S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by S.Sauda_date  , S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by S.Sauda_date  , S.Sett_no,S.Sett_type Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order by S.Sauda_date  , S.Sett_no,S.Sett_type Option (Fast 1 ) "

End

If @OrderF = "4.1"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Sauda_date,Tmark  ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order by Region  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sauda_date Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.party_code  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sauda_date Option (Fast 1 ) "

          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order  by Branch_cd  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,S.Sauda_date Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sauda_date Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S.Sauda_date Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order by Sub_Broker , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series ,S.Sauda_date Option (Fast 1 ) "
End


Set @@WhereText =  " And S.Sauda_date   Between '" + @Sauda_date  + " 00:00:00'  And '"   + @Todate  + " 23:59:00' And S.Scrip_cd Between '"  + @Fromscrip + "' And  '"+  @Toscrip +"' And S.Sett_no Between '" + @Sett_no + "' And '" + @Tosett_no +"' And "  
---------------------------  Now We Will Decide about Join  We will always provide from Party and ToParty -------------------------------------------


Set @@WhereText =  @@WhereText  + "  S.Party_code Between '" + @@FromParty_code  + "' And '"  + @@ToParty_code   +"'  "  

If @Consol = "Region" 
Set @@WhereText =  @@WhereText +   "  And Region Between '" + @@FromRegion  + "' And '" + @@ToRegion   +"'  " 


If @Consol = "FAMILY" 
Set @@WhereText =  @@WhereText +   "  And Family Between '" + @@FromFamily  + "' And '" + @@ToFamily   +"'  " 

If @Consol = "Trader"
Set @@WhereText =  @@WhereText + " And  Trader Between '" + @@FromTrader  + "' And '" + @@ToTrader   +"' " 

If @Consol = "Branch_cd" 
Set @@WhereText =  @@WhereText + " And Branch_cd Between '" + @@FromBranch_cd  + "' And '" + @@ToBranch_cd   +"' " 


If @Consol = "Sub_Broker" 
Set @@WhereText =  @@WhereText + " And Sub_Broker Between '" + @@FromSub_Broker  + "' And '" + @@ToSub_Broker   +"' " 

--Print "I am Here "
--Print @@WhereText


------------------------- Added For Access Control as per User Login Status ---------------------------------------------------------------------------------------------
If @StatusId = "FAMILY" 
	Begin
		Set @@WhereText =  @@WhereText +   "  And Family Between '" + @StatusName  + "' And '" + @StatusName   +"'  " 
	End

If @StatusId = "TRADER"
Begin
	Set @@WhereText =  @@WhereText + " And  Trader Between '" + @StatusName  + "' And '" + @StatusName   +"'  " 
End

If @StatusId = "BRANCH" 
Begin
	Set @@WhereText =  @@WhereText + " And Branch_cd Between '" + @StatusName  + "' And '" + @StatusName   +"'  " 
End


If @StatusId = "SUBBROKER" 
Begin
	Set @@WhereText =  @@WhereText + " And Sub_Broker Between '" + @StatusName  + "' And '" + @StatusName   +"'  " 
End

If @StatusId = "PARTY" 
Begin
	Set @@WhereText =  @@WhereText + " And Party_Code Between '" + @StatusName  + "' And '" + @StatusName   +"'  " 
End



Set @@Selectflex = " select S.Party_code, Family,Trader,Branch_cd,Sub_broker,Contractno,Long_Name,Res_Phone1,Scrip_cd,Series,Trade_no,Left(Convert(varchar,Sauda_date,109),11),Sauda_date,User_id ,sett_no,sett_type,Marketrate,brokapplied,NBrokapp,Tradeqty,sell_buy, "
Set @@SelectFlex = @@SelectFlex + " Netrate = ( Case when  Sell_buy = 1 Then Marketrate + brokapplied  Else Marketrate - Brokapplied end), Netamount = Tradeqty * ( Case when  Sell_buy = 1 Then Marketrate + brokapplied  Else Marketrate - Brokapplied end), "
Set @@SelectFlex = @@SelectFlex + " N_Netrate = ( Case when  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - NBrokapp end) ,N_NetAmount =  Tradeqty * ( Case when  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - NBrokapp end),Service_Tax = Service_Tax ,NserTax = Nsertax " + " , SorIs = 'S',Branch_Id = Branch_Id  "
Set @@SelectFlex = @@SelectFlex + " from history S,Client1 C1 ,Client2 C2 where s.party_code = C2.Party_code and C2.cl_code = C1.Cl_code and Tradeqty > 0 and S.Auctionpart not like 'A%' and S.AuctionPart not Like 'F%'"
Set @@SelectFlex1 =  " Union all select S.Party_code,Family,Trader,Sub_broker,Branch_cd,Contractno,Long_Name,Res_Phone1,Scrip_cd,Series,Trade_no,Left(Convert(varchar,Sauda_date,109),11),Sauda_date,User_id ,sett_no,sett_type,Marketrate,brokapplied,NBrokapp,Tradeqty,sell_buy, "
Set @@SelectFlex1 = @@SelectFlex1 + " Netrate = ( Case when  Sell_buy = 1 Then Marketrate + brokapplied  Else Marketrate - Brokapplied end), Netamount = Tradeqty * ( Case when  Sell_buy = 1 Then Marketrate + brokapplied  Else Marketrate - Brokapplied end), "
Set @@SelectFlex1 = @@SelectFlex1+ " N_Netrate = ( Case when  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - NBrokapp end) ,N_NetAmount =  Tradeqty * ( Case when  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - NBrokapp end),Service_Tax = Service_Tax ,NserTax = Nsertax " + ", SorIs = 'IS',Branch_Id = Branch_Id "
Set @@SelectFlex1 = @@SelectFlex1 + " from ISettlement S,Client1 C1 ,Client2 C2 where s.party_code = C2.Party_code and C2.cl_code = C1.Cl_code and Tradeqty > 0 and S.Auctionpart not like 'A%' and S.AuctionPart not Like 'F%' "


--Select @@Wheretext
--Select @@Selectflex
--Select @@MyOrder


Exec (@@SelectFlex + @@WhereText + @@Selectflex1 + @@WhereText + @@MyOrder)

GO
