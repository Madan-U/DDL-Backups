-- Object: PROCEDURE dbo.Bbgconfirmation_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Bbgconfirmation_New    Script Date: 16/07/2007 8:49:45 PM ******/



--EXEC BBGConfirmation_New '', '', '%', 'Dec 31 2007', 'Dec 31 2007', '', '', '', '', 'AREA', 'C', '0', '1', '1', '', 'broker', 'broker'



CREATE  Procedure Bbgconfirmation_New 
( 
@sett_no Varchar(10), 		 ---1  Settlement No(from)
@tosett_no Varchar(10),		 ---2  Settlement No (to)
@sett_type Varchar(3),		 ---3  Settlement Type 
@sauda_date Varchar(11),	 ---4 Sauda_date (from)
@todate Varchar(11),		 ---5 Sauda_date (to)
@fromscrip Varchar(10),		 ---6 From Scrip_cd (from)
@toscrip Varchar(10),		 ---7 To Scrip_cd (to)
@from Varchar(20), 		 ---8  From Consol
@to Varchar (20), 		 ---9  To Consol
@consol Varchar(10),		 ---10  Consol Indicates That Whether Is "party_code","trader","sub Broker","branch"
@detail Varchar(3),		 ---11  This Is Other Details In Query "b" = "bill","c" = "confirmation","p" = "position","br" = "brokerage","s" = "sauda Summary"
@level  Smallint,                ---12 Will Be Used To Select  Level Of Consolidation Default 0
@groupf Varchar(500),		 ---13 (any Necessary Grouping) This Can Be Defined On The Fly By Developer
@orderf Varchar(500),		 ---14 (any Necessary Order By) This Can De Defined On The Fly By Developer 
@use1 Varchar(10),               --- 15 To Be Used Later  For Other Purposes
@statusid Varchar(15),
@statusname Varchar(25) 
)

As
Declare
@@getstyle As Cursor,
@@sett_no As Varchar(10),
@@fromparty_code As Varchar(10),
@@toparty_code  As Varchar(10),
@@fromsett_type As Varchar(3),
@@tosett_type As Varchar(3),
@@myquery As Varchar(4000),
@@myreport As Varchar(50),
@@myorder As Varchar(8000),
@@mygroup As Varchar(1500),
@@part As Varchar(8000),
@@part1 As Varchar(8000),
@@part2 As Varchar(8000),
@@part3 As Varchar(8000),
@@part4 As Varchar(8000),
@@part5 As Varchar(8000),
@@part6 As Varchar(8000),
@@wisereport As Varchar(10),
@@dummy1 As Varchar(1000),
@@dummy2 As Varchar(1000),
@@fromregion As Varchar(10),
@@toregion  As Varchar(10),
@@fromfamily As Varchar(10),
@@tofamily  As Varchar(10),
@@frombranch_cd As Varchar(15),
@@tobranch_cd  As Varchar(15),
@@fromsub_broker As Varchar(15),
@@tosub_broker  As Varchar(15),
@@fromtrader As Varchar(15),
@@totrader  As Varchar(15),
@@dummy3 As Varchar(1000),
@@fromtable As Varchar(1000),    --------------------   This String Will Enable Us To Code Conditions Like From Settlement
@@selectflex As Varchar (8000),   ---------------------  This String Will Enable Us To Code Flexible Select Conditions 
@@selectflex1 As Varchar(8000),   ---------------------  This String Will Enable Us To Code Flexible Select Conditions 
@@selectflex11 As Varchar(8000),   ---------------------  This String Will Enable Us To Code Flexible Select Conditions 
@@selectbody As Varchar(8000),  ---------------------   This Is Regular Select Body
@@selectbody1 As Varchar(8000),  ---------------------   This Is Regular Select Body
@@wheretext As Varchar(8000),  ---------------------  This Will Be Used For Coding Where Condition  
@@fromtable1 As Varchar(1000), ---------------------   This Is Another String That Can Be Used For  
@@wherecond1 As Varchar(2000)


Select @@wheretext  = ''

