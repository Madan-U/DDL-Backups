-- Object: PROCEDURE dbo.fopmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fopmargin    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.fopmargin    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.fopmargin    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fopmargin    Script Date: 20-Mar-01 11:38:50 PM ******/

CREATE proc fopmargin 
 @party varchar(10) as
/*created on 9 feb 2001 - ranjeet*/
/*this store procedure is used in fomargin control */
/*it is used to reterive pmargin rate from client3 table*/
 select pmarginrate from client3 
 where party_code= @party and markettype like 'Future%'

GO
