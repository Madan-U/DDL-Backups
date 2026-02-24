-- Object: PROCEDURE dbo.MULTIBANKINSERT_CI
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





  

CREATE PROC [dbo].[MULTIBANKINSERT_CI]  AS      

      

      

      

INSERT INTO POBANK      

SELECT DISTINCT BANK_NAME,BRANCH,'','','','','','','','','','',IFSCCODE,MICR_CODE 

FROM MULTIBANKID_COMMONINTERFACE WHERE UPDATEFLAG=0  

 AND EXCHANGE ='NSE' AND SEGMENT ='CAPITAL'    

AND BANK_NAME NOT IN (SELECT BANK_NAME FROM POBANK WHERE BRANCH_NAME = BRANCH)    



      

      

INSERT INTO ACCOUNT.DBO.MULTIBANKID      

SELECT  CLTCODE,MAX(P.BANKID) BANKID ,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK

FROM MULTIBANKID_COMMONINTERFACE AS C, POBANK AS P      

WHERE  EXCHANGE ='NSE' AND SEGMENT ='CAPITAL'  AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK 



   

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='NSE' AND SEGMENT ='CAPITAL' AND UPDATEFLAG=0 





-----------------BSE--------------     

      

      

SET XACT_ABORT ON       

      

INSERT INTO AngelBSECM.BSEDB_AB.DBO.POBANK

           ([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])      

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM AngelBSECM.BSEDB_AB.DBO.POBANK 

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='BSE' AND SEGMENT ='CAPITAL'



     

	  

INSERT INTO AngelBSECM.ACCOUNT_AB.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, AngelBSECM.BSEDB_AB.DBO.POBANK AS P      

WHERE  EXCHANGE ='BSE' AND SEGMENT ='CAPITAL' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK      

      

      

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='BSE' AND SEGMENT ='CAPITAL' AND UPDATEFLAG=0         

      

-----------------------------------NSEFO      

SET XACT_ABORT ON    

      

INSERT INTO ANGELFO.NSEFO.DBO.POBANK 

  ([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])      

                

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELFO.NSEFO.DBO.POBANK 

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='NSE' AND SEGMENT ='FUTURES'  





     

INSERT INTO ANgelfo.ACCOUNTfo.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELFO.NSEFO.DBO.POBANK  AS P      

WHERE  EXCHANGE ='NSE' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK      

           

      

    

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE EXCHANGE ='NSE' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0 





---------------------------NSX---------





   

      

INSERT INTO ANGELFO.NSECURFO.DBO.POBANK

([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])     

                  

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELFO.NSECURFO.DBO.POBANK 

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='NSX' AND SEGMENT ='FUTURES'  

      

    

INSERT INTO ANgelfo.ACCOUNTCURfo.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELFO.NSECURFO.DBO.POBANK AS P      

WHERE  EXCHANGE ='NSX' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK   

      

      

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='NSX' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0      











---------------------MCDX------------    

      

SET XACT_ABORT ON          

      

INSERT INTO ANGELCOMMODITY.MCDX.DBO.POBANK   

([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])        

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELCOMMODITY.MCDX.DBO.POBANK  

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='MCX' AND SEGMENT ='FUTURES'  

      



INSERT INTO ANGELCOMMODITY.ACCOUNTMCDX.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELCOMMODITY.MCDX.DBO.POBANK  AS P      

WHERE  EXCHANGE ='MCX' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK 

      

      

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='MCX' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0  





-------------------NCDX---------   





      

INSERT INTO ANGELCOMMODITY.NCDX.DBO.POBANK      

([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])        

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELCOMMODITY.NCDX.DBO.POBANK 

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='NCX' AND SEGMENT ='FUTURES'  



      

INSERT INTO ANGELCOMMODITY.ACCOUNTNCDX.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELCOMMODITY.NCDX.DBO.POBANK AS P      

WHERE  EXCHANGE ='NCX' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK       

      

      

      

--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='NCX' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0      





------------------------------MCDXCDS--------------- 



