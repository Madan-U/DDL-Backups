-- Object: PROCEDURE dbo.rpt_connetposloginhandler
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/*
REPORT NAME		-	NET POSITION (CONSOLIDATED)
FILE			-	//asp/cgi-bin/backoffice/consolidated/ConNetPosition/ListBranchSB.asp
CREATED ON		-	APR 12 2001
CREATED BY		-	Core SQL- Mousami, Additional Conditions/Changes/Add-On's By Shyam
LATEST CHANGES	-	ON APR 14-18 2001 - BY Shyam - ADDED CONDITIONAL LISTING ACC TO PARAMETERS PASSED
DESCRIPTION		-	RETRIEVES LISTING OF BRANCHES/SUBBROKERS/TRADERS DEPENDING ON PARAMETERS PASSED
				(INDIVIDUAL SQL BLOCS. BELOW ARE FURTHER COMMENTED)
*/
CREATE PROCEDURE rpt_connetposloginhandler

@settno varchar(7),
@setttype varchar(3),
@statusid varchar(15),
@showwhat varchar(15),
/*THE 'name' PARAMETER CONTAINS THE BRANCH CODE IN CASE A LIST OF ALL TRADERS UNDER A BRANCH ARE TO BE RETRIEVED.*/
/*IT CONTAINS THE SUBBROKER CODE IF RECS FOR A PARTICULAR SUBBROKER ARE TO BE RETRIEVED/CLIENTS UNDER A SUBBROKER ARE TO BE RETRIEVED*/
/*IT CONTAINS THE TRADER NAME IF ALL CLIENTS UNDER A TRADER ARE TO BE LISTED*/
@name varchar(15),
/*THE 'listby' PARAMETER STORES 'TRADER' OR 'SUBBROKER', DEPENDING ON THE LISTING REQUIRED*/
@listby varchar(10),
/*THE 'listclscr' PARAMETER STORES 'CLIENTWISE' OR 'SCRIPWISE', DEPENDING ON THE LISTING REQUIRED*/
@listclscr varchar(10),
/*THE 'scripcd' PARAMETER STORES THE SCRIP CODE OF A PARTICULAR SCRIP*/
/*THIS PARAMETER IS USED TO DISPLAY THE CLIENTS WHO HAVE TRADED IN A PARTICULAR SCRIP*/
@scripcd varchar(10),
/*THE 'brokertrdsb' PARAMETER IS USED IN THE BROKER LOGIN TO DIFERENCIATE LISTING OF THE CLIENTS UNDER A SCRIP UNDER A TRADER*/
/*AND THE CLIENTS UNDER A SCRIP UNDER A SUBBROKER*/
/*IT STORES EITHER 'SUBBROKER' OR '', (BLANK FOR A TRADER)*/
@brokertrdsb varchar (10)

AS

