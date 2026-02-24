-- Object: PROCEDURE dbo.SaudaReport_withoutclient_Parent
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--EXEC SaudaReport_withoutclient_Parent '', '', 'N', 'Dec 21 2006', 'Dec 21 2009', '', '', '0A141', '0A149', '', '', 'PARTY_CODE', '1','broker', 'broker' 


CREATE  Proc [dbo].[SaudaReport_withoutclient_Parent]  
(         
@Sett_no Varchar(10),    
@Tosett_No Varchar(10),  
@Sett_type Varchar(3),   
@Sauda_date Varchar(11),  
@ToDate Varchar(11),     
@fromFamily varchar(20),  
@toFamily varchar(20),    
@FromParty Varchar(20),   
@ToParty Varchar (20),    
@FromScrip Varchar(12),   
@ToScrip Varchar(12),     
@Consol Varchar(10),      
@Groupby Varchar(10),     
@StatusID VarChar(20),    
@StatusName VarChar(50))  
as         
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
Declare        
@@Getstyle as Cursor,        
@@FromSett_no As Varchar(10),        
@@ToSett_no As Varchar(10),        
@@Fromparty_code as varchar(10),        
@@Toparty_code  As Varchar(10),        
@@Sett_type As Varchar(3),        
@@FromFamily As varchar(10),        
@@ToFamily  As Varchar(10)        


--- ADDED ON 25TH JUNE 2009 BY MEGHA JADHAV--------
SET @Sauda_date = CONVERT(VARCHAR(11),CONVERT(DATETIME,@Sauda_date,103),109)
SET @ToDate = CONVERT(VARCHAR(11),CONVERT(DATETIME,@ToDate,103),109)
--- ADDED ON 25TH JUNE 2009 BY MEGHA JADHAV--------


If (@Consol = "PARTY_CODE") And  ((@FromParty <> "") And (@ToParty <> "" ) )         
Begin        
          Select @@FromParty_Code = @FromParty        
          Select @@ToParty_Code = @ToParty         
          Select @@FromFamily = Min(Family)  , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code  and Client2.Party_Code between @@FromParty_code  And @@ToParty_code        
End        
else If (@Consol = "PARTY_CODE") And  ((@FromParty = "") And (@ToParty = "" ) )         
Begin                  
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromFamily = Min(Family) , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code         
/*      Select @@ToParty_code =  Max(Party_code) ,@@FromParty_code = Min(Party_code) From Details */        
End        
        
If (@Consol = "FAMILY") And  ((@fromFamily <> "") And (@ToFamily <> "" ) )         
Begin        
          Select @@FromFamily = @fromFamily        
          Select @@ToFamily = @ToFamily         
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code and Client1.Family between @@FromFamily  And @@ToFamily        
End        
else If (@Consol = "FAMILY") And  ((@fromFamily = "") And (@toFamily = "" ) )         
Begin                  
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromFamily = Min(Family) , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code         
End        
        
If @Sett_type  <>  "%" And @Sett_Type <> ''         
Begin        
     Select @@Sett_type = @Sett_type        
End        
        
If (@Sett_type  =  "%" Or @Sett_Type = '' )        
Begin        
      Select @@Sett_type = "%"        
End        
        
        
If  ( (@FromScrip = "") And  (@ToScrip = "") )        
   Select @FromScrip = Min(scrip_cd) ,@ToScrip = Max(scrip_cd) From Scrip2        
        
If (@FromScrip = "")        
   Select @FromScrip = Min(scrip_cd) From Scrip2        
        
If (@ToScrip = "")        
   Select @ToScrip = Max(scrip_cd) From Scrip2        
        
        
        
        
If ( (@Sett_no = "" ) And (@ToSett_no = "" ) )         
         Select @sett_no = Min(Sett_no),@Tosett_no=Max(Sett_no) from Sett_Mst where convert(datetime,Start_Date,103) Between @sauda_date And @todate + ' 23:59:00'       
        
If ( (@Sett_no = "" ) )         
         Select @sett_no = Min(Sett_no) from  Sett_Mst where convert(datetime,Start_Date,103) Between @sauda_date And @todate + ' 23:59:00'        
        
If ( (@ToSett_no = "" ) )         
         Select @Tosett_no=Max(Sett_no) from  Sett_Mst where convert(datetime,Start_Date,103) Between @sauda_date And @todate + ' 23:59:00'        
      
      
        
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
        
