-- Object: PROCEDURE dbo.sp_StockRegister
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure sp_StockRegister                     
(        
@fromDate varchar(11),         
@toDate varchar(11),         
@fromParty varchar(10),         
@toParty varchar(10),         
@fromScrip varchar(12),         
@toScrip varchar(12),             
@DpID varchar(10),         
@ClientID Varchar(15),         
@ReportLevel varchar(5),        
@FromSettNo varchar(10),                  
@ToSettNo varchar(10)                  
)                    
            
As                    
            
/*If @ReportLevel = 'MNO'            
Begin            
*/            
        
If @FromSettNo = ''        
Begin        
   Set @FromSettNo = '00000000'        
End        
        
If @ToSettNo = ''        
Begin        
   Set @ToSettNo = '99999999'        
End        
    
    
SELECT * INTO #DELTRANS FROM DELTRANS D    
WHERE d.Sett_No >= @FromSettNo and d.Sett_No <= @ToSettNo     
AND d.Party_Code >= @fromParty and d.Party_Code <= @toParty                    
And d.Scrip_Cd >= @fromScrip and d.Scrip_Cd <= @toScrip            
AND FILLER2 = 1     
AND TRTYPE <> 906    
AND PARTY_CODE <> 'BROKER'    
AND CERTNO LIKE 'IN%'    
And d.TransDate >= @fromDate and d.TransDate <= @toDate        
And D.BDpID Like @DpID +'%'              
And D.BCltDpId Like @ClientID +'%'    
    
           
Select                  
d.Party_Code as Party_Code, TransDate as sdate,                    
PurQty = Sum(Case When DrCr = 'D' Then Qty Else 0 End),                      
ExeDate = (Case When DrCr = 'D' Then Convert(Varchar,TransDate,103) Else '' End),                     
SellQty = Sum(Case When DrCr = 'C' Then Qty Else 0 End),                    
RecDate = (Case When DrCr = 'C' Then Convert(Varchar,TransDate,103) Else '' End),            
Purpose = (Case when DrCr = 'D' Then 'Payout ' + D.SETT_NO + '-' + D.SETT_TYPE Else             
  (Case when DrCr = 'C' Then 'Payin ' + D.SETT_NO + '-' + D.SETT_TYPE Else '' End)             
  End),            
Balance = 0,          
d.Scrip_Cd as Scrip_CD,                    
s1.long_name as ScripName,          
c1.Long_Name as Long_Name            
From #DELTRANS d, Sett_Mst S, client1 c1, client2 c2 , scrip1 s1, scrip2 s2                    
Where S.Sett_No = D.Sett_No                    
And S.Sett_Type = D.Sett_Type                    
And c2.cl_code = c1.cl_code                    
And d.party_code = c2.party_code                    
And d.scrip_cd = s2.scrip_cd                    
And d.series = s1.series                    
And s2.co_code = s1.co_code                    
And CertNo Like 'IN%'                    
And Filler2 = 1             
--And Delivered <> (Case When DrCr = 'C' Then '' Else '0' End)                    
And TrType <> 906             
--And d.Party_Code <> 'BROKER'                    
And CltDpId Not In (Select DpCltNo From DeliveryDp Dp Where D.DpId =Dp.DpId And D.CltDpId = DP.DpCltNo )                    
--And Sec_PayIn >= @fromdate and Sec_PayIn <= @todate                    
And d.Party_Code >= @fromParty and d.Party_Code <= @toParty                    
And d.Scrip_Cd >= @fromScrip and d.Scrip_Cd <= @toScrip            
And d.TransDate >= @fromDate and d.TransDate <= @toDate        
And d.Sett_No >= @FromSettNo and d.Sett_No <= @ToSettNo              
And D.BDpID Like @DpID +'%'              
And D.BCltDpId Like @ClientID +'%'
Group By             
d.Party_Code,                      
c1.Long_Name, D.TransDate, DrCr, d.Scrip_Cd, s1.long_name, D.SETT_NO, D.SETT_TYPE                  
            
Union All                    
            
