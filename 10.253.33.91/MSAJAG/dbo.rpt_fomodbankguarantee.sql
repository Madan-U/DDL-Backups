-- Object: PROCEDURE dbo.rpt_fomodbankguarantee
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodbankguarantee    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodbankguarantee    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodbankguarantee    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodbankguarantee    Script Date: 5/5/2001 1:24:13 PM ******/
CREATE PROCEDURE rpt_fomodbankguarantee

@code varchar(10),
@sdate varchar(12)

AS

select exch_indicator,seg_indicator,cl_type,party_code,sysid,bankId,bk_guarantee_no,bk_guarantee_amt,guarantee_bal_amt,issue_dt,maturity_dt,lastclaim_dt,status,create_dt,created_by,guarantee_rec_dt,remarks,update_dt,old_id 
from bankguarantee 
where party_code = @code  
and exch_indicator = 'NSE' 
and seg_indicator like 'FUT%' 
and status='V'
and maturity_dt >= @sdate

GO
