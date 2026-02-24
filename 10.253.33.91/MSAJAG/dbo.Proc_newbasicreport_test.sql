-- Object: PROCEDURE dbo.Proc_newbasicreport_test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Proc_NewBasicReport    Script Date: 5/12/2009 4:00:26 PM ******/
/****** Object:  Stored Procedure dbo.Proc_NewBasicReport    Script Date: 3/13/2009 7:04:11 PM ******/
/****** Object:  Stored Procedure dbo.Proc_newbasicreport    Script Date: 06/07/2007 6:48:58 PM ******/  
/****** Object:  Stored Procedure Dbo.proc_newbasicreport    Script Date: 01/15/2005 1:12:51 Pm ******/  
/****** Object:  Stored Procedure Dbo.proc_newbasicreport    Script Date: 12/06/2004 10:42:58 Pm ******/  
/****** Object:  Stored Procedure Dbo.proc_newbasicreport    Script Date: 12/06/2004 8:29:47 Pm ******/  
  
CREATE                    Procedure [dbo].[Proc_newbasicreport_test] (   
@sett_no Varchar(10),    ---1  Settlement No(from)  
@tosett_no Varchar(10),   ---2  Settlement No (to)  
@sett_type Varchar(3),   ---3  Settlement Type   
@sauda_date Varchar(11),  ---4 Sauda_date (from)  
@todate Varchar(11),   ---5 Sauda_date (to)  
@fromscrip Varchar(10),   ---6 From Scrip_cd (from)  
@toscrip Varchar(10),   ---7 To Scrip_cd (to)  
@from Varchar(20),     ---8  From Consol  
@to Varchar (20),     ---9  To Consol  
@consol Varchar(10),   ---10  Consol Indicates That Whether Is "party_code","trader","sub Broker","branch"  
@detail Varchar(3),    ---11  This Is Other Details In Query "b" = "bill","c" = "confirmation","p" = "position","br" = "brokerage","s" = "sauda Summary"  
@level  Smallint,            ---12 Will Be Used To Select  Level Of Consolidation Default 0  
@groupf Varchar(500),   ---13 (any Necessary Grouping) This Can Be Defined On The Fly By Developer  
@orderf Varchar(500),   ---14 (any Necessary Order By) This Can De Defined On The Fly By Developer   
@use1 Varchar(10),           ---15 To Be Used Later  For Other Purposes  
@statusid Varchar(15),  
@statusname Varchar(25) )  
  
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
@@myorder As Varchar(1500),  
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
@@fromfamily As Varchar(10),  
@@tofamily  As Varchar(10),  
@@frombranch_cd As Varchar(15),  
@@tobranch_cd  As Varchar(15),  
@@fromsub_broker As Varchar(25),  
@@tosub_broker  As Varchar(25),  
@@fromtrader As Varchar(50),  
@@totrader  As Varchar(50),  
@@fromregion Varchar(15),  
@@toregion Varchar(15),  
@@fromarea Varchar(15),  
@@toarea Varchar(15),  
@@dummy3 As Varchar(1000),  
@@fromtable As Varchar(1000),    --------------------   This String Will Enable Us To Code Conditions Like From Settlement  
@@selectflex As Varchar (2000),   ---------------------  This String Will Enable Us To Code Flexible Select Conditions   
@@selectflex1 As Varchar (2000),   ---------------------  This String Will Enable Us To Code Flexible Select Conditions   
@@selectbody As Varchar(8000),  ---------------------   This Is Regular Select Body  
@@selectbody1 As Varchar(8000),  ---------------------   This Is Regular Select Body  
@@wheretext As Varchar(8000),  ---------------------  This Will Be Used For Coding Where Condition    
@@fromtable1 As Varchar(1000), ---------------------   This Is Another String That Can Be Used For    
@@wherecond1 As Varchar(2000)  
  
/* To Reduce The Number Of Queries We Have Joined Maximum Number Of Parameters With Ranges*/  
/* Hence We Are Extracting Ranges If The Partmeter Passed Is %  Or ""   */  
/* If The Parameter Is Passed Then We Make That Same Parameter As From <-----> To  */  
  
  
/* Here I Will Define Rules For Various  */  
-----------------------------------------------------------------------------------------  
/*  
print @consol  
print @from  
print @to  
*/  
if len(@sauda_date) = 10 and charindex('/', @sauda_date) > 0    
 begin    
  set @sauda_date = convert(varchar(11), convert(datetime, @sauda_date, 103), 109)    
 end    
