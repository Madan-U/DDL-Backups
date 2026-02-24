-- Object: PROCEDURE dbo.rpt_ListClientName
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_ListClientName    Script Date: 10/17/02 1:48:57 PM ******/
/*Created by Vaishali on 16/10/2002 client detail report  */
CREATE PROCEDURE rpt_ListClientName
@statusid varchar(15),
@statusname varchar(25),
@partyName varchar(50),
@TopartyName varchar(50)
AS
if @statusid='broker'
  begin
    select distinct  party_code, Long_Name
    from client2, Client1
    where  Client1.cl_code = client2.cl_code
    and Long_Name Between  ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by Long_Name
  end
if @statusid='branch'
  begin
    select distinct  c2.Party_Code, c1.Long_Name
    from client2 c2, client1 c1, branches b
    where ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
    c1.cl_code = c2.cl_code and
    ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname)) 
    and C1.Long_Name Between ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by c1.Long_Name
  end 	
if @statusid='subbroker'
  begin
    select distinct  c2.Party_Code, c1.Long_Name
    from client2 c2,client1 c1,subbrokers sb
    where c1.cl_code = c2.cl_code and
    ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
    ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))  
    and c1.Long_Name Between  ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
	  order by c1.Long_Name
  end 
if @statusid='trader'
  begin
    select distinct  c2.Party_Code, Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))  
      and Long_Name Between  ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by Long_Name
  end	
if @statusid='client'
  begin
    select distinct c2.Party_Code, Long_Name
    from client2 c2, client1 c1 
    where c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	 and Long_Name Between  ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
	order by Long_Name
  end
if @statusid='family'
  begin
    select distinct c2.Party_Code, Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
    and Long_Name Between ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by Long_Name
  end

if @statusid='area'
  begin
    select distinct c2.Party_Code, Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.area))  = ltrim(rtrim(@statusname))
    and Long_Name Between ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by Long_Name
  end

if @statusid='region'
  begin
    select distinct c2.Party_Code, Long_Name
    from client2 c2, client1 c1
    where c1.cl_code = c2.cl_code and ltrim(rtrim(c1.region))  = ltrim(rtrim(@statusname))
    and Long_Name Between ltrim(rtrim(@partyName))  and ltrim(rtrim(@TopartyName))
    order by Long_Name
  end

GO