If ((@consol = "party_code" Or @consol = "broker")) And  ((@from <> "") And (@to = "" ) ) 
Begin
          Select @@fromparty_code = @from
          Select @@toparty_code = @from 
End

If ((@consol = "party_code" Or @consol = "broker")) And  ((@from <> "") And (@to <> "" ) ) 
Begin
          Select @@fromparty_code = @from
          Select @@toparty_code = @to 
End


If (@consol = "family") And  ((@from <> "") And (@to <> "" ) ) 
Begin
          Select @@fromfamily = @from
          Select @@tofamily = @to 
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code And Client1.family Between @@fromfamily  And @@tofamily
End
Else If (@consol = "family") And  ((@from = "") And (@to = "" ) ) 
Begin          
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code 
End

If (@consol = "branch_cd") And  ((@from <> "") And (@to <> "" ) ) 
Begin
          Select @@frombranch_cd = @from
          Select @@tobranch_cd = @to 

          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.branch_cd  Between @@frombranch_cd  And @@tobranch_cd
End
Else If (@consol = "branch_cd") And  ((@from = "") And (@to = "" ) ) 
Begin
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code),@@frombranch_cd = Min(branch_cd), @@tobranch_cd = Max(branch_cd) From Client2, Client1 Where Client2.cl_code = Client1.cl_code 
End

If (@consol = "trader") And  ((@from <> "") And (@to <> "" ) ) 
Begin
          Select @@fromtrader = @from
          Select @@totrader = @to 
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.trader Between @@fromtrader  And @@totrader
End
Else If (@consol = "trader")  And ( ( @from = "" ) And ( @to = "" ) )  
Begin
	Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromtrader=min(trader),@@totrader=max(trader) From Client2, Client1 Where Client2.cl_code = Client1.cl_code 
End


If (@consol = "sub_broker") And  ((@from <> "") And (@to <> "" ) ) 
Begin
          Select @@fromsub_broker = @from
          Select @@tosub_broker = @to 
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.sub_broker Between @@fromsub_broker  And @@tosub_broker      	
End
Else If (@consol = "sub_broker")  And ( ( @from = "" ) And ( @to = "" ) )  
Begin
	Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromsub_broker=min(sub_broker),@@tosub_broker=max(sub_broker) From Client2, Client1 Where Client2.cl_code = Client1.cl_code 
End


If ( (@consol = "party_code" Or @consol = "broker")) And ( ( @from = "" ) And ( @to = "" ) ) 
Begin
     Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details 
End

If (@consol = "region")  And ( ( @from = "" ) And ( @to = "" ) )  
Begin
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromregion=min(region),@@toregion = Max(region) From Cmbillvalan  
End

If (@consol = "region")  And ( ( @from <> "" ) And ( @to <> "" ) )  
Begin
     Set @@fromregion = @from
     Set @@toregion = @to
     Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code)  From Cmbillvalan   Where Region Between @@fromregion And @@toregion
End

-----------------------------------------------------------------------------------------
If @sett_type  <>  "%" 

Begin
     Select @@fromsett_type = @sett_type
     Select @@tosett_type = @sett_type
End


If @sett_type  =  "%" 
Begin
      Select @@fromsett_type = Min(sett_type), @@tosett_type = Max(sett_type) From Details
End

-----------------------------------------------------------------------------------------
If  ( (@fromscrip = "") And  (@toscrip = "") )
   Select @fromscrip = Min(scrip_cd) ,@toscrip = Max(scrip_cd) From Scrip2

If (@fromscrip = "")
   Select @fromscrip = Min(scrip_cd) From Scrip2

If (@toscrip = "")
   Select @toscrip = Max(scrip_cd) From Scrip2
-----------------------------------------------------------------------------------------
If @tosett_no = "" 
   Set @tosett_no = @sett_no

Select @sauda_date = Ltrim(rtrim(@sauda_date))
If Len(@sauda_date) = 10 
Begin
          Set @sauda_date = Stuff(@sauda_date, 4, 1,"  ")
End

Select @todate = Ltrim(rtrim(@todate))

