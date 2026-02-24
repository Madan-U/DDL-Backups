-- Object: PROCEDURE dbo.sp_STT_Annexure_Cum
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[sp_STT_Annexure_Cum] (@datefrom varchar(11),@dateto varchar(11), @partyfrom varchar(10),    
  @partyto varchar(10), @statusid varchar(15), @statusname varchar(25),  @strbranch varchar(12),     
  @strbranchto varchar(12),  @strsubbrokfrom varchar(12),  @strsubbrokto varchar(12) )            
  AS    

---return 0
           
if len(ltrim(rtrim(@partyto))) = 0     
  begin            
     Set @partyto = 'ZZZZZZZZZ'        
  end    
            
if len(ltrim(rtrim(@strbranchto))) = ''             
begin             
 set @strbranchto = 'ZZZZZZZZZZZZZZ'             
             
end            
            
if len(ltrim(rtrim(@strsubbrokto))) = ''            
begin             
 set @strsubbrokto = 'ZZZZZZZZZZZ'                  
end            
            
Set transaction isolation level read uncommitted             
       
Select Party_code, sauda_date= left(sauda_date,11), TransactionCode = '01',   
TurnOver = sum(PAmtDel),   
Stt = (Case When sum(PSTTDel) > 0   
   Then sum(PSTTDel) + (round((sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)),0) - (sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)))  
   Else sum(PSTTDel)  
    End)  
into #Stt02 From VW_STT_ClientDetail   WITH(NOLOCK)    
Where party_code between @partyfrom and  @partyto  and sauda_date between @datefrom and  @dateto +' 23:59'     
and  recType = 30   
Group By Party_code, left(sauda_date,11)      
       
Select Party_code, sauda_date= left(sauda_date,11), TransactionCode = '02',   
TurnOver = sum(SAmtDel),   
Stt = (Case When sum(PSTTDel) = 0 And sum(SSTTDel) > 0  
   Then sum(SSTTDel) + (round((sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)),0) - (sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)))  
   Else sum(SSTTDel)  
    End)       
into #Stt03 from  VW_STT_ClientDetail  WITH(NOLOCK)  
where party_code between @partyfrom and  @partyto  and  sauda_date between @datefrom and  @dateto +' 23:59'         
and  recType = 30   
Group By Party_code, left(sauda_date,11)  
    
Select Party_code, sauda_date= left(sauda_date,11), TransactionCode = '03',   
TurnOver = sum(SAmtTrd),   
Stt = (Case When sum(PSTTDel) = 0 And sum(SSTTDel) = 0 And sum(SSTTTrd) > 0  
   Then sum(SSTTTrd) + (round((sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)),0) - (sum(PSTTDel)+sum(SSTTDel)+sum(SSTTTrd)))  
   Else sum(SSTTTrd)  
    End)  
into #Stt01 from VW_STT_ClientDetail   WITH(NOLOCK) 
where party_code between @partyfrom and @partyto and  sauda_date between @datefrom and  @dateto +' 23:59'     
and  recType = 30   
Group By Party_code, left(sauda_date,11)  
       
  
CREATE INDEX [PartyCd] ON [dbo].[#Stt01] ([Party_Code])  
  
CREATE INDEX [PartyCd] ON [dbo].[#Stt02] ([Party_Code])  
  
CREATE INDEX [PartyCd] ON [dbo].[#Stt03] ([Party_Code])  
  
    
Select       
 Company, addr1, addr2, city, zip, phone, exchangecode,       
 membercode,C2.Party_code, long_name,      
 L_address1,      
 L_address2,     
 L_address3,     
 L_City ,    
 pan_gir_no,' ' mapidid,
 L_ZIP      
      
into #Client      
      
From       
Client1 C1 WITH(NOLOCK),Client2 C2 WITH(NOLOCK),Owner      
Where       
 C1.Cl_Code =c2.Cl_Code and       
 party_code >= @partyfrom and party_code <= @partyto  and           
 branch_cd >= @strbranch and  branch_cd <= @strbranchto  and           
 sub_broker >= @strsubbrokfrom  and sub_broker <= @strsubbrokto and                 
 branch_cd like (case when @statusid = 'branch' then @statusname else '%' end) and           
 sub_broker like (case when @statusid = 'subbroker' then @statusname else '%' end) and           
 trader like (case when @statusid = 'trader' then @statusname else '%' end) and           
 c1.family like (case when @statusid = 'family' then @statusname else '%' end)  and           
 c1.cl_code like (case when @statusid = 'client' then @statusname else '%' end)          
    
CREATE INDEX [PartyCd] ON [dbo].[#Client] ([Party_Code])  
        
Insert into #Stt01 Select Party_Code,@datefrom,'01',0,0 From #Client Where Party_Code         
not in (Select Party_Code from #Stt01)        
        
Insert into #Stt02 Select Party_Code,@datefrom,'02',0,0 From #Client Where Party_Code         
not in (Select Party_Code from #Stt02)        
        
Insert into #Stt03 Select Party_Code,@datefrom,'03',0,0 From #Client Where Party_Code         
not in (Select Party_Code from #Stt03)        
    
Select Party_Code,'04' TransactionCode ,0 TurnOver,0 STT into #Stt04  From #Client        
        
Select Party_Code,'05' TransactionCode ,0 TurnOver,0 STT into #Stt05  From #Client        
        
Select s.Party_code,TransactionCode, TurnOver,  STT        
        
into #Stt00        
        
From        
        
(         
  Select Party_code,TransactionCode, TurnOver=sum(TurnOver), STT=sum(stt) From #Stt01            
  group by Party_code,TransactionCode  
  Union        
  Select Party_code,TransactionCode, TurnOver=sum(TurnOver), STT=sum(stt) From #Stt02           
  group by Party_code,TransactionCode  
  Union         
  Select Party_code,TransactionCode, TurnOver=sum(TurnOver), STT=sum(stt) From #Stt03          
  group by Party_code,TransactionCode  
  Union         
  Select Party_code,TransactionCode, TurnOver=sum(TurnOver), STT=sum(stt) From #Stt04  
  group by Party_code,TransactionCode  
  Union         
  Select Party_code,TransactionCode, TurnOver=sum(TurnOver), STT=sum(stt) From #Stt05  
  group by Party_code,TransactionCode  
        
) S        
        
Order By s.Party_code,TransactionCode        
  
Drop table #Stt01  
Drop table #Stt02  
Drop table #Stt03  
Drop table #Stt04  
Drop table #Stt05  
  
CREATE INDEX [PartyCd] ON [dbo].[#Stt00] ([Party_Code])  
    
Select Company, addr1, addr2, city, zip, phone, exchangecode,       
 membercode,long_name, L_address1,L_address2, L_address3, L_city, L_ZIP, pan_gir_no, isnull(u.mapidid, '') mapinid,       
 s.Party_code,TransactionCode, TurnOver,  STT, convert(varchar, getdate(), 103) CurDate        
From  #Client C  , #Stt00 S left outer join ucc_client u on (u.party_code = s.party_code)      
where S.Party_Code = C.Party_Code     
and s.party_code in ( select party_code from #Stt00 group by party_code having sum(stt) > 0)

GO