/*LOGIN - BROKER*/
if @statusid = 'broker'
begin
	if @showwhat= 'branch'
	/* LIST DTLS FOR ALL BRANCHES UNDER A BROKER */
	begin
		select b.branch_cd, s.party_code, Scrip_cd, series,sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
		from connetposfinalsumScrip s, branches b, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
		and c1.cl_code=c2.cl_code and c1.trader=b.short_name and s.party_code=c2.party_code
		UNION ALL
		select b.branch_cd, s.party_code, Scrip_cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
		from connetposoppalbmScrip s ,branches b, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and c1.trader=b.short_name and s.party_code=c2.party_code
		UNION ALL
		select b.branch_cd, s.party_code, Scrip_cd, series,sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
		from connetposPlusOneAlbmScrip s, branches b, client2 c2, client1 c1 where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' )  and  sett_type = @setttype
		and  c1.cl_code=c2.cl_code and c1.trader=b.short_name and s.party_code=c2.party_code
		order by b.branch_cd, Scrip_cd, series, s.party_code, sell_buy
	end	/*if @showwhat= 'branch'*/

	if @showwhat= 'subbroker'
	/* LISTS DTLS FOR ALL SUBBROKERS/A PARTICULAR SUBBROKER UNDER A BROKER */
	begin
		/* FOR ALL THE SUBBROKERS - PARAMETER 'name' IS EMPTY */
		if @name = ''
			begin
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposfinalsumScrip s, subbrokers sb, client2 c2, client1 c1
				where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code
				UNION ALL
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposoppalbmScrip s, subbrokers sb, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code
				UNION ALL
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposPlusOneAlbmScrip s, subbrokers sb, client2 c2, client1 c1 where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code
				order by sb.sub_broker,sett_type,sett_no,Scrip_Cd, series
			end	/*if @showwhat= 'subbroker' - if @name = ''*/

		/* FOR A PARTICULAR SUBBROKER - PARAMETER 'name' CONTAINS A NON-NULL VALUE */
		if @name <> ''
			begin
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.sub_broker
				from connetposfinalsumScrip s, subbrokers sb, client2 c2, client1 c1
				where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code and c1.sub_broker = @name
				UNION ALL
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.sub_broker
				from connetposoppalbmScrip s, subbrokers sb, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code and c1.sub_broker = @name
				UNION ALL
				select sb.sub_broker, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.sub_broker
				from connetposPlusOneAlbmScrip s, subbrokers sb, client2 c2, client1 c1 where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  s.party_code=c2.party_code and c1.sub_broker = @name
				order by sb.sub_broker,sett_type,sett_no,Scrip_Cd, series
			end	/*if @showwhat= 'subbroker' - if @name <> ''*/
	end	/*if @showwhat= 'subbroker'*/

	if @showwhat= 'trader'
	/* LISTS DTLS FOR ALL TRADERS/ALL TRADERS UNDER A BRANCH UNDER A BROKER */
	begin
		/* FOR ALL THE TRADERS - PARAMETER 'name' IS EMPTY*/
		if @name = ''
			begin
				select c1.trader, s.party_code, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposfinalsumScrip s, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code
				UNION ALL
				select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposoppalbmScrip s, client2 c2, client1 c1 where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code 
				UNION ALL
				select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1 where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code
				order by c1.trader,sett_type,sett_no,Scrip_Cd, series
			end	/*	if @showwhat= 'trader' - if @name = ''*/

		/* FOR TRADERS UNDER A BRANCH - PARAMETER 'name' CONTAINS A NON-NULL VALUE (THE TRADER NAME)*/
		if @name <> ''
			begin
				select c1.trader, s.party_code, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
				from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
				UNION ALL
				select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
				from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
				UNION ALL
				select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
				order by c1.trader,sett_type,sett_no,Scrip_Cd, series
			end	/*	if @showwhat= 'trader' - if @name <> ''*/

	end	/*	if @showwhat= 'trader'*/
	
	/* LIST ALL CLIENTS' DTLS WHO ARE UNDER A PARTICULAR TRADER UNDER A BRANCH*/	
	if @showwhat = 'client'
	begin
	/*LIST CLIENTS UNDER A TRADER*/
	/*ADDITIONAL CHECK 'b.branch_cd = @branchcd' NOT ADDED BECAUSE THE CHECK ' c1.trader= b.short_name' IS PRESENT*/
	/*SO ONLY THE TRADERS UNDER A PARTICULAR BRANCH WILL BE LISTED*/
		if @listby = 'TRADER'
		begin
			/*SHOW A CLIENT-WISE LIST*/
			if @listclscr = 'CLIENTWISE'
			begin
				select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
				from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				UNION ALL
				select  s.party_code, c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
				from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				UNION ALL
				select  s.party_code, c1.trader,  Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
			end	/*if @listclscr = 'CLIENTWISE'*/

			/*SHOW A SCRIP-WISE LIST*/
			if @listclscr = 'SCRIPWISE'
			begin
				select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
				from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				UNION ALL
				select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
				from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				UNION ALL
				select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' )  and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
				and c1.trader= @name /*and b.branch_cd = @branchcd*/
				order by Scrip_Cd, s.party_code, c1.trader, sett_type,sett_no, series
			end	/*if @listclscr = 'SCRIPWISE'*/
		end	/*if @listby = 'TRADER' - if @showwhat = 'client'*/

		/*LIST CLIENTS UNDER A SUBBROKER*/
		if @listby = 'SUBBROKER'
		begin
			/*SHOW A CLIENT-WISE LIST*/
			if @listclscr = 'CLIENTWISE'
			begin
				select s.party_code, c1.sub_broker, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
				from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
				and c1.sub_broker = @name
				UNION ALL
				select  s.party_code, c1.sub_broker, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type , c1.short_name
				from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
				and c1.sub_broker = @name
				UNION ALL
				select s.party_code, c1.sub_broker, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
				and c1.sub_broker = @name
				order by c1.sub_broker, s.party_code, sett_type,sett_no,Scrip_Cd, series
			end	/*if @listclscr = 'SCRIPWISE'*/
			/*SHOW A SCRIP-WISE LIST*/
			if @listclscr = 'SCRIPWISE'
			begin
				select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
				from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
				and c1.sub_broker = @name
				UNION ALL
				select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
				from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
				and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
				and c1.sub_broker = @name
				UNION ALL
				select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
				from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
				and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
				and c1.sub_broker = @name
				order by Scrip_Cd, s.party_code, c1.sub_broker, sett_type,sett_no, series
			end	/*if @listclscr = 'SCRIPWISE'*/
		end	/*if @listby = 'SUBBROKER' - if @showwhat = 'client'*/
	end	/*if showwhat = 'client'*/

	if @showwhat = 'scripclient'
	begin
		if @brokertrdsb = ''
		begin
		/*LIST CLIENTS UNDER A SCRIPS UNDER A TRADER*/
			select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
			and c1.trader= @name and scrip_cd = @scripcd
			UNION ALL
			select s.party_code,c1.trader,  Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader= @name and scrip_cd = @scripcd
			UNION ALL
			select  s.party_code, c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
			from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
			and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader= @name and scrip_cd = @scripcd
			order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
		end	/*if brokertrdsb = ''*/

		/*LIST CLIENTS UNDER A SCRIPS UNDER A SB*/
		if @brokertrdsb = 'SUBBROKER'
		begin
			select s.party_code, c1.sub_broker, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
			from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
			and c1.sub_broker = @name and scrip_cd = @scripcd
			UNION ALL
			select s.party_code, c1.sub_broker, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type , c1.short_name
			from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
			and c1.sub_broker = @name and scrip_cd = @scripcd
			UNION ALL
			select  s.party_code, c1.sub_broker, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
			from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
			and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
			and c1.sub_broker = @name and scrip_cd = @scripcd
			order by c1.sub_broker, s.party_code, sett_type,sett_no,Scrip_Cd, series
		end	/*if brokertrdsb = 'SUBBROKER'*/
	end	/*if @showwhat = 'scripclient'*/
