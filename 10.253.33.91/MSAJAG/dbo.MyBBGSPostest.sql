-- Object: PROCEDURE dbo.MyBBGSPostest
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Procedure MyBBGSPostest ( 
@Sett_no Varchar(10), 		 ---1  Settlement No(from)
@Tosett_No Varchar(10),		 ---2  Settlement no (to)
@Sett_type Varchar(3),		 ---3  Settlement type 
@Sauda_date Varchar(11),	 ---4 Sauda_date (from)
@ToDate Varchar(11),		 ---5 Sauda_date (to)
@FromScrip Varchar(10),		 ---6 From scrip_cd (from)
@ToScrip Varchar(10),		 ---7 To Scrip_cd (to)
@From Varchar(20), 		 ---8  From Consol
@To Varchar (20), 		 ---9  To Consol
@Consol Varchar(10),		 ---10  Consol indicates that whether is 'Party_code','Trader','Sub Broker','Branch'
@Detail Varchar(3),		 ---11  This is other details in Query 'B' = 'Bill','C' = 'Confirmation','P' = 'Position','Br' = 'Brokerage','S' = 'Sauda summary'
@Level  SmallInt,                                  --- 12 Will be used to Select  Level of Consolidation Default 0
@GroupF Varchar(500),		 ---13 (any necessary Grouping) This can be defined on the fly by developer
@OrderF Varchar(500),		 ---14 (any necessary Order by) This can de defined on the fly by developer 
@Use1 Varchar(10) )                           --- 15 To be used later  for other purposes
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
@@Dummy3 As Varchar(1000),
@@FromTable As Varchar(1000),    --------------------   This string will enable us to code conditions Like From settlement
@@SelectFlex As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectFlex1 As Varchar (2000),   ---------------------  This String will enable us to code Flexible Select Conditions 
@@SelectBody As Varchar(8000),  ---------------------   This is regular Select Body
@@SelectBody1 As Varchar(8000),  ---------------------   This is regular Select Body
@@WhereText As Varchar(2000),  ---------------------  This will be used for Coding Where condition  
@@FromTable1 As Varchar(1000), ---------------------   This is Another String that can be used for  
@@Wherecond1 As Varchar(2000)

/* To reduce the number of queries we have joined maximum number of parameters with ranges*/
/* Hence we are extracting ranges if the partmeter passed is %  or ''   */
/* If the parameter is passed then we make that same parameter as from <-----> To  */

Set @@Part1 = ' '
Set @@Part2 = ' '
Set @@Part3 = ' '
Set @@Part4 = ' '
Set @@Part5 = ' '
Set @@Part6 = ' '


/* Here I will define rules for various  */
-----------------------------------------------------------------------------------------
If (@Consol = 'PARTY_CODE') And  ((@From <> '') And (@To = '' ) ) 
Begin
          Select @@FromParty_code = @From
          Select @@ToParty_code = @From 
End

If (@Consol = 'PARTY_CODE') And  ((@From <> '') And (@To <> '' ) ) 
Begin
          Select @@FromParty_code = @From
          Select @@ToParty_code = @To 
End

If (@Consol = 'FAMILY') And  ((@From <> '') And (@To <> '' ) ) 
Begin
          Select @@FromFamily = @From
          Select @@ToFamily = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code and Client1.Family between @@FromFamily  And @@ToFamily
End

If (@Consol = 'Branch_cd') And  ((@From <> '') And (@To <> '' ) ) 
Begin
          Select @@FromBranch_cd = @From
          Select @@ToBranch_cd = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Branch_cd  Between @@FromBranch_cd  And @@ToBranch_cd
End

If (@Consol = 'Trader') And  ((@From <> '') And (@To <> '' ) ) 
Begin
          Select @@FromTrader = @From
          Select @@ToTrader = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Trader Between @@FromTrader  And @@ToTrader
End

If (@Consol = 'Sub_Broker') And  ((@From <> '') And (@To <> '' ) ) 
Begin
          Select @@FromSub_Broker = @From
          Select @@ToSub_broker = @To 
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1 Where Client2.Cl_code = Client1.Cl_code and Client1.Sub_Broker Between @@FromSub_Broker  And @@ToSub_Broker
End


If ( @Consol = 'PARTY_CODE' ) And ( ( @From = '' ) And ( @To = '' ) ) 
Begin
     Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details 
End
-----------------------------------------------------------------------------------------
If @Sett_type  <>  '%' 
Begin
     Select @@FromSett_type = @Sett_type
     Select @@ToSett_type = @Sett_type
End


If @Sett_type  =  '%' 
Begin
      Select @@FromSett_type = Min(Sett_type), @@ToSett_type = Max(Sett_type) From Details
