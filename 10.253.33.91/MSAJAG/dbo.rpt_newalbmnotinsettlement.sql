-- Object: PROCEDURE dbo.rpt_newalbmnotinsettlement
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newalbmnotinsettlement    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmnotinsettlement    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmnotinsettlement    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmnotinsettlement    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newalbmnotinsettlement    Script Date: 12/27/00 8:58:56 PM ******/

/* report : misnews 
   file : topclient_scripsett.asp
*/
/* selects those clients whose trades are in albm but not in current settlement */
CREATE PROCEDURE rpt_newalbmnotinsettlement
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7)
AS
if @statusid='broker'
begin
select distinct party_code from settlement where sett_type='l' and
sett_no=@settno and party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
order by party_code
end 
if @statusid='branch'
begin
select distinct s.party_code from settlement s , branches b , client1 c1, client2 c2 where s.sett_type='l' and
s.sett_no=@settno and b.branch_cd=@statusname and b.short_name=c1.trader
and s.party_code=c2.party_code
and c2.cl_code=c1.cl_code 
and s.party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
order by s.party_code
end 
if @statusid='subbroker'
begin
select distinct s.party_code from settlement s, subbrokers sb, client1 c1, client2 c2 where sett_type='l' and
sett_no=@settno and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
and c1.cl_code=c2.cl_code and s.party_code=c2.party_code and
s.party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
order by s.party_code
end 
if @statusid='trader'
begin
select distinct s.party_code from settlement s , client1 c1, client2 c2 where sett_type='l' and
sett_no=@settno and c2.cl_code=c1.cl_code and s.party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
and c2.party_code=s.party_code
and c1.trader=@statusname
order by s.party_code
end 
if @statusid='client'
begin
select distinct s.party_code from settlement s, client1 c1, client2 c2 where sett_type='l' and
sett_no=@settno and s.party_code not in (select distinct party_code from settlement where
(sett_type='w' or sett_type='m' or sett_type='n') and billno=0)
and s.party_code=@statusname
and c1.cl_code=c2.cl_code and s.party_code=c2.party_code
order by s.party_code
end

GO
