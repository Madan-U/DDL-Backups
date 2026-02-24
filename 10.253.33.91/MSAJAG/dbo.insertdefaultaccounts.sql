-- Object: PROCEDURE dbo.insertdefaultaccounts
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 7/1/01 2:19:43 PM ******/

/****** Object:  Stored Procedure dbo.insertdefaultaccounts    Script Date: 06/28/2001 5:44:43 PM ******/

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
insert into defaacmast values('SEBI TAX','SEBI  TAX','LIABILITY','3','','99892','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99893','','L0101000000')
insert into defaacmast values('CLEARING CHARGES','CLEARING CHARGES','LIABILITY','3','','99894','','L0101000000')
insert into defaacmast values('REVERSE CLEARING CHARGES','REVERSE CLEARING CHARGES','LIABILITY','3','','99895','','L0101000000')
insert into defaacmast values('CLEARING PREMIUM ACCOUNT','CLEARING PREMIUM ACCOUNT','LIABILITY','3','','99897','','L0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99887','','L0101000000')


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
insert into defaacmast values('TRANSACTION CHARGES','TRANSACTION CHARGES','LIABILITY','3','','99691','','N0101000000')
insert into defaacmast values('SERVICE TAX PAYABLE','SERVICE TAX PAYABLE','LIABILITY','3','','99687','','L0101000000')
insert into defaacmast values('BANK CHARGES','BANK CHARGES','LIABILITY','3','','99692','','N0101000000')
insert into defaacmast values('REVERSE ENTRY FOR CLEARING ACCOUNT','REVERSE ENTRY FOR CLEARING ACCOUNT','LIABILITY','3','','99694','','N0101000000')
insert into defaacmast values('TM - MTOM','TM - MTOM','LIABILITY','3','','99696','','N0101000000')
insert into defaacmast values('TM - REVERSE MTOM','TM - REVERSE MTOM','LIABILITY','3','','99697','','N0101000000')
insert into defaacmast values('BANK MTOM FOR TM','BANK MTOM FOR TM','LIABILITY','3','','99698','','N0101000000')
insert into defaacmast values('CLEARING PREMIUM ACCOUNT','CLEARING PREMIUM ACCOUNT','LIABILITY','3','','99680','','N0101000000')
insert into defaacmast values('SEBI TAX','SEBI TAX','LIABILITY','3','','99682','','L0101000000')
insert into defaacmast values('TURNOVER TAX','TURNOVER TAX','LIABILITY','3','','99684','','L0101000000')

GO
