-- Object: PROCEDURE dbo.AngelNewBBGSPostest
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE     Procedure AngelNewBBGSPostest ( 
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
@@FromFamily As varchar(10),
@@ToFamily  As Varchar(10),
@@FromBranch_cd As varchar(15),
@@ToBranch_cd  As Varchar(15),
@@FromSub_Broker As varchar(15),
@@ToSub_Broker  As Varchar(15),
@@FromTrader As varchar(15),
@@ToTrader  As Varchar(15),
@@FromRegion Varchar(15),
@@ToRegion Varchar(15),
@@Dummy3 As Varchar(1000),
@@FromTable As Varchar(1000),    --------------------   This string will enable us to code conditions Like From settlement
@@SelectFlex As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectFlex1 As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectBody As Varchar(8000),  ---------------------   This is regular Select Body
@@SelectBody1 As Varchar(8000),  ---------------------   This is regular Select Body
@@WhereText As Varchar(8000),  ---------------------  This will be used for Coding Where condition  
@@FromTable1 As Varchar(1000), ---------------------   This is Another String that can be used for  
@@Wherecond1 As Varchar(2000)

/* To reduce the number of queries we have joined maximum number of parameters with ranges*/
/* Hence we are extracting ranges if the partmeter passed is %  or ""   */
/* If the parameter is passed then we make that same parameter as from <-----> To  */

/* Here I will define rules for various  */
-----------------------------------------------------------------------------------------
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
else If (@Consol = "REGION")  And  ((@From <> "") And (@To <> "" ) ) 
begin
     Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details 
     Select @@FromRegion = @From 
     Select @@ToRegion = @To 	
End

else If (@Consol = "REGION")  And  ((@From = "") And (@To = "" ) ) 
begin
     Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details 
     Select @@FromRegion = Min(Region), @@ToRegion=Max(Region) From CmBillValan
End

If ( (@Consol = "PARTY_CODE" Or @Consol = "BROKER")) And ( ( @From = "" ) And ( @To = "" ) ) 
Begin
     Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details 
End
-----------------------------------------------------------------------------------------

If @Sett_type  <>  "%" And @Sett_Type <> ''
Begin
     Select @@FromSett_type = @Sett_type
     Select @@ToSett_type = @Sett_type
End

If (@Sett_type  =  "%" Or @Sett_Type = '' )
Begin
      Select @@FromSett_type = Min(Sett_type), @@ToSett_type = Max(Sett_type) From Details
--		Print 'Sett Type Min = ' + @@FromSett_type
--		Print 'Sett Type Max = ' + @@ToSett_type
End

----------------------------------------------------------------------------------------

If  ( (@FromScrip = "") And  (@ToScrip = "") )
   Select @FromScrip = Min(scrip_cd) ,@ToScrip = Max(scrip_cd) From Scrip2

If (@FromScrip = "")
   Select @FromScrip = Min(scrip_cd) From Scrip2

If (@ToScrip = "")
   Select @ToScrip = Max(scrip_cd) From Scrip2

-----------------------------------------------------------------------------------------
If @Tosett_no = "" 
   Set @Tosett_no = @Sett_no

----------------------------------------------------Find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------
If ( (@Sett_no = "" ) And ( Len(@Sauda_date) > 1)) 
Begin
         Select @sett_no = Min(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type And @@Tosett_type  and Start_Date >= @Sauda_date + " 00:00"  and End_date <= @Todate + " 23:59:59"   
         If @Todate = "" 
        Set @Tosett_no = @Sett_no
End

If ( (@ToSett_no = "" ) And ( Len(@Todate) > 1)) 
Begin
        Select @Tosett_no = Max(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type  and @@ToSett_type and Start_Date >= @Sauda_date + " 00:00" and End_date <= @Todate  + " 23:59:59" 
End
-----------------------------------------------------------------------------------------

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
	--Select @Todate = End_date from sett_mst where Sett_type = @Sett_type and Sett_no = @ToSett_no 
	Select @Todate = Max(End_date) from sett_mst where Sett_type Between  @@FromSett_type And @@Tosett_type and Sett_no between @Sett_no And @ToSett_no
--	Print 'In Blank To Date'
--	Print 'Set No : ' + @Sett_no
--	Print 'Set Type : ' + @Sett_type
--	Print 'To Sauda Date : ' + @Todate
End

If ( @Sauda_date  = "" )
Begin
	--Select @Sauda_date = Start_date from sett_mst where Sett_type = @Sett_type and Sett_no = @Sett_no 
	Select @Sauda_date = Min(Start_date) from sett_mst where Sett_type Between  @@FromSett_type And @@Tosett_type and Sett_no between @Sett_no And @ToSett_no
--	Print 'In Blank Sauda Date'
--	Print 'Set No : ' + @Sett_no
--	Print 'Set Type : ' + @Sett_type
--	Print 'From Sauda Date : ' + @Sauda_date
End
-----------------------------------------------------------------------------------------

If @Detail = "B"
   Set @@MyReport = "Bill"
 
If @Detail = "C"
   Set @@MyReport = "Confirmation"

If @Detail = "P"
   Set @@MyReport = "Position"

If @Detail = "BR"
   Set @@MyReport = "Brokerage"

If @Detail = "S"
   Set @@MyReport = "SaudaSummary"

------------------------------------- We Will Select From  Various Order By Options -------------------------------------- 

If @OrderF = "0"       ------------------------------ To be used For Contract / Bill Printing  ------------------------
Begin
          If @Consol = "Party_code"
             Set @@MyOrder = " Order by S.party_code, S.Sett_No, S.Sett_Type,  S.Scrip_Cd Asc, S.Series, TradeTyp , BillNo, ContractNo, S.Sauda_date Option (Fast 10 )  "
End
	
If @OrderF = "1"  ------------------------ To be used for Gross position Across Range ----------------------
Begin
          If @Consol = "Region"
             Set  @@MyOrder = " Order   by Region  Option (Fast 1 ) "
          If @Consol = "Party_code"
             Set  @@MyOrder = " Order   by party_code  Option (Fast 1 ) "
          If @Consol = "Branch_Cd"
             Set  @@MyOrder = " Order  by Branch_cd  Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker Option (Fast 1 ) "
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
             Set  @@MyOrder = " Order by Branch_cd , S.party_code, S.Scrip_cd , S.Series Option (Fast 1 ) "
          If @Consol = "Family"
             Set  @@MyOrder = " Order  by Family, S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Trader"
             Set  @@MyOrder = " Order  by Trader , S.Scrip_cd, S.Series Option (Fast 1 ) "
          If @Consol = "Sub_broker"
             Set  @@MyOrder = " Order  by Sub_Broker , S.Scrip_cd, S.Series Option (Fast 1 )"
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
             Set  @@MyOrder = " Order by S.Sauda_date , S.Sett_no,S.Sett_type  Option (Fast 1 ) "          If @Consol = "Party_code"
             Set  @@MyOrder = " Order by S.Sauda_date , S.Sett_no,S.Sett_type  Option (Fast 1 ) "          If @Consol = "Branch_Cd"
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


-------------------------------------  End Of Select  Order By Options  ----------------------------------------------------


Set @@FromTable = " From CmBillValan S"

--Print 'CONSOL : ' + @Consol
--Print 'GROUPF : ' + @GroupF


------------------------------------- We Will Decide Various Group By Options -------------------------------------- 

If @GroupF = "0"    ----------------------  To be Used for Contract or Bills ----------------------
Begin
     If @Consol = "Party_code" 
     Set  @@MyGroup =  " Group by Party_Code , Party_Name, Branch_Cd, Sub_Broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_Name, Sauda_date  , left(convert(varchar,sauda_date,109),11), ContractNo , Billno , TradeType , Start_Date, End_Date"
     Set  @@SelectFlex =  " Select Party_Code , Long_Name=Party_Name, Branch_Cd, Sub_Broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_Name, Sauda_date = left(convert(varchar,sauda_date,109),11), ContractNo , Billno, PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg),  Trade_Date = S.Sauda_date , TradeTyp = (Case when TradeType like  '%BF' then 1 else case when TradeType like  '%CF' then 3 else case when TradeType like  '%R' then 4 else 2 end end end), TrdType = TradeType, Start_Date, End_Date "
End

If @GroupF = "1"  ------------------------ To be used for Gross position Across Range ----------------------
Begin
     If @Consol = "Region"
     Begin
          Set @@MyGroup = " Group by Region, MemberType, CompanyName"
          Set @@SelectFlex =  " Select Region, long_name=Region,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel), BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) , BuyDeliveryChrg = Sum(PBrokDel), SellDeliveryChrg = Sum(SBrokDel), ClientType = 1, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End

     If @Consol = "Party_code"
     Begin
          Set @@MyGroup = " Group by S.Party_code, Party_name,ClientType ,MemberType, CompanyName"
          Set @@SelectFlex =  " Select Party_Code, long_name=Party_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel), BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) , BuyDeliveryChrg = Sum(PBrokDel), SellDeliveryChrg = Sum(SBrokDel), ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Branch_Cd"
     Begin 
          Set  @@MyGroup = " Group by Branch_cd, ClientType, MemberType, CompanyName"
          Set @@SelectFlex =  " Select long_name=branch_cd,Branch_cd,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End
     If @Consol = "Family"
     Begin 
          Set  @@MyGroup = " Group by Family, Family_Name,ClientType , MemberType, CompanyName"
          Set @@SelectFlex =  " Select Family, long_name=Family_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Trader"
     Begin 
          Set  @@MyGroup = " Group by Trader ,MemberType,ClientType, CompanyName "
          Set @@SelectFlex =  " Select trader,long_name=Trader,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End       
     If @Consol = "Sub_broker"
     Begin 
          Set  @@MyGroup = " Group by Sub_broker ,MemberType ,ClientType, CompanyName "                    
          Set @@SelectFlex =  " Select Sub_broker,long_name=Sub_broker,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "1.1"  ------------------------ To be used for Gross position Across Range ----------------------
Begin
     If @Consol = "Region"
     Begin
          Set @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, Region,MemberType, CompanyName"
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, Region, long_name = Region,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End

     If @Consol = "Party_code"
     Begin
          Set @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, S.Party_code, Party_name,ClientType ,MemberType, CompanyName"
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, Party_Code, long_name=Party_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Branch_Cd"
     Begin 
          Set  @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, Branch_cd, ClientType, MemberType, CompanyName"
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, long_name=branch_cd,Branch_cd,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End
     If @Consol = "Family"
     Begin 
          Set  @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, Family, Family_Name,ClientType , MemberType, CompanyName"
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, Family, long_name=Family_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Trader"
     Begin 
          Set  @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, Trader ,MemberType,ClientType, CompanyName "
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, trader,long_name=Trader,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End       
     If @Consol = "Sub_broker"
     Begin 
          Set  @@MyGroup = " Group by Scrip_Cd, Series, Scrip_Name, Sub_broker ,MemberType ,ClientType, CompanyName "                    
          Set @@SelectFlex =  " Select Scrip_Cd, Series, Scrip_Name, Sub_broker,long_name=Sub_broker,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "2"   ------------------------ To be used for Net position Across Settlement  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set @@MyGroup = " Group by Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex = " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Region"
     Begin 
          Set @@MyGroup = " Group By Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex = " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  

     If @Consol = "Branch_Cd"
     Begin 
          Set @@MyGroup = " Group By Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex = " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Family"
     Begin 
          Set @@MyGroup =  " Group By Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex =  " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End                   
     If @Consol = "Trader"
     Begin 
          Set @@MyGroup =  " Group By Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex =  " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Sub_broker"
     Begin 
          Set @@MyGroup =  " Group By Sett_No, Sett_Type,Start_Date,End_Date,MemberType, CompanyName "
          Set @@SelectFlex =  " Select Sett_No, Sett_Type,Start_Date,End_Date,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End


If @GroupF = "3"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select Scrip_Cd, Series, Scrip_Name, PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Region"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  

     If @Consol = "Branch_Cd"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Family"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End                   
     If @Consol = "Trader"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select  Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Sub_broker"
     Begin 
          Set @@MyGroup = " Group by Scrip_Cd,Series,Scrip_Name,MemberType, CompanyName "
          Set @@SelectFlex = " Select Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "2.11"
Begin
     If @Consol = "Region"
     Begin
          Set  @@MyGroup = " Group By Region,Branch_cd,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select  Region,Branch_cd,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) "  
     End
End


If @GroupF = "3.11"   ------------------------ To be used for Net position Across Settlement ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group By Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Party_Code, Party_Name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 

     End 
     If @Consol = "Region"
     Begin
          Set  @@MyGroup = " Group By Region,Branch_cd,Party_Code, Party_Name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select  Region,Branch_cd,Party_Code, Party_Name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) "  
     End

     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Branch_cd,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select  Branch_cd,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) "  
     End
     If @Consol = "Family"
     Begin
/*          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Family,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Family,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) "  */
          Set  @@MyGroup = " Group By Family,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Family,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 


     End
     If @Consol = "Trader"
     Begin
/*          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Trader,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trader,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
*/
          Set  @@MyGroup = " Group By Trader,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Trader,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 

     End
     If @Consol = "Sub_broker"
     Begin
/*          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sub_broker,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Sub_broker,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
*/
          Set  @@MyGroup = " Group By Sub_broker,Party_code,Party_name,ClientType,MemberType, CompanyName "
          Set  @@SelectFlex =  " Select Sub_broker,Party_code,Party_name,ClientType,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 

     End
End

If @GroupF = "3.1"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Party_Code, Party_Name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Region"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Region,Branch_cd,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Region,Region,Branch_cd,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Branch_cd,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Branch_cd,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Family"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Family,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Family,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Trader"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Trader,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trader,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Sub_broker"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sub_broker,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Sub_broker,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End


If @GroupF = "3.2"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Party_Code, Party_Name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 

     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Region,Branch_cd,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Region,Branch_cd,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End

     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Branch_cd,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Branch_cd,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Family"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Family,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Family,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Trader"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Trader,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Trader,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Sub_broker"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Sauda_Date,left(convert(varchar,sauda_date,109),11),Sub_broker,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Sub_broker,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "3.3"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group By Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Party_Code, Party_Name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Region"
     Begin
          Set  @@MyGroup = " Group By Region,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Region,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End

     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Branch_cd,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Branch_cd,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Family"
     Begin
          Set  @@MyGroup = " Group By Family,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Family,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Trader"
     Begin
          Set  @@MyGroup = " Group By Trader,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Trader,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Sub_broker"
     Begin
          Set  @@MyGroup = " Group By Sub_broker,Party_code,Party_name,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sub_broker,Party_code,Party_name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "3.4"   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End 
     If @Consol = "Region"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Branch_Cd"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Family"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Trader"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
     If @Consol = "Sub_broker"
     Begin
          Set  @@MyGroup = " Group By Sett_No, Sett_Type,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd)  ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt=Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End
End

If @GroupF = "4"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Region"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  

     If @Consol = "Branch_Cd"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Family"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Trader"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Sub_broker"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),MemberType, CompanyName "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) ,  BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ), TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End  
