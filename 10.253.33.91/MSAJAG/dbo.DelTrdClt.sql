-- Object: PROCEDURE dbo.DelTrdClt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DelTrdClt    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DelTrdClt    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DelTrdClt    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.DelTrdClt    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DelTrdClt    Script Date: 12/27/00 8:59:07 PM ******/

CREATE PROC  DelTrdClt ( @partycode varchar(10) , @scripcd varchar(12) , @settno varchar(7)   ) AS
 select distinct  c1.party_code from client2 c1 where c1.cl_code in
          ( select distinct cl_Code from client2,dematdelivery d1 
            where client2.Party_code = d1.party_code 
            and client2.party_code <> c1.party_code 
            and d1.party_code = @partycode and d1.sett_no = @settno and d1.scrip_cd = @scripcd)

GO
