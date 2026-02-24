-- Object: PROCEDURE dbo.rpt_loginclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*Created by amit on 06/08/2002 client detail report  */  
CREATE PROCEDURE rpt_loginclient   
@statusid varchar(15),  
@statusname varchar(25)  
AS  
if @statusid='broker'  
  begin  
    select distinct  party_code  
    from client2  
    order by party_code  
  end  
if @statusid='branch'  
  begin  
    select distinct  c2.Party_Code  
    from client2 c2, client1 c1, branches b  
    where ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and  
   c1.cl_code = c2.cl_code and  
   ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))   
    order by c2.Party_Code  
  end    
if @statusid='subbroker'  
  begin  
    select distinct  c2.Party_Code  
    from client2 c2,client1 c1,subbrokers sb  
    where c1.cl_code = c2.cl_code and  
   ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and  
   ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))    
   order by c2.Party_Code  
  end   
if @statusid='trader'  
  begin  
    select distinct  c2.Party_Code  
    from client2 c2, client1 c1  
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))    
    order by c2.Party_Code  
  end   
if @statusid='client'  
  begin  
    select distinct c2.Party_Code  
    from client2 c2, client1 c1   
    where c1.cl_code=c2.cl_code and  
  c2.party_code=@statusname   
 order by c2.Party_Code  
  end  
if @statusid='family'  
  begin  
    select distinct c2.Party_Code  
    from client2 c2, client1 c1  
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))  
    order by c2.Party_Code  
  end  
if @statusid='region'  
  begin  
    select distinct c2.Party_Code  
    from client2 c2, client1 c1   
    where c1.cl_code=c2.cl_code and  
c1.region =@statusname   
 order by c2.Party_Code  
  end  

if @statusid='area'  
  begin  
    select distinct c2.Party_Code  
    from client2 c2, client1 c1   
    where c1.cl_code=c2.cl_code and  
c1.area=@statusname   
 order by c2.Party_Code  
  end

GO
