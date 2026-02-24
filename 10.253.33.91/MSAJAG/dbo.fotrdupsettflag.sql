-- Object: PROCEDURE dbo.fotrdupsettflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdupsettflag    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdupsettflag    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdupsettflag    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdupsettflag    Script Date: 20-Mar-01 11:38:51 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdupsettflag
(@settflag int,
@sellbuy int) as
 Update FOTRADE set settflag = @settflag from FOTRADE  
 where FOTRADE.sell_buy =@sellbuy

GO
