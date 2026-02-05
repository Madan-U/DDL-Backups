-- Object: PROCEDURE citrus_usr.pr_relation_data
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--exec pr_relation_data

CREATE   proc [citrus_usr].[pr_relation_data]
as
truncate table Rel_data
--DROP TABLE #TEMPRL
truncate table ENTR_Data_for_data

insert into ENTR_Data_for_data
select entr_sba  ,ENTR_HO,ENTR_RE,ENTR_AR,ENTR_BR,ENTR_DUMMY4,ENTR_DUMMY5   from entity_relationship 
where  ENTR_DELETED_IND = 1 and getdate () between ENTR_FROM_DT and isnull (ENTR_TO_DT , 'Dec 31 2900')



select entr_sba sba , entm_name1  RE , '' AR , ''BR , ''SB ,'' DUMMY1 , '' DUMMY5     into #TEMPRL  from ENTR_Data_for_data , entity_mstr 
where entm_id =  entr_RE and ENTM_ENTTM_CD = 'RE'

ALTER TABLE #TEMPRL
ALTER COLUMN AR VARCHAR (70)
ALTER TABLE #TEMPRL
ALTER COLUMN BR VARCHAR (70)
ALTER TABLE #TEMPRL
ALTER COLUMN SB VARCHAR (70)
ALTER TABLE #TEMPRL
ALTER COLUMN DUMMY1 VARCHAR (70)
ALTER TABLE #TEMPRL
ALTER COLUMN DUMMY5 VARCHAR (70)

create index ix on  #TEMPRL (sba)
 
--DROP TABLE #TEMPRLAR
select entr_sba sbaAR , entm_name1 ARAR  into #TEMPRLAR  from ENTR_Data_for_data , entity_mstr 
where entm_id =  entr_ar and ENTM_ENTTM_CD = 'AR'
and ENTM_DELETED_IND = 1 

create index ix on  #TEMPRLAR (sbaAR)

UPDATE #TEMPRL
SET AR = ARAR
FROM   #TEMPRLAR , #TEMPRL WHERE sbaAR = SBA 


--DROP TABLE #TEMPRLSB
select entr_sba sbaSB , entm_name1 SBSB  into #TEMPRLSB  from ENTR_Data_for_data , entity_mstr 
where entm_id =  ENTR_DUMMY4 and ENTM_ENTTM_CD = 'SB'
and ENTM_DELETED_IND = 1

create index ix on  #TEMPRLSB (sbaSB)

UPDATE #TEMPRL
SET SB = SBSB
FROM   #TEMPRLSB , #TEMPRL WHERE sbaSB = SBA 



--DROP TABLE #TEMPRLBR
select entr_sba sbaBR , entm_name1 BRBR  into #TEMPRLBR  from ENTR_Data_for_data , entity_mstr 
where entm_id =  ENTR_BR and ENTM_ENTTM_CD = 'BR'
and ENTM_DELETED_IND = 1 

create index ix on  #TEMPRLBR (sbaBR)

UPDATE #TEMPRL
SET BR = BRBR
FROM   #TEMPRLBR , #TEMPRL WHERE sbaBR = SBA 
 

--DROP TABLE #TEMPRLDUMMY5
select entr_sba sbaDUMMY5 , entm_name1 DUMMY5DUMMY5  into #TEMPRLDUMMY5  from ENTR_Data_for_data , entity_mstr 
where entm_id =  ENTR_DUMMY5 and ENTM_ENTTM_CD = 'BL'
and ENTM_DELETED_IND = 1 
 
 create index ix on  #TEMPRLDUMMY5 (sbaDUMMY5)
 
UPDATE #TEMPRL
SET  DUMMY5 = DUMMY5DUMMY5
FROM   #TEMPRLDUMMY5 , #TEMPRL WHERE sbaDUMMY5 = SBA 

insert into   Rel_data 
select *  from #TEMPRL

drop table #TEMPRL
DROP TABLE #TEMPRLAR
DROP TABLE #TEMPRLSB
DROP TABLE #TEMPRLBR
DROP TABLE #TEMPRLDUMMY1
DROP TABLE #TEMPRLDUMMY5

GO
