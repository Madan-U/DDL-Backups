-- Object: PROCEDURE dbo.rpt_cmlistclientparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_cmlistclientparty    Script Date: 05/20/2002 5:36:55 PM ******/
CREATE PROCEDURE rpt_cmlistclientparty
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
  begin
    select distinct party_code
    from settlement  
	union 
    select distinct party_code
    from history

    order by party_code
  end

if @statusid='branch'
  begin
    select distinct  fo.Party_Code
    from settlement fo,client2 c2, client1 c1, branches b
    where fo.Party_Code = c2.party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))
	union 
    select distinct  fo.Party_Code
    from history fo,client2 c2, client1 c1, branches b
    where fo.Party_Code = c2.party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))

    order by fo.Party_Code
  end 	

if @statusid='subbroker'
  begin
    select distinct  fo.Party_Code
    from settlement fo,client2 c2,client1 c1,subbrokers sb
    where fo.Party_Code = c2.party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
	union 
    select distinct  fo.Party_Code
    from history fo,client2 c2,client1 c1,subbrokers sb
    where fo.Party_Code = c2.party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
   order by fo.Party_Code
  end 

if @statusid='trader'
  begin
    select distinct  fo.Party_Code
    from settlement fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))  
	union 
    select distinct  fo.Party_Code
    from history fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))  

    order by fo.Party_Code
  end	

if @statusid='client'
  begin
    select distinct  fo.Party_Code
    from settlement fo, client2 c2, client1 c1 
    where fo.Party_Code=c2.party_code and
	  c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	union 
    select distinct  fo.Party_Code
    from history fo, client2 c2, client1 c1 
    where fo.Party_Code=c2.party_code and
	  c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	order by fo.Party_Code
  end

if @statusid='family'
  begin
    select distinct  fo.Party_Code
    from settlement fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
	union 
    select distinct  fo.Party_Code
    from history fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
    order by fo.Party_Code
  end

GO
