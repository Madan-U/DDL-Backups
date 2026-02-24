-- Object: PROCEDURE dbo.rpt_foclientdetailbill1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclientdetailbill1    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_foclientdetailbill1    Script Date: 11/28/2001 12:23:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientdetailbill1    Script Date: 29-Sep-01 8:12:07 PM ******/


/****** Object:  Stored Procedure dbo.rpt_foclientdetailbill1    Script Date: 9/7/2001 6:05:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclientdetailbill1    Script Date: 10/26/00 2:46:52 PM ******/

CREATE PROCEDURE rpt_foclientdetailbill1

@statusid varchar(15),
@statusname varchar(25),
@code varchar(10),
@sdate varchar(15),
@tdate varchar(15)
AS

if @statusid = 'broker'
begin
	select  party_code ,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill
	where party_code like ltrim(@code)
	and billdate >= ltrim(@sdate )
                and billdate <= ltrim(@tdate) + ' 23:59:00'
	and amount <> 0
/*	order by party_code,Year(billdate),month(billdate),day(billdate)*/
	union 
	select  party_code ,billdate =left(convert(varchar,billdate,106),11),
	credit = 0,
	debit  = 0,Year(billdate),month(billdate),day(billdate)
	from Rpt_FoColl
	where party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <= ltrim(@tdate) + ' 23:59:00'
	order by party_code,Year(billdate),month(billdate),day(billdate)

end 

if @statusid = 'branch'
begin
	select  fo.party_code,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill fo,client2 c2, client1 c1, branches b
	where fo.Party_Code = c2.party_code and 
	 b.short_name = c1.trader and
	 c1.cl_code = c2.cl_code and
	 b.branch_cd = @statusname and
	fo.party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <= ltrim(@tdate) + '23:59:00'
	and amount <> 0
	order by fo.party_code,Year(billdate),month(billdate),day(billdate)
end 

if @statusid = 'subbroker'
begin
	select  fo.party_code,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill fo,client2 c2, client1 c1, subbrokers sb
	where fo.Party_Code = c2.party_code and 
	sb.sub_broker = @statusname and
	sb.sub_broker = c1.sub_broker and
	c1.cl_code = c2.cl_code and
	fo.party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <= ltrim(@tdate) + '23:59:00'
	and amount <> 0
	order by fo.party_code,Year(billdate),month(billdate),day(billdate)
end 

if @statusid = 'trader'
begin
	select  fo.party_code,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill fo,client2 c2, client1 c1
	where fo.Party_Code = c2.party_code and 
	c1.cl_code = c2.cl_code and
	c1.trader  = @statusname and
	fo.party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <=  ltrim(@tdate) + '23:59:00'
	and amount <> 0
	order by fo.party_code,Year(billdate),month(billdate),day(billdate)
end 

if @statusid = 'client'
begin
	select  fo.party_code,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill fo,client2 c2, client1 c1
	where fo.Party_Code = c2.party_code and 
	c1.cl_code = c2.cl_code and
	fo.party_code = @statusname and
	fo.party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <= ltrim(@tdate) + '23:59:00'
	and amount <> 0
	order by fo.party_code,Year(billdate),month(billdate),day(billdate)
end 

if @statusid = 'family'
begin
	select  fo.party_code,billdate =left(convert(varchar,billdate,106),11),
	credit = (case when sell_buy = 2 then amount else 0 end ),
	debit  = (case when sell_buy = 1 then amount else 0 end),Year(billdate),month(billdate),day(billdate)
	from foaccbill fo,client2 c2, client1 c1
	where fo.Party_Code = c2.party_code and 
	c1.cl_code = c2.cl_code and
	c1.family  = @statusname and
	fo.party_code like ltrim(@code)
	and billdate >= @sdate 
                and billdate <= ltrim(@tdate) + '23:59:00'
	and amount <> 0
	order by fo.party_code,Year(billdate),month(billdate),day(billdate)
end

GO