if len(@todate) = 10 and charindex('/', @todate) > 0    
 begin    
  set @todate = convert(varchar(11), convert(datetime, @todate, 103), 109)    
 end   

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
          Select @@fromparty_code = IsNull(Min(party_code),'') , @@toparty_code = IsNull(Max(party_code),'zzzzzzz') From Client2, Client1  Where  Client2.cl_code = Client1.cl_code And Client1.family Between @@fromfamily  And @@tofamily  
End  
Else If (@consol = "family") And  ((@from = "") And (@to = "" ) )   
Begin            
/*       Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code   
         Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code And Client2.party_code = @statusname*/  
  Select @@fromparty_code = ''  
  Select @@toparty_code = 'zzzzzzz'  
  Select @@fromfamily = ''  
  Select @@tofamily = 'zzzzzzz'  
End  
  
If (@consol = "branch_cd") And  ((@from <> "") And (@to <> "" ) )   
Begin  
 Select @@frombranch_cd = @from  
 Select @@tobranch_cd = @to   
 Select @@fromparty_code = IsNull(Min(party_code),'') , @@toparty_code = IsNull(Max(party_code),'zzzzzzz') From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.branch_cd  Between @@frombranch_cd  And @@tobranch_cd  
End  
Else If (@consol = "branch_cd") And  ((@from = "") And (@to = "" ) )   
Begin  
 --Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code),@@frombranch_cd = Min(branch_cd), @@tobranch_cd = Max(branch_cd) From Client2, Client1 Where Client2.cl_code = Client1.cl_code   
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
 Select @@frombranch_cd = ''  
 Select @@tobranch_cd = 'zzzzzzz'  
End  
  
If (@consol = "trader") And  ((@from <> "") And (@to <> "" ) )   
Begin  
          Select @@fromtrader = @from  
          Select @@totrader = @to   
          Select @@fromparty_code = IsNull(Min(party_code),'') , @@toparty_code = IsNull(Max(party_code),'zzzzzzz') From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.trader Between @@fromtrader  And @@totrader  
End  
Else If (@consol = "trader")  And ( ( @from = "" ) And ( @to = "" ) )    
Begin  
 --Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromtrader=min(trader),@@totrader=max(trader) From Client2, Client1 Where Client2.cl_code = Client1.cl_code   
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
 Select @@fromtrader = ''  
 Select @@totrader = 'zzzzzzz'  
End  
  
  
If (@consol = "sub_broker") And  ((@from <> "") And (@to <> "" ) )   
Begin  
 Select @@fromsub_broker = @from  
 Select @@tosub_broker = @to   
 Select @@fromparty_code = IsNull(Min(party_code),'') , @@toparty_code = IsNull(Max(party_code),'zzzzzzz') From Client2, Client1 Where Client2.cl_code = Client1.cl_code And Client1.sub_broker Between @@fromsub_broker  And @@tosub_broker         
End  
Else If (@consol = "sub_broker")  And ( ( @from = "" ) And ( @to = "" ) )    
Begin  
 --Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromsub_broker=min(sub_broker),@@tosub_broker=max(sub_broker) From Client2, Client1 Where Client2.cl_code = Client1.cl_code   
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
 Select @@fromsub_broker = ''  
 Select @@tosub_broker = 'zzzzzzz'  
End  
  
If (@consol = "region")  And  ((@from <> "") And (@to <> "" ) )   
Begin  
      --Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details   
 Select @@fromregion = @from   
 Select @@toregion = @to  
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'   
End  
  
Else If (@consol = "region")  And  ((@from = "") And (@to = "" ) )   
Begin  
      --Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details   
      --Select @@fromregion = Min(region), @@toregion=max(region) From Cmbillvalan  
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
 Select @@fromregion = ''  
 Select @@toregion = 'zzzzzzz'  
End  
If (@consol = "area")  And  ((@from <> "") And (@to <> "" ) )   
Begin  
      --Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details   
      Select @@fromarea = @from   
      Select @@toarea = @to  
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
End  
  
