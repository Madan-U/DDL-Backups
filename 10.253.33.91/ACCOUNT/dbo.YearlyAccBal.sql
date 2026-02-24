-- Object: PROCEDURE dbo.YearlyAccBal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.YearlyAccBal    Script Date: 01/04/1980 1:40:44 AM ******/


/****** Object:  Stored Procedure dbo.YearlyAccBal    Script Date: 10/15/2001 7:36:16 AM ******/
CREATE Procedure YearlyAccBal
@sdtcur datetime,
@ldtcur datetime,
@flag int
AS

if @flag = 1 
begin
	select l.cltcode,l.acname ,debit = sum(debit),credit = sum(credit)
	from partydrcrview l,acmast a
	where l.cltcode = a.cltcode and 
	(a.actyp like 'ASSET%' or a.actyp like 'LIAB%')
	and l.vdt > = @sdtcur and l.vdt <= @ldtcur
	group by l.cltcode,l.acname
	order by l.acname,l.cltcode
end

if @flag = 2
begin
	select l.cltcode,l.acname ,debit = sum(debit),credit = sum(credit)
	from partydrcrview l,acmast a
	where l.cltcode = a.cltcode and 
	(a.actyp like 'EXP%' )
	and l.vdt > = @sdtcur and l.vdt <= @ldtcur
	group by l.cltcode,l.acname
	order by l.acname,l.cltcode
end

if @flag = 3
begin
	select l.cltcode,l.acname ,debit = sum(debit),credit = sum(credit)
	from partydrcrview l,acmast a
	where l.cltcode = a.cltcode and 
	(a.actyp like 'INC%' )
	and l.vdt > = @sdtcur and l.vdt <= @ldtcur
	group by l.cltcode,l.acname
	order by l.acname,l.cltcode
end

GO