End

If @GroupF = "4.1"  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
     If @Consol = "Party_code"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Party_code,Party_name,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "          Set  @@SelectFlex =  " Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Party_Code, Party_Name,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Region"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Region,Branch_cd,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Region,Branch_cd,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  

     If @Consol = "Branch_Cd"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Branch_cd,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Branch_cd,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Family"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Family,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Family,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Trader"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Trader,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Trader,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName,pnl = sum(samttrd-pamttrd) " 
     End  
     If @Consol = "Sub_broker"
     Begin 
          Set  @@MyGroup = " Group by Sett_No, Sett_Type,Sauda_Date,left(convert(varchar,sauda_date,109),11),Sub_broker,ClientType,MemberType, CompanyName,Scrip_Cd,Series,Scrip_Name "
          Set  @@SelectFlex =  "Select Sett_No, Sett_Type,Trade_Date = S.Sauda_date,Sauda_date = left(convert(varchar,sauda_date,109),11),Sub_broker,Scrip_Cd,Series,Scrip_Name,PTradedqty = Sum(PQtyTrd + PQtyDel) ,PtradedAmt = Sum(PAmtTrd + PAmtDel) ,STradedQty = Sum(SQtyTrd + SQtyDel), STradedAmt = Sum(SAmtTrd + SAmtDel),BuyBrokerage = Sum(PBrokTrd) , SelBrokerage= Sum(SBrokTrd) ,BuyDeliveryChrg = Sum(PBrokDel) ,SellDeliveryChrg = Sum(SBrokDel) , ClientType, BillPamt = Sum(Pamt) , BillSAmt = Sum(Samt) , PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) , SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),  TrdAmt= Sum(TrdAmt) ,DelAmt=Sum(DelAmt), SerInEx=Sum(SerInEx),Service_Tax= Sum(Service_Tax) ,ExService_Tax= Sum(ExService_Tax),Turn_tax=Sum(Turn_Tax),Sebi_tax=Sum(Sebi_Tax),Ins_chrg=Sum(Ins_Chrg),Broker_Chrg=Sum(Broker_Chrg),Other_Chrg=Sum(Other_Chrg), MemberType, CompanyName ,pnl = sum(samttrd-pamttrd)" 
     End  
