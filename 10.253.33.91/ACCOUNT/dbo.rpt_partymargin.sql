-- Object: PROCEDURE dbo.rpt_partymargin
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_partymargin    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_partymargin    Script Date: 11/28/2001 12:23:50 PM ******/




/****** Object:  Stored Procedure dbo.rpt_partymargin    Script Date: 2/17/01 5:19:53 PM ******/

/* report : allpartyledger
    file : cumledger.asp
    finds margin of a party for a particular exchange and markettype
*/
/*changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase
*/
 
CREATE PROCEDURE rpt_partymargin
@partycode varchar(10)
AS
select c2.cl_code, c3.margin from client3 c3, client2 c2 
where c3.party_code=@partycode  and
c2.cl_code=c3.cl_code and c3.party_code=c2.party_code
and c2.exchange=c3.exchange and c3.markettype='capital'

GO
