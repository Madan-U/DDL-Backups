-- Object: PROCEDURE dbo.FoNseSpMarginPercent
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoNseSpMarginPercent    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FoNseSpMarginPercent    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoNseSpMarginPercent    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoNseSpMarginPercent    Script Date: 20-Mar-01 11:38:50 PM ******/

/*The procedure was last updated on 6 th feb 2001*/
/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE PROC FoNseSpMarginPercent
(@inst varchar(6),
 @symbol varchar(12),
 @near_expirydate smalldatetime,
 @far_expirydate smalldatetime ) as

/*This store procedure returns the spread percentage according to the parameter passed*/
/*Created on 22 nov 2000*/

select spreadmargin from fonsespmargin
 where left(convert(varchar,near_expirydate,109),11)=@near_expirydate and 
       left(convert(varchar,far_expirydate,109),11)=@far_expirydate and 
      /* valiD_date >=(select getdate()) and*/
       inst_type=@inst and
       symbol=@symbol and   
       date=(select max(date) from fonsespmargin
                    where inst_type =@inst AND
                          SYMBOL =@symbol and
                left(convert(varchar,near_expirydate,109),11)=@near_expirydate and 
             left(convert(varchar,far_expirydate,109),11)=@far_expirydate and
              /*The below line has been added on 2nd feb 2001 since the non spread margin was not taking properly it new non spread margin was taken*/
             /*The below condition was not added */
                        date <=(select getdate())
         )

GO