End

-------------------------------------  End Of Decide Group By Options  ----------------------------------------------------

Set @@WhereText =  " Where S.Sauda_date   Between '" + @Sauda_date  + " 00:00:00'  And '"   + @Todate  + " 00:00:00' And S.Scrip_cd Between '"  + @Fromscrip + "' And  '"+  @Toscrip +"' And S.Sett_no Between '" + @Sett_no + "' And '" + @Tosett_no +"' And "  
---------------------------  Now We Will Decide about Join  We will always provide from Party and ToParty -------------------------------------------
--Print "Sett No : " + @Sett_no

Set @@WhereText =  @@WhereText + "  S.Party_code Between '" + @@FromParty_code  + "' And '" + @@ToParty_code   +"'  "  

If @Consol = "FAMILY" 
Set @@WhereText =  @@WhereText +   "  And Family Between '" + @@FromFamily  + "' And '" + @@ToFamily   +"'  " 

If @Consol = "Trader"
Set @@WhereText =  @@WhereText + " And  Trader Between '" + @@FromTrader  + "' And '" + @@ToTrader   +"' " 

If @Consol = "Branch_cd" 
Set @@WhereText =  @@WhereText + " And Branch_cd Between '" + @@FromBranch_cd  + "' And '" + @@ToBranch_cd   +"' " 

