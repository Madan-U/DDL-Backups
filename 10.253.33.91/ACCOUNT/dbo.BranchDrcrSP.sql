-- Object: PROCEDURE dbo.BranchDrcrSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.BranchDrcrSP    Script Date: 01/08/2003 1:51:49 PM ******/
CREATE PROCEDURE BranchDrcrSP
@cltcode as varchar(10),
@fromdate as varchar(21),
@todate as varchar(21),
@fromamt money,
@toamt money,
@flag tinyint
As
If @flag = 0
begin
select cltcode = isnull(cltcode,''),acname = isnull(acname,''),costcode,
bal =round(Sum(debit) - Sum(credit),2)
from branchbalance
where vdt >= @fromdate and vdt <= @todate and cltcode = rtrim(@Cltcode)
group by cltcode,acname,costcode
Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - 
Sum(credit)) <= @toamt
order by cltcode
end
else if @flag = 1
begin
select cltcode = isnull(cltcode,''),acname = isnull(acname,''),costcode,
bal =round(Sum(debit) - Sum(credit),2)
from branchbalance
where vdt >= @fromdate and vdt <= @todate and cltcode = rtrim(@Cltcode)
group by cltcode,acname,costcode
Having  Abs(Sum(debit) - Sum(credit)) >= @fromamt and Abs(Sum(debit) - 
Sum(credit)) <= @toamt
order by acname
end

GO
