-- Object: PROCEDURE dbo.sbNetNsedemat
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbNetNsedemat    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNsedemat    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNsedemat    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNsedemat    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbNetNsedemat    Script Date: 12/27/00 8:59:00 PM ******/

/*** file : dematscrip.asp
    report : NetPosition nse  
displays settlementwise, scripwise position
 ***/
CREATE PROCEDURE 
sbNetNsedemat 
@settno varchar(7),
@settype varchar(3),
@subbroker varchar(15)
AS
select s.scrip_cd,s.series,s.sell_buy,Qty=sum(s.tradeqty),Amt=sum(s.tradeqty*marketrate),s.sett_no,s.sett_Type,
isnull(s1.demat_date,0)
 from settlement s,scrip1 s1, scrip2 s2 ,client1 c1,client2 c2,subbrokers sb
where s1.co_code = s2.co_code and s1.series = s2.series and s2.scrip_cd = s.scrip_cd
 and s2.series =s.series and s.sett_no = @settno and s.sett_type = @settype
and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and  sb.sub_broker=@subbroker and 
s.party_code=c2.party_code
group by s.scrip_cd,s.series,s.sell_buy,s.sett_no,s.sett_Type,s1.demat_date 
order by s.scrip_cd,s.series,s.sett_no,s.sett_Type,s.sell_buy

GO
