-- Object: PROCEDURE dbo.rpt_iGrpExp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_iGrpExp    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iGrpExp    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iGrpExp    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iGrpExp    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_iGrpExp    Script Date: 12/27/00 8:59:12 PM ******/

CREATE proc  rpt_iGrpExp (@sett_no varchar(7),@sett_type varchar(2),@code varchar(10), @pcode varchar(15), @statusid varchar(15), @statusname varchar(25)) as
if @statusid='broker' 
begin
delete from iRptGrpExp 
insert into iRptGrpExp 
select * from itempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
union 
select * from ioppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'  and partipantcode like ltrim(@pcode)+'%'
union
select * from iPlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
order by party_code
end
if @statusid='branch' 
begin
delete from iRptGrpExp 
insert into iRptGrpExp 
select * from itempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
union 
select * from ioppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'  and partipantcode like ltrim(@pcode)+'%'
union
select * from iPlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
order by party_code
end
if @statusid='trader' 
begin
delete from iRptGrpExp 
insert into iRptGrpExp 
select * from itempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
union 
select * from ioppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'  and partipantcode like ltrim(@pcode)+'%'
union
select * from iPlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
order by party_code
end
if @statusid='subbroker' 
begin
delete from iRptGrpExp 
insert into iRptGrpExp 
select * from itempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
union 
select * from ioppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code like ltrim(@code)+'%'  and partipantcode like ltrim(@pcode)+'%'
union
select * from iPlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code like ltrim(@code)+'%' and partipantcode like ltrim(@pcode)+'%'
order by party_code
end
if @statusid='client' 
begin
delete from iRptGrpExp 
insert into iRptGrpExp 
select * from itempsettsumExp where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' and party_code =@statusname and partipantcode like ltrim(@pcode)+'%'
union 
select * from ioppalbmExp where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' and party_code =@statusname  and partipantcode like ltrim(@pcode)+'%'
union
select * from iPlusOneAlbmExp where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' and party_code  =@statusname and partipantcode like ltrim(@pcode)+'%'
order by party_code
end

GO