End
-----------------------------------------------------------------------------------------
If  ( (@FromScrip = '') And  (@ToScrip = '') )
   Select @FromScrip = Min(BseCode) ,@ToScrip = Max(BseCode) From Scrip2

If (@FromScrip = '')
   Select @FromScrip = Min(BseCode) From Scrip2

If (@ToScrip = '')
   Select @ToScrip = Max(BseCode) From Scrip2
-----------------------------------------------------------------------------------------
If @Tosett_no = '' 
   Set @Tosett_no = @Sett_no

Select @Sauda_date = Ltrim(Rtrim(@Sauda_date))
If Len(@Sauda_date) = 10 
Begin
          Set @Sauda_date = STUFF(@Sauda_date, 4, 1,'  ')
End

Select @Todate = Ltrim(Rtrim(@Todate))

If Len(@Todate) = 10 
Begin
          Set @Todate = STUFF(@Todate, 4, 1,'  ')
End
--------------------------------------------------- Find SaudaDate From To From Settlement Range  -------------------------------------------------------------------------------------------------------
If ( @Todate  = '' ) 
Begin
        Select @Todate = End_date from sett_mst where Sett_type = @Sett_type and Sett_no = @ToSett_no 
End

If ( @Sauda_date  = '' ) 
Begin
        Select @Sauda_date = Start_date from sett_mst where Sett_type = @Sett_type and Sett_no = @Sett_no 