Else If (@consol = "area")  And  ((@from = "") And (@to = "" ) )   
Begin  
 /*Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details   
 Select @@fromarea = Min(area), @@toarea=max(area) From Cmbillvalan*/  
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
 Select @@fromarea = ''  
 Select @@toarea = 'zzzzzzz'  
End  
  
If ( (@consol = "party_code" Or @consol = "broker")) And ( ( @from = "" ) And ( @to = "" ) )   
Begin  
/*     Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details   
     Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details Where Party_code = @statusname*/  
 Select @@fromparty_code = ''  
 Select @@toparty_code = 'zzzzzzz'  
End  
-----------------------------------------------------------------------------------------  
If @sett_type  <>  "%"   
Begin  
     Select @@fromsett_type = @sett_type  
     Select @@tosett_type = @sett_type  
End  
  
  
If @sett_type  =  "%"   
Begin  
      Select @@fromsett_type = Min(sett_type), @@tosett_type = Max(sett_type) From sett_mst  
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
         Select @sett_no = Min(sett_no) From Sett_mst Where Sett_type Between  @@fromsett_type And @@tosett_type  And Start_date >= @sauda_date + " 00:00"  And End_date <= @todate + " 23:59:59"     
         If @todate = ""   
        Set @tosett_no = @sett_no  
End  
  
If ( (@tosett_no = "" ) And ( Len(@todate) > 1))   
Begin  
        Select @tosett_no = Max(sett_no) From Sett_mst Where Sett_type Between  @@fromsett_type And @@tosett_type  And Start_date >= @sauda_date + " 00:00"  And End_date <= @todate + " 23:59:59"     
End  
/*  
If @sett_no <> ''   
 Select @sauda_date = Left(Min(Start_date),11) From Sett_mst Where Sett_type Like @sett_type And Sett_no >= @sett_no And Sett_No <= @tosett_no  
If @tosett_no <> ''   
 Select @todate = Left(Max(End_Date),11) From Sett_mst Where Sett_type Like @sett_type And Sett_no >= @sett_no And Sett_No <= @tosett_no  
*/  
-----------------------------------------------------------------------------------------  
If @detail = "b"   
   Set @@myreport = "bill"  
   
If @detail = "c"   
   Set @@myreport = "confirmation"  
  
If @detail = "p"   
   Set @@myreport = "position"  
  
If @detail = "br"   
   Set @@myreport = "brokerage"  
  
If @detail = "s"   
   Set @@myreport = "saudasummary"  
  
------------------------------------- We Will Select From  Various Order By Options --------------------------------------   
  
  
If @orderf = "0"       ------------------------------ To Be Used For Contract / Bill --Printing  ------------------------  
Begin  
          If @consol = "party_code"  
             Set @@myorder = " Order By S.party_code, S.sett_no, S.sett_type,  S.scrip_cd Asc, S.series, Tradetyp , Billno, Contractno, S.sauda_date Option (fast 10 )  "  
End  
   
If @orderf = "1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
   If @consol = "region"  
             Set  @@myorder = " Order   By Region  Option (fast 1 ) "  
   If @consol = "area"  
             Set  @@myorder = " Order   By Area  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order   By Party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order  By Branch_cd  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker Option (fast 1 ) "  
End  
  
If @orderf = "1.1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Region  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Area  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Branch_cd  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Family Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Trader Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, S.Sub_broker Option (fast 1 ) "  
End  
  
If @orderf = "2"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "area"  
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
          If @consol = "area"  
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
             Set  @@myorder = " Order By Region , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  ,s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.11"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region,s.party_code  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area,s.party_code  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  , S.party_code  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.party_code  Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.party_code  Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.party_code Option (fast 1 )"  
End  
  
If @orderf = "3.2"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  ,s.sauda_date ,s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.3"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
  
          If @consol = "region"  
             Set  @@myorder = " Order By Region,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,S.party_code, s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,S.party_code, s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By S.Family,S.party_code, S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By S.Trader,S.party_code, S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker,S.party_code, S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type  ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.sett_no,s.sett_type  , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,sauda_date,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "          If @consol = "party_code"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "          If @consol = "branch_cd"  
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
          If @consol = "area"  
             Set  @@myorder = " Order By Area  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "  
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
  
  
-------------------------------------  End Of Select  Order By Options  ----------------------------------------------------  
  
  
If @groupf = "3.3" Or @groupf = "1"  
Begin  
 --Set @@fromtable = " From Cmbillvalan S, BRANCH BR, SUBBROKERS SB "  
 Set @@fromtable = " From Cmbillvalan S Left Outer Join BRANCH BR On (S.Branch_CD = BR.Branch_Code) Left Outer Join SUBBROKERS SB On (S.sub_broker = SB.Sub_Broker) "  
