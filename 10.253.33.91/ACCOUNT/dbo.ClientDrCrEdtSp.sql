-- Object: PROCEDURE dbo.ClientDrCrEdtSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClientDrCrEdtSp    Script Date: 02/22/2002 1:56:04 PM ******/
/************************************************************************************************************************************************************************************************
Created by vaishali on 28/02/2001 Calculated the debit and credit amount for client

Recent Changes are done by Vaishali on 19/11/2001 This sp is used in TrialBalancePrint Control

*************************************************************************************************************************************************************************************************/

CREATE PROCEDURE ClientDrCrEdtSp
@fromdate as varchar(21),
@todate as varchar(21),
@fromparty varchar(36),
@toparty varchar(36),
@fromamt money,
@toamt money,
@flag tinyint

AS

/* If from party and to party are selected and if order by partyname is selected*/
if @flag = 1
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4' 
	and p.cltcode >= @fromparty and p.cltcode <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt  	
	order by p.acname
end

/* If from party and to party are not selected and if order by partyname is selected*/
if @flag = 2
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4' 
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.acname
end

/* If from party and to party are selected and if order by cltcode is selected*/
if @flag = 3
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4'
	and p.cltcode >= @fromparty and p.cltcode <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end

/* If from party and to party are not selected and if order by cltcode is selected*/
if @flag = 4
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4'
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end


/*Check on ac name*/

if @flag = 11
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4' 
	and p.acname >= @fromparty and p.acname <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt  
	order by p.acname
end


/* If from party and to party are selected and if order by cltcode is selected*/
if @flag = 13
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,acmast a  
	where p.edt >= @fromdate and p.edt <= @todate
	and p.cltcode = a.cltcode and a.accat = '4' 
	and p.acname >= @fromparty and p.acname <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end


--COMMENTED BY SHEETAL ON 15-02-2002  ADDED FROM DATE AND TO DATE AS PARAMETERS 
/*
@tdate as varchar(21),
@fromparty varchar(10),
@toparty varchar(10),
@fromamt money,
@toamt money,
@flag tinyint

AS
if @flag = 1
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	and p.cltcode >= @fromparty and p.cltcode <= @toparty	
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.acname
end


if @flag = 2
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.acname
end


if @flag = 3
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	and p.cltcode >= @fromparty and p.cltcode <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end


if @flag = 4
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end


Check for acname
if @flag = 11
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	and p.acname >= @fromparty and p.acname <= @toparty	
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.acname
end

if @flag = 13
begin
	select isnull(p.cltcode,''),isnull(p.acname,''),bal =round(Sum(debit) - Sum(credit),2) 
	from partydrcredtview p,parameter,acmast a  
	where edt >= sdtcur and p.edt <= @tdate
	and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
	and p.acname >= @fromparty and p.acname <= @toparty
	group by p.cltcode,p.acname 
	Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
	order by p.cltcode
end
*/

GO