end	/*if @statusid = 'broker'*/

/*LOGIN - BRANCH*/
if @statusid = 'branch'
begin
	if @showwhat= 'trader'
	/* LISTS DTLS FOR ALL TRADERS/ALL TRADERS UNDER A BRANCH UNDER A BROKER */
	begin
		select c1.trader, s.party_code, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
		from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
		UNION ALL
		select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
		from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
		UNION ALL
		select c1.trader, s.party_code, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader=b.short_name and b.branch_cd = @name
		order by c1.trader,sett_type,sett_no,Scrip_Cd, series
	end	/*	if @showwhat= 'trader'*/

	/* LIST ALL CLIENTS' DTLS WHO ARE UNDER A PARTICULAR TRADER UNDER A BRANCH*/	
	if @showwhat = 'client'
	begin
	/*LIST CLIENTS UNDER A TRADER*/
	/*ADDITIONAL CHECK 'b.branch_cd = @branchcd' NOT ADDED BECAUSE THE CHECK ' c1.trader= b.short_name' IS PRESENT*/
	/*SO ONLY THE TRADERS UNDER A PARTICULAR BRANCH WILL BE LISTED*/
		/*SHOW A CLIENT-WISE LIST*/
		if @listclscr = 'CLIENTWISE'
		begin
			select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
			and c1.trader= @name /*and b.branch_cd = @branchcd*/
			UNION ALL
			select s.party_code,  c1.trader,Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader= @name /*and b.branch_cd = @branchcd*/
			UNION ALL
			select  s.party_code,  c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
			from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
			and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader= @name /*and b.branch_cd = @branchcd*/
			order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
		end	/*if @listclscr = 'CLIENTWISE'*/
		/*SHOW A SCRIP-WISE LIST*/
		if @listclscr = 'SCRIPWISE'
		begin
			select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
			and c1.trader = @name
			UNION ALL
			select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
			and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader = @name
			UNION ALL
			select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
			from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
			and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
			and c1.trader = @name
			order by Scrip_Cd, s.party_code, c1.trader, sett_type,sett_no, series
		end	/*if @listclscr = 'SCRIPWISE'*/
	end	/*if @showwhat = 'client'*/

	/*LIST CLIENTS UNDER A SCRIP*/
	if @showwhat = 'scripclient'
	begin
		select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		UNION ALL
		select  s.party_code,c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		UNION ALL
		select  s.party_code, c1.trader,Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
	end	/*if @showwhat = 'scripclient'*/