End
----------------------------------------------------Find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------
If ( (@Sett_no = '' ) And ( Len(@Sauda_date) > 1)) 
Begin
         Select @sett_no = Min(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type And @@Tosett_type  and Start_Date < @Sauda_date + ' 00:01'  and End_date >= @Sauda_date + ' 23:58:59'   
         If @Todate = '' 
        Set @Tosett_no = @Sett_no
End

If ( (@ToSett_no = '' ) And ( Len(@Todate) > 1)) 
Begin
        Select @Tosett_no = Max(Sett_no) from sett_mst where Sett_type Between  @@FromSett_type  and @@ToSett_type and Start_Date < @Todate + ' 00:01' and End_date >= @Todate  + ' 23:58:59' 
End
-----------------------------------------------------------------------------------------
If @Detail = 'B' 
   Set @@MyReport = 'Bill'
 
If @Detail = 'C' 
   Set @@MyReport = 'Confirmation'

If @Detail = 'P' 
   Set @@MyReport = 'Position'

If @Detail = 'BR' 
   Set @@MyReport = 'Brokerage'

If @Detail = 'S' 
   Set @@MyReport = 'SaudaSummary'

------------------------------------- We Will Select From  Various Order By Options -------------------------------------- 

If @Consol = 'PARTY_CODE'
Begin
          Set @@FromTable = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
          Set @@FromTable1 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
End
If @Consol = 'BRANCH_CD'
Begin
          Set @@FromTable = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
          Set @@FromTable1 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
End
If @Consol = 'FAMILY'
Begin
          Set @@FromTable = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
          Set @@FromTable1 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
End
If @Consol = 'TRADER'
Begin
          Set @@FromTable = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
          Set @@FromTable1 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
End
If @Consol = 'SUB_BROKER'
Begin
          Set @@FromTable = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
          Set @@FromTable1 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
End


If @OrderF = '0'       ------------------------------ To be used For Contract / Bill Printing  ------------------------
   Set @@MyOrder = ' Order by ContractNo, S.party_code,S.Scrip_cd Asc ,S.Series,Sell_buy, Order_No Asc ,Trade_no Asc, Tmark,S.Sauda_date   Option (Fast 10 )  '

If @OrderF = '1'  ------------------------ To be used for Gross position Across Range ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order   by S.party_code  Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order  by c1.Branch_cd  Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order  by c1.Trader Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order  by c1.Sub_Broker Option (Fast 1 ) '
End

If @OrderF = '2'    ------------------------ To be used for Net position Across Range ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order  by S.party_code , S.Sell_buy  Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order  by c1.Branch_cd, S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family, S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order by c1.Trader , S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order  by c1.Sub_Broker, S.Sell_buy  Option (Fast 1 )'
End

If @OrderF = '3'   ------------------------ To be used for Net position Across Settlement  ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order  by S.party_code , S.Sett_no,S.Sett_type, S.Sell_buy   Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder  = ' Order  by c1.Branch_cd ,S.Sett_no,S.Sett_type , S.Sell_buy  Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder  = ' Order  by c1.Family  ,S.Sett_no,S.Sett_type , S.Sell_buy  Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder  = ' Order  by c1.Trader  , S.Sett_no,S.Sett_type , S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order by c1.Sub_Broker  , S.Sett_no,S.Sett_type , S.Sell_buy Option (Fast 1 )'
End

If @OrderF = '4'   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order by S.party_code , S.Scrip_cd, S.Sett_no,S.Sett_type ,S.Series , S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order by c1.Branch_cd  , S.Scrip_cd,S.Sett_no,S.Sett_type , S.Series , S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family , S.Scrip_cd,S.Sett_no,S.Sett_type , S.Series , S.Sell_buy  Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order  by c1.Trader  , S.Scrip_cd, S.Sett_no,S.Sett_type , S.Series , S.Sell_buy Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order  by c1.Sub_Broker  , S.Scrip_cd, S.Sett_no,S.Sett_type ,S.Series, S.Sell_buy  Option (Fast 1 )'
End

If @OrderF = '5'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order by S.party_code  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series  , S.Sell_buy, Tmark Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order  by c1.Branch_cd  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy,Tmark Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,Tmark Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order  by c1.Trader  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S.Sell_buy, Tmark Option (Fast 1 )'
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order by c1.Sub_Broker , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,Tmark Option (Fast 1 ) '
End


If @OrderF = '6'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Sauda_date,Tmark  ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order by S.party_code  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series  , S.Sell_buy, S.Sauda_date,Tmark Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order  by c1.Branch_cd  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy,S.Sauda_date,Tmark Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,S.Sauda_date,Tmark Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order  by c1.Trader  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S.Sell_buy,S.Sauda_date, Tmark Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order by c1.Sub_Broker , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,S.Sauda_date,Tmark Option (Fast 1 ) '
End

If @OrderF = '7'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Sauda_date,Order_no,Tmark  ----------------------
Begin
          If @Consol = 'Party_code'
             Set  @@MyOrder = ' Order by S.party_code  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series  , S.Sell_buy, S.Sauda_date,S.Order_no,Tmark Option (Fast 1 ) '
          If @Consol = 'Branch_Cd'
             Set  @@MyOrder = ' Order  by c1.Branch_cd  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy,S.Sauda_date,S.Order_no,Tmark Option (Fast 1 ) '
          If @Consol = 'Family'
             Set  @@MyOrder = ' Order  by c1.Family  ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,S.Sauda_date,S.Order_no,Tmark Option (Fast 1 ) '
          If @Consol = 'Trader'
             Set  @@MyOrder = ' Order  by c1.Trader  , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S.Sell_buy,S.Sauda_date, S.Order_no,Tmark Option (Fast 1 ) '
          If @Consol = 'Sub_broker'
             Set  @@MyOrder = ' Order by c1.Sub_Broker , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , S.Sell_buy ,S.Sauda_date,S.Order_no,Tmark Option (Fast 1 ) '
End


-------------------------------------  End Of Select  Order By Options  ----------------------------------------------------

------------------------------------- We Will Decide Various Group By Options -------------------------------------- 

If @GroupF = '0'    ----------------------  To be Used for Contract or Bills ----------------------
Begin
          If @Consol = 'Party_code' 
          Set  @@MyGroup =  ' Group by S.party_code , S.Sell_buy , S.Sett_no  ,S.Sett_type  , S.Scrip_cd  , S.Series,S.Tmark,S.Sauda_date  , ContractNo,Billno,ParticipantCode,Trade_no,Order_no '
End

If @GroupF = '1'  ------------------------ To be used for Gross position Across Range ----------------------
Begin
          If @Consol = 'Party_code'
          Begin
                    Set  @@MyGroup = ' Group by S.Party_code, Dispcharge  '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0000,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0000,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
         End
         If @Consol = 'Branch_Cd'
         Begin 
                   Set  @@MyGroup = ' Group by c1.Branch_cd , Dispcharge'
                   Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = C1.Branch_Cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                   Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = C1.Branch_Cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
         End
         If @Consol = 'Family'
         Begin 
                   Set  @@MyGroup = ' Group by c1.Family, Dispcharge '
                   Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = C1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                   Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = C1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
         End 
         If @Consol = 'Trader'
         Begin 
                   Set  @@MyGroup = ' Group by c1.Trader, Dispcharge '
                   Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = C1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                   Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = C1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
         End       
          If @Consol = 'Sub_broker'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Sub_Broker, Dispcharge '                    
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = C1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = C1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = 0,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
End

If @GroupF = '2'    ------------------------ To be used for Net position Across Range ----------------------
Begin
          If @Consol = 'Party_code'
          Begin
                    Set  @@MyGroup = ' Group by S.party_code , C1.Long_Name ,S.Sell_buy , Dispcharge '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  C1.Long_Name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  C1.Long_Name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End  
           If @Consol = 'Branch_Cd'
           Begin 
                      Set  @@MyGroup = ' Group by c1.Branch_cd, S.Sell_buy , Dispcharge '
                      Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                      Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End 
           If @Consol = 'Family'
           Begin 
                     Set  @@MyGroup = ' Group by c1.Family, C1.Long_name,S.Sell_buy  , Dispcharge '
                     Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family =c1.Family, Trader = 0000 ,Party_code = 0000,Long_name = C1.Long_name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family =c1.Family, Trader = 0000 ,Party_code = 0000,Long_name = C1.Long_name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
            End
            If @Consol = 'Trader'
            Begin 
                      Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , Dispcharge '
                      Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                      Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
             End 
             If @Consol = 'Sub_broker'
             Begin 
                        Set  @@MyGroup = ' Group by c1.Sub_Broker, S.Sell_buy , Dispcharge '
                        Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                        Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
              End               
End


If @GroupF = '3'   ------------------------ To be used for Net position Across Settlement  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type, Dispcharge '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type , Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type , Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Branch_Cd'
          Begin 
                     Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , Dispcharge '
                     Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_Cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0, Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_Cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0, Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End  
          If @Consol = 'Family'
          Begin 
                     Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type, Dispcharge '
                     Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End                   
          If @Consol = 'Trader'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type, Dispcharge '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Sub_broker'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type, Dispcharge '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
End

If @GroupF = '4'   ------------------------ To be used for Net position Across Settlement,Scrip,Series  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,S1.Long_name, Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = s.party_code,Long_name =  0 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0, Series = 0, ScripName = 0,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Branch_Cd'
          Begin
                     Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S1.Long_name,Dispcharge '
                     Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Family'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S1.Long_name,Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1=  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Trader'
          Begin
                     Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,S1.Long_name, Dispcharge '
                     Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Sub_broker'
          Begin
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, S1.Long_name, Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
End

If @GroupF = '5'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , Tmark, S1.Long_name, Dispcharge,B.trd_del '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
          End  
          If @Consol = 'Branch_Cd'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark , S1.Long_name,Dispcharge,B.trd_del'
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
          End 
          If @Consol = 'Family'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark,S1.Long_name, Dispcharge,B.trd_del '
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
          End
          If @Consol = 'Trader'
          Begin
                    Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark ,S1.Long_name,B.trd_del, Dispcharge'
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
          End 
          If @Consol = 'Sub_broker'
          Begin
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark, S1.Long_name,B.trd_del,Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = 0, ' 
          End
End

If @GroupF = '6'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series , Tmark, S1.Long_name, Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End  
          If @Consol = 'Branch_Cd'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark , S1.Long_name,Dispcharge'
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Family'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark,S1.Long_name, Dispcharge '
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Trader'
          Begin
                    Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark ,S1.Long_name, Dispcharge'
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Sub_broker'
          Begin
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series, Tmark, S1.Long_name,Dispcharge '
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
End

If @GroupF = '7'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark,Sauda_Date  Terminal  Bill Wise  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date ,S1.Long_name, S.BillNo,Dispcharge'
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End
           If @Consol = 'Branch_Cd'
           Begin 
                     Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date, S1.Long_name,S.BillNo,Dispcharge '
                     Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                     Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End
          If @Consol = 'Family'
          Begin
                    Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date,S1.Long_name, S.BillNo,Dispcharge '
                    Set @@SelectFlex  =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family , Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family , Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Trader'
          Begin
                    Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date,S1.Long_name,S.BillNo,Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0000 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Sub_broker'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date ,S1.Long_name, S.BillNo,Dispcharge '
                    Set  @@SelectFlex  =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0000,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = 0,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0000,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End  
End


If @GroupF = '8'  ------------------------ To be used for Net position Across Settlement,Scrip,Series,Tmark,Sauda_Date,ContractNo, BillNo , Order_no  ----------------------
Begin
          If @Consol = 'Party_code'
          Begin 
                    Set  @@MyGroup = ' Group by S.party_code , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date,Order_no,S1.Long_name,S.BillNo,S.Contractno,User_ID,Dispcharge  '
                    Set  @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.Billno, Sauda_date = S.Sauda_date, Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = S.ContractNo,Bill_no = S.Billno, Sauda_date = S.Sauda_date, Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Branch_Cd'
          Begin
                    Set  @@MyGroup = ' Group by c1.Branch_cd , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date,Order_no,S1.Long_name,S.BillNo,S.Contractno, User_ID,Dispcharge  '
                    Set  @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End 
          If @Consol = 'Family'
          Begin  
                    Set  @@MyGroup = ' Group by c1.Family , S.Sell_buy ,S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date ,Order_no, S1.Long_name,S.BillNo,S.Contractno,User_ID,Dispcharge '
                    Set  @@SelectFlex  =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1  =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = c1.Family, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
           End
          If @Consol = 'Trader'
          Begin  
                    Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date ,Order_no,S1.Long_name,S.BillNo,S.Contractno,User_ID, Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex1 =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
          If @Consol = 'Sub_broker'
          Begin 
                    Set  @@MyGroup = ' Group by c1.Sub_Broker , S.Sell_buy , S.Sett_no,S.Sett_type , S.Scrip_cd,S.Series,Tmark,S.Sauda_date ,Order_no,S1.Long_name,S.BillNo,S.Contractno,User_ID, Dispcharge '
                    Set  @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = C1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
                    Set  @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = 0000, Order_no = S.Order_no,Branch_cd = 0000 , SubBroker = C1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = Tmark ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = 0, ' 
          End
End

If @GroupF = '2.5'    ------------------------ To be used for Net position Across Range ----------------------
Begin
          If @Consol = 'Party_code'
          Begin
                    Set  @@MyGroup = ' Group by S.party_code , C1.Long_Name ,S.Sell_buy ,Cl_type, Dispcharge '
                    Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  C1.Long_Name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
                    Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = S.Party_code,Long_name =  C1.Long_Name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
           End  
           If @Consol = 'Branch_Cd'
           Begin 
                      Set  @@MyGroup = ' Group by c1.Branch_cd, S.Sell_buy , Cl_type,Dispcharge '
                      Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
                      Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = c1.Branch_cd , SubBroker = 0000 ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
           End 
           If @Consol = 'Family'
           Begin 
                     Set  @@MyGroup = ' Group by c1.Family, C1.Long_name,S.Sell_buy  , Cl_type,Dispcharge '
                     Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family =c1.Family, Trader = 0000 ,Party_code = 0000,Long_name = C1.Long_name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
                     Set @@SelectFlex1 =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" ,Sett_no = 0000,Sett_type = 0000,Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family =c1.Family, Trader = 0000 ,Party_code = 0000,Long_name = C1.Long_name , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
            End
            If @Consol = 'Trader'
            Begin 
                      Set  @@MyGroup = ' Group by c1.Trader , S.Sell_buy , Cl_type, Dispcharge '
                      Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
                      Set  @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = 0000 ,Family = 0000, Trader = c1.Trader ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
             End 
             If @Consol = 'Sub_broker'
             Begin 
                        Set  @@MyGroup = ' Group by c1.Sub_Broker, S.Sell_buy , Cl_type, Dispcharge '
                        Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'S' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
                        Set @@SelectFlex =  ' Select Contractno = 0,Bill_no = 0, Sauda_date = "' + 'JAN  1 1980' + '" , Sett_no = 0000,Sett_type = 0000, Trade_no = 0000, Order_no = 0000,Branch_cd = 0000 , SubBroker = c1.Sub_Broker ,Family = 0000, Trader = 0000 ,Party_code = 0000,Long_name =  0000 , Scrip_cd = 0000, Series = 0000, ScripName = 0000,Sell_buy = Sell_buy,SettFlag = 0 ,BillFlag = 0 , Tmark = 0 ,Participantcode = 0 , SorIS = "' + 'IS' + '", TerminalId = 0 ,NorNd = "' +  'N' + '"  , F_S = 0,  Client_type = C1.Cl_type, ' 
              End               
End

-------------------------------------  End Of Decide Group By Options  ----------------------------------------------------

If @Detail = 'C'  
Set @@SelectFlex =  ' Select Contractno = S.ContractNo,Bill_no = S.BillNo, Sauda_date = S.Sauda_date, Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = S.Trade_no, Order_no = S.Order_no,Branch_cd = C1.Branch_cd , SubBroker = C1.Sub_Broker ,Family = C1.Family, Trader = C1.Trader ,Party_code = S.party_code,Long_name =  C1.Long_name ,SettFlag = Settflag,BillFlag = Billflag,Tmark = Tmark ,participantcode = PartiCipantCode,SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = C1.Cl_type  ' 

If @Detail = 'B'  
Set @@SelectFlex =  ' Select Contractno = 0000,Bill_no = S.BillNo, Sauda_date = S.Sauda_date,Sett_no = S.Sett_no,Sett_type = S.Sett_type ,Trade_no = S.Trade_no,Order_no = S.Order_no,Branch_cd = C1.Branch_cd , SubBroker = C1.Sub_Broker ,Family = C1.Family, Trader = C1.Trader ,Party_code = S.party_code, Long_name =  C1.Long_name ,   SettFlag = Settflag,BillFlag = Billflag,Tmark = Tmark ,participantcode = PartiCipantCode,SorIS = "' + 'S' + '", TerminalId = User_id ,NorNd = "' +  'N' + '"  , F_S = B.trd_del,  Client_type = C1.Cl_type ' 

If (( @Detail = 'C' ) Or (@Detail = 'B'))
Begin
           Set @@SelectBody = ' , Scrip_cd = S.Scrip_cd, Series = S.Series, ScripName = S1.Long_name,Sell_buy = Sell_buy,Marketrate = Marketrate ,SumTradeqty = Tradeqty , 
Netrate = isnull((Case When Sell_Buy = 1 then   
 ( Case When  Service_chrg = 2 Then  
    N_NetRate   
 Else    
    N_NetRate + ( NserTax/Tradeqty)   
 End ) + ( CASE When Dispcharge = 1 Then  
   ( CASE When Turnover_tax = 1 Then  
           Turn_tax    
     Else 0 End )    
    Else 0 End )  
         + (Case When Dispcharge = 1 Then  
   ( Case When Sebi_Turn_tax = 1 Then  
    Sebi_Tax   
    Else 0 end )    
    Else 0 end )  
         + ( Case When Dispcharge = 1 Then  
   ( Case When Insurance_Chrg = 1 Then  
     Ins_chrg    
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Brokernote = 1 Then  
    Broker_chrg   
     Else 0 end )    
    Else 0 end )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When c2.Other_chrg = 1 Then  
     S.Other_chrg   
     Else 0 End )    
    Else 0 End ) Else  
  (Case When Sell_buy = 2 Then   
 ( Case When  Service_chrg = 2 Then  
        N_NetRate    
 Else    
        N_NetRate  - ( NserTax / Tradeqty)   
 End ) - ( Case When Dispcharge = 1 Then  
   ( Case When Turnover_tax = 1 Then  
    (Turn_tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Sebi_Turn_tax = 1 Then  
    (Sebi_Tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Insurance_Chrg = 1 Then  
    (Ins_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Brokernote = 1 Then  
    (Broker_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When C2.Other_Chrg = 1 Then  
    (S.Other_Chrg)   
     Else 0 End )    
    Else 0 End )  
End)
End),0)  ,  Brokapplied = (Brokapplied  * Tradeqty ), DeliveryCharges =  (NBrokapp * Tradeqty ) - (Brokapplied * Tradeqty )  ,  
TradeAmount = (Tradeqty * N_Netrate),
Amount =   Isnull(( Case When Sell_buy = 1 Then   
 ( Case When  Service_Chrg = 2 Then  
   Tradeqty * N_NetRate   
 Else    
   ( Tradeqty *  N_NetRate) + NserTax   
 End ) + ( Case When Dispcharge = 1 Then  
   ( Case When Turnover_tax = 1 Then  
           Turn_tax    
     Else 0 End )    
    Else 0 End )  
         + (Case When Dispcharge = 1 Then  
   ( Case When Sebi_Turn_tax = 1 Then  
    Sebi_Tax   
     Else 0 End )    
    Else 0 End )  
         + ( Case When Dispcharge = 1 Then  
   ( Case When Insurance_Chrg = 1 Then  
     Ins_Chrg    
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Brokernote = 1 Then  
    Broker_chrg   
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When C2.Other_chrg = 1 Then
     S.Other_Chrg   
     Else 0 End )    
    Else 0 End ) Else   
  (Case When Sell_buy = 2 Then   
 ( Case When  Service_chrg = 2 Then  
        Tradeqty *  N_NetRate    
 Else    
        ( Tradeqty *  N_NetRate) - NserTax   
 End ) - ( Case When Dispcharge = 1 Then  
   ( Case When Turnover_tax = 1 Then  
    (Turn_tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Sebi_Turn_tax = 1 Then  
    (Sebi_Tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Insurance_Chrg = 1 Then  
    (Ins_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Brokernote = 1 Then  
    (Broker_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When C2.Other_chrg = 1 Then  
    (S.Other_chrg)   
     Else 0 End )    
    Else 0 End )  
End)
End),0),  Service_tax = (Case When Service_Chrg = 2 Then 0 Else Nsertax  End), Ins_chrg = (Case WHEN Dispcharge = 1 
		 Then (Case When Insurance_Chrg = 1 
			    THEN (Ins_chrg)   
     			    Else 0 
		       End)    
		 Else 0 
	    End), Turn_tax = (Case When Dispcharge = 1 
		 Then (Case When Turnover_tax = 1 
		            Then (Turn_tax)   
	   	            Else 0 
		       End)    
	         Else 0 
	    End ),  Other_chrg = (Case When Dispcharge = 1 
		   Then (Case When C2.Other_chrg = 1 
		              Then (S.Other_Chrg)   
		              Else 0 
		         End)    
		   Else 0 
	      End),  Sebi_tax = (Case When Dispcharge = 1 
		 Then (Case When Sebi_Turn_tax = 1 
		            Then (Sebi_Tax)   
			    Else 0 
		       End)    
		 Else 0 
	    End),Broker_Chrg = (Case When Dispcharge = 1 
		    Then (Case When Brokernote = 1 
			       Then (Broker_Chrg)   
		               Else 0 
		          End)    
		    Else 0 
	       End) ' 
End
Set @@Part2 = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '
Set @@WhereText =  '  Where C2.Party_code = S.Party_code And C1.Cl_code = C2.Cl_code  And S2.BseCode = S.Scrip_cd And S2.Co_code = S1.Co_code And S.table_no = b.table_no and S.line_no = b.line_no ' 
Set @@WhereText = @@WhereText + ' And S.Sauda_date   Between "' + @Sauda_date  + ' 00:01"  And "'   + @Todate  + ' 23:58:59" And S.Scrip_cd Between "'  + @Fromscrip + '" And  "'+  @Toscrip +'" And S.Sett_no Between "' + @Sett_no + '" And "' + @Tosett_no +'" And  '  

---------------------------  Now We Will Decide about join  We will always provide from Party and ToParty -------------------------------------------

Set @@WhereText =  @@WhereText + '  S.Party_code Between "' + @@FromParty_code  + '" And "' + @@ToParty_code   +'"  ' 

If @Consol = 'FAMILY'
Set @@WhereText =  @@WhereText +   '  And  C1.Family Between "' + @@FromFamily  + '" And "' + @@ToFamily   +'"  ' 

If @Consol = 'Trader'
Set @@WhereText =  @@WhereText + ' And  C1.Trader Between "' + @@FromTrader  + '" And "' + @@ToTrader   +'" ' 

If @Consol = 'Branch_cd'
Set @@WhereText =  @@WhereText + ' And C1.Branch_cd Between "' + @@FromBranch_cd  + '" And "' + @@ToBranch_cd   +'" ' 

If @Consol = 'Sub_Broker'
Set @@WhereText =  @@WhereText + ' And C1.Sub_Broker Between "' + @@FromSub_Broker  + '" And "' + @@ToSub_Broker   +'" ' 

---------------------------   Decided about join  -------------------------------------------

Set @@WhereText = @@WhereText + ' And  S.Sett_type Between "' + @@Fromsett_type + '"  And "' +  @@Tosett_type  + '" And Tradeqty > 0'   

If @Detail = 'C'
Set @@WhereText = @@WhereText + ' And Trade_no not Like "' + '%C%' + '"'

If @Detail = 'B'
Set @@WhereText = @@WhereText + ' And Trade_no not Like "' + '%C%' + '"'


Set @@Dummy1 =  ' UNION ALL ' 
Set @@Dummy2 = ' From ISettlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  '

If @Detail = 'C'
Exec (@@SelectFlex + @@SelectBody +  @@Part2 + @@WhereText  + @@Dummy1   + @@SelectFlex + @@SelectBody  + @@Dummy2  + @@WhereText  +@@MyOrder )  

----------------------------------------------------------- We Will Create Bills Reverse Leg for ND trades----------------------------------------------------------------

If @Detail = 'B'
Begin
           Set @@Part5 = ' From Settlement  S ,  Client2 C2 , Client1 C1,Scrip2 S2, Scrip1 S1,Broktable B,Owner  , Nodel N , Havala H ' 
           Set @@Part6 = ' And S.Scrip_cd  In (Select Scrip_Cd From Nodel Where S.Sett_no = Nodel.Sett_no )  And H.Sett_no = S.Sett_no and H.Scrip_cd = S.Scrip_cd  '
End

If @Detail = 'B'
Exec (@@SelectFlex + @@SelectBody +  @@Part2 + @@WhereText )  

If @Detail = 'Br'
Begin
Set @@SelectBody = ' Marketrate = IsNull(Avg(Marketrate),0) ,SumTradeqty = IsNull( Sum(Tradeqty) ,0)  , 
Brokapplied = Isnull( Sum(Brokapplied  * Tradeqty ),0), DeliveryCharges =  Isnull(Sum((NBrokapp * Tradeqty ) - (Brokapplied * Tradeqty )),0)  , 
Netrate = isnull((Case When Sell_Buy = 1 then   
 ( Case When  Min(Service_chrg) = 2 Then  
    Sum(N_NetRate * Tradeqty) / Sum(Tradeqty)   
 Else    
     Avg ( N_NetRate)  +  Avg ( NserTax)   
 End ) + ( CASE When Dispcharge = 1 Then  
   ( CASE When Min(Turnover_tax) = 1 Then  
           Sum(Turn_tax)    
     Else 0 End )    
    Else 0 End )  
         + (Case When Dispcharge = 1 Then  
   ( Case When Min(Sebi_Turn_tax) = 1 Then  
    Sum(Sebi_Tax)   
    Else 0 end )    
    Else 0 end )  
         + ( Case When Dispcharge = 1 Then  
   ( Case When Min(Insurance_Chrg) = 1 Then  
     Sum(Ins_chrg)    
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Min(Brokernote) = 1 Then  
    Sum(Broker_chrg)   
     Else 0 end )    
    Else 0 end )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Min(c2.Other_chrg) = 1 Then  
     Sum(S.Other_chrg)   
     Else 0 End )    
    Else 0 End ) Else  
  (Case When Sell_buy = 2 Then   
 ( Case When  Min(Service_chrg) = 2 Then  
        Sum(N_NetRate * Tradeqty) / Sum(Tradeqty)    
 Else    
        ( Sum(N_NetRate ) / Sum(Tradeqty) )  -  ( Sum(NserTax )  /Sum(Tradeqty) )
 End ) - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Turnover_tax) = 1 Then  
    Sum(Turn_tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Sebi_Turn_tax) = 1 Then  
    Sum(Sebi_Tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Insurance_Chrg) = 1 Then  
    Sum(Ins_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Brokernote) = 1 Then  
    Sum(Broker_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Min(C2.Other_Chrg) = 1 Then  
    Sum(S.Other_Chrg)   
     Else 0 End )    
    Else 0 End )  
End)
End),0)  ,    
TradeAmount = Sum(Tradeqty * N_Netrate),
Amount =   Isnull(( Case When Sell_buy = 1 Then   
 ( Case When  Min(Service_Chrg) = 2 Then  
   Sum(Tradeqty  *  N_NetRate)   
 Else    
    Sum(Tradeqty * N_NetRate ) + Sum ( NserTax)
 End ) + ( Case When Dispcharge = 1 Then  
   ( Case When Min(Turnover_tax) = 1 Then  
           Sum(Turn_tax)    
     Else 0 End )    
    Else 0 End )  
         + (Case When Dispcharge = 1 Then  
   ( Case When Min(Sebi_Turn_tax) = 1 Then  
    Sum(Sebi_Tax)   
     Else 0 End )    
    Else 0 End )  
         + ( Case When Dispcharge = 1 Then  
   ( Case When Min(Insurance_Chrg) = 1 Then  
     Sum(Ins_Chrg)    
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Min(Brokernote) = 1 Then  
    Sum(Broker_chrg)   
     Else 0 End )    
    Else 0 End )  
  + ( Case When Dispcharge = 1 Then  
   ( Case When Min(C2.Other_chrg) = 1 Then
     Sum(S.Other_Chrg)   
     Else 0 End )    
    Else 0 End ) Else   
  (Case When Sell_buy = 2 Then   
 ( Case When  Min(Service_chrg) = 2 Then  
        Sum(Tradeqty * N_NetRate)    
 Else    
        ( Sum(Tradeqty  * N_NetRate) ) - Sum(NserTax)    
 End ) - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Turnover_tax) = 1 Then  
    Sum(Turn_tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Sebi_Turn_tax) = 1 Then  
    Sum(Sebi_Tax)   
     Else 0 End )    
    Else 0 End )  
         - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Insurance_Chrg) = 1 Then  
    Sum(Ins_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Min(Brokernote) = 1 Then  
    Sum(Broker_chrg)   
     Else 0 End )    
    Else 0 End )  
  - ( Case When Dispcharge = 1 Then  
   ( Case When Min(C2.Other_chrg) = 1 Then  
    Sum(S.Other_chrg)   
     Else 0 End )    
    Else 0 End )  
End)
End),0),  Service_tax = (Case When Min(Service_Chrg) = 2 Then 0 Else Isnull(Sum(Nsertax),0)  End), Ins_chrg = 
(Case WHEN Dispcharge = 1 
		 Then (Case When Min(Insurance_Chrg) = 1 
			    THEN IsNull(Sum(Ins_chrg),0)   
     			    Else 0 
		       End)    
		 Else 0 
	    End), Turn_tax = (Case When Dispcharge = 1 
		 Then (Case When Min(Turnover_tax) = 1 
		            Then Isnull(Sum(Turn_tax),0)   
	   	            Else 0 
		       End)    
	         Else 0 
	    End ),  Other_chrg = (Case When Dispcharge = 1 
		   Then (Case When Min(C2.Other_chrg) = 1 
		              Then Isnull(Sum(S.Other_Chrg),0)   
		              Else 0 
		         End)    
		   Else 0 
	      End),  Sebi_tax = (Case When Dispcharge = 1 
		 Then (Case When Min(Sebi_Turn_tax) = 1 
		            Then Isnull(Sum(Sebi_Tax) , 0)   
			    Else 0 
		       End)    
		 Else 0 
	    End),Broker_Chrg = (Case When Dispcharge = 1 
		    Then (Case When Min(Brokernote) = 1 
			       Then Isnull(Sum(Broker_Chrg),0)   
		               Else 0 
		          End)    
		    Else 0 
	       End)  ' 
End
If @Detail = 'BR'
Exec (@@SelectFlex + @@SelectBody+ @@FromTable + @@WhereText + @@MyGroup + @@Dummy1   + @@SelectFlex + @@SelectBody  + @@FromTable1  + @@WhereText  + @@MyGroup+@@MyOrder  )

GO