If Len(@todate) = 10 
Begin
          Set @todate = Stuff(@todate, 4, 1,"  ")
End
--------------------------------------------------- Find Saudadate From To From Settlement Range  -------------------------------------------------------------------------------------------------------
If ( @todate  = "" ) 
Begin
        Select @todate = End_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @tosett_no 
End

If ( @sauda_date  = "" ) 
Begin
        Select @sauda_date = Start_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @sett_no 
End
----------------------------------------------------find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------
If ( (@sett_no = "" ) And ( Len(@sauda_date) > 1)) 
Begin
         Select @sett_no = Isnull(min(sett_no),'0') From Sett_mst Where Sett_type Between  @@fromsett_type And @@tosett_type  And Start_date < @sauda_date + " 00:01"  And End_date >= @sauda_date + " 23:58:59"   
         If @todate = "" 
         Set @tosett_no = @sett_no
     
End

If ( (@tosett_no = "" ) And ( Len(@todate) > 1)) 
Begin
        Select @tosett_no = Isnull(max(sett_no),'0') From Sett_mst Where Sett_type Between  @@fromsett_type  And @@tosett_type And Start_date < @todate + " 00:01" And End_date >= @todate  + " 23:58:59" 
        
End
-----------------------------------------------------------------------------------------
 
If @detail = "C" 
   Set @@myreport = "confirmation"





If @orderf = "0"       ------------------------------ To Be Used For Contract / Bill Printing  ------------------------
Begin
          If @consol = "party_code"
             Set @@myorder = " Order By S.party_code, S.contractno,s.sett_no, S.sett_type,  Flag, S.scrip_cd Asc, S.series, Tradetyp , Billno, Contractno, S.sauda_date Option (fast 10 )  "
End
	
If @orderf = "1"  ------------------------ To Be Used For Gross Position Across Range ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order   By Region,s.party_code,s.sett_no,s.sett_type, Flag, contractno,s.scrip_cd Asc, S.series,sell_buy,sauda_date,tradeqty Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order   By S.party_code,s.sett_no,s.sett_type, Flag, contractno,s.scrip_cd Asc, S.series,sell_buy,sauda_date,tradeqty  Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order  By Branch_cd, S.party_code,s.sett_no,s.sett_type, Flag, contractno,s.scrip_cd Asc, S.series,sell_buy,sauda_date,tradeqty Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family,s.party_code,s.sett_no,s.sett_type,Flag, contractno,s.scrip_cd Asc, S.series,sauda_date,tradeqty Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader,s.party_code,s.sett_no,s.sett_type, Flag,contractno,s.scrip_cd Asc, S.series,sell_buy,sauda_date,tradeqty Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By Sub_broker,s.party_code,s.sett_no,s.sett_type, Flag, contractno,s.scrip_cd Asc, S.series,sell_buy,sauda_date,tradeqty Option (fast 1 ) "
End

If @orderf = "1.1"  ------------------------ To Be Used For Gross Position Across Range ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Region  Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Party_code  Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Branch_cd  Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Family Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Trader Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order By Flag, S.scrip_cd, S.series, Sub_broker Option (fast 1 ) "
End

If @orderf = "2"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "

          If @consol = "party_code"
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "sub_broker"
     Set  @@myorder = " Order By S.sett_no,s.sett_type Option (fast 1 )"
End


If @orderf = "3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order  By S.scrip_cd ,s.series Option (fast 1 ) "

          If @consol = "party_code"
             Set  @@myorder = " Order  By S.scrip_cd ,s.series Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "
          If @consol = "sub_broker"
     Set  @@myorder = " Order By S.scrip_cd ,s.series  Option (fast 1 )"
End

If @orderf = "3.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Region , S.sett_no,s.sett_type , Flag, S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By S.party_code , Flag, S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order By Branch_cd  , Flag, s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family , Flag, S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader  , Flag, S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By Sub_broker  , Flag, S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"
End

If @orderf = "3.11"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Region, s.party_code  Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By S.party_code  Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order By Branch_cd  ,s.party_code Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family , S.party_code Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader  , S.party_code Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By Sub_broker  , S.party_code Option (fast 1 )"
End

