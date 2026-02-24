-- Object: PROCEDURE dbo.Sbdealingadress
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  procedure [dbo].[Sbdealingadress]   as



truncate table vwGetSubBrokerDetail_dummY

  

insert into   vwGetSubBrokerDetail_dummY

select  SBTAG AS SUB_BROKER,SBNAME AS NAME,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then 'G-1, Akruti Trade Centre, Road No. 7,' else [Terminal Address 1] end) as ADDRESS1,    

(case when [Terminal Address 1]  like  'Not CTCL ID' then 'MIDC Marol, Andheri (East),' else [Terminal Address 2] end) as ADDRESS2,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '' else [Terminal Address 3] end) AS ADDRESS3,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then 'MUMBAI' else [Terminal City] end) AS CITY,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then 'MAHARASHTRA' else [Terminal State] end) AS STATE,    

 '' AS NATION,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '400093' else [Terminal PinCode] end) AS ZIP,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '' else [Terminal Fax] end) AS FAX,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '' else [Terminal Telephone] end) AS PHONE1,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '' else [Terminal Mobile] end) AS PHONE2,    

'' AS REG_NO,'' AS REGISTERED,'' AS MAIN_SUB,    

(case when [Terminal Address 1]  like 'Not CTCL ID' then '' else [TerminalEmail] end) AS EMAIL,    

'' AS COM_PERC,BRANCH AS BRANCH_CODE,AUTHSIGN AS CONTACT_PERSON,'' AS REMPARTYCODE,'B2B' AS SBTYPE    

    

 from INTRANET.ctclnew.dbo.vwGetSubBrokerDetail with (nolock)    

    

 UNION ALL    

  

    

 SELECT SUB_BROKER ,NAME,ADDRESS1,    

    

 ADDRESS2,ADDRESS3,CITY,STATE,NATION,ZIP,FAX,PHONE1,PHONE2,REG_NO,    

    

REGISTERED,MAIN_SUB,EMAIL,COM_PERC,BRANCH_CODE,CONTACT_PERSON,REMPARTYCODE,SBTYPE  FROM sb_dealing 



UPDATE vwGetSubBrokerDetail_dummY SET ADDRESS1= REPLACE( ADDRESS1,'"',''),ADDRESS2= REPLACE( ADDRESS2,'"',''),ADDRESS3= REPLACE( ADDRESS3,'"','')

GO
