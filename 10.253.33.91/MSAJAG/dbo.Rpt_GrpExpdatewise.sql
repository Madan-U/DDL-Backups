-- Object: PROCEDURE dbo.Rpt_GrpExpdatewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_GrpExpdatewise    Script Date: 04/27/2001 4:32:42 PM ******/
CREATE proc Rpt_GrpExpdatewise (@fdate varchar(21),@tdate varchar(21),@code varchar(10),@settype varchar(3),
@settno varchar(7),@flag int) as
delete from RptGrpExpdatewise 
if @flag = 1 
begin
insert into RptGrpExpdatewise 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from tempsettsumExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like (case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and 
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from oppalbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   )  and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from PlusOneAlbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'
order by party_code
end 
else if @flag = 2 
begin
insert into RptGrpExpdatewise 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from tempsettsumExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like (case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and 
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%' 
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from oppalbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   )  and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%' and tmark <> '$'
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from PlusOneAlbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'  and tmark <> '$'
order by party_code
end 
else if @flag = 3 
begin
insert into RptGrpExpdatewise 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from tempsettsumExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like (case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and 
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%' 
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from oppalbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   )  and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%' and tmark = '$'
union All
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt,sauda_date from PlusOneAlbmExpdatewise 
where sauda_date >= @fdate and sauda_date <= @tdate +  ' 23:59:59'  and 
sett_type like(case when  ltrim(@settype)='%' then '%' else ltrim(@settype) end   ) and
sett_no like (case when  ltrim(@settno)='%' then '%' else ltrim(@settno) end   ) 
and party_code like ltrim(@code)+'%'  and tmark = '$'
order by party_code
end

GO
