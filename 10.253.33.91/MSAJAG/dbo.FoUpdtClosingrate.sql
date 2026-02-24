-- Object: PROCEDURE dbo.FoUpdtClosingrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoUpdtClosingrate    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoUpdtClosingrate    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoUpdtClosingrate    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.FoUpdtClosingrate    Script Date: 20-Mar-01 11:38:51 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

/*modified on 17/01/2001 the input parameter trade_date was added on 17 /01/2001*/
/*This store proc is used in the foclosingctlprj control*/
/*segment nsefo*/
/*made by ranjeet choudhary*/
/*the function of this store procedure is to update the closing rate as per the parameter passed*/
/* all the parameters are necessary to be passed from the control*/
CREATE proc FoUpdtClosingrate
( @rate  money,
  @inst varchar(6),
  @symbol varchar(12),
  @expirydt varchar(30),
  @option varchar(2),
  @strike money,
  @Trade_Date smalldatetime
   ) as
  


update foclosing 
set cl_rate=@rate
 where inst_type=@inst and 
symbol = @symbol and
 expirydate =@expirydt and 
option_type =@option and 
strike_price=@strike and
TRADE_DATE=@trade_date

GO