If @orderf = "3.2"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Region , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "

          If @consol = "party_code"
             Set  @@myorder = " Order By S.party_code , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order By Branch_cd  ,s.sauda_date ,s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By Sub_broker  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"
End

If @orderf = "3.3"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Region  ,s.scrip_cd, S.series Option (fast 1 ) "

          If @consol = "party_code"
             Set  @@myorder = " Order By S.party_code  ,s.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order By Branch_cd  ,s.scrip_cd , S.series Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader  , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By Sub_broker  , S.scrip_cd, S.series Option (fast 1 )"
End

If @orderf = "3.4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "branch_cd"

             Set  @@myorder = " Order By S.sett_no,s.sett_type  ,s.scrip_cd , S.series Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  Bys.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order  By S.sett_no,s.sett_type  , S.scrip_cd, S.series Option (fast 1 )"
End

If @orderf = "4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,sauda_date,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "
          If @consol = "branch_cd"
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "

End

If @orderf = "4.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,sauda_date,tmark  ----------------------
Begin
          If @consol = "region"
             Set  @@myorder = " Order By Region  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "
          If @consol = "party_code"
             Set  @@myorder = " Order By S.party_code  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "

          If @consol = "branch_cd"
             Set  @@myorder = " Order  By Branch_cd  ,s.sett_no,s.sett_type , S.scrip_cd,s.series,s.sauda_date Option (fast 1 ) "
          If @consol = "family"
             Set  @@myorder = " Order  By Family  ,s.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "
          If @consol = "trader"
             Set  @@myorder = " Order  By Trader  , S.sett_no,s.sett_type , S.scrip_cd,s.series, S.sauda_date Option (fast 1 ) "
          If @consol = "sub_broker"
             Set  @@myorder = " Order By Sub_broker , S.sett_no,s.sett_type , S.scrip_cd,s.series ,s.sauda_date Option (fast 1 ) "
End

Set @@wheretext =  " And S.sauda_date   Between '" + @sauda_date  + " 00:00:00'  And '"   + @todate  + " 23:59:00' And S.scrip_cd Between '"  + @fromscrip + "' And  '"+  @toscrip +"' And /* S.sett_no Between '" + @sett_no + "' And '" + @tosett_no +"' And */ "  
---------------------------  Now We Will Decide About Join  We Will Always Provide From Party And Toparty -------------------------------------------

Set @@wheretext =  @@wheretext  + "  S.party_code Between '" + @@fromparty_code  + "' And '"  + @@toparty_code   +"'  "  

If @consol = "region" 
Set @@wheretext =  @@wheretext +   "  And Region Between '" + @@fromregion  + "' And '" + @@toregion   +"'  " 

If @consol = "family" 
Set @@wheretext =  @@wheretext +   "  And Family Between '" + @@fromfamily  + "' And '" + @@tofamily   +"'  " 

If @consol = "trader"
Set @@wheretext =  @@wheretext + " And  Trader Between '" + @@fromtrader  + "' And '" + @@totrader   +"' " 

If @consol = "branch_cd" 
Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @@frombranch_cd  + "' And '" + @@tobranch_cd   +"' " 

If @consol = "sub_broker" 
Set @@wheretext =  @@wheretext + " And Sub_broker Between '" + @@fromsub_broker  + "' And '" + @@tosub_broker   +"' " 

--print "i Am Here "
--print @@wheretext

------------------------- Added For Access Control As Per User Login Status ---------------------------------------------------------------------------------------------
If @statusid = "family" 
	Begin
		Set @@wheretext =  @@wheretext +   "  And Family Between '" + @statusname  + "' And '" + @statusname   +"'  " 
	End

If @statusid = "trader"
Begin
	Set @@wheretext =  @@wheretext + " And  Trader Between '" + @statusname  + "' And '" + @statusname   +"'  " 
End

If @statusid = "branch" 
Begin
	Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @statusname  + "' And '" + @statusname   +"'  " 
