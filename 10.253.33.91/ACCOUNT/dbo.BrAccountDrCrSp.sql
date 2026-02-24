-- Object: PROCEDURE dbo.BrAccountDrCrSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BrAccountDrCrSp    Script Date: 02/22/2002 1:56:03 PM ******/
/************************************************************************************************************************************************************************************************
Created by Sheetal 21/02/2002  Calculated the debit and credit amount for client
This sp is used in TrialBalancePrint Control

*************************************************************************************************************************************************************************************************/

CREATE PROCEDURE BrAccountDrCrSp
@fromdate as varchar(21),
@todate as varchar(21),
@fromparty varchar(36),
@toparty varchar(36),
@fromamt money,
@toamt money,
@flag tinyint,
@costcode smallint

AS

/* If from party and to party are selected and if order by partyname is selected*/
if @flag = 1
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate 	and p.cltcode = a.cltcode and a.accat <> '4' 
	and p.cltcode >= @fromparty and p.cltcode <= @toparty and costcode = @costcode
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt  	
	order by p.acname

end

/* If from party and to party are not selected and if order by partyname is selected*/
if @flag = 2
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate  and costcode = @costcode
	and p.cltcode = a.cltcode and a.accat <> '4'  
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.acname
end

/* If from party and to party are selected and if order by cltcode is selected*/
if @flag = 3
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate and costcode = @costcode
	and p.cltcode = a.cltcode and a.accat <> '4'
	and p.cltcode >= @fromparty and p.cltcode <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end

/* If from party and to party are not selected and if order by cltcode is selected*/
if @flag = 4
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate and costcode = @costcode
	and p.cltcode = a.cltcode and a.accat <> '4'
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end


/*Check on ac name*/

if @flag = 11
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate and costcode = @costcode
	and p.cltcode = a.cltcode and a.accat <> '4' 
	and p.acname >= @fromparty and p.acname <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt  
	order by p.acname
end


/* If from party and to party are selected and if order by cltcode is selected*/
if @flag = 13
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcrbranchwise p,acmast a  
	where vdt >= @fromdate and p.vdt <= @todate and costcode = @costcode
	and p.cltcode = a.cltcode and a.accat <> '4' 
	and p.acname >= @fromparty and p.acname <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end

GO
