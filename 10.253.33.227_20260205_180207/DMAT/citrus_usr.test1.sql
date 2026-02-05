-- Object: PROCEDURE citrus_usr.test1
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[test1]
 
@accno varchar(100)
 as
select * from a where dpam_sba_no= @accno

GO
