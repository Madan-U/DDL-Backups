-- Object: PROCEDURE dbo.fobillupsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fobillupsett    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.fobillupsett    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.fobillupsett    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.fobillupsett    Script Date: 20-Mar-01 11:38:49 PM ******/



/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc fobillupsett(
@billno varchar(5),
@contractno varchar(5)
)as

update fosettlement set billno=@billno,billflag=1 
where contractno =@contractno
and (settflag=2 or settflag=3)

GO
