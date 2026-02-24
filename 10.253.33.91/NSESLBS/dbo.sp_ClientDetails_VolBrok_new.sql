-- Object: PROCEDURE dbo.sp_ClientDetails_VolBrok_new
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE procedure sp_ClientDetails_VolBrok_new                               
@statusid   varchar(15) ,                               
@statusname varchar(25) ,                              
@BrCode     varchar(10) ,                              
@FromDate   Varchar(11) ,                               
@ToDate     Varchar(11)                               
                          
AS                              
                
set transaction isolation level read uncommitted                
        
--Exec sp_ClientDetails_VolBrok_new 'BROKER', 'BROKER', 'HO', 'Apr  1 2000', 'Aug 30 2005'        
                
Select distinct C2.Party_Code, C1.Long_Name , c1.cl_status , isnull(replace(c1.l_address1,',',''),'') l_address1 , isnull(replace(c1.l_address2,',',''),'') l_address2 , isnull(replace(c1.l_address3,',',''),'') l_address3 , c1.l_city, c1.l_zip,            
                 
C1.Branch_Cd, C1.Sub_broker, C1.Trader,                              
b1.long_name as brName , b2.long_name as rmName ,                            
Status = (Case When InActiveFrom <= GetDate() Then 'Inactive' Else 'Active  ' End),                               
convert(varchar(11),ActiveFrom,103) as ActiveFrom ,                               
convert(varchar(11),InActiveFrom,103) as InActiveFrom, Approver,          
        
FirstDate = (Select IsNull(min(Convert(DateTime,start_date)),'Jan  1 1900') From AccBill D       
    Where D.Party_Code=C2.Party_Code        
    ),                 
LastDate  = (Select IsNull(max(Convert(DateTime,end_date)),'Jan  1 1900') From AccBill D        
    Where D.Party_Code=C2.Party_Code        
    ),        
IntroBy=space(50),                
volume = C1.Credit_Limit,                
Brokerage= C1.Credit_Limit                
                 
into #CltReport                             
From Client1 C1, Client5 C5, Client2 C2,           
branch b1, branches b2          
                
Where C1.Cl_Code = C2.Cl_Code                           
And C1.Cl_Code = C5.Cl_Code                             
AND c1.branch_cd = b1.branch_code                           
and c1.trader= b2.short_name                          
--and c1.branch_cd= b2.branch_cd                          
AND C1.Branch_Cd Like (Case When @BrCode = '1' Then '%' Else @BrCode End)                              
And ActiveFrom >= @FromDate And ActiveFrom <= @Todate + ' 23:59'                              
And C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)                              
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)                              
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)                              
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)                              
And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)                              
                
Update #CltReport Set    volume=0,    Brokerage = 0                 
                
          
/*                
  --Fetching First Date & Last Date for the client                 
    Update #CltReport Set FirstDate = IsNull((Select Min(Convert(DateTime,Sauda_date))                               
                                       From Details S Where S.Party_Code = #CltReport.Party_Code ),'Jan  1 1900')                              
                
                
                
   Update #CltReport Set LastDate = IsNull((Select Max(Convert(DateTime,Sauda_date))                               
                                       From Details S Where S.Party_Code = #CltReport.Party_Code ),'Jan  1 1900')                              
 --Fetching VOLUME & BROKERGAE for the client.                 
                
Update #cltReport                             
Set Volume = isnull((select sum(tradeqty*dummy1)                             
    FROM settlement s                            
    Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
    sauda_date <= @ToDate),0),                            
                            
Brokerage = isnull((select sum(nbrokapp*tradeqty)                             
   FROM settlement s                            
   Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
   sauda_date <= @ToDate),0)                       
                      
-------------------------               
                      
Update #cltReport                             
Set Volume = isnull(#cltReport.Volume,0) + (isnull((select sum(tradeqty*dummy1)                             
      FROM Isettlement s                            
      Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
      sauda_date <= @ToDate),0)),                                    
Brokerage = isnull(#cltReport.Brokerage,0) + (isnull((select sum(nbrokapp*tradeqty)                             
      FROM Isettlement s                            
      Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
      sauda_date <= @ToDate),0))                       
        
*/        
        
/*        
Update #cltReport Set FirstDate = (Select IsNull(Min(Convert(DateTime,Sauda_date)),'')                               
                                       From Details S Where S.Party_Code = #CltReport.Party_Code )        
          
Update #cltReport Set LastDate = (Select IsNull(Max(Convert(DateTime,Sauda_date)),'')        
                                       From Details S Where S.Party_Code = #CltReport.Party_Code)        
          
*/          
            
Select sum(tradeqty*dummy1)Volume,s.Party_Code                             
into #Volume                
FROM settlement s    , #CltReport                        
Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
sauda_date <= @ToDate  +' 23:59'               
Group by s.Party_Code                
                
Insert into #Volume                
Select sum(tradeqty*dummy1)Volume,s.Party_Code                             
FROM isettlement s ,#CltReport                
Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
sauda_date <= @ToDate    +' 23:59'                      
Group by s.Party_Code                
                
Select sum(nbrokapp*tradeqty)Brokerage,s.Party_Code                             
into #Brokerage                
FROM settlement s  ,#CltReport                          
Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
sauda_date <= @ToDate  +' 23:59'                        
Group by s.Party_Code                
                
Insert into #Brokerage                
Select sum(nbrokapp*tradeqty)Brokerage,s.Party_Code                             
FROM isettlement s ,#CltReport                
Where s.party_code = #CltReport.Party_Code and sauda_date >= @FromDate and                             
sauda_date <= @ToDate   +' 23:59'                       
Group by s.Party_Code                
                
Select sum(Volume)Volume,Party_Code                
Into #Volume1                
From #Volume                
Group by Party_Code                
                
                
Select sum(Brokerage)Brokerage,Party_Code                
Into #Brokerage1                
From #Brokerage                
Group by Party_Code                
          
                
update #cltReport Set Volume = #Volume1.Volume From #Volume1 where #Volume1.Party_Code = #cltReport.Party_Code                
update #cltReport Set Brokerage = #Brokerage1.Brokerage From #Brokerage1 where #Brokerage1.Party_Code = #cltReport.Party_Code                
          
                
Update #cltReport Set IntroBy = C1.Long_Name
From remissor_master r,client1 c1
where #CltReport.party_code = r.party_code                             
and c1.cl_code = r.remcode             
and r.fromdate >= @FromDate                              
and r.transtype like 'TRD'        
and r.todate like 'Dec 31 2049%'                          
                            
            
Select Party_Code, Long_Name, cl_status, replace(l_address1,',','') as l_address1, 
replace(l_address2, ',', '') as l_address2, replace(l_address3, ',', '') as l_address3, replace(l_city, ',', '') as l_city, l_zip, Branch_Cd, Sub_broker, Trader, Status,  brName, rmName,                             
ActiveFrom,InActiveFrom,Approver,                             
Left(convert(varchar,FirstDate,103),11) as FirstDate,                        
Left(convert(varchar,LastDate,103),11) as LastDate , Volume, Brokerage , IntroBy                       
From #CltReport                              
Order By Branch_Cd, Long_Name

GO
