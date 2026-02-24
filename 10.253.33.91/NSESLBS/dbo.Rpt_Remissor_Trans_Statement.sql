-- Object: PROCEDURE dbo.Rpt_Remissor_Trans_Statement
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_Remissor_Trans_Statement        
(@FromDate Varchar(11), @ToDate Varchar(11), @FromRemCode Varchar(10), @ToRemCode Varchar(10),@Flag Varchar(1),        
@statusid varchar(15),@statusname varchar(25))        
As        
If Upper(@Flag) = 'D'         
Begin        
 Select RemCode, RemName=R1.Long_Name,R.Party_Code, Party_Name=C1.Long_Name,SharingType,        
 Start_Date=Convert(Varchar,Start_Date,103),        
 TrdBrk=Sum(Case When TransType = 'TRD' Then ClientTrdBrokerage Else 0 End),        
 DelBrk=Sum(Case When TransType = 'DEL' Then ClientDelBrokerage Else 0 End),        
 TrdTurnOver=Sum(Case When TransType = 'TRD' Then TrdTurnOver Else 0 End),        
 DelTurnOver=Sum(Case When TransType = 'DEL' Then DelTurnOver Else 0 End),        
 TrdSharing=max(Case When TransType = 'TRD' Then Sharing Else 0 End),        
 DelSharing=max(Case When TransType = 'DEL' Then Sharing Else 0 End),        
 TrdRemSharing=sum(Case When TransType = 'TRD' Then RemShareBrokeRage Else 0 End),        
 DelRemSharing=sum(Case When TransType = 'DEL' Then RemShareBrokeRage Else 0 End),        
 TotalRemSharing=Sum(RemShareBrokeRage),         
 TrdCharge = Max(Case When TransType = 'TRD' Then Charges Else 0 End),        
 DelCharge = Max(Case When TransType = 'DEL' Then Charges Else 0 End),        
 DD=Day(Start_Date), MM=Month(Start_Date), YY=Year(Start_Date),      
 Service_Tax = Round(Sum(RemShareBrokeRage*Service_Tax) / 100,2)       
 from Remissor_Trans_Temp R, Client1 C1, Client2 C2, Client1 R1, Client2 R2, Sett_Mst S, Globals G        
 Where R.Party_Code = C2.Party_Code        
 And C1.Cl_Code = C2.Cl_Code        
 And R.RemCode = R2.Party_Code        
 And R1.Cl_Code = R2.Cl_Code        
 And S.Sett_No = R.Sett_No        
 And S.Sett_Type = R.Sett_Type        
 And Start_Date >= @FromDate        
 And Start_Date <= @ToDate + ' 23:59:59'        
 And RemCode >= @FromRemCode         
 And RemCode <= @ToRemCode        
 And Start_Date Between Year_Start_Dt And Year_End_Dt      
 And @StatusName = 
                  (case 
                        when @StatusId = 'BRANCH' then c1.branch_cd
                        when @StatusId = 'SUBBROKER' then c1.sub_broker
                        when @StatusId = 'Trader' then c1.Trader
                        when @StatusId = 'Family' then c1.Family
                        when @StatusId = 'Area' then c1.Area
                        when @StatusId = 'Region' then c1.Region
                        when @StatusId = 'Client' then c2.party_code
                  else 
                        'BROKER'
                  End)                     
 Group By RemCode,R1.Long_Name,R.Party_Code,C1.Long_Name,SharingType,Convert(Varchar,Start_Date,103),        
 Day(Start_Date), Month(Start_Date), Year(Start_Date)        
 Order BY RemCode,R.Party_Code, Day(Start_Date), Month(Start_Date), Year(Start_Date)        
