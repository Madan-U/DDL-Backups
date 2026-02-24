-- Object: PROCEDURE dbo.SaudaReport_withoutclient_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--EXEC SaudaReport_withoutclient_New '','','','Jun  1 2007','Oct  8 2007','','','0A141','0A149','','','PARTY_CODE','1','broker','broker'

CREATE  Proc [dbo].[SaudaReport_withoutclient_New]
(

	@Sett_no Varchar(10),			---7  Settlement No(From)
	@Tosett_No Varchar(10),			---8  Settlement No (To)
	@Sett_type Varchar(3),			---9  Settlement Type 
	@Sauda_date Varchar(11),       		---4  Sauda_date (From)
	@ToDate Varchar(11),			---4  Sauda_date (To)
	@fromFamily varchar(20),		---5  Family (From)
	@toFamily varchar(20),			---5  Family (To)
	@FromParty Varchar(20),			---6  Consol (From)	
	@ToParty Varchar (20),			---6  Consol (To)	
	@FromScrip Varchar(12),			---7  Scrip	Cd (From)
	@ToScrip Varchar(12),			---7  Scrip	Cd (To)
	@Consol Varchar(10),			---8  This Is Used For Selection Criteria -'Party_code' Or 'Family'
	@Groupby Varchar(10),			---12 This Is Used For Order By Clause
	@StatusID VarChar(20),			---13 longin Id
	@StatusName VarChar(50)			---14 longin Name
)

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
        
If (@Consol = "PARTY_CODE") And  ((@FromParty <> "") And (@ToParty <> "" ) )
Begin        
          Select @@FromParty_Code = @FromParty        
          Select @@ToParty_Code = @ToParty         
          Select @@FromFamily = Min(Family)  , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code  and Client2.Party_Code between @@FromParty_code  And @@ToParty_code        
End

else If (@Consol = "PARTY_CODE") And  ((@FromParty = "") And (@ToParty = "" ) )
Begin                  
          Select @@FromParty_code = Min(Party_code) , @@ToParty_code = Max(Party_code), @@FromFamily = Min(Family) , @@ToFamily = Max(Family) From Client2, Client1  Where  Client2.Cl_code = Client1.Cl_code
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
         Select @sett_no = Min(Sett_no),@Tosett_no=Max(Sett_no) from  Details   where convert(datetime,sauda_date,103)  Between @sauda_date   And @todate + ' 23:59:00'       
        
If ( (@Sett_no = "" ) )         
         Select @sett_no = Min(Sett_no) from  Details  where convert(datetime,sauda_date,103) Between @sauda_date   And @todate + ' 23:59:00'        
        
If ( (@ToSett_no = "" ) )         
         Select @Tosett_no=Max(Sett_no) from  Details  where convert(datetime,sauda_date,103) Between @sauda_date   And @todate + ' 23:59:00'        

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
End
),
        
@Todate = (Case When Convert(DateTime,@Sauda_Date) > Convert(DateTime,@Todate)

	Then @Sauda_Date
	Else @Todate

End
)
        
/*        
Select @sett_no = (Case When @sett_no > @@toSett_no         
            Then @toSett_no        
            Else @Sett_No         
          End),        
@toSett_no = (Case When @sett_no > @@toSett_no         
            Then @Sett_no        
            Else @toSett_no         
          End)        
*/        
        
begin
if @Groupby = '1'         
 begin        
        
 select sett_no,sett_type,s.party_code,replace(long_Name,"'","") as party_name,scrip_cd,series,PTradedqty=Sum(Pqty),
PtradedAmt=convert(Numeric(20, 2),Sum(Pamt)),        
 STradedQty=Sum(Sqty),STradedAmt=convert(Numeric(20, 2),Sum(Samt)),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=convert(Numeric(20, 2),Sum(Pamt)-Sum(SAmt)),        
 sum(convert(numeric(20, 4),Pmarketrate)) "Pmarketrate", sum(convert(numeric(20 ,4),Pnetrate)) "Pnetrate", sum(convert(numeric(20, 4),Smarketrate)) "Smarketrate", sum(convert(numeric(20 ,4),Snetrate)) "SNetrate" 
