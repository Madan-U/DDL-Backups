-- Object: PROCEDURE dbo.Rpt_settosetGrpExp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_settosetGrpExp    Script Date: 04/27/2001 4:32:49 PM ******/
CREATE  proc Rpt_settosetGrpExp (@fromsett varchar(7),@tosett varchar(7), @sett_type varchar(2),@code varchar(10),@flag int) as
delete from settrptgrpexp

if @flag = 1
begin
insert into  settrptgrpexp 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from tempsettsumExp where sett_no in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
union 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from oppalbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
union
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from PlusOneAlbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
order by party_code, scrip_cd
end 
else
if @flag = 2
begin
insert into  settrptgrpexp 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from tempsettsumExp where sett_no in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
union 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from oppalbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%' and tmark <> '$'
union
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from PlusOneAlbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%' and tmark <> '$'
order by party_code, scrip_cd
end 
else
if @flag = 3
begin
insert into  settrptgrpexp 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from tempsettsumExp where sett_no in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
union 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from oppalbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%' and tmark = '$'
union
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt from PlusOneAlbmExp where sett_no  in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%' and tmark = '$'
order by party_code, scrip_cd
end

GO
