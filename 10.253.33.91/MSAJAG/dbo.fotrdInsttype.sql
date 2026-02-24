-- Object: PROCEDURE dbo.fotrdInsttype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdInsttype    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdInsttype    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdInsttype    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdInsttype    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/



CREATE Proc fotrdInsttype as
   /*This store procedure selects Instrument type, symbol and account from foconfirmview*/
select distinct Inst_type, Symbol,party_code,option_type,strike_price from foconfirmview

GO
