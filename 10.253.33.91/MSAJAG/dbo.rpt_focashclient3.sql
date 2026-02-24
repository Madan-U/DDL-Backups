-- Object: PROCEDURE dbo.rpt_focashclient3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 4/30/01 5:50:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focashclient3    Script Date: 12/27/00 8:59:09 PM ******/
CREATE PROCEDURE rpt_focashclient3
@code varchar(10)
AS
select isnull(margin_recd ,0)
from client3 
where party_code = @code
and exchange = 'NSE' 
and markettype like 'Future%'

GO