Select              
D.Party_Code as Party_Code, TransDate as sdate,            
PurQty = Sum(Case When DrCr = 'D' Then Qty Else 0 End),                      
ExeDate = (Case When DrCr = 'D' Then Convert(Varchar,TransDate,103) Else '' End),                     
SellQty = Sum(Case When DrCr = 'C' Then Qty Else 0 End),            
RecDate = (Case When DrCr = 'C' Then Convert(Varchar,TransDate,103) Else '' End),                    
Purpose = (Case when DrCr = 'D' Then 'Payout ' + D.SETT_NO + '-' + D.SETT_TYPE Else             
  (Case when DrCr = 'C' Then 'Payin ' + D.SETT_NO + '-' + D.SETT_TYPE Else '' End)             
  End),            
Balance = 0,          
d.Scrip_Cd as Scrip_CD,            
s1.long_name as ScripName,          
c1.Long_Name as Long_Name            
From #DELTRANS d, Sett_Mst S, client1 c1, client2 c2 , scrip1 s1, scrip2 s2              
Where S.Sett_No = D.Sett_No                    
And S.Sett_Type = D.Sett_Type                    
And c2.cl_code = c1.cl_code                    
And d.party_code = c2.party_code                    
And d.scrip_cd = s2.scrip_cd                    
And d.series = s1.series                    
And s2.co_code = s1.co_code                    
And CertNo Like 'IN%'                    
And Filler2 = 1             
--And Delivered <> (Case When DrCr = 'C' Then '' Else '0' End)     
And TrType <> 906             
--And d.Party_Code <> 'BROKER'                    
And CltDpId In (Select DpCltNo From DeliveryDp Dp Where D.DpId =Dp.DpId And D.CltDpId = DP.DpCltNo )                    
--And Sec_PayIn >= @fromdate and Sec_PayIn <= @todate                    
And d.Party_Code >= @fromParty and d.Party_Code <= @toParty                    
And d.Scrip_Cd >= @fromScrip and d.Scrip_Cd <= @toScrip            
And d.TransDate >= @fromDate and d.TransDate <= @toDate        
And d.Sett_No >= @FromSettNo and d.Sett_No <= @ToSettNo                    
And D.BDpID Like @DpID +'%'              
And D.BCltDpId Like @ClientID +'%'              
                
Group By             
d.Party_Code,             
c1.Long_Name,             
D.TransDate, DrCr, d.Scrip_Cd, s1.long_name, D.SETT_NO, D.SETT_TYPE                   
--Order By d.Party_Code, D.TransDate                    
                         
UNION All            
            
select mst.party_code as party_code, mst.EffDate as sdate,           
PurQty = Sum(Case When DrCr = 'C' Then Qty Else 0 End),                      
ExeDate = (Case When DrCr = 'D' Then Convert(Varchar,mst.EffDate,103) Else '' End),                     
SellQty = Sum(Case When DrCr = 'D' Then Qty Else 0 End),                    
RecDate = (Case When DrCr = 'C' Then Convert(Varchar,mst.EffDate,103) Else '' End),            
Purpose = (Case when DrCr = 'D' Then 'Marg Received' Else             
  (Case when DrCr = 'C' Then 'Marg Delivered' Else '' End)             
  End),            
Balance = 0,          
mst.Scrip_Cd as Scrip_CD,          
s1.long_name as ScripName,          
C1.Long_Name as Long_Name                  
            
from c_securitiesmst mst, Client1 C1, Scrip1 S1, SCrip2 S2             
--from muasjmmsrs4.msajag.dbo.c_securitiesmst mst, Client1 C1, Scrip1 S1, SCrip2 S2             
where             
mst.party_code = C1.Cl_Code          
And mst.scrip_cd = s2.scrip_cd                    
And mst.series = s1.series                    
And s2.co_code = s1.co_code                    
And mst.Party_code >= @fromParty            
And mst.Party_code <= @toParty            
And mst.Scrip_CD >= @fromScrip            
And mst.Scrip_CD <= @toScrip            
And segment like 'capital%'             
And b_dp_acc_code Like @ClientID +'%'            
And B_BankDpId Like @DpID +'%'            
And mst.EffDate >= @fromDate             
And mst.EffDate <= @toDate             
            
Group By mst.party_code,C1.Long_Name,DrCr,mst.EffDate,mst.Scrip_Cd,s1.long_name            
Order By Party_Code,long_name,Scrip_CD,sdate            
            
--End

GO
