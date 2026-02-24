-- Object: PROCEDURE dbo.rpt_datewisedetailofposscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datewisedetailofposscrip    Script Date: 04/27/2001 4:32:38 PM ******/
/* report : datewise position report 
    file :datewisescriptrans.asp
*/
CREATE  PROCEDURE rpt_datewisedetailofposscrip 
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12),
@series varchar(3),
@sdate varchar(12),
@flag int
as

if @flag = 1
begin
select  * from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode 
and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate 
union all
select *  from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series 
and left(convert(varchar,sauda_date,109),11) = @sdate  
union all
select *  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate 
order by sauda_date
end
else if @flag = 2
begin
select  * from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate   
union all
select *  from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate  and tmark <>'$'
union all
select *  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate   and tmark <>'$'
order by sauda_date
end
else if @flag = 3
begin
select  * from detailtempsettsumExp where sett_no=@settno and sett_type=@settype and party_code=@partycode and scrip_cd=@scripcd  and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate  
union all
select *  from detailoppalbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series 
and left(convert(varchar,sauda_date,109),11) = @sdate   and tmark = '$'
union all
select *  from detailPlusOneAlbmExp where sett_no=@settno and sett_type=@settype  and party_code=@partycode and scrip_cd=@scripcd and series=@series
and left(convert(varchar,sauda_date,109),11) = @sdate   and tmark = '$'
order by sauda_date
end

GO