End  
Else  
Begin  
 Set @@fromtable = " From Cmbillvalan S "  
End  
  
  
------------------------------------- We Will Decide Various Group By Options --------------------------------------   
  
If @groupf = "0"    ----------------------  To Be Used For Contract Or Bills ----------------------  
Begin  
     If @consol = "party_code"   
     Set  @@mygroup =  " Group By Party_code , Party_name, Branch_cd, Sub_broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_name, Sauda_date  , Left(convert(varchar,sauda_date,109),11), Contractno , Billno , Tradetype , Start_date, End_date"  
     Set  @@selectflex =  " Select Party_code , Long_name=party_name, Branch_cd, Sub_broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_name, Sauda_date = Left(convert(varchar,sauda_date,109),11), Contractno , Billno, Ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),  Trade_date = S.sauda_date , Tradetyp = (case When Tradetype Like  '%bf' Then 1 Else Case When Tradetype Like  '%cf' Then 3 Else Case When Tradetype Like  '%r' Then 4 Else 2 End End End), Trdtype = Tradetype, Start_date, End_date "  
End  
  
If @groupf = "1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set @@mygroup = " Group By Region, Membertype, Companyname"  
          Set @@selectflex =  " Select Region, Long_name=region,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)), Buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) , Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype = '', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "area"  
     Begin  
          Set @@mygroup = " Group By Area, Membertype, Companyname"  
          Set @@selectflex =  " Select Area, Long_name=area,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)), Buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) , Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype = '', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "party_code"  
     Begin  
          Set @@mygroup = " Group By S.party_code, Party_name,clienttype ,membertype, Companyname"  
          Set @@selectflex =  " Select Party_code, Long_name=party_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)), Buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) , Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "branch_cd"  
     Begin   
          Set  @@mygroup = " Group By Branch_cd, Branch, Membertype, Companyname"  
          Set @@selectflex =  " Select branch_cd,Long_name=Branch,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)"   
     End  
     If @consol = "family"  
     Begin   
          Set  @@mygroup = " Group By Family, Family_name, Membertype, Companyname"  
          Set @@selectflex =  " Select Family, Long_name=family_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "trader"  
     Begin   
          Set  @@mygroup = " Group By Trader, membertype, Companyname "  
          Set @@selectflex =  " Select Trader,long_name=trader,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)"   
     End         
     If @consol = "sub_broker"  
     Begin   
          Set  @@mygroup = " Group By S.Sub_broker, Name, membertype,Companyname "                      
          Set @@selectflex =  " Select S.Sub_broker,long_name=Name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
If @groupf = "1.1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set @@mygroup = " Group By Scrip_cd, Clienttype, Series, Scrip_name, Region,membertype, Companyname"  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Region, Long_name = Region,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "area"  
     Begin  
          Set @@mygroup = " Group By Scrip_cd, Clienttype, Series, Scrip_name, Area,membertype, Companyname"  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Area, Long_name = Area,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
  
     If @consol = "party_code"  
     Begin  
          Set @@mygroup = " Group By Scrip_cd, Series, Scrip_name, S.party_code, Party_name,clienttype ,membertype, Companyname"  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Party_code, Long_name=party_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "branch_cd"  
     Begin   
          Set  @@mygroup = " Group By Scrip_cd, Series, Scrip_name, Branch_cd, Clienttype, Membertype, Companyname"  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Long_name=branch_cd,branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)"   
     End  
     If @consol = "family"  
     Begin   
          Set  @@mygroup = " Group By Scrip_cd, Series, Scrip_name, Family, Family_name,clienttype , Membertype, Companyname"  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Family, Long_name=family_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "trader"  
     Begin   
          Set  @@mygroup = " Group By Scrip_cd, Series, Scrip_name, Trader ,membertype,clienttype, Companyname "  
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Trader,long_name=trader,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)"   
     End         
     If @consol = "sub_broker"  
     Begin   
          Set  @@mygroup = " Group By Scrip_cd, Series, Scrip_name, Sub_broker ,membertype ,clienttype, Companyname "                      
          Set @@selectflex =  " Select Scrip_cd, Series, Scrip_name, Sub_broker,long_name=sub_broker,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
