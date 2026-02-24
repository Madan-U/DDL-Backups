-- Object: PROCEDURE dbo.V2_CLASS_PROC_ENTITYMASTER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC V2_CLASS_PROC_ENTITYMASTER  
  
as  
  
  SELECT ENT_TYPE = A.ENT_TYPE,   
         NO_OF_UNITS = ISNULL(NO_OF_UNITS,0),   
         NO_OF_LOGIN = ISNULL(NO_OF_LOGIN,0),   
         NO_OF_USERS = ISNULL(NO_OF_USERS,0)   
  FROM   (SELECT ENT_TYPE,   
                 NO_OF_UNITS = COUNT(1),   
                 ORDER_BY  
          FROM   V2_CLASS_VW_ENTITYMASTER   
          GROUP BY ENT_TYPE,ORDER_BY) A   
            LEFT OUTER JOIN   
            (SELECT ENT_TYPE = UPPER(FLDSTATUS),   
                    NO_OF_LOGIN = SUM(NO_OF_LOGIN)   
             FROM   (SELECT FLDADMINAUTO,   
                            NO_OF_LOGIN = COUNT(DISTINCT FLDSTNAME)   
                     FROM   TBLPRADNYAUSERS   
                     GROUP BY FLDADMINAUTO) U,   
                     TBLADMIN A   
             WHERE FLDADMINAUTO = FLDAUTO_ADMIN   
             GROUP BY FLDSTATUS) B  
             ON A.ENT_TYPE = B.ENT_TYPE    
              LEFT OUTER JOIN   
                (SELECT ENT_TYPE = UPPER(FLDSTATUS),   
                        NO_OF_USERS = SUM(NO_OF_USERS)   
                 FROM   (SELECT FLDADMINAUTO,   
                                FLDSTNAME,   
                                NO_OF_USERS = COUNT(1)   
                         FROM TBLPRADNYAUSERS   
                         GROUP BY FLDADMINAUTO,   
                          FLDSTNAME) U, TBLADMIN A   
                 WHERE FLDADMINAUTO = FLDAUTO_ADMIN   
                 GROUP BY FLDSTATUS) C   
                 ON A.ENT_TYPE = C.ENT_TYPE   
  ORDER BY ORDER_BY

GO
