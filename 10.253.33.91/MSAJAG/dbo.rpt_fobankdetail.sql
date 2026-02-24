-- Object: PROCEDURE dbo.rpt_fobankdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 5/7/2001 9:02:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 5/5/2001 2:43:35 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 5/5/2001 1:24:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 4/30/01 5:50:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fobankdetail    Script Date: 12/27/00 8:59:08 PM ******/
CREATE PROCEDURE rpt_fobankdetail
@code varchar(10)
AS
select party_code,po.bank_name, po.branch_name, 
bk_guarantee_no, convert(varchar,maturity_dt,106) as maturitydate, bk_guarantee_amt
from bankguarantee bk, pobank po
where exch_indicator = 'NSE'
and seg_indicator like 'Fut%'
and party_code = @code
and bk.bankid = po.bankid

GO
