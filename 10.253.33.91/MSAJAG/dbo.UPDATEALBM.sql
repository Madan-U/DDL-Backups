-- Object: PROCEDURE dbo.UPDATEALBM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.UPDATEALBM    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.UPDATEALBM    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.UPDATEALBM    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.UPDATEALBM    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.UPDATEALBM    Script Date: 12/27/00 8:59:05 PM ******/

CREATE PROC UPDATEALBM as
update sett_mst set MarketType = ( case when sett_type = 'N' then '03' 
        else ( case when sett_type = 'M' then '05'   
        else ( case when sett_type = 'W' then '01'
                                                          end )
                                                       end )
                                                      end )

GO
