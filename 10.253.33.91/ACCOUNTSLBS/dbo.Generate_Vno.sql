-- Object: PROCEDURE dbo.Generate_Vno
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC Generate_Vno

	@vdt      varchar(11),  /* dd/mm/yyyy */                
	@vtyp     smallint,                
	@booktype varchar(2),                
	@sdtcur   varchar(11),                
	@ldtcur   varchar(11),      
	@acc_serevr1 varchar(15),
	@acc_db1 varchar(15),
	@exchange1 varchar(10),
	@acc_serevr2 varchar(15),
	@acc_db2 varchar(15),
	@exchange2 varchar(10),
	@acc_serevr3 varchar(15),
	@acc_db3 varchar(15),
	@exchange3 varchar(10),
	@noofrecords int = 1      

as

declare
@@sql varchar(1000)

create table #vno_table 
(
	NSEVNO VARCHAR(12),
	BSEVNO VARCHAR(12),
	FOVNO VARCHAR(12)
)

insert into #vno_table values('', '', '')


create table #vno
(
	vno varchar(12)
)



	set @@sql = "insert into #vno exec " + @acc_serevr1 + "." + @acc_db1 + ".dbo.Acc_GenVno_New '" + @vdt + "'," + convert(varchar,@vtyp) + ",'" + @booktype + "','" + @sdtcur + "','" + @ldtcur + "'"
	print @@sql
	exec (@@sql)

	if @exchange1 = "NSE" 
	BEGIN
		update #vno_table set NSEVNO = vno from #vno
	END	
	Else if @exchange1 = "BSE" 
	BEGIN
		update #vno_table set BSEVNO = vno from #vno
	END	
	Else If @exchange1 = "FO" 
	BEGIN
		update #vno_table set FOVNO = vno from #vno
	END	

	truncate table #vno

	set @@sql = "insert into #vno exec " + @acc_serevr2 + "." + @acc_db2 + ".dbo.Acc_GenVno_New '" + @vdt + "'," + convert(varchar,@vtyp) + ",'" + @booktype + "','" + @sdtcur + "','" + @ldtcur + "'"
	print @@sql
	exec (@@sql)

	if @exchange2 = "NSE" 
	BEGIN
		update #vno_table set NSEVNO = vno from #vno
	END	
	Else if @exchange2 = "BSE" 
	BEGIN
		update #vno_table set BSEVNO = vno from #vno
	END	
	Else If @exchange2 = "FO" 
	BEGIN
		update #vno_table set FOVNO = vno from #vno
	END	

	truncate table #vno

	set @@sql = "insert into #vno exec " + @acc_serevr3 + "." + @acc_db3 + ".dbo.Acc_GenVno_New '" + @vdt + "'," + convert(varchar,@vtyp) + ",'" + @booktype + "','" + @sdtcur + "','" + @ldtcur + "'"
	print @@sql
	exec (@@sql)

	if @exchange3 = "NSE" 
	BEGIN
		update #vno_table set NSEVNO = vno from #vno
	END	
	Else if @exchange3 = "BSE" 
	BEGIN
		update #vno_table set BSEVNO = vno from #vno
	END	
	Else If @exchange3 = "FO" 
	BEGIN
		update #vno_table set FOVNO = vno from #vno
	END	


	select * from #vno_table

GO
