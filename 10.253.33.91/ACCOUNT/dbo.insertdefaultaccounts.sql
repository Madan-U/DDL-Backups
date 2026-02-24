-- Object: PROCEDURE dbo.insertdefaultaccounts
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 20-Mar-01 11:43:33 PM ******/
/*WRITTEN BY vns ON 03-fEB-2001*/
/*To insert default accounts in account master */

CREATE PROCEDURE insertdefaultaccounts AS

/* for NSE CM */

insert into defaacmast values('CLEARING HOUSE','CLEARING HOUSE','LIABILITY','3','','99985','','L0101000000')
insert into defaacmast values('BROKERAGE REALISED','BROKERAGE REALISED','INCOME','3','','99990','','N0101000000')
insert into defaacmast values('SERVICE TAX','SERVICE TAX','LIABILITY','3','','99988','','L0101000000')
insert into defaacmast values('DELIVERY CHARGES','DELIVERY CHARGES','INCOME','3','','61310','','N0101000000')
insert into defaacmast values('ROUNDING OFF','ROUNDING OFF','INCOME','3','','100','','N0101000000')
insert into defaacmast values('MARGIN','MARGIN','LIABILITY','3','','99984','','N0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99987','','L0101000000')
insert into defaacmast values('SEBI TURNOVER TAX','SEBI TURNOVER TAX','LIABILITY','3','','99970','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99971','','L0101000000')
insert into defaacmast values('INSURANCE CHARGES','INSURANCE CHARGES','LIABILITY','3','','99972','','L0101000000')
insert into defaacmast values('BROKER NOTE STAMP CHARGES','BROKER NOTE STAMP CHARGES','LIABILITY','3','','99973','','L0101000000')
insert into defaacmast values('OTHER CHARGES','OTHER CHARGES','LIABILITY','3','','99974','','L0101000000')


/* for NSE FO */

insert into defaacmast values('CLEARING HOUSE','CLEARING HOUSE','LIABILITY','3','','99885','','L0101000000')
insert into defaacmast values('BROKERAGE REALISED','BROKERAGE REALISED','INCOME','3','','99890','','N0101000000')
insert into defaacmast values('SERVICE TAX','SERVICE TAX','LIABILITY','3','','99888','','L0101000000')
insert into defaacmast values('ROUNDING OFF','ROUNDING OFF','INCOME','3','','200','','N0101000000')
insert into defaacmast values('MARGIN','MARGIN','LIABILITY','3','','99891','','N0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99887','','L0101000000')
insert into defaacmast values('SEBI TURNOVER TAX','SEBI TURNOVER TAX','LIABILITY','3','','99870','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99871','','L0101000000')
insert into defaacmast values('INSURANCE CHARGES','INSURANCE CHARGES','LIABILITY','3','','99872','','L0101000000')
insert into defaacmast values('BROKER NOTE STAMP CHARGES','BROKER NOTE STAMP CHARGES','LIABILITY','3','','99873','','L0101000000')
insert into defaacmast values('OTHER CHARGES','OTHER CHARGES','LIABILITY','3','','99874','','L0101000000')


/*for BSE CM */

insert into defaacmast values('CLEARING HOUSE','CLEARING HOUSE','LIABILITY','3','','99785','','L0101000000')
insert into defaacmast values('BROKERAGE REALISED','BROKERAGE REALISED','INCOME','3','','99790','','N0101000000')
insert into defaacmast values('SERVICE TAX','SERVICE TAX','LIABILITY','3','','99788','','L0101000000')
insert into defaacmast values('DELIVERY CHARGES','DELIVERY CHARGES','INCOME','3','','61410','','N0101000000')
insert into defaacmast values('ROUNDING OFF','ROUNDING OFF','INCOME','3','','300','','N0101000000')
insert into defaacmast values('MARGIN','MARGIN','LIABILITY','3','','99791','','N0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99787','','L0101000000')
insert into defaacmast values('SEBI TURNOVER TAX','SEBI TURNOVER TAX','LIABILITY','3','','99770','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99771','','L0101000000')
insert into defaacmast values('INSURANCE CHARGES','INSURANCE CHARGES','LIABILITY','3','','99772','','L0101000000')
insert into defaacmast values('BROKER NOTE STAMP CHARGES','BROKER NOTE STAMP CHARGES','LIABILITY','3','','99773','','L0101000000')
insert into defaacmast values('OTHER CHARGES','OTHER CHARGES','LIABILITY','3','','99774','','L0101000000')


/* for BSE FO */

insert into defaacmast values('CLEARING HOUSE','CLEARING HOUSE','LIABILITY','3','','99685','','L0101000000')
insert into defaacmast values('BROKERAGE REALISED','BROKERAGE REALISED','INCOME','3','','99690','','N0101000000')
insert into defaacmast values('SERVICE TAX','SERVICE TAX','LIABILITY','3','','99688','','L0101000000')
insert into defaacmast values('ROUNDING OFF','ROUNDING OFF','INCOME','3','','400','','N0101000000')
insert into defaacmast values('MARGIN','MARGIN','LIABILITY','3','','99691','','N0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99687','','L0101000000')
insert into defaacmast values('SEBI TURNOVER TAX','SEBI TURNOVER TAX','LIABILITY','3','','99970','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99971','','L0101000000')
insert into defaacmast values('INSURANCE CHARGES','INSURANCE CHARGES','LIABILITY','3','','99972','','L0101000000')
insert into defaacmast values('BROKER NOTE STAMP CHARGES','BROKER NOTE STAMP CHARGES','LIABILITY','3','','99973','','L0101000000')
insert into defaacmast values('OTHER CHARGES','OTHER CHARGES','LIABILITY','3','','99974','','L0101000000')

GO