If @groupf = "2"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
          Set @@mygroup = " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex = " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "area"  
     Begin   
          Set @@mygroup = " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex = " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
  
     If @consol = "party_code"  
     Begin   
          Set @@mygroup = " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex = " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "branch_cd"  
     Begin   
          Set @@mygroup = " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex = " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "family"  
     Begin   
          Set @@mygroup =  " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex =  " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End                     
     If @consol = "trader"  
     Begin   
          Set @@mygroup =  " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex =  " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "sub_broker"  
     Begin   
          Set @@mygroup =  " Group By Sett_no, Sett_type,start_date,end_date,membertype, Companyname "  
          Set @@selectflex =  " Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
  
If @groupf = "3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "area"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "party_code"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd, Series, Scrip_name, Ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
  If @consol = "branch_cd"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "family"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End                     
     If @consol = "trader"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select  Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "sub_broker"  
     Begin   
          Set @@mygroup = " Group By Scrip_cd,series,scrip_name,membertype, Companyname "  
          Set @@selectflex = " Select Scrip_cd,Series,Scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
If @groupf = "2.11"  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Region,branch_cd,membertype, Companyname "  
          Set  @@selectflex =  " Select  Region,branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Area,branch_cd,membertype, Companyname "  
          Set  @@selectflex =  " Select  Area,branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
End  
If @groupf = "3.1"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,region,branch_cd,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,region,branch_cd,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,area,branch_cd,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,area,branch_cd,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,party_code, Party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,branch_cd,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,branch_cd,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,family,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,family,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,trader,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trader,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sub_broker,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,sub_broker,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
if @groupf = "3.11"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Region,branch_cd,party_code, Party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select  Region,branch_cd,party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Area,branch_cd,party_code, Party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select  Area,branch_cd,party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Party_code,party_name,clienttype,membertype, Companyname, "  
          Set  @@selectflex =  " Select Party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By Branch_cd,party_code,party_name,clienttype,membertype, Companyname  "  
          Set  @@selectflex =  " Select Branch_cd,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By Family,party_code,party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select Family,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By Trader,party_code,party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select Trader,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By Sub_broker,party_code,party_name,clienttype,membertype, Companyname  "  
          Set  @@selectflex =  " Select Sub_broker,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
  
  
If @groupf = "3.2"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),Region,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),Region,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),area,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),area,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),party_code, Party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "  
 
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),branch_cd,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),branch_cd,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),family,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),family,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),trader,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),trader,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),sauda_date,left(convert(varchar,sauda_date,109),11),sub_broker,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),sub_broker,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
  
If @groupf = "3.3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Region,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Region,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Area,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Area,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,Party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,Party_code, Party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Trader,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BR.Branch,SB.Name,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,BranchName=BR.Branch,SubBrokerName = SB.Name,party_code,party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
  
If @groupf = "3.4"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
    If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
  
    If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By Sett_no, Sett_type,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  " Select Sett_no, Sett_type,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
If @groupf = "4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "area"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "          Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "branch_cd"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "family"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "trader"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "sub_broker"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)"   
     End    
End  
  
  
  
If @groupf = "4.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),region,branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),region,branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "area"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),area,branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),area,branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),party_code,party_name,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "            
   Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),party_code, Party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "branch_cd"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "  
 
     End    
     If @consol = "family"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),family,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),family,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "trader"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),trader,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),trader,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "sub_broker"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),sub_broker,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),sub_broker,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum((CASE WHEN sqtytrd = 0 AND samttrd <> 0 THEN -samttrd ELSE samttrd END) + (CASE WHEN sqtydel = 0 AND Samtdel <> 0 THEN -Samtdel ELSE Samtdel END)),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum((CASE WHEN sqtytrd =0 AND samttrd<>0 THEN -samttrd ELSE samttrd END) + (CASE WHEN Sqtydel=0 AND samtdel<>0 THEN -samtdel ELSE samtdel END)) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)" 
  
     End    
End  
  
-------------------------------------  End Of Decide Group By Options  ----------------------------------------------------  
  
