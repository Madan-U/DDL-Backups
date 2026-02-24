-- Object: PROCEDURE dbo.Rpt_GrpExp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_GrpExp    Script Date: 04/27/2001 4:32:42 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_GrpExp    Script Date: 3/21/01 12:50:17 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_GrpExp    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_GrpExp    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_GrpExp    Script Date: 12/27/00 8:59:11 PM ******/

CREATE proc Rpt_GrpExp (@sett_no varchar(7),@sett_type varchar(2),@code varchar(10)) as
delete from RptGrpExp 
insert into RptGrpExp 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt
 from tempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'
union all
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt
 from oppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'
union all
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt
 from PlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code like ltrim(@code)+'%'
order by party_code

GO
