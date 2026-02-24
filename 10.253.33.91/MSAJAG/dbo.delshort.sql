-- Object: PROCEDURE dbo.delshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.delshort    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.delshort    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.delshort    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.delshort    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.delshort    Script Date: 12/27/00 8:59:07 PM ******/

CREATE PROCEDURE delshort 
@settno varchar(8),
@setttype varchar (3)
as
select  d.scrip_Cd,d.series, d.entitycode,d.name, d.Deliver_Qty, d.Delivered_Qty, 
qty=isnull((select sum(qty)from certinfo c where c.sett_no=d.sett_no and c.sett_type=d.sett_type and c.scrip_cd=d.scrip_Cd and 
c.series=d.series and c.targetparty=d.entitycode group by c.sett_no,c.sett_type, c.scrip_Cd,c.series),0), 
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() and s1.co_code=s2.co_code and s2.scrip_cd=d.scrip_cd
and s2.series=d.series ), '')
 from delivery d where d.sett_no=@settno and d.sett_type=@setttype

GO
