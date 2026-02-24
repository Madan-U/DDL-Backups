-- Object: PROCEDURE dbo.dematscrips_asp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.dematscrips_asp    Script Date: 12/18/99 8:24:04 AM ******/
CREATE PROCEDURE dematscrips_asp (@Party varchar(30),@scrip Varchar(12)) AS 
select Party_code,short_name,Scrip_Cd,series,sum(tqty) 'qty',sum(tamt) 'Amount',sell_buy,Res_Phone1,Fax  from dematview 
where short_name like @party+'%' and scrip_cd like @scrip+'%'
group by Party_code,short_name,Scrip_Cd,series,sell_buy ,Res_Phone1,Fax
having sum(tqty) <> 0
order by Party_code,short_name,Scrip_Cd,series,sell_buy,Res_Phone1,Fax

GO
