-- Object: PROCEDURE dbo.sbobligation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbobligation    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbobligation    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbobligation    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbobligation    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbobligation    Script Date: 12/27/00 8:59:01 PM ******/

/* displays internal obligation for a particular settlement for a subbroker */
CREATE PROCEDURE sbobligation
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12),
@subbroker varchar(15)
AS
select inout,scrip_cd,sum(qty) from deliveryclt clt, client1 c1, client2 c2, subbrokers sb 
where sett_no=@settno  and sett_type=@settype  and scrip_Cd=@scripcd and 
sb.sub_broker=c1.sub_broker and c2.party_code=clt.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=@subbroker 
group by inout,scrip_Cd ,series
order by inout

GO
