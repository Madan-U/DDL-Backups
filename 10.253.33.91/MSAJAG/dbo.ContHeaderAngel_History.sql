-- Object: PROCEDURE dbo.ContHeaderAngel_History
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc ContHeaderAngel_History       
(        
@Sdate varchar(12),         
@Sett_Type varchar(2),         
@ContNo varchar(7),         
@Sett_no Varchar(10),         
@Party_code Varchar(15)        
)         
        
as            
    
if len(@sdate) = 10    
begin    
  set @sdate = left(@sdate,4) + substring(@sdate,4,3) + right(@sdate,4)    
end    
    
Select @ContNo = Replicate('0',7-len(@ContNo)) + @ContNo       
        
    
set transaction isolation level read uncommitted    
select distinct history.party_code,         
Partyname = client1.Long_name,        
history.billno,         
history.contractno,         
sett_mst.sett_no,         
sett_mst.sett_type,             
convert(varchar,sett_mst.start_date,103) as start_date , convert(varchar,sett_mst.end_date,103) as end_date,         
client1.l_address1,            
client1.l_address2,         
client1.l_address3,         
client1.l_city,         
client1.l_zip,         
convert(varchar,history.sauda_date,103) as sauda_date ,        
client1.email,         
client1.pan_gir_no,            
client1.Sub_Broker,         
client1.branch_cd            
into #sett from history (nolock), client1 (nolock), client2 (nolock), sett_mst (nolock)    
where client1.cl_code = client2.cl_code             
--And client2.Party_code = @Party_code            
And history.Party_code = @Party_code            
and history.party_code = client2.party_code            
And history.Party_code = @Party_code            
--and history.sett_no = @SETT_NO            
and history.sett_type = @SETT_TYPE            
and sett_mst.sett_no = @SETT_NO            
and sett_mst.sett_type = @SETT_TYPE            
and history.sett_Type = sett_mst.sett_Type            
--and convert(int,history.contractno) = @CONTNO            
--and history.contractno = Replicate('0',7-len(@CONTNO)) + @CONTNO          
and history.sauda_datE LIKE @SDATE + '%'            
and sett_mst.start_date <= history.SAUDA_DATE            
and sett_mst.end_date >=  history.SAUDA_DATE            
And End_date Like @SDATE + '%'          
and history.tradeqty <> 0         
and client2.printf = 0            
      
if (select isnull(Count(1),0) From #sett ) > 0       
Begin      
 Select * From #Sett      
End      
Else      
Begin      
      
 select distinct history.party_code,         
 Partyname = client1.Long_name,        
 history.billno,         
 history.contractno,         
 sett_mst.sett_no,         
 sett_mst.sett_type,             
 convert(varchar,sett_mst.start_date,103) as start_date , convert(varchar,sett_mst.end_date,103) as end_date,         
 client1.l_address1,            
 client1.l_address2,         
 client1.l_address3,         
 client1.l_city,         
 client1.l_zip,         
 convert(varchar,history.sauda_date,103) as sauda_date ,        
 client1.email,         
 client1.pan_gir_no,            
 client1.Sub_Broker,         
 client1.branch_cd            
 from history (nolock), client1 (nolock), client2 (nolock), sett_mst (nolock)          
 where client1.cl_code = client2.cl_code             
 --And client2.Party_code = @Party_code            
 And history.Party_code = @Party_code            
 and history.party_code = client2.party_code            
 And history.Party_code = @Party_code            
 and history.sett_no = @SETT_NO            
 and history.sett_type = @SETT_TYPE            
 and sett_mst.sett_no = @SETT_NO            
 and sett_mst.sett_type = @SETT_TYPE            
 and history.sett_Type = sett_mst.sett_Type            
 --and convert(int,history.contractno) = @CONTNO            
-- and history.contractno = Replicate('0',7-len(@CONTNO)) + @CONTNO          
 --and history.sauda_datE LIKE @SDATE + '%'            
 --and sett_mst.start_date <= history.SAUDA_DATE            
 --and sett_mst.end_date >=  history.SAUDA_DATE            
 --And End_date Like @SDATE + '%'          
 and history.tradeqty <> 0         
 and client2.printf = 0            
End

GO