If ( @Sauda_date  = "" )         
Begin        
        Select @Sauda_date = Min(Start_date) from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End        
        
If ( @Todate  = "" )         
Begin        
        Select @Todate = End_date from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End        
        
Select @Sauda_Date = (Case When Convert(DateTime,@Sauda_Date) > Convert(DateTime,@Todate)         
               Then @Todate        
               Else @Sauda_Date        
            End),         
@Todate = (Case When Convert(DateTime,@Sauda_Date) > Convert(DateTime,@Todate)         
          Then @Sauda_Date        
          Else @Todate        
        End)        

/*
Print '@sett_no : ' + @sett_no 
Print '@toSett_no : ' + @toSett_no        
Print '@@sett_type : ' + @@sett_type
Print '@@fromFamily : ' + @@fromFamily
Print '@@toFamily : ' + @@toFamily        
Print '@@fromParty_code : ' + @@fromParty_code
Print '@@toParty_Code : ' + @@toParty_Code        
Print '@fromscrip : ' + @fromscrip 
Print '@toScrip : ' + @toScrip         
Print '@sauda_date : ' + @sauda_date
Print '@todate : ' + @todate
*/
        

begin

CREATE TABLE #SETT
	(
	sett_no VARCHAR(12),
	sett_type VARCHAR(2),
	Party_Code VARCHAR(15),
	party_name VARCHAR(100), 
	scrip_cd VARCHAR(20),
	series VARCHAR(5),
	PTradedqty INT,
	PtradedAmt MONEY,
	STradedQty INT,
	STradedAmt MONEY,
	Nqty INT,
	NAmt MONEY,
	Pmarketrate MONEY, 
	Pnetrate MONEY, 
	Smarketrate MONEY, 
	Snetrate MONEY, 
	L_Address1 VARCHAR(100),
	L_Address2 VARCHAR(100),
	L_city VARCHAR(25),
	L_State VARCHAR(20),
	L_Nation VARCHAR(20),
	L_Zip VARCHAR(10)
	)

if @Groupby = '1'         
 begin        
 Insert Into #SETT
 select sett_no,sett_type,Party_Code=C2.ParentCode,
 party_name = SPACE(100), scrip_cd,series,PTradedqty=Sum(Pqty),PtradedAmt=Sum(Pamt),        
 STradedQty=Sum(Sqty),STradedAmt=Sum(Samt),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=Sum(PAMT)-Sum(SAmt),        
 Pmarketrate=(CASE WHEN SUM(PQTY) > 0 
				   THEN SUM(PQTY*PMARKETRATE)/SUM(PQTY)
				   ELSE 0 
			  END), 
 Pnetrate  =(CASE WHEN SUM(PQTY) > 0 
				   THEN SUM(PQTY*Pnetrate)/SUM(PQTY)
				   ELSE 0 
			  END), 
 Smarketrate = (CASE WHEN SUM(SQTY) > 0 
				   THEN SUM(SQTY*SMARKETRATE)/SUM(SQTY)
				   ELSE 0 
			  END), 
 Snetrate = (CASE WHEN SUM(SQTY) > 0 
				   THEN SUM(SQTY*Snetrate)/SUM(SQTY)
				   ELSE 0 
			  END), 
 L_Address1 = SPACE(100),L_Address2 = SPACE(100),L_city = SPACE(25),L_State=SPACE(20),
 L_Nation = SPACE(20),L_Zip = SPACE(10)        
 from SaudaReportNormal s,Client1 C1,Client2 c2 
 where         
 c1.cl_code = c2.cl_code 
 And c2.party_code = s.party_code
 --And C2.Party_Code = C2.ParentCode
 And S.Sett_no Between @sett_no And @toSett_no        
 And S.Sett_type like @@sett_type  +'%'        
 and c1.family between @@fromFamily and @@toFamily        
 And C2.ParentCode Between @@fromParty_code And @@toParty_Code        
 And S.Scrip_cd Between @fromscrip And  @toScrip         
 --and SDate >= @sauda_date and Sdate <= @todate        
 and convert(datetime,S.Sdate)   Between @sauda_date   And @todate + ' 23:59:00'         
  /*LOGIN CONDITIONS*/        
  and c1.branch_cd LIKE (Case When @StatusID  = 'branch' Then  @StatusName  Else '%' End)         
  and  c1.sub_broker LIKE (Case When  @StatusID  = 'subbroker' Then @StatusName  Else '%' End)         
  and  c1.trader LIKE (Case When  @StatusID = 'trader' Then  @StatusName Else '%' End)        
  and  c1.family LIKE (Case When  @StatusID  = 'family' Then  @StatusName Else '%' End)        
  and  c2.party_code LIKE (Case When  @StatusID = 'client' Then  @StatusName Else '%' End)        
  and  c1.Area LIKE (Case When  @StatusID  = 'Area' Then  @StatusName Else '%' End)        
  and  c1.Region LIKE (Case When  @StatusID  = 'Region' Then  @StatusName Else '%' End)        
  /*END LOGIN CONDITIONS*/        
 Group by sett_no,
	sett_type,
	C2.ParentCode,
	scrip_cd,
	series
 order by 	C2.ParentCode,Scrip_Cd        
        
          
 end         
