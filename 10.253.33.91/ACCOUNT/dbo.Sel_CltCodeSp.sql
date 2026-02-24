-- Object: PROCEDURE dbo.Sel_CltCodeSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Sel_CltCodeSp    Script Date: 02/22/2002 1:56:05 PM ******/

/****** Object:  Stored Procedure dbo.Sel_CltCodeSp    Script Date: 01/24/2002 12:12:14 PM ******/

/****** Object:  Stored Procedure dbo.Sel_CltCodeSp    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.Sel_CltCodeSp    Script Date: 29-Sep-01 8:12:07 PM ******/


/*Created by vaishali on 26/02/2001*/

CREATE PROCEDURE Sel_CltCodeSp
@flag as tinyint,
@FromParty varchar(10),
@ToParty varchar(10)

AS

if @flag = 1  
begin
	select distinct isnull(l.cltcode,'') cltcode, isnull(l.acname,' ') acname
	from ledger l,acmast a
	where accat <> 4 and l.cltcode = a.cltcode
	order by cltcode  
end 

if @flag = 2
begin
	select distinct isnull(l.cltcode,'') cltcode, isnull(l.acname,' ') acname
	from ledger l,acmast a
	where accat = 4 and l.cltcode = a.cltcode  
	order by cltcode 
end


if @flag = 3
begin
	select distinct isnull(l.cltcode,' ') cltcode , isnull(l.acname,' ') acname
	from ledger l,acmast a 
	where accat <> 4 and l.cltcode = a.cltcode 
	and l.cltcode >= @FromParty and l.cltcode <= @ToParty
	order by cltcode               
end


if @flag = 4
begin
	select distinct isnull(l.cltcode,' ') cltcode , isnull(l.acname,' ') acname
	from ledger l,acmast a 
	where accat = 4 and l.cltcode = a.cltcode 
	and l.cltcode >= @FromParty and l.cltcode <= @ToParty 
	order by cltcode              
end

if @flag = 5
begin
	select distinct isnull(acname,' ') acname 
	from ledger where cltcode =  @FromParty
	order by acname 
end

GO