If @groupf = "3.3"  
Begin  
 Set @@wheretext =  " Where /*S.Branch_CD = BR.Branch_Code And S.sub_broker= SB.Sub_Broker And*/ S.sauda_date Between '" + @sauda_date + " 00:00:00' And '" + @todate + " 00:00:00'"  
End  
ELse  
Begin  
 Set @@wheretext =  " Where S.sauda_date Between '" + @sauda_date + " 00:00:00' And '" + @todate + " 00:00:00'"  
End  
Set @@wheretext =  @@wheretext + " And S.scrip_cd Between '" + @fromscrip + "' And '"+  @toscrip +"' /*and S.sett_no Between '" + @sett_no + "' And '" + @tosett_no +"' */ "    
Set @@wheretext =  @@wheretext + " And S.party_code Between '" + @@fromparty_code  + "' And '" + @@toparty_code   +"'  "    
  
If Upper(@use1) <> 'ALL'  
Begin  
   If Len(@use1) > 0   
   Begin   
 Set @@wheretext = @@wheretext +  " And S.clienttype = '" + @use1 + "' "  
   End  
End  
---------------------------  Now We Will Decide About Join  We Will Always Provide From Party And Toparty -------------------------------------------  
  
If @consol = "family"  
Begin   
 Set @@wheretext =  @@wheretext + " And Family Between '" + @@fromfamily  + "' And '" + @@tofamily   +"'  "   
End  
If @consol = "trader"  
Begin  
 Set @@wheretext =  @@wheretext + " And  Trader Between '" + @@fromtrader  + "' And '" + @@totrader   +"' "   
End  
If @consol = "branch_cd"   
Begin  
 Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @@frombranch_cd  + "' And '" + @@tobranch_cd   +"' "   
End   
If @consol = "sub_broker"  
Begin   
 Set @@wheretext =  @@wheretext + " And S.Sub_broker Between '" + @@fromsub_broker  + "' And '" + @@tosub_broker   +"' "   
End  
If @consol = "region"   
Begin  
 Set @@wheretext =  @@wheretext + " And Region Between '" + @@fromregion  + "' And '" + @@toregion  +"' "   
End   
If @consol = "area"   
Begin  
 Set @@wheretext =  @@wheretext + " And  Area Between '" + @@fromarea  + "' And '" + @@toarea  +"' "   
End  
------------------------- Added For Access Control As Per User Login Status ---------------------------------------------------------------------------------------------  
  
  
If @statusid = "family"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Family Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If @statusid = "trader"  
Begin  
 Set @@wheretext =  @@wheretext + " And  Trader Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If (@statusid = "branch") OR (@statusid = "branch_cd")  
Begin  
 Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If (@statusid = "subbroker") OR (@statusid = "sub_broker")  
Begin  
 Set @@wheretext =  @@wheretext + " And S.Sub_broker Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If @statusid = "client"   
Begin  
 Set @@wheretext =  @@wheretext + " And Party_code Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = "region"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Region Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = "area"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Area Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = ""   
Begin  
 Set @@wheretext =  @@wheretext +   "  And 1 = 2 "   
End  
  
  
---------------------------   Decided About Join  -------------------------------------------  
Set @@wheretext = @@wheretext + " And  S.sett_type Between '" + @@fromsett_type + "'  And '" +  @@tosett_type  + "'"    
  
If @detail = "br"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'scf','icf','ir' )  "    
  
If @detail = "s"  
Begin  
   If @groupf <> "0"  
   Begin  
    Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'ir' )  "    
   End  
End  
  
If @detail = "po"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'sbf','scf','ir' )"    
  
If @detail = "tu"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'sbf','scf','ibf','icf','ir' )"    
  
/*null Chk For Where*/  
If @@wheretext Is Null Or Len(ltrim(rtrim(@@wheretext))) = 0  
Begin  
 Set @@wheretext = " Where 1=0"  
End  
  
Print @@selectflex   
Print @@selectbody   
Print @@fromtable   
Print @@wheretext   
Print @@mygroup  
Print @@myorder  
  
If @detail = "br"  
Exec (@@selectflex + @@selectbody+ @@fromtable + @@wheretext + @@mygroup + @@myorder)    
If @detail = "s"  
Exec (@@selectflex + @@selectbody+ @@fromtable + @@wheretext + @@mygroup + @@myorder)

GO
