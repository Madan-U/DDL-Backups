-- Object: PROCEDURE dbo.OldClientDrCrSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.OldClientDrCrSp    Script Date: 2/17/01 3:34:15 PM ******/

/****** Object:  Stored Procedure dbo.oldClientDrCrSp    Script Date: 20-Mar-01 11:43:32 PM ******/

/*Created by vaishali on 28/02/2001
Calculated the debit and credit amount for client
*/
CREATE PROCEDURE OldClientDrCrSp

@tdate as varchar(21),
@fromparty varchar(10),
@toparty varchar(10),
@fromamt money,
@toamt money,
@flag tinyint

AS
/*For all parties and  for no range of amount*/
if @flag = 1
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal = round(Sum(debit),2) - round(Sum(credit),2) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1' 
group by p.cltcode,p.acname 
order by p.acname
end

 /*For specified parties and  for no range of amount*/
if @flag = 2
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal = round(Sum(debit),2) - round(Sum(credit),2) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1' 
and p.cltcode >= @fromparty and p.cltcode <= @toparty
group by p.cltcode,p.acname 
order by p.acname
end 

/*For all parties and  for specified from amount*/
if @flag = 3
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1' 
group by p.cltcode,p.acname  Having Abs(Sum(debit) - Sum(credit)) >= @fromamt
order by p.acname
end


 /*For specified parties and  for specified from amount*/
if @flag = 4
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1' 
and p.cltcode >= @fromparty and p.cltcode <= @toparty
group by p.cltcode,p.acname  
Having Abs(Sum(debit) - Sum(credit)) >= @fromamt
order by p.acname
end


/*For all parties and  for specified from amount*/

if @flag = 5
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
group by p.cltcode,p.acname 
Having Abs(Sum(debit) - Sum(credit)) <= @toamt 
order by p.acname
end


if @flag = 6
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
and p.cltcode >= @fromparty and p.cltcode <= @toparty
group by p.cltcode,p.acname 
Having Abs(Sum(debit) - Sum(credit)) <= @toamt 
order by p.acname
end


if @flag = 7
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
group by p.cltcode,p.acname 
Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
order by p.acname
end


if @flag = 8
begin
select isnull(p.cltcode,''),isnull(p.acname,''),bal =(round(Sum(debit),2) - round(Sum(credit),2)) 
from partydrcrview p,parameter,acmast a  
where vdt >= sdtcur and p.vdt <= @tdate
and p.cltcode = a.cltcode and a.accat = '4' and curyear = '1'
and p.cltcode >= @fromparty and p.cltcode <= @toparty
group by p.cltcode,p.acname 
Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - Sum(credit)) <= @toamt 
order by p.acname
end

GO
