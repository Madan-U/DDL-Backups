-- Object: PROCEDURE dbo.defferedpos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.defferedpos    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.defferedpos    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.defferedpos    Script Date: 20-Mar-01 11:38:49 PM ******/

create procedure defferedpos 
@sett_no varchar(7),
@sauda_date smalldatetime     
as
select scrip_cd,series,
	pqty=sum(pqty),sqty=sum(sqty),
	tot=sum(pqty)-sum(sqty)
	from tempgrossvwn
	where sett_no =@sett_no
	and sauda_date <= @sauda_date 
	and scrip_cd in(select distinct scrip_cd from settlement where sett_type ='L' and sett_no = @sett_no and left(order_no,1) <> 'P')
	group by scrip_cd,series
union 
select scrip_cd,series,pqty=sum(pqty),sqty=sum(sqty),tot=sum(pqty)-sum(sqty)
	from tempgrossvwl where sett_no =(select min(Sett_no) from sett_mst where sett_no >@sett_no and  sett_type ='N')
	and sauda_date <= @sauda_date 
	and scrip_cd in(select distinct scrip_cd from settlement where sett_type = 'L' and sett_no = (select min(Sett_no) from sett_mst where sett_no > @sett_no and  sett_type = 'N') and left(order_no,1) <> 'P')
	group by scrip_cd,series
	order by scrip_cd

GO
