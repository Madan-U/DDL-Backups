-- Object: PROCEDURE citrus_usr.pr_ins_grpcode
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_ins_grpcode]
 @grpocde nvarchar(50)
,@grpcreatedby nvarchar(50)
,@grplastupdateby nvarchar(50)
,@grpdpmid numeric
as 
begin
--declare @grpid numeric
--set @grpid  =   isnull(max(Grp_id+1),1) from group_mstr
insert into group_mstr 
 select isnull(max (Grp_id) + 1,1)  , '0', '',ltrim(rtrim(@grpocde)),ltrim(rtrim(@grpdpmid)), @grpcreatedby,getdate(),@grpcreatedby, getdate(),'1' from group_mstr 
end

GO