If @Consol = "Sub_Broker" 
Set @@WhereText =  @@WhereText + " And Sub_Broker Between '" + @@FromSub_Broker  + "' And '" + @@ToSub_Broker   +"' " 

If @Consol = "REGION" 
Set @@WhereText =  @@WhereText + " And Region Between '" + @@FromRegion  + "' And '" + @@ToRegion  +"' " 

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

---------------------------   Decided about join  -------------------------------------------
Set @@WhereText = @@WhereText + " And  S.Sett_type Between '" + @@Fromsett_type + "'  And '" +  @@Tosett_type  + "'"  

If @Detail = "BR"
   Set @@WhereText = @@WhereText + " And  Tradetype not in ( 'SCF','ICF','IR' )  "  

If @Detail = "S"
Begin
   If @GroupF <> "0"
   Begin
	   Set @@WhereText = @@WhereText + " And  Tradetype not in ( 'IR' )  "  
   End
End

If @Detail = "PO"
   Set @@WhereText = @@WhereText + " And  Tradetype not in ( 'SBF','SCF','IR' )"  

If @Detail = "TU"
   Set @@WhereText = @@WhereText + " And  Tradetype not in ( 'SBF','SCF','IBF','ICF','IR' )"  


/*NULL CHK FOR WHERE*/
If @@WhereText is NULL OR Len(LTrim(rTrim(@@WhereText))) = 0
Begin
	Set @@WhereText = " WHERE 1=0"
End

/*
Print '********************************************'

Print  @Sett_no
Print  @Tosett_No
Print  @Sett_type
Print  @Sauda_date
Print  @ToDate
Print  @FromScrip
Print  @ToScrip
Print  @From
Print  @To
Print  @Consol
Print  @Detail
Print  @Level
Print  @GroupF
Print  @OrderF
Print  @Use1
Print  @statusid
Print  @statusname

Print '********************************************'

Set Quoted_Identifier OFF
*/
Print @@SelectFlex 
Print @@SelectBody 
Print @@FromTable 
Print @@WhereText 
Print @@MyGroup



If @Detail = "BR"
print @@SelectFlex + @@SelectBody+ @@FromTable + @@WhereText + @@MyGroup +  @@MyOrder    
If @Detail = "S"
Print @@SelectFlex + @@SelectBody+ @@FromTable + @@WhereText + @@MyGroup + @@MyOrder

GO
