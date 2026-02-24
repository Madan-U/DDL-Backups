-- Object: PROCEDURE dbo.fotrdSelectSmSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdSelectSmSett    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdSelectSmSett    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdSelectSmSett    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdSelectSmSett    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdSelectSmSett(@settflag1 int,@settflag2 int) as
select trade_no,party_code,tradeqty,price,sauda_date,inst_type,
symbol,sec_name,expirydate,strike_price,option_type from fosettlement
where settflag=@settflag1 or settflag=@settflag2

GO