End        
Else If Upper(@Flag) = 'T'            
Begin        
 Select RemCode, RemName=R1.Long_Name,Party_Code=RemCode, Party_Name=R1.Long_Name,        
 TrdBrk=Sum(Case When TransType = 'TRD' Then ClientTrdBrokerage Else 0 End),        
 DelBrk=Sum(Case When TransType = 'DEL' Then ClientDelBrokerage Else 0 End),        
 TrdTurnOver=Sum(Case When TransType = 'TRD' Then TrdTurnOver Else 0 End),        
 DelTurnOver=Sum(Case When TransType = 'DEL' Then DelTurnOver Else 0 End),        
 TrdSharing=max(Case When TransType = 'TRD' Then Sharing Else 0 End),        
 DelSharing=max(Case When TransType = 'DEL' Then Sharing Else 0 End),        
 TrdRemSharing=sum(Case When TransType = 'TRD' Then RemShareBrokeRage Else 0 End),        
 DelRemSharing=sum(Case When TransType = 'DEL' Then RemShareBrokeRage Else 0 End),        
 TotalRemSharing=Sum(RemShareBrokeRage),         
 TrdCharge = Max(Case When TransType = 'TRD' Then Charges Else 0 End),        
 DelCharge = Max(Case When TransType = 'DEL' Then Charges Else 0 End),      
 Service_Tax = Round(Sum(RemShareBrokeRage*Service_Tax) / 100,2)       
 from Remissor_Trans_temp R, Client1 C1, Client2 C2, Client1 R1, Client2 R2, Sett_Mst S, Globals G        
 Where R.Party_Code = C2.Party_Code        
 And C1.Cl_Code = C2.Cl_Code        
 And R.RemCode = R2.Party_Code     
 And R1.Cl_Code = R2.Cl_Code        
 And S.Sett_No = R.Sett_No        
 And S.Sett_Type = R.Sett_Type        
 And Start_Date >= @FromDate        
 And Start_Date <= @ToDate + ' 23:59:59'        
 And RemCode >= @FromRemCode         
 And RemCode <= @ToRemCode        
 And Start_Date Between Year_Start_Dt And Year_End_Dt      
 And @StatusName = 
                  (case 
                        when @StatusId = 'BRANCH' then c1.branch_cd
                        when @StatusId = 'SUBBROKER' then c1.sub_broker
                        when @StatusId = 'Trader' then c1.Trader
                        when @StatusId = 'Family' then c1.Family
                        when @StatusId = 'Area' then c1.Area
                        when @StatusId = 'Region' then c1.Region
                        when @StatusId = 'Client' then c2.party_code
                  else 
                        'BROKER'
                  End)                     
 Group By RemCode,R1.Long_Name    
 Order BY RemCode        
End      
Else        
Begin        
 Select RemCode, RemName=R1.Long_Name,R.Party_Code, Party_Name=C1.Long_Name,SharingType,        
 TrdBrk=Sum(Case When TransType = 'TRD' Then ClientTrdBrokerage Else 0 End),        
 DelBrk=Sum(Case When TransType = 'DEL' Then ClientDelBrokerage Else 0 End),        
 TrdTurnOver=Sum(Case When TransType = 'TRD' Then TrdTurnOver Else 0 End),        
 DelTurnOver=Sum(Case When TransType = 'DEL' Then DelTurnOver Else 0 End),        
 TrdSharing=max(Case When TransType = 'TRD' Then Sharing Else 0 End),        
 DelSharing=max(Case When TransType = 'DEL' Then Sharing Else 0 End),        
 TrdRemSharing=sum(Case When TransType = 'TRD' Then RemShareBrokeRage Else 0 End),        
 DelRemSharing=sum(Case When TransType = 'DEL' Then RemShareBrokeRage Else 0 End),        
 TotalRemSharing=Sum(RemShareBrokeRage),         
 TrdCharge = Max(Case When TransType = 'TRD' Then Charges Else 0 End),        
 DelCharge = Max(Case When TransType = 'DEL' Then Charges Else 0 End),      
 Service_Tax = Round(Sum(RemShareBrokeRage*Service_Tax) / 100,2)       
 from Remissor_Trans_temp R, Client1 C1, Client2 C2, Client1 R1, Client2 R2, Sett_Mst S, Globals G        
 Where R.Party_Code = C2.Party_Code        
 And C1.Cl_Code = C2.Cl_Code        
 And R.RemCode = R2.Party_Code        
 And R1.Cl_Code = R2.Cl_Code        
 And S.Sett_No = R.Sett_No        
 And S.Sett_Type = R.Sett_Type        
 And Start_Date >= @FromDate        
 And Start_Date <= @ToDate + ' 23:59:59'        
 And RemCode >= @FromRemCode         
 And RemCode <= @ToRemCode        
 And Start_Date Between Year_Start_Dt And Year_End_Dt      
 And @StatusName = 
                  (case 
                        when @StatusId = 'BRANCH' then c1.branch_cd
                        when @StatusId = 'SUBBROKER' then c1.sub_broker
                        when @StatusId = 'Trader' then c1.Trader
                        when @StatusId = 'Family' then c1.Family
                        when @StatusId = 'Area' then c1.Area
                        when @StatusId = 'Region' then c1.Region
                        when @StatusId = 'Client' then c2.party_code
                  else 
                        'BROKER'
                  End)          
 Group By RemCode,R1.Long_Name,R.Party_Code,C1.Long_Name,SharingType        
 Order BY RemCode,R.Party_Code        
End

GO
