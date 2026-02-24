-- Object: PROCEDURE dbo.rpt_sbmngtodaysreport2be
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport2be    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport2be    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngtodaysreport2be    Script Date: 20-Mar-01 11:39:03 PM ******/









/*  file :todays reports .asp 
    report : management info
displays list of trades that are confirmed 
if you don't want to show albm of w then use this query else rpt_sbmngtodaysreport
 **/
/* changed by mousami on 6th mar 2001
    added family login */

CREATE PROCEDURE rpt_sbmngtodaysreport2be
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(6),
@series varchar(3)

AS

if @statusid='broker'

	begin
		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
		from trade4432 t4,client1 c1,client2 c2 
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		order by t4.party_code,c1.short_name,t4.markettype,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
	end


if @statusid='branch'
begin

		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype
		from trade4432 t4,client1 c1,client2 c2 , branches b
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		and b.branch_cd=@statusname and b.short_name=c1.trader
		order by t4.party_code,c1.short_name,t4.markettype,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end

if @statusid='subbroker'
begin
		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code ,t4.markettype
		from trade4432 t4,client1 c1,client2 c2 , subbrokers sb
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
		order by t4.party_code,c1.short_name,t4.markettype,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end


if @statusid='trader'
begin
		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
		from trade4432 t4,client1 c1,client2 c2 
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		and c1.trader=@statusname
		order by t4.party_code,t4.markettype,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
end


if @statusid='client'
begin
	begin
		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
		from trade4432 t4,client1 c1,client2 c2 
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		and t4.party_code=@statusname
		order by t4.party_code,c1.short_name,t4.markettype,t4.scrip_cd,t4.sell_buy,t4.sauda_date
	end
end



if @statusid='family'

	begin
		select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
		t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code,t4.markettype 
		from trade4432 t4,client1 c1,client2 c2 
		where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
		and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
		t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(@series)+'%'
		and c1.family=@statusname
		order by t4.party_code,c1.short_name,t4.markettype,t4.scrip_cd,t4.sell_buy,t4.sauda_date 
	end

GO
