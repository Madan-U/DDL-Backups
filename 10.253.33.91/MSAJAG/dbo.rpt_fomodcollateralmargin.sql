-- Object: PROCEDURE dbo.rpt_fomodcollateralmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodcollateralmargin    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateralmargin    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateralmargin    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcollateralmargin    Script Date: 5/5/2001 1:24:14 PM ******/
CREATE PROCEDURE rpt_fomodcollateralmargin

@code varchar(10)

AS

select cl_code,party_code,exchange,markettype,margin,nooftimes,margin_recd,MtoM,pmarginrate,MtoMdate 
from client3 
where party_code = @code 
and exchange = 'NSE'  
and markettype like 'FUT%'

GO