end	/*if @statusid = 'branch'*/


/*LOGIN - SUBBROKER*/
if @statusid = 'subbroker'
begin
	if @listclscr = 'CLIENTWISE'
	begin
		select s.party_code, c1.sub_broker, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name
		UNION ALL
		select s.party_code, c1.sub_broker,  Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type , c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
		and c1.sub_broker = @name
		UNION ALL
		select s.party_code, c1.sub_broker,  Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name
		order by c1.sub_broker, s.party_code, sett_type,sett_no,Scrip_Cd, series
	end	/*if @listclscr = 'CLIENTWISE'*/
	if @listclscr = 'SCRIPWISE'
	begin
		select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name
		UNION ALL
		select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
		and c1.sub_broker = @name
		UNION ALL
		select Scrip_Cd, s.party_code, c1.sub_broker, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name
		order by Scrip_Cd, s.party_code, c1.sub_broker, sett_type,sett_no,series
	end	/*if @listclscr = 'SCRIPWISE'*/

	/*LIST CLIENTS UNDER A SCRIP*/
	if @showwhat = 'scripclient'
	begin
		select s.party_code, c1.sub_broker, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name and scrip_cd = @scripcd
		UNION ALL
		select s.party_code, c1.sub_broker, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type , c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.sub_broker= sb.sub_broker
		and c1.sub_broker = @name and scrip_cd = @scripcd
		UNION ALL
		select  s.party_code,c1.sub_broker,  Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, subbrokers sb where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.sub_broker = sb.sub_broker
		and c1.sub_broker = @name and scrip_cd = @scripcd
		order by c1.sub_broker, s.party_code, sett_type,sett_no,Scrip_Cd, series
	end	/*if @showwhat = 'scripclient'*/
end	/*if @statusid = 'subbroker'*/

/*LOGIN - TRADER*/
if @statusid = 'trader'
begin
	if @listclscr = 'CLIENTWISE'
	begin
		select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		UNION ALL
		select  s.party_code, c1.trader,Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		UNION ALL
		select  s.party_code, c1.trader,Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
	end	/*if @listclscr = 'CLIENTWISE'*/

	if @listclscr = 'SCRIPWISE'
	begin
		select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		UNION ALL
		select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		UNION ALL
		select Scrip_Cd, s.party_code, c1.trader, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name /*and b.branch_cd = @branchcd*/
		order by Scrip_Cd, s.party_code, c1.trader, sett_type,sett_no,series
	end	/*if @listclscr = 'SCRIPWISE'*/

	/*LIST CLIENTS UNDER A SCRIP*/
	if @showwhat = 'scripclient'
	begin
		select s.party_code, c1.trader, Scrip_Cd,series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposfinalsumScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader = b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		UNION ALL
		select  s.party_code,c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd, c1.short_name
		from connetposoppalbmScrip s, client2 c2, client1 c1, branches b where sett_no = @settno and sett_type = @setttype
		and  c1.cl_code=c2.cl_code and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		UNION ALL
		select  s.party_code,c1.trader, Scrip_Cd, series, sell_buy, pqty, sqty, pamt, samt, sett_no, sett_type, b.branch_cd,  c1.short_name
		from connetposPlusOneAlbmScrip s, client2 c2, client1 c1, branches b where sett_no = (select min(Sett_no) from sett_mst where sett_no > @settno  and sett_type = 'L' ) and sett_type = @setttype
		and  c1.cl_code=c2.cl_code  and  s.party_code=c2.party_code and c1.trader= b.short_name
		and c1.trader= @name and scrip_cd = @scripcd
		order by c1.trader, s.party_code, sett_type,sett_no,Scrip_Cd, series
	end	/*if @showwhat = 'scripclient'*/
end	/*if @statusid = 'trader'*/

GO
