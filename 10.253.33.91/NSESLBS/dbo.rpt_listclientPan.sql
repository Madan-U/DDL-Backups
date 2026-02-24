-- Object: PROCEDURE dbo.rpt_listclientPan
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_listclient    Script Date: 04/16/2005 13:42:18 ******/        
CREATE PROCEDURE rpt_listclientPan         
@statusid varchar(15),        
@statusname varchar(25),        
@panNo varchar(10)      
AS        
Set Transaction isolation level read uncommitted        
if @statusid='broker'        
  begin        
    select distinct  party_code        
    from client2, Client1         
    where  Client1.cl_code = Client2.Cl_Code
    and Pan_Gir_No = @panNo
    order by party_code        
  end        
if @statusid='branch'        
  begin        
    select distinct  c2.Party_Code        
    from client2 c2, client1 c1, branches b        
    where ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and        
   c1.cl_code = c2.cl_code and        
   ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname)) 
   and Pan_Gir_No = @panNo
    order by c2.Party_Code        
  end          
if @statusid='subbroker'        
  begin        
    select distinct  c2.Party_Code        
    from client2 c2,client1 c1,subbrokers sb        
    where c1.cl_code = c2.cl_code and        
   ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and        
   ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))  
   and Pan_Gir_No = @panNo
   order by c2.Party_Code        
  end         
if @statusid='trader'        
  begin        
    select distinct  c2.Party_Code        
    from client2 c2, client1 c1        
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))          
   and Pan_Gir_No = @panNo       
    order by c2.Party_Code        
  end         
if @statusid='client'        
  begin        
    select distinct c2.Party_Code        
    from client2 c2, client1 c1         
    where c1.cl_code=c2.cl_code and        
  c2.party_code=@statusname         
  and Pan_Gir_No = @panNo
 order by c2.Party_Code        
  end        
if @statusid='family'        
  begin        
    select distinct c2.Party_Code        
    from client2 c2, client1 c1        
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))        
    and Pan_Gir_No = @panNo     
    order by c2.Party_Code        
  end

GO