End


If @statusid = "subbroker" 
Begin
	Set @@wheretext =  @@wheretext + " And Sub_broker Between '" + @statusname  + "' And '" + @statusname   +"'  " 
End

If @statusid = "party" 
Begin
	Set @@wheretext =  @@wheretext + " And Party_code Between '" + @statusname  + "' And '" + @statusname   +"'  " 
End

If Len(@@wheretext) = 0 Or @@wheretext Is Null 
Select @@wheretext = ' And 1 = 2 ' 

Set @@selectflex = " set transaction isolation level read uncommitted SELECT Contractno, Billno, Trade_No=Pradnya.DBO.ReplaceTradeNo(Trade_No), S.Party_Code, Scrip_Cd, " 
Set @@selectflex = @@selectflex + " Tradeqty=Sum(TradeQty), Series, Order_No, Marketrate, Sauda_Date, Sell_Buy, Settflag, User_Id, Branch_id, AuctionPart, "
Set @@selectflex = @@selectflex + " Brokapplied=Sum(Brokapplied*TradeQty)/Sum(TradeQty), Netrate=Sum(Netrate*TradeQty)/Sum(TradeQty), "
Set @@selectflex = @@selectflex + " Amount=Sum(Amount), Ins_Chrg=Sum(Ins_Chrg), Turn_Tax=Sum(Turn_Tax), Other_Chrg=Sum(S.Other_Chrg), " 
Set @@selectflex = @@selectflex + " Sebi_Tax=Sum(Sebi_Tax), Broker_Chrg=Sum(Broker_Chrg), Service_Tax=Sum(Service_Tax), Billflag,  "
Set @@selectflex = @@selectflex + " Sett_No, Nbrokapp=Sum(Nbrokapp*TradeQty)/Sum(TradeQty), Nsertax=Sum(Nsertax), N_Netrate=Sum(N_Netrate*TradeQty)/Sum(TradeQty), " 
Set @@selectflex = @@selectflex + " Sett_Type, Tmark, cpid, Flag = 1 INTO #SETTLEMENT From Settlement S, Client2 C2, Client1 C1 "
Set @@selectflex = @@selectflex + " Where C2.Cl_Code = C1.Cl_Code "
Set @@selectflex = @@selectflex + " And S.Party_Code = C2.Party_Code and TradeQty > 0 " + @@wheretext
Set @@selectflex = @@selectflex + " Group By Contractno, Billno, Pradnya.DBO.ReplaceTradeNo(Trade_No), s.Party_Code, Scrip_Cd, Series, Order_No,  "
Set @@selectflex = @@selectflex + " Marketrate, Sauda_Date, Sell_Buy, Settflag, User_Id, Branch_id, AuctionPart, Billflag, Sett_No, Sett_Type, Tmark, cpid  "

