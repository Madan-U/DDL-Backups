-- Object: PROCEDURE dbo.rpt_branchDelGet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_branchDelGet    Script Date: 05/08/2002 12:35:08 PM ******/







CREATE PROCEDURE rpt_branchDelGet

@dematid varchar(2),
@settno varchar(7),
@settype varchar(3),
@branch varchar(15)

AS

if @dematid = 1  
begin
	 select d.sett_no, d.sett_type, d.Scrip_cd, d.Series, 
	 GetFromNse = (case when inout = 'I' then Sum(d.Qty) else 0 end ),
	 RecievedNse=/* (case when inout='O' then Sum(d.Qty)else 0 end),*/
	isnull(( select Sum(qty) from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
		 scrip_cd = d.scrip_cd and series = d.series and party_code = c2.party_code and c1.cl_code = c2.cl_code
		and c1.trader like ltrim(@branch)+'%' 
		and DrCr = 'C' And Filler2 = 1 ),0), inout,
	 demat_date=isnull(s1.demat_date,getdate()+2),Branch=c1.trader
	 from scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt d 
	 where s1.co_code = s2.co_code and s1.series = s2.series
	 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
	 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = c2.party_code and c2.cl_code = c1.cl_code
	 and c1.trader like ltrim(@branch)+'%'  
	 and s1.demat_date < getdate() 
	 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, d.inout, c1.trader, c1.cl_code, c2.party_code, c2.cl_code,c1.Trader
	order by c1.trader,d.scrip_cd
end
if @dematid = 2  
begin
	 select d.sett_no, d.sett_type, d.Scrip_cd, d.Series, 
	 GetFromNse = (case when inout = 'I' then Sum(d.Qty) else 0 end ),
	 RecievedNse=/* (case when inout='O' then Sum(d.Qty)else 0 end),*/
	isnull(( select Sum(qty) from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
		 scrip_cd = d.scrip_cd and series = d.series and party_code = c2.party_code and c1.cl_code = c2.cl_code
		and c1.trader like ltrim(@branch)+'%' 
		and DrCr = 'C' And Filler2 = 1 ),0), inout,
	 demat_date=isnull(s1.demat_date,getdate()+2),Branch=c1.trader
	 from scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt d 
	 where s1.co_code = s2.co_code and s1.series = s2.series
	 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
	 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = c2.party_code and c2.cl_code = c1.cl_code
	 and c1.trader like ltrim(@branch)+'%'  
	 and s1.demat_date > getdate()
	group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, d.inout, c1.trader, c1.cl_code, c2.party_code, c2.cl_code,Trader
	order by c1.trader,d.scrip_cd
end

if @dematid = 3  
begin
	 select d.sett_no, d.sett_type, d.Scrip_cd, d.Series, 
	GetFromNse = (case when inout = 'I' then Sum(d.Qty) else 0 end ),
	 RecievedNse=/* (case when inout='O' then Sum(d.Qty)else 0 end),*/
	isnull(( select Sum(qty) from DelTrans where sett_no = d.sett_no and sett_type = d.sett_type and 
		 scrip_cd = d.scrip_cd and series = d.series and party_code = c2.party_code and c1.cl_code = c2.cl_code
		and c1.trader like ltrim(@branch)+'%' 
		and DrCr = 'C' And Filler2 = 1),0), inout,
	 demat_date=isnull(s1.demat_date,getdate()+2),Branch=c1.trader
	 from scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt d 
	 where s1.co_code = s2.co_code and s1.series = s2.series
	 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
	 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = c2.party_code and c2.cl_code = c1.cl_code
	 and c1.trader like ltrim(@branch)+'%'  
	 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, d.inout, c1.trader, c1.cl_code, c2.party_code, c2.cl_code,Trader
	 order by c1.trader,d.scrip_cd
end 
/*
if @branch <> '%'  
begin
if @dematid = 1
 FOR DELEVIRY FROM NSE (DEMAT SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers )),0),
            demat_date=isnull(s1.demat_date,getdate()+2) , c1.trader
  from delivery d,scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt dc, branches br

 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and d.sett_no = dc.sett_no and d.sett_type = dc.sett_type
 and d.scrip_cd = dc.scrip_cd and d.series = dc.series and dc.party_code = c2.party_code and c2.cl_code = c1.cl_code
 and c1.trader = br.short_name 
 and c1.trader like (case when  @branch  = '%' then  ltrim(@branch)+'%' else  @branch end  )
 and s1.demat_date < getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, c1.trader
end
if @dematid = 2
 FOR DELEVIRY FROM NSE (NON DEMAT SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers) ),0),demat_date=isnull(s1.demat_date,getdate()+2),
 c1.trader
 from delivery d,scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt dc, branches br
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and d.sett_no = dc.sett_no and d.sett_type = dc.sett_type
 and d.scrip_cd = dc.scrip_cd and d.series = dc.series and dc.party_code = c2.party_code and c2.cl_code = c1.cl_code
 and c1.trader = br.short_name  and c1.trader like  (case when  @branch  = '%' then  ltrim(@branch)+'%' else  @branch end  )
 and s1.demat_date > getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, c1.trader
end
if @dematid = 3 
 FOR DELEVIRY FROM NSE (ALL SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers) ),0),demat_date=isnull(s1.demat_date,getdate()+2),
 c1.trader
 from delivery d,scrip1 s1,scrip2 s2, client1 c1, client2 c2, deliveryclt dc, branches br
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype and d.sett_no = dc.sett_no and d.sett_type = dc.sett_type
 and d.scrip_cd = dc.scrip_cd and d.series = dc.series and dc.party_code = c2.party_code and c2.cl_code = c1.cl_code
 and c1.trader = br.short_name  and c1.trader like  (case when  @branch  = '%' then  ltrim(@branch)+'%' else  @branch end  )
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date, c1.trader
end
end 
else
begin
if @dematid = 1
 FOR DELEVIRY FROM NSE (DEMAT SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers )),0),
            demat_date=isnull(s1.demat_date,getdate()+2)
 from delivery d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype  and s1.demat_date < getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
end
if @dematid = 2
 FOR DELEVIRY FROM NSE (NON DEMAT SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers) ),0),demat_date=isnull(s1.demat_date,getdate()+2)
 from delivery d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype  and s1.demat_date > getdate()
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
end
if @dematid = 3 
 FOR DELEVIRY FROM NSE (ALL SCRIPS)
begin
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=Sum(d.Deliver_Qty),
 GivenNse= isnull(( select Sum(qty) from certinfo where sett_no = d.sett_no and sett_type = d.sett_type and 
 scrip_cd = d.scrip_cd and series = d.series and targetparty in ( select Distinct Broker_Code from brokers) ),0),demat_date=isnull(s1.demat_date,getdate()+2)
 from delivery d,scrip1 s1,scrip2 s2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.sett_no = @settno and d.sett_type = @settype
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,s1.demat_date
end
end 
*/

GO