else        
 begin        
       
 Insert Into #SETT
 select sett_no,sett_type,Party_Code=C2.ParentCode,
 party_name = SPACE(100),scrip_cd,series,PTradedqty=Sum(Pqty),PtradedAmt=Sum(Pamt),        
 STradedQty=Sum(Sqty),STradedAmt=Sum(Samt),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=Sum(PAMT)-Sum(SAmt),        
 Pmarketrate=(CASE WHEN SUM(PQTY) > 0 
				   THEN SUM(PQTY*PMARKETRATE)/SUM(PQTY)
				   ELSE 0 
			  END), 
 Pnetrate  =(CASE WHEN SUM(PQTY) > 0 
				   THEN SUM(PQTY*Pnetrate)/SUM(PQTY)
				   ELSE 0 
			  END), 
 Smarketrate = (CASE WHEN SUM(SQTY) > 0 
				   THEN SUM(SQTY*SMARKETRATE)/SUM(SQTY)
				   ELSE 0 
			  END), 
 Snetrate = (CASE WHEN SUM(SQTY) > 0 
				   THEN SUM(SQTY*Snetrate)/SUM(SQTY)
				   ELSE 0 
			  END), 
 L_Address1 = SPACE(100),L_Address2 = SPACE(100),L_city = SPACE(25),L_State=SPACE(20),
 L_Nation = SPACE(20),L_Zip = SPACE(10)        
 from SaudaReportNormal s,Client1 C1,Client2 c2 
 where 
 c1.cl_code = c2.cl_code and c2.party_code = s.party_code
 --And C2.ParentCode = C2.Party_Code
 And S.Sett_no Between @sett_no And @toSett_no        
 And S.Sett_type like @@sett_type  +'%'        
 and c1.family between @@fromFamily and @@toFamily        
 And C2.ParentCode Between @@fromParty_code And @@toParty_Code        
 And S.Scrip_cd Between @fromscrip And  @toScrip         
 --and SDate >= @sauda_date and Sdate <= @todate        
 and convert(datetime,S.Sdate)  Between @sauda_date   And @todate + ' 23:59:00'         
  /*LOGIN CONDITIONS*/        
  and c1.branch_cd LIKE (Case When @StatusID  = 'branch' Then  @StatusName  Else '%' End)         
  and  c1.sub_broker LIKE (Case When  @StatusID  = 'subbroker' Then @StatusName  Else '%' End)         
  and  c1.trader LIKE (Case When  @StatusID = 'trader' Then  @StatusName Else '%' End)        
  and  c1.family LIKE (Case When  @StatusID  = 'family' Then  @StatusName Else '%' End)        
  and  c2.party_code LIKE (Case When  @StatusID = 'client' Then  @StatusName Else '%' End)        
  and  c1.Area LIKE (Case When  @StatusID  = 'Area' Then  @StatusName Else '%' End)        
  and  c1.Region LIKE (Case When  @StatusID  = 'Region' Then  @StatusName Else '%' End)        
  /*END LOGIN CONDITIONS*/        
 Group by sett_no,sett_type,C2.ParentCode,scrip_cd,series
 order by Scrip_Cd ,  C2.ParentCode        
        
 end         
end

UPDATE #SETT SET
	party_name	= C1.LONG_NAME,
	L_Address1	= C1.L_Address1,
	L_Address2	= C1.L_Address2,
	L_city		= C1.L_city,
	L_State		= C1.L_State,
	L_Nation	= C1.L_Nation,
	L_Zip		= C1.L_Zip
FROM CLIENT1 C1 (NOLOCK)
WHERE #SETT.PARTY_CODE = C1.CL_CODE

SELECT * FROM #SETT

DROP TABLE #SETT

GO