INSERT INTO ANGELCOMMODITY.MCDXCDS.DBO.POBANK

([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])       

      

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELCOMMODITY.MCDXCDS.DBO.POBANK

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='MCD' AND SEGMENT ='FUTURES'  





INSERT INTO ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELCOMMODITY.MCDXCDS.DBO.POBANK AS P      

WHERE  EXCHANGE ='MCD' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK 

  



--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='MCD' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0





 

    

 -----------------BSEFO     

     

  

      



INSERT INTO ANGELCOMMODITY.BSEFO.DBO.POBANK 

([Bank_Name]

           ,[Branch_Name]

           ,[Address1]

           ,[Address2]

           ,[City]

           ,[State]

           ,[Nation]

           ,[Zip]

           ,[Phone1]

           ,[Phone2]

           ,[Fax]

           ,[Email]

           ,[IFSCCODE]

           ,[MICRNO])        

SELECT DISTINCT BANK_NAME [Bank_Name],BRANCH [Branch_Name],'' [Address1],'' [Address2],

'' [City],'' [State],'' [Nation],'' [Zip],'' [Phone1],'' [Phone2],'' [Fax],'' [Email],IFSCCODE,MICR_CODE

FROM MULTIBANKID_COMMONINTERFACE      

WHERE BANK_NAME NOT IN (SELECT BANK_NAME FROM ANGELCOMMODITY.BSEFO.DBO.POBANK 

WHERE BRANCH_NAME = BRANCH)  AND UPDATEFLAG=0 

AND EXCHANGE ='BSEFO' AND SEGMENT ='FUTURES'  





      

      

INSERT INTO ANGELCOMMODITY.ACCOUNTbfo.DBO.MULTIBANKID     

           ([cltcode]

           ,[bankid]

           ,[accno]

           ,[ACCTYPE]

           ,[CHEQUENAME]

           ,[DEFAULTBANK])

                     SELECT  CLTCODE ,MAX(P.BANKID) BANKID  ,ACCNO ,ACCTYPE ,CHEQUENAME ,DEFAULTBANK 

FROM MULTIBANKID_COMMONINTERFACE AS C, ANGELCOMMODITY.BSEFO.DBO.POBANK AS P      

WHERE  EXCHANGE ='bsefo' AND SEGMENT ='FUTURES' AND P.BANK_NAME=C.BANK_NAME AND UPDATEFLAG=0      

AND P.BRANCH_NAME=C.BRANCH      

GROUP BY CLTCODE,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK  





--UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE  EXCHANGE ='BSE' AND SEGMENT ='FUTURES' AND UPDATEFLAG=0 





UPDATE MULTIBANKID_COMMONINTERFACE SET UPDATEFLAG= 1 WHERE UPDATEFLAG=0              

      

    

       

----------- ADD KARTA DETAILS 



 SELECT *,SPACE(1) AS ISEXIST INTO #CONTACTDETAILS
 
 FROM CLIENT_CONTACT_DETAILS_COMMONINTERFACE WHERE UPDATION_FLAG=0
 
 UPDATE  #CONTACTDETAILS SET ISEXIST='Y' FROM   CLIENT_CONTACT_DETAILS
 WHERE #CONTACTDETAILS.Cl_Code=CLIENT_CONTACT_DETAILS.Cl_Code

INSERT INTO CLIENT_CONTACT_DETAILS     

SELECT CL_CODE,LINE_NO,CONTACT_NAME,ADDRESS1,ADDRESS2,ADDRESS3,CITY,STATE,NATION,    

ZIP,PHONE_NO,MOBILENO,PANNO,DESIGNATION,EMAIL,RELATIONSHIP,POLTICAL_CONNECTION,UID,DIN,    

CLIENT_STATUS    

FROM #CONTACTDETAILS WHERE UPDATION_FLAG=0 AND ISNULL(ISEXIST,'')=''   

      

UPDATE CLIENT_CONTACT_DETAILS_COMMONINTERFACE SET UPDATION_FLAG =1 WHERE UPDATION_FLAG=0

GO
