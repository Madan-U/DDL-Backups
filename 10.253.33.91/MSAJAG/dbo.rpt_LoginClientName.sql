-- Object: PROCEDURE dbo.rpt_LoginClientName
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_LoginClientName    Script Date: 10/17/02 1:48:58 PM ******/
/*Created by Vaishali on 16/10/2002 client detail report  */
CREATE PROCEDURE rpt_LoginClientName
@statusid varchar(15),
@statusname varchar(25)

AS
if @statusid='broker'
  begin
    select distinct C2.party_code, C1.Long_Name
    from Client1 C1, client2 C2
    Where C1.Cl_code = C2.cl_Code
    order by C1.Long_Name
  end
if @statusid='branch'
  begin
    select distinct  c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1, branches b
    where ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
    c1.cl_code = c2.cl_code and
    ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname)) 
    order by C1.Long_Name
  end 	
if @statusid='subbroker'
  begin
    select distinct  c2.Party_Code, C1.Long_Name
    from client2 c2,client1 c1,subbrokers sb
    where c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))  
	  order by C1.Long_Name
  end 
if @statusid='trader'
  begin
    select distinct  c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))  
    order by C1.Long_Name
  end	
if @statusid='client'
  begin
    select distinct c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1 
    where c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	order by C1.Long_Name
  end
if @statusid='family'
  begin
    select distinct c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
    order by C1.Long_Name
  end
if @statusid='region'
  begin
    select distinct c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.region))  = ltrim(rtrim(@statusname))
    order by C1.Long_Name
  end
if @statusid='area'
  begin
    select distinct c2.Party_Code, C1.Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.area))  = ltrim(rtrim(@statusname))
    order by C1.Long_Name
  end

GO