,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip        
 from SaudaReportNormal s,Client1 C1,Client2 c2 where         
 S.Sett_no Between @sett_no And @toSett_no        
  And  S.Sett_type like @@sett_type  +'%'        
 and c1.family between @@fromFamily and @@toFamily        
 and c1.cl_code = c2.cl_code and c2.party_code = s.party_code        
 And S.Party_code Between @@fromParty_code And @@toParty_Code        
 And S.Scrip_cd Between @fromscrip And  @toScrip         
 --and SDate >= @sauda_date and Sdate <= @todate        
 and convert(datetime,S.Sdate)   Between @sauda_date   And @todate + ' 23:59:00'         
  /*LOGIN CONDITIONS*/        
  and c1.branch_cd LIKE (Case When @StatusID  = 'branch' Then  @StatusName  Else '%' End)         
  and  c1.sub_broker LIKE (Case When  @StatusID  = 'subbroker' Then @StatusName  Else '%' End)         
  and  c1.trader LIKE (Case When  @StatusID = 'trader' Then  @StatusName Else '%' End)        
  and  c1.family LIKE (Case When  @StatusID  = 'family' Then  @StatusName Else '%' End)        
  and  c2.party_code LIKE (Case When  @StatusID = 'client' Then  @StatusName Else '%' End)        
  /*END LOGIN CONDITIONS*/        
 Group by sett_no,
sett_type,
s.party_code,
long_Name,
scrip_cd,
series ,
L_Address1,
L_Address2,
L_city,
L_State,
L_Nation,
L_Zip       
order by s.party_code,Scrip_Cd
compute sum(Sum(Pqty)),sum(convert(Numeric(20, 2),Sum(Pamt))),sum(Sum(sqty)),sum(convert(Numeric(20, 2),Sum(samt))),sum(Sum(Pqty)-Sum(Sqty)),Sum(convert(Numeric(20, 2),Sum(Pamt)-Sum(SAmt))) 
by s.party_code
          
 end         
else        
 begin        
        
 select sett_no,sett_type,s.party_code,replace(long_Name,"'","") as party_name,scrip_cd,series,PTradedqty=Sum(Pqty),
PtradedAmt=convert(Numeric(20, 2),Sum(Pamt)),        
 STradedQty=Sum(Sqty),STradedAmt=convert(Numeric(20, 2),Sum(Samt)),Nqty=Sum(Pqty)-Sum(Sqty),NAmt=convert(Numeric(20, 2),Sum(Pamt)-Sum(SAmt)),        
 sum(convert(numeric(20, 4),Pmarketrate)) "Pmarketrate", sum(convert(numeric(20 ,4),Pnetrate)) "Pnetrate", sum(convert(numeric(20, 4),Smarketrate)) "Smarketrate", sum(convert(numeric(20, 4),Snetrate)) "SNetrate" ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip        
 from SaudaReportNormal s,Client1 C1,Client2 c2 where S.Sett_no Between @sett_no And @toSett_no        
  And  S.Sett_type like @@sett_type  +'%'        
 and c1.family between @@fromFamily and @@toFamily        
 and c1.cl_code = c2.cl_code and c2.party_code = s.party_code        
 And S.Party_code Between @@fromParty_code And @@toParty_Code        
 And S.Scrip_cd Between @fromscrip And  @toScrip         
 --and SDate >= @sauda_date and Sdate <= @todate        
 and convert(datetime,S.Sdate)  Between @sauda_date   And @todate + ' 23:59:00'         
  /*LOGIN CONDITIONS*/        
  and c1.branch_cd LIKE (Case When @StatusID  = 'branch' Then  @StatusName  Else '%' End)         
  and  c1.sub_broker LIKE (Case When  @StatusID  = 'subbroker' Then @StatusName  Else '%' End)         
  and  c1.trader LIKE (Case When  @StatusID = 'trader' Then  @StatusName Else '%' End)        
  and  c1.family LIKE (Case When  @StatusID  = 'family' Then  @StatusName Else '%' End)        
  and  c2.party_code LIKE (Case When  @StatusID = 'client' Then  @StatusName Else '%' End)        
  /*END LOGIN CONDITIONS*/        
 Group by sett_no,sett_type,s.party_code,long_Name,scrip_cd,series ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip        
 order by Scrip_Cd, series,  s.party_code        
compute sum(Sum(Pqty)), sum(convert(Numeric(20, 2),Sum(Pamt))),sum(Sum(sqty)), sum(convert(Numeric(20, 2),Sum(samt))),sum(Sum(Pqty)-Sum(Sqty)),Sum(convert(Numeric(20, 2),Sum(Pamt)-Sum(SAmt))) 
by scrip_cd, series
        
 end         
end

GO