Set @@selectflex = @@selectflex + " Update #Settlement Set "
Set @@selectflex = @@selectflex + " NetRate = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		Then MarketRate + (Case When BillFlag in (2,3) Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "      		Else MarketRate - (Case When BillFlag in (2,3) Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "        	   End), "
Set @@selectflex = @@selectflex + " N_NetRate = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		Then MarketRate + (Case When BillFlag in (2,3) Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "      		Else MarketRate - (Case When BillFlag in (2,3) Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "        	   End), "
Set @@selectflex = @@selectflex + " Brokapplied = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		    Then (Case When BillFlag in (2,3) Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "      		    Else (Case When BillFlag in (2,3) Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "        	       End), "
Set @@selectflex = @@selectflex + " NBrokapp = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		    Then (Case When BillFlag in (2,3) Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "      		    Else (Case When BillFlag in (2,3) Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)/TradeQty "
Set @@selectflex = @@selectflex + "        	       End), "
Set @@selectflex = @@selectflex + " Service_Tax = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		    Then (Case When BillFlag in (2,3) Then CD_TrdBuySerTax Else CD_DelBuySerTax End) "
Set @@selectflex = @@selectflex + "      		    Else (Case When BillFlag in (2,3) Then CD_TrdSellSerTax Else CD_DelSellSerTax End) "
Set @@selectflex = @@selectflex + "        	       End), "
Set @@selectflex = @@selectflex + " NSerTax = (Case When Sell_Buy = 1   "
Set @@selectflex = @@selectflex + "      		    Then (Case When BillFlag in (2,3) Then CD_TrdBuySerTax Else CD_DelBuySerTax End) "
Set @@selectflex = @@selectflex + "      		    Else (Case When BillFlag in (2,3) Then CD_TrdSellSerTax Else CD_DelSellSerTax End) "
Set @@selectflex = @@selectflex + "        	       End) "
Set @@selectflex = @@selectflex + " FROM CHARGES_DETAIL  "
Set @@selectflex = @@selectflex + " WHERE "
Set @@selectflex = @@selectflex + " CD_Sett_No = #Settlement.Sett_No "
Set @@selectflex = @@selectflex + " And CD_Sett_Type = #Settlement.Sett_Type "
Set @@selectflex = @@selectflex + " And CD_Party_Code = #Settlement.Party_Code "
Set @@selectflex = @@selectflex + " And CD_Scrip_Cd = #Settlement.Scrip_Cd "
Set @@selectflex = @@selectflex + " And CD_Series = #Settlement.Series "
Set @@selectflex = @@selectflex + " And CD_Trade_No = Trade_No "
Set @@selectflex = @@selectflex + " And CD_Order_No = Order_No "
Set @@selectflex = @@selectflex + " And Left(Sauda_Date,11) = Left(Cd_Sauda_Date,11) "

Set @@selectflex = @@selectflex + " Insert into #Settlement "
Set @@selectflex = @@selectflex + " SELECT Contractno='0', Billno='0', Trade_No='', CD_Party_Code, CD_Scrip_Cd, Tradeqty=1, CD_Series, CD_Order_No = '', "
Set @@selectflex = @@selectflex + " Marketrate = 0, CD_Sauda_Date, Sell_Buy = 1, Settflag = 1, User_Id = '', Branch_id = '', AuctionPart = '', Brokapplied = Sum(CD_TotalBrokerage), "
Set @@selectflex = @@selectflex + " NetRate = Sum(CD_TotalBrokerage), Amount = 0, Ins_Chrg = 0, Turn_Tax = 0, Other_Chrg = 0, Sebi_Tax = 0, Broker_Chrg = 0, "
Set @@selectflex = @@selectflex + " Service_Tax = Sum(CD_TotalSerTax), Billflag = 1, CD_Sett_No, Nbrokapp = Sum(CD_TotalBrokerage), Nsertax = Sum(CD_TotalSerTax), N_Netrate = Sum(CD_TotalBrokerage), "
Set @@selectflex = @@selectflex + " CD_Sett_Type, Tmark = 'N', cpid = '', Flag = 4 "
Set @@selectflex = @@selectflex + " From Charges_Detail S, Client2 C2, Client1 C1 Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = CD_Party_code And CD_Trade_no = '' " + Replace(Replace(Replace(@@wheretext,'Scrip_Cd','CD_Scrip_Cd'),'Sauda_date','CD_Sauda_Date'),'Party_Code', 'CD_Party_code')
Set @@selectflex = @@selectflex + " Group By CD_Party_Code, CD_Scrip_Cd, CD_Series, CD_Sauda_Date, CD_Sett_No, CD_Sett_Type "

Set @@selectflex = @@selectflex + " Select S.party_code,Region, Family,trader,branch_cd,sub_broker,contractno,c1.long_name,res_phone1,scrip_cd=s1.long_name, S.series,trade_no,sdate=left(convert(varchar,sauda_date,109),11),sauda_date,user_id ,sett_no,sett_type,marketrate,brokapplied,nbrokapp,tradeqty,sell_buy, "
Set @@selectflex = @@selectflex + " Netrate = ( Case When  Sell_buy = 1 Then Marketrate + Brokapplied  Else Marketrate - Brokapplied End), Netamount = Tradeqty * ( Case When  Sell_buy = 1 Then Marketrate + Brokapplied  Else Marketrate - Brokapplied End), "
Set @@selectflex = @@selectflex + " N_netrate = ( Case When  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - Nbrokapp End) ,n_netamount =  Tradeqty * ( Case When  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - Nbrokapp End),service_tax = (case When Service_chrg <> 2 Then Service_tax Else 0 End) ,nsertax = (case When Service_chrg <> 2 Then Nsertax Else 0 End) " + " , Soris = 's',branch_id = Branch_id, "
Set @@selectflex = @@selectflex + " Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),Turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),Sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),Other_chrg =(Case When c2.Other_chrg = 1 Then S.other_chrg Else 0 End),Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ) "
Set @@selectflex = @@selectflex + " ,TOTBrok = isnull(tradeqty*nbrokapp+ (Case When Service_Chrg = 1 Then NSertax Else 0 End),0), Flag "
Set @@selectflex = @@selectflex + " From #Settlement S,client1 C1 ,client2 C2, Scrip2 S2, Scrip1 S1 Where S1.co_code = S2.co_code And S2.series = S1.series And S.scrip_cd = S2.scrip_cd And S.series = S2.series And S.party_code = C2.party_code And C2.cl_code = C1.cl_code And Tradeqty > 0 And S.auctionpart Not Like 'a%' And S.auctionpart Not Like 'f%'"

Set @@selectflex1 =  " Union All Select S.party_code, Region, family,trader,sub_broker,branch_cd,contractno,c1.long_name,res_phone1,scrip_cd=s1.long_name, S.series,trade_no,left(convert(varchar,sauda_date,109),11),sauda_date,user_id ,sett_no,sett_type,marketrate,brokapplied,nbrokapp,tradeqty,sell_buy, "
Set @@selectflex1 = @@selectflex1 + " Netrate = ( Case When  Sell_buy = 1 Then Marketrate + Brokapplied  Else Marketrate - Brokapplied End), Netamount = Tradeqty * ( Case When  Sell_buy = 1 Then Marketrate + Brokapplied  Else Marketrate - Brokapplied End), "
Set @@selectflex1 = @@selectflex1+ " N_netrate = ( Case When  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - Nbrokapp End) ,n_netamount =  Tradeqty * ( Case When  Sell_buy = 1 Then Marketrate + Nbrokapp  Else Marketrate - Nbrokapp End),service_tax = (case When Service_chrg <> 2 Then Service_tax Else 0 End) ,nsertax = (case When Service_chrg <> 2 Then Nsertax Else 0 End) " + ", Soris = 'is',branch_id = Branch_id, "
Set @@selectflex1 = @@selectflex1 + " Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),Turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),Sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),Other_chrg =(Case When c2.Other_chrg = 1 Then S.other_chrg Else 0 End),Ins_Chrg = (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ) "
Set @@selectflex1 = @@selectflex1 + " ,TOTBrok = isnull(tradeqty*nbrokapp+ (Case When Service_Chrg = 1 Then NSertax Else 0 End),0), Flag = 1 "
Set @@selectflex1 = @@selectflex1 + " From Isettlement S,client1 C1 ,client2 C2 , Scrip2 S2, Scrip1 S1 Where S1.co_code = S2.co_code And S2.series = S1.series And S.scrip_cd = S2.scrip_cd And S.series = S2.series And S.party_code = C2.party_code And C2.cl_code = C1.cl_code And Tradeqty > 0 And S.auctionpart Not Like 'a%' And S.auctionpart Not Like 'f%' "

--select @@wheretext
--select @@selectflex
select @@myorder = @@myorder 

--print @consol 
print @@selectflex 
print @@wheretext 
print @@selectflex1 
print @@wheretext 
print @@myorder

--Exec (@@selectflex + @@wheretext + @@selectflex1 + @@wheretext + @@myorder)
--Print (@@selectflex + @@wheretext + @@selectflex1 + @@wheretext + @@myorder)



Exec (@@selectflex + @@wheretext + @@selectflex1 + @@wheretext + @@myorder)

GO
