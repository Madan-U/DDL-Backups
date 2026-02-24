-- Object: PROCEDURE dbo.rpt_NSEDelShrtGet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_NSEDelShrtGet    Script Date: 05/08/2002 12:35:16 PM ******/







CREATE PROCEDURE rpt_NSEDelShrtGet
@dematid varchar(2),
@settno varchar(7),
@settype varchar(3)
AS
if @dematid = 1
/* FOR DELEVIRY FROM NSE (DEMAT SCRIPS)*/
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GetFromNse=Sum(d.Qty),
 RecievedNse= isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and ShareType = 'DEMAT' and filler2 = 1),0),demat_date=isnull(s1.demat_date,getdate()+2)
 from DelNet d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and inout = 'O' and s1.demat_date < getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
having Sum(d.Qty) <> isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and ShareType = 'DEMAT' and filler2 = 1),0)
 Order By d.sett_no,d.sett_type,d.scrip_cd,d.series
end
if @dematid = 2
/* FOR DELEVIRY FROM NSE (NON DEMAT SCRIPS)*/
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GetFromNse=Sum(d.Qty),
 RecievedNse= isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and ShareType = 'PHYSICAL' and filler2 = 1),0),demat_date=isnull(s1.demat_date,getdate()+2)
 from DelNet d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and inout = 'O' and s1.demat_date > getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
having Sum(d.Qty) <> isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and ShareType = 'PHYSICAL' and filler2 = 1),0)
 Order By d.sett_no,d.sett_type,d.scrip_cd,d.series
end
if @dematid = 3 
/* FOR DELEVIRY FROM NSE (ALL SCRIPS)*/
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GetFromNse=Sum(d.Qty),
 RecievedNse= isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and filler2 = 1 ),0),demat_date=isnull(s1.demat_date,getdate()+2)
 from DelNet d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and inout = 'O' 
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
having Sum(d.Qty) <> isnull(( select Sum(qty)from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and TrType = 906 and DrCr = 'C' and filler2 = 1 ),0)
 Order By d.sett_no,d.sett_type,d.scrip_cd,d.series
end

GO
